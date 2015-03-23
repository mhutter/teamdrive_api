module TeamdriveApi
  # An exception raised by the TeamDrive API
  class Error < StandardError
    def initialize(code, msg)
      super msg
      @code, @msg = code, msg
    end
  end
end
