#!/usr/bin/python -u

import os.path
import sys
import re
from string import Template
import logging

DEBUG = True
VERSION = "v0.2-10072013"
LOG_FILE_NAME = "/var/log/pdns-query.log"

######################################################################
class pdnsRecord(object):
  """Class for hold NS record loaded from file or DB"""
  
  def __init__(self):
    #print "pdnsRecord init"
    self.data_str = ""
    self.data = []
    self.data_valid = False
  
  def loadFromLine(self, inline):
    if not inline == "":
      self.data_str = inline.lower();
      self.data = self.data_str.split()
      self.data_valid = self.validateData()      
  
  def validateData(self):
    if not hasattr(self, 'data') or not self.data:
      logging.debug("pdnsRecord content undefined")
      return False
    # name class type ttl content
        
    # validate qclass
    self.data[1] = self.data[1].upper();
    if self.data[1] != "IN":
      logging.debug("pdnsRecord class is't 'IN'")
      return False
      
    # validate qtype
    self.data[2] = self.data[2].upper();
    if not self.data[2] in ["A", "NS", "CNAME", "MX", "SOA", "PTR"]:
      logging.debug("pdnsRecord type not supported")
      return False    
      
    # validate content    
    if self.data[2] == "A" and not self.validateIPAddr(self.data[4]):
      logging.debug("pdnsRecord 'A' content is't valid IP")
      return False
      
    return True

  def validateIPAddr(self, ipaddr):
    match = re.search("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$", ipaddr)
    if not match == None: 
      return True
    else:
      return False

  def setAllData(self, name, rclass, type, ttl, content):
    self.data = [name, rclass, type, ttl, content]
  
  def getName(self):
    if self.data_valid:
      return self.data[0]
      
  def getClass(self):
    if self.data_valid:
      return self.data[1]          
      
  def getType(self):
    if self.data_valid:
      return self.data[2]
  
  def getTtl(self):
    if self.data_valid:
      if self.data[2] != "SOA":
        return self.data[3]
      else:
        return self.data[9]
      
  def getContent(self):
    if self.data_valid:
      return self.data[4]
      
  def getSOAContent(self):
    if self.data_valid:
      soa_data = self.data[4:]
      return "\t".join(soa_data)

  def printAll(self):
    logging.info("pdnsRecord: " + self.data)


#################################################################################33
class pdnsZone(object):
  """Class holding entire DNS zone in collection of pdnsRecord instances"""

  def __init__(self):
    self.records = []
    self.data_valid = False

  def loadFromFile(self, filename):
    file = open(filename)
    self.records = []
    for line in file:
      record = pdnsRecord()
      record.loadFromLine(line.strip())
      self.records.append(record)
    self.data_valid = True
    
  def printAll(self):
    for record in self.records:
      record.printAll()
      logging.info("pdnsZone all data valid: " + record.data_valid)

  def getRecords(self, rname, rtype):
    if self.data_valid:
      if rtype != "ANY":
        req_records = []
        for record in self.records:
          if record.getName() == rname and record.getType() == rtype:
            req_records.append(record)
        return req_records
      else:
        return self.records



class pdnsBackEnd(object):
  """
  Class-interface to communicate with PowerDNS server via abi protocol 1
  http://doc.powerdns.com/html/backends-detail.html#pipebackend-protocol
  """

  def __init__(self):
    self.in_helo = True
    #self.in_helo = False
    self.abi_version = "1"
    self.db_link = None
    self.zones_dir = "/var/pdns/"
    self.zones = {}

  def validateQuery(self, qstr):
    qdatalen = len(qstr.split())
    if self.abi_version == "1" and not qdatalen == 6:
      logging.debug("pdnsBackend query params count for ABI v1 wrong!")
      #return False
    if self.abi_version == "2" and not qdatalen == 7: 
      logging.debug("pdnsBackend query params count for ABI v2 wrong!")
      #return False
    if self.abi_version == "3" and not qdatalen == 8: 
      logging.debug("pdnsBackend query params count for ABI v3 wrong!")    
      #return False  
    return True
      

  # main backend life cycle
  def waitForInput(self):    
    line = sys.stdin.readline()
    line = line.strip()
    while  line:
      if not self.in_helo and not self.validateQuery(line):
        print "LOG\tInvalid query!"
        line = sys.stdin.readline()
        line = line.strip()
        continue
      logging.debug(line)
      input = line.split()
      if self.in_helo:
        # checking if initial HELO passed
        if input[0] == "HELO" and input[1] == self.abi_version:
          self.in_helo = False
          # standart banner for helo
          print "OK\tReady to serve requests "+VERSION+"."
      else:
        # proceed Q command
        if input[0] == "Q":
          qrecords = self.lookupZoneRecords(input[1], input[3])
          if qrecords != None:
            for record in qrecords:
              if record.getType() != "SOA":
                ans = Template("DATA\t$qname\t$qclass\t$qtype\t$qttl\t$qid\t$content").substitute(
                  qname=record.getName(),
                  qclass=record.getClass(),
                  qtype=record.getType(),
                  qttl=record.getTtl(),
                  qid=input[4],
                  content=record.getContent(),
                )
              else:
                ans = Template("DATA\t$qname\t$qclass\t$qtype\t$qttl\t$qid\t$content").substitute(
                  qname=record.getName(),
                  qclass=record.getClass(),
                  qtype=record.getType(),
                  qttl=record.getTtl(),
                  qid=input[4],
                  content=record.getSOAContent(),
                  )                 
              print ans;
              logging.debug(ans)
          print "END"
        # Procced with PING command
        if input[0] == "PING":
          # return 'END' as standard answer
          print "END"
      line = sys.stdin.readline()

  # loads dns zone
  def lookupZoneRecords(self, queryname, querytype):
  
    qn = queryname.lower()    
    qn = qn.strip('.')
    
    domain = qn.split('.')
    domain.reverse()
    
    if len(domain) < 2:
      return None
    
    dom_part = domain.pop(0)    
    fname = dom_part
    local_cached = False
    local_file = False
    while dom_part:
      # lookup local cache
      if fname in self.zones and not (self.zones[fname] is None):
        local_cached = True
        break
      if os.path.isfile(self.zones_dir + fname):
        local_file = True
        break
      try:
        dom_part = domain.pop(0)
        fname = dom_part + '.' + fname
      except IndexError:
        break

    if not local_file and not local_cached:
      logging.debug("Zone "+queryname+" file not found!")
      return None

    logging.debug("File name is "+fname)

    if not local_cached:
      # load zone
      zone = pdnsZone()
      zone.loadFromFile(self.zones_dir + fname)    
      #print "DEBUG", zone.printAll()
      # add it to local cache
      self.zones[fname] = zone
    else:        
      zone = self.zones[fname]
    
    # look up for requested record return array of records
    return zone.getRecords(qn, querytype)

##########################################################################3

if __name__ == "__main__":
  logging.basicConfig(format = u'[%(asctime)s] %(levelname)-8s %(message)s', level = logging.DEBUG, filename = LOG_FILE_NAME)
  pdnsBackEnd().waitForInput()
