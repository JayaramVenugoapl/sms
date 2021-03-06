module Error
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from StandardError do |e|
          respond("unknown failure", 500, e.to_s)
        end

        rescue_from CustomError do |e|
          respond(e.error, e.status)
        end

        rescue_from ActiveRecord::RecordNotFound do |e|
          respond(:record_not_found, 404)
        end
        rescue_from ActiveRecord::RecordInvalid do |e|
          respond(:record_not_found, 422)
        end
      end
    end

    private

    def respond(_error, _status, _message = "")
        json = Helpers::Render.json(_error, _status, _message)
        render json: json, status: _status
    end
  end
end
