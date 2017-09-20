class Api::V1::SecretMessagesController < AuthenticationController
  def show
    render json: { message: "secret message placeholder" }
  end
end
