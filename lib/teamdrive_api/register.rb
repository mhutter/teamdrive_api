module TeamdriveApi
  # API Client for the TeamDrive Register Server. See the TeamDrive Register
  # docs for more informations on specific commands.
  class Register < Base
    # Create a new Register API Client.
    #
    # @param [String] host the API Server
    # @param [String] api_checksum_salt the +APIChecksumSalt+ system setting
    #   ("Edit Settings -> RegServer").
    # @param [String] api_version optionally overwrite the api_version
    def initialize(host, api_checksum_salt, api_version = '1.0.005')
      super
      @uri = URI.join(@host + '/', 'pbas/td2api/api/api.htm').to_s
    end

    # Assign license to client (added in RegServ API 1.0.004)
    #
    # @param [String] username
    # @param [String] number License Number
    # @param [Array] devices optional list of devices the user posses. If
    #   empty, all of the user's devices will be used
    # @return [Boolean] success?
    def assign_license_to_client(username, number, devices = nil)
      res = send_request :assignlicensetoclient,
                         username: username,
                         number: number,
                         devices: devices

      res[:intresult].eql?('0')
    end

    # Assign user to license (added in RegServ API v1.0.003)
    #
    # @param [String] username
    # @param [String] number License Number
    # @return [Boolean] success?
    def assign_user_to_license(username, number)
      res = send_request :assignusertolicense,
                         username: username,
                         number: number

      res[:intresult].eql?('0')
    end

    # Create a license and assign it to a user.
    #
    # @param [Hash] opts license options
    # @option opts [String] :username User to assign license to
    # @option opts [String] :productname +server+, +client+
    # @option opts [String] :type +monthly+ / +yearly+ / +permanent+
    # @option opts [String] :featurevalue one of +webdavs+, +personal+,
    #   +professional+, +enterprise+
    # @option opts [String] :limit Amount, only for client licenses. _Optional_.
    # @option opts [String] :licensereference An _optional_ external reference.
    #   Added with v1.0.004
    # @option opts [String] :contactnumber An _optional_ contact number. Added
    #   with v1.0.004
    # @option opts [String] :validuntil An _optional_ valid-until date. Format
    #   must be +MM/DD/YYYY+. Added with v1.0.004
    # @option opts [String] :changeid An _optional_ change id for license
    #   changes. Added with v1.0.004
    # @return [String] The license number of the created license
    def create_license(opts = {})
      require_all of: [:username, :productname, :type, :featurevalue],
                  in_hash: opts
      res = send_request :createlicense, opts
      res[:licensedata][:number]
    end

    # Create license without user (added in RegServ API v1.0.003)
    #
    # @see #create_license
    def create_license_without_user(opts = {})
      require_all of: [:productname, :type, :featurevalue], in_hash: opts
      res = send_request :createlicensewithoutuser, opts
      res[:licensedata][:number]
    end

    # Downgrade default-license
    #
    # @param [Hash] opts license options
    # @option opts [String] :username
    # @option opts [String] :featurevalue _optional_
    # @option opts [String] :limit _optional_
    def downgrade_default_license(opts = {})
      require_all of: [:username], in_hash: opts
      res = send_request(:downgradedefaultlicense, opts)
      res[:intresult].eql?('0')
    end

    # Upgrade default-license
    #
    # @param [Hash] opts license options
    # @option opts [String] :username
    # @option opts [String] :featurevalue _optional_
    # @option opts [String] :limit _optional_
    def upgrade_default_license(opts = {})
      require_all of: [:username], in_hash: opts
      res = send_request(:upgradedefaultlicense, opts)
      res[:intresult].eql?('0')
    end

    # Get default-license for a user
    #
    # @param [String] username
    # @param [String] distributor _optional_
    # @return [Hash] the license data
    def get_default_license_for_user(username, distributor = nil)
      res = send_request :getdefaultlicense,
                         username: username,
                         distributor: distributor

      res[:licensedata]
    end

    # Get license data for a user
    #
    # @param [String] username
    # @param [String] distributor (optional)
    # @return [Hash] the license data
    def get_license_data_for_user(username, distributor = nil)
      res = send_request :getlicensedata,
                         username: username,
                         distributor: distributor

      res[:licensedata]
    end

    # Get User Data
    #
    # @param [String] username
    # @param [String] distributor (optional, added in RegServ API v1.0.003)
    # @return [Hash] the user data
    def get_user_data(username, distributor = nil)
      send_request :getuserdata,
                   username: username,
                   distributor: distributor
    end

    # Create a new Account
    #
    # @note The range of possible Usernames depend on the +RegNameComplexity+
    #   setting as described in the Registration Server documentation.
    #   Similary, the length of passwords can be restricted by the
    #   +ClientPasswordLength+ setting. However, these restriction only apply
    #   when creating a new account, they will not be checked when a user
    #   attempts to log in.
    #
    # @param [Hash] opts Data for the new user.
    # @option opts [String] :username
    # @option opts [String] :useremail
    # @option opts [String] :password
    # @option opts [String] :language _optional_
    # @option opts [String] :reference _optional_
    # @option opts [String] :department _optional_
    # @option opts [String] :distributor _optional_
    # @return [Boolean] +true+ if the User has been created
    def register_user(opts = {})
      require_all of: [:username, :useremail, :password], in_hash: opts
      res = send_request(:registeruser, opts)
      res[:intresult].eql?('0')
    end
    alias_method :create_account, :register_user

    # Remove user (added in RegServ API v1.0.003)
    #
    # @param [String] username User to be deleted
    # @param [Boolean] delete_license delete the user's license aswell
    # @param [Boolean] delete_depot delete the user's depot (data) aswell
    # @param [String] distributor Distributor. Only used if allowed by the API
    #   (see +APIAllowSettingDistributor+ in the Teamdrive Register docs).
    # @return [Boolean] success?
    def remove_user(username:, delete_license: false, delete_depot: false, distributor: nil)
      res = send_request :removeuser,
                         username: username,
                         deletelicense: delete_license,
                         deletedepot: delete_depot,
                         distributor: distributor

      res[:intresult].eql?('0')
    end

    # Search user
    #
    # @param [Hash] query the search query.
    # @option query [String] :username
    # @option query [String] :email
    # @option query [String] :startid (0)
    # @option query [Boolean] :showdevice (false)
    # @option query [Boolean] :onlyownusers (false)
    # @return [Hash] list of users
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
