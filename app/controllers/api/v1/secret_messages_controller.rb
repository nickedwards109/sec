require './lib/encryption'

class Api::V1::SecretMessagesController < AuthenticationController
  include Encryption
  def show
    message = SecretMessage.find(params[:id]).message
    encryption_output = encrypt(message)
    encrypted_message = encryption_output[:cipher]
    initialization_vector = encryption_output[:initialization_vector]
    response.headers["initialization_vector"] = initialization_vector
    render json: { message: encrypted_message }
  end
end
