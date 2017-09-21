require 'rails_helper'
require './lib/encryption.rb'

describe 'encryption module' do
  include Encryption

  it 'encrypts data and returns a hash containing the encrypted data and the initialization vector' do
    ENV['key'] = 'ff5c66433974329a675b114f27799251821c6830f0aa69cbb62cfcce6c6cd20f864494873c0e513a2033f650f357ef2cc9818b6541bf5625d3a4ee374e254b1e'
    iv = '35cd6e2b82b6537d'

    data = "There's always money in the banana stand."

    result = encrypt(data, iv)

    expect(result.class).to equal(Hash)
    expect(result[:cipher]).to eql('2d8c5aa513c04092ae3811f9a7dde8286e00badeb8310907c64da9c7289ed74734f4246a8c49f088ebea3d7d154604f5')
    expect(result[:iv]).to eql('35cd6e2b82b6537d')
  end

  it 'generates an initialization vector if one is not provided' do
    ENV['key'] = 'ff5c66433974329a675b114f27799251821c6830f0aa69cbb62cfcce6c6cd20f864494873c0e513a2033f650f357ef2cc9818b6541bf5625d3a4ee374e254b1e'

    data = "There's always money in the banana stand."

    result = encrypt(data)

    expect(result[:iv].class).to equal(String)
  end
end
