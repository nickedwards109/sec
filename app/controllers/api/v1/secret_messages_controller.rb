require './lib/encryption'

class Api::V1::SecretMessagesController < AuthenticationController
  include Encryption

  def index
    secret_messages = SecretMessage.all
    response_body = []
    secret_messages.each do |secret_message|
      encryption_output = encrypt(secret_message.message)
      response_body.push encryption_output
    end
    render json: response_body
  end

  def show
    message = SecretMessage.find(params[:id]).message
    encryption_output = encrypt(message)
    render json: [encryption_output]
  end
end
