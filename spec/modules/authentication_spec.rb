require 'rails_helper'
require './lib/authentication.rb'

describe 'authentication module' do
  include Authentication

  # stub an incoming HTTP request
  class Request
    attr_accessor :headers, :request_method, :fullpath
  end

  before(:each) do
    # This overrides the key in application.yml which is ignored from
    #  version control
    @request = Request.new
  end

  it 'authenticates a request with a valid signature' do
    ENV['key'] = 'ff5c66433974329a675b114f27799251821c6830f0aa69cbb62cfcce6c6cd20f864494873c0e513a2033f650f357ef2cc9818b6541bf5625d3a4ee374e254b1e'
    @request.headers = { 'Authorization' => '90aa7d0c79677d86800500f6c999a6273544169f3912322c5e48174b58fb90dc' }
    @request.request_method = 'GET'
    @request.fullpath = '/api/v1/secret_messages/1.json'
    expect(authenticated?(@request)).to be_truthy
  end

  it 'does not authenticate a request with an invalid signature' do
    ENV['key'] = 'ff5c66433974329a675b114f27799251821c6830f0aa69cbb62cfcce6c6cd20f864494873c0e513a2033f650f357ef2cc9818b6541bf5625d3a4ee374e254b1e'
    @request.headers = { 'Authorization' => 'asdf plz' }
    @request.request_method = 'GET'
    @request.fullpath = '/api/v1/secret_messages/1.json'
    expect(authenticated?(@request)).to be_falsy
  end

  it 'does not authenticate a request whose HTTP method or URL do not match the API requirements' do
    ENV['key'] = 'ff5c66433974329a675b114f27799251821c6830f0aa69cbb62cfcce6c6cd20f864494873c0e513a2033f650f357ef2cc9818b6541bf5625d3a4ee374e254b1e'

    # The signature in these tests is a hash of the request line 'GET http://localhost:3000/api/v1/secret_messages/1.json HTTP/1.1'
    @request.headers = { 'Authorization' => '90aa7d0c79677d86800500f6c999a6273544169f3912322c5e48174b58fb90dc' }

    # incorrect HTTP method
    @request.request_method = 'POST'
    @request.fullpath = '/api/v1/secret_messages/1.json'
    expect(authenticated?(@request)).to be_falsy

    # incorrect URL
    @request.request_method = 'GET'
    @request.fullpath = '/api/v42/public_messages/1.json'
    expect(authenticated?(@request)).to be_falsy
  end

  it 'does not authenticate a request when the key is incorrect' do
    ENV['key'] = 'lulz0194r019RnE2plz'
    @request.headers = { 'Authorization' => '90aa7d0c79677d86800500f6c999a6273544169f3912322c5e48174b58fb90dc' }
    @request.request_method = 'GET'
    @request.fullpath = '/api/v1/secret_messages/1.json'
    expect(authenticated?(@request)).to be_falsy
  end

  it 'generates a digital signature from a message' do
    ENV['key'] = 'ff5c66433974329a675b114f27799251821c6830f0aa69cbb62cfcce6c6cd20f864494873c0e513a2033f650f357ef2cc9818b6541bf5625d3a4ee374e254b1e'
    message = "There's always money in the banana stand."
    expect(generate_signature(message)).to eql("b255de9b3d2342f43c97ec1ec94f9fc8744512a31f6ae85fbc80b33da5596952")
  end
end
