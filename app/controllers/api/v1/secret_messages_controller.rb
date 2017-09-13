class Api::V1::SecretMessagesController < ApplicationController
  before_action :authenticate_request
  def show
  end

  def authenticate_request
    render status: 404
  end
end
