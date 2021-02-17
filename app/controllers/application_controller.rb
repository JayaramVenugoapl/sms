class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods  
  include Error::ErrorHandler

  before_action :authenticate!
  attr_reader :account

  def routing_error
    raise Error::RoutingError
  end

  private
  def authenticate!
    authenticate_with_http_basic do |username, auth_id|
      @account = Account.find_by(:username => username, :auth_id => auth_id)
      raise Error::UnauthorizedError unless @account
    end
  end
end
