module Error
  class CustomError < StandardError
    attr_reader :status, :error, :message

    def initialize(_error = nil, _status = nil, _message = nil)
      @error = _error || "unknown failure"
      @status = _status || :unprocessable_entity
      @message = _message || ''
    end

    def fetch_json
      Helpers::Render.json(error, message, status)
    end
  end
end
