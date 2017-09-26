require './lib/encryption'

class Api::V1::SecretMessagesController < AuthenticationController
  include Encryption

  def index
    secret_messages = SecretMessage.all
    response_body = []
    secret_messages.each do |secret_message|
      encryption_output = encrypt(secret_message.message)
      signature = generate_signature(secret_message.message)
      message_data = encryption_output.merge({signature: signature})
      response_body.push message_data
    end
    render json: {"messages" => response_body}
  end

  def show
    message = SecretMessage.find(params[:id]).message
    encryption_output = encrypt(message)
    signature = generate_signature(message)
    message_data = encryption_output.merge({signature: signature})
    render json: {"messages" => [message_data]}
  end
end
