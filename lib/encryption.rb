module Encryption
  def encrypt(text, iv = SecureRandom.hex(8))
    cipher = OpenSSL::Cipher::AES.new(256, :CBC)
    cipher.encrypt
    cipher.key = ENV['key']
    cipher.iv = iv
    encrypted = cipher.update(text) + cipher.final

    # as of now, encrypted is a string of binary characters encoded as rubys's ASCII-8bit
    # convert that data into a string of hex characters
    encrypted_hex = encrypted.unpack('H*')[0]

    { cipher: encrypted_hex, iv: iv }
  end
end
