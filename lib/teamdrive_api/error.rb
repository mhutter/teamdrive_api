module TeamdriveApi
  # An exception raised by the TeamDrive API
  class Error < StandardError
    attr_reader :code, :secondarycode, :message
    def initialize(code, secondarycode, message)
      super message
      @code, @secondarycode, @message = code, secondarycode, message
    end
  end
end
