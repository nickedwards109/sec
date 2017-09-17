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

    secret_message = JSON.parse(response.body)["description"]

    expect(secret_message.class).to equal(String)
    expect(response).to have_http_status(200)
  end
end
