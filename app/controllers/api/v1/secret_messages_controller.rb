class Api::V1::SecretMessagesController < AuthenticationController
  def show
    render json: { description: "secret message placeholder" }
  end
end
