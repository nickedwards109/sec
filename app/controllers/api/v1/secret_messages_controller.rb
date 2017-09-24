require './lib/encryption'

class Api::V1::SecretMessagesController < AuthenticationController
  include Encryption

  def index
    secret_messages = SecretMessage.all
    response_body = {}
    secret_messages.each do |secret_message|
      encryption_output = encrypt(secret_message.message)
      response_body[secret_message.id] = encryption_output
    end
    render json: response_body
  end

  def show
    message = SecretMessage.find(params[:id]).message
    encryption_output = encrypt(message)
    encrypted_message = encryption_output[:cipher]
    initialization_vector = encryption_output[:initialization_vector]
    response.headers["initialization_vector"] = initialization_vector
    render json: { message: encrypted_message }
  end
end
