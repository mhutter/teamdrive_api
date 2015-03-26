require 'digest'
require 'httparty'
require 'uri'

module TeamdriveApi
  class Base # :nodoc:
    include ::HTTParty
    attr_reader :uri
    format :xml

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
        next if v.nil?
        v = v.to_s
        v = %w{true false}.include?(v) ? '$' + v : v
        out << "<#{k}>#{v}</#{k}>"
      end
      out << '</teamdrive>'
    end

    private

    # make sure at least one of the keys in +of+ exists in +in_hash+. Raise an
    # +ArgumentError+ if not so.
    def require_one(of: [], in_hash: {})
      keys = [of].flatten
      unless keys.any? { |k| in_hash.keys.include?(k) }
        msg = keys.map { |k| %Q{"#{k}"} }.join(', ')
        fail ArgumentError, "Provide at least one of #{msg}."
      end
    end

    def send_request(command, data = {})
      body = payload_for(command, data)
      res = self.class.post @uri,
        headers: { 'User-Agent' => "TeamdriveApi v#{TeamdriveApi::VERSION}" },
        body: body,
        query: {
          checksum: Digest::MD5.hexdigest(body + @api_checksum_salt)
        }

      res = res['teamdrive'].symbolize_keys
      unless res[:exception].nil?
        fail TeamdriveApi::Error.new(
          res[:exception][:primarycode],
          res[:exception][:message]
        )
      end
      res
    end
  end
end
