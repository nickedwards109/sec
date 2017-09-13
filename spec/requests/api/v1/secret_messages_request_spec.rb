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

  xit 'responds with a 200 to an authenticated request' do
    # This overrides the password in application.yml which is ignored from
    #  version control
    ENV['password'] = 'ff5c66433974329a675b114f27799251821c6830f0aa69cbb62cfcce6c6cd20f864494873c0e513a2033f650f357ef2cc9818b6541bf5625d3a4ee374e254b1e'

    # When this password is used with AES-256-CBC to encrypt the following
    #  string: 'GET https://secret-message-server.herokuapp.com/api/v1/secret_messages/1.json 1.1'
    #  the resulting string is the digital signature below.
    # This follows the authentication scheme described in README.md.
    # This test data is the same data used in the client-side application at
    # https://github.com/nickedwards109/secret-message-client
    signature = '73c9f540c5f00bc56f07b6ba5f2e1e34b5b937ed4db731a4500424458cf6a72d18ec0ad61b12a7f24f181f7815c69166ee94dfc6fa4cb5871b0d086ee7e31fccf3f720de99f9f5fb06eb770c61bde6e905eaf9f6f93548eb33c1eb7463901684'
    get '/api/v1/secret_messages/1.json', headers: { 'Authorization' => signature }
    expect(response).to have_http_status(200)
  end
end
