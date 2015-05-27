require 'digest'
require 'httparty'
require 'uri'

module TeamdriveApi
  # API-Baseclass for all XML RPC APIs
  class Base
    include ::HTTParty
    attr_reader :uri
    format :xml

    def initialize(host, api_checksum_salt, api_version)
      @api_checksum_salt = api_checksum_salt
      @api_version       = api_version
      @host = host.start_with?('http') ? host : 'https://' + host
    end

    # Generates the XML payload for the RPC
    def payload_for(command, query = {})
      out = header_for(command)
      query.each do |k, v|
        next if v.nil?
        v = v.to_s
        v = '$' + v if %w(true false).include?(v)
        out << "<#{k}>#{v}</#{k}>"
      end
      out << '</teamdrive>'
    end

    private

    # Generates the XML header for the RPC
    def header_for(command)
      out = "<?xml version='1.0' encoding='UTF-8' ?>"
      out << '<teamdrive>'
      out << "<apiversion>#{@api_version}</apiversion>"
      out << "<command>#{command}</command>"
      out << "<requesttime>#{Time.now.to_i}</requesttime>"
    end

    def check_for(method, hash, params, message)
      keys = [params].flatten
      return if keys.send(method) { |k| hash.key?(k) }
      msg = keys.map { |k| %("#{k}") }.join(', ')
      fail ArgumentError, "Provide #{message} of #{msg}"
    end

    # make sure at least one of the keys in +of+ exists in +in_hash+. Raise an
    # +ArgumentError+ if not so.
    def require_one(of: [], in_hash: {})
      check_for(:any?, in_hash, of, 'at least one')
    end

    # make sure all of the keys in +of+ exists in +in_hash+. Raise an
    # +ArgumentError+ if not so.
    def require_all(of: [], in_hash: {})
      check_for(:all?, in_hash, of, 'all')
    end

    # actually send a HTTP request
    def send_request(command, data = {})
      body = payload_for(command, data)
      res = self.class.post(
        @uri,
        headers: { 'User-Agent' => "TeamdriveApi v#{TeamdriveApi::VERSION}" },
        body: body,
        query: { checksum: Digest::MD5.hexdigest(body + @api_checksum_salt) }
      )

      return_or_fail(res['teamdrive'].symbolize_keys)
    end

    # raise TeamdriveApi::Error if +response+ contains an exception, return
    # +response+ otherwise
    def return_or_fail(response)
      return response if response[:exception].nil?
      fail TeamdriveApi::Error.new response[:exception][:primarycode],
                                   response[:exception][:secondarycode],
                                   response[:exception][:message]
    end
  end
end
