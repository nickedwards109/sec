module Encryption
  def encrypt(text)
    cipher = OpenSSL::Cipher::AES.new(256, :CBC)
    cipher.encrypt
    cipher.key = ENV['key']

    # If this is executed via the request specs, ENV['initialization_vector']
    #  is set in the specs.
    # ENV['initialization_vector'] is not set in application.yml.
    # If ENV['initialization_vector'] does not exist, generate a new random
    #  initialization vector.
    initialization_vector = ENV['initialization_vector'] || SecureRandom.hex(8)
    cipher.iv = initialization_vector
    encrypted = cipher.update(text) + cipher.final

    # as of now, encrypted is a string of binary characters encoded as rubys's ASCII-8bit
    # convert that data into a string of hex characters
    encrypted_hex = encrypted.unpack('H*')[0]

    { cipher: encrypted_hex, initialization_vector: initialization_vector }
  end
end
