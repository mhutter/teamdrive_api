module TeamdriveApi
  # API Client for the TeamDrive Register Server. See the TeamDrive Register docs for more informations on specific commands.
  class Register < Base
    # Create a new Register API Client.
    #
    # @param [String] host the API Server
    # @param [String] api_checksum_salt the +APIChecksumSalt+ system setting ("Edit Settings -> RegServer").
    # @param [String] api_version optionally overwrite the api_version
    def initialize(host, api_checksum_salt, api_version = '1.0.005')
      super
      @uri = URI.join(@host + '/', 'pbas/td2api/api/api.htm').to_s
    end

    # Remove user (added in +1.0.003+)
    #
    # @param [String] username to be deleted
    # @param [Boolean] delete the user's license aswell
    # @param [String] distributor will only be used if allowed by the API (see +APIAllowSettingDistributor+ in the Teamdrive Register docs).
    def remove_user(username, delete_license = false, distributor = nil)
      res = send_request :removeuser, {
        username: username,
        delete_license: delete_license,
        distributor: distributor
      }
      return res[:intresult].eql?('0')
    end
  end
end
