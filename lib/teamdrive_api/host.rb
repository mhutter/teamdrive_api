module TeamdriveApi
  # API Client for the TeamDrive Host Server. See the TeamDrive Host
  # docs for more informations on specific commands.
  class Host < Base
    # Set Depot Limits (added in 3.0.003)
    #
    #     The values of +<disclimit>+ and +<trafficlimit>+ is in Bytes:
    #     +1 KB = 1024 Bytes+.
    #
    # @param [String] username
    # @param [#to_s] depot_id
    # @param [Hash] args
    # @return [Boolean] success?
    def set_depot(username, depot_id, args)
      require_all of: [:disclimit], in_hash: args
      args = args.merge(
        username: username,
        depotid: depot_id
      )

      res = send_request :setdepot, args
      res[:intresult].eql?('0')
    end
  end
end
