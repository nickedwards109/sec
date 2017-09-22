require 'rails_helper'

describe 'Secret messages API' do
  it 'responds with a 404 to an unauthenticated request' do
    get '/api/v1/secret_messages/1.json'
    expect(response).to have_http_status(404)

    get '/api/v1/secret_messages/1.json', headers: { 'Authorization' => '' }
    expect(response).to have_http_status(404)

    invalid_signature = "1234abcd"
    get '/api/v1/secret_messages/1.json', headers: { 'Authorization' => invalid_signature }
    expect(response).to have_http_status(404)
  end

  it 'responds with an HTTP 200 response to an authenticated request' do
    # This overrides the key in application.yml which is ignored from
    #  version control
    ENV['key'] = 'ff5c66433974329a675b114f27799251821c6830f0aa69cbb62cfcce6c6cd20f864494873c0e513a2033f650f357ef2cc9818b6541bf5625d3a4ee374e254b1e'

    # When this key is used with SHA-256 HMAC to hash the following
    #  string: 'GET http://localhost:3000/api/v1/secret_messages/1.json HTTP/1.1'
    #  the resulting string is the digital signature below.
    # This follows the authentication scheme described in README.md.
    # Eventually, when this app is pushed to production, the endpoint will be:
    #  http://secret-message-server.herokuapp.com/api/v1/secret_messages/1.json
    correct_signature = '90aa7d0c79677d86800500f6c999a6273544169f3912322c5e48174b58fb90dc'
    get '/api/v1/secret_messages/1.json', headers: { 'Authorization' => correct_signature }

    secret_message = JSON.parse(response.body)["message"]

    expect(secret_message.class).to equal(String)
    expect(response).to have_http_status(200)
  end

  it 'encrypts the response body with AES-256-CBC and sends the initialization vector' do
    original_message = SecretMessage.create(message: "There's always money in the banana stand.")

    ENV['key'] = 'ff5c66433974329a675b114f27799251821c6830f0aa69cbb62cfcce6c6cd20f864494873c0e513a2033f650f357ef2cc9818b6541bf5625d3a4ee374e254b1e'
    ENV['initialization_vector'] = '35cd6e2b82b6537d'
    correct_signature = '90aa7d0c79677d86800500f6c999a6273544169f3912322c5e48174b58fb90dc'
    get '/api/v1/secret_messages/1.json', headers: { 'Authorization' => correct_signature }

    response_initialization_vector = response.headers["initialization_vector"]
    response_body = JSON.parse(response.body)
    response_cipher = response["cipher"]

    expected_response_cipher = "2d8c5aa513c04092ae3811f9a7dde8286e00badeb8310907c64da9c7289ed74734f4246a8c49f088ebea3d7d154604f5"
    expect(response_cipher).to equal(expected_response_cipher)
    expect(response_initialization_vector).to equal('35cd6e2b82b6537d')
  end
end
