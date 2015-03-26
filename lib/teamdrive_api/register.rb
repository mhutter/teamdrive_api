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

    # Create license without user (added in 1.0.003)
    #
    # @param [Hash] opts license options
    # @option opts [String] :productname +server+, +client+
    # @option opts [String] :type +monthly+ / +yearly+ / +permanent+
    # @option opts [String] :featurevalue one of +webdavs+, +personal+, +professional+, +enterprise+
    # @option opts [String] :limit Amount (for a client license)
    # @option opts [String] :licensereference An optional external reference. Added with v1.0.004
    # @option opts [String] :contactnumber An optional contact number. Added with v1.0.004
    # @option opts [String] :validuntil An optional valid-until date. Format must be +DD.MM.YYYY+. Added with v1.0.004
    # @option opts [String] :changeid An optional change id for license changes. Added with v1.0.004
    def create_license_without_user(opts = {})
      require_all of: [:productname, :type, :featurevalue], in_hash: opts
      res = send_request :createlicensewithoutuser, opts
      return res[:intresult].eql?('0')
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

    # Search user
    #
    # @param [Hash] query the search query.
    # @option query [String] :username
    # @option query [String] :email
    # @option query [String] :startid (0)
    # @option query [Boolean] :showdevice (false)
    # @option query [Boolean] :onlyownusers (false)
    def search_user(query = {})
      require_one of: [:username, :email], in_hash: query
      query = {
        showdevice: false,
        onlyownusers: false
      }.merge(query)
      send_request :searchuser, query
    end
  end
end
