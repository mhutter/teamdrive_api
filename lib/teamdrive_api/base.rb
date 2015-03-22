require 'uri'

module TeamdriveApi
  class Base # :nodoc:
    attr_reader :uri

    def initialize(host, api_checksum_salt, api_version)
      @api_checksum_salt, @api_version = api_checksum_salt, api_version
      @host = host.start_with?('http') ? host : 'https://' + host
    end

    # Generates the XML payload for the RPC
    def payload_for(command, query = {})
      out = ''
      out << %q{<?xml version='1.0' encoding='UTF-8' ?>}
      out << '<teamdrive>'
      out << "<apiversion>#{@api_version}</apiversion>"
      out << "<command>#{command}</command>"
      out << "<requesttime>#{Time.now.to_i}</requesttime>"
      query.each do |k,v|
        v = v.to_s
        v = %w{true false}.include?(v) ? '$' + v : v
        out << "<#{k}>#{v}</#{k}>"
      end
      out << '</teamdrive>'
    end
  end
end
