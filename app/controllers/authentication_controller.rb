require './lib/authentication.rb'

class  AuthenticationController < ApplicationController
  include Authentication
  before_action :authenticate_request

  def authenticate_request
    render status: 404 if authenticated?(request) == false
  end
end
