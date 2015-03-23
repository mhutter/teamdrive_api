module TeamdriveApi
  # Create a new API Client.
  #
  # @param [String] host the API Server
  # @param [String] api_checksum_salt the +APIChecksumSalt+ system setting ("Edit Settings -> RegServer").
  # @param [String] api_version optionally overwrite the api_version
  class Register < Base
    def initialize(host, api_checksum_salt, api_version = '1.0.005')
      super
      @uri = URI.join(@host + '/', 'pbas/td2api/api/api.htm').to_s
    end

    def remove_user(username, delete_license = false, distributor = nil)
      send_request :removeuser, {
        username: username,
        delete_license: delete_license,
        distributor: distributor
      }
    end
  end
end
