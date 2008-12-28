#!/usr/bin/ruby
require 'soap/rpc/driver'
require 'soap/driver'
require 'soap/header/simplehandler'

class ClientAuthHeaderHandler < SOAP::Header::SimpleHandler
  MyHeaderName = XSD::QName.new("urn:zimbra", "context")

  def initialize(sessionid = nil, authtoken = nil)
    super(MyHeaderName)
    @sessionid = sessionid
    @authtoken = authtoken       
  end

  def on_simple_outbound
    if @sessionid
      { "sessionId" => @sessionid, "authToken" => @authtoken }
    end
  end
end

drv = SOAP::RPC::Driver.new('http://api.productserve.com/v1/ProductServeService?wsdl', 'urn:zimbraAdmin')
drv.wiredump_dev = STDERR
username = '75643'
password = 'b151ac50be357e4f86a9717a5cee1827'
drv.add_method('User Authorisation', username, password)

token, lifetime, sessionid = drv.UserAuthorisation('usrename','password')
drv.headerhandler << ClientAuthHeaderHandler.new(sessionid, token) 
p drv.GetProducts()