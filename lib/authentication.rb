module Authentication
  def authenticated?(request)
    # development scheme and host:
    scheme = 'http://'
    host = 'localhost:3000'

    # production scheme and host:
    # scheme = 'https://'
    # host = 'secret-message-server.herokuapp.com'

    method = request.request_method
    path = request.fullpath
    url = scheme + host + path
    http_version = 'HTTP/1.1'
    request_line = method + ' ' + url + ' ' + http_version

    key = ENV['key']
    digest = OpenSSL::Digest.new('sha256')
    expected_signature = OpenSSL::HMAC.hexdigest(digest, key, request_line)

    actual_signature = request.headers['Authorization']

    expected_signature == actual_signature
  end

  def generate_signature(message)
    key = ENV['key']
    digest = OpenSSL::Digest.new('sha256')
    OpenSSL::HMAC.hexdigest(digest, key, message)
  end
end
