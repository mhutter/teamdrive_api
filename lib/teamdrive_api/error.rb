module TeamdriveApi
  # An exception raised by TeamdriveApi
  class Error < StandardError
    def initialize(code, msg)
      super msg
      @code, @msg = code, msg
    end
  end
end
