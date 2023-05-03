class ApiApplicationController < ActionController::Base
  include Response
  include ExceptionHandler

  skip_before_action :verify_authenticity_token

  # called before every action on controllers
  before_action :authenticate_request!
  attr_reader :current_user

  private

  # Check for valid request token and return user
  def authenticate_request!
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end
end