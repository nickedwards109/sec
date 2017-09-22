require 'rails_helper'

RSpec.describe SecretMessage, type: :model do
  it "validates for existence of a message attribute" do
    invalid_message1 = SecretMessage.create
    expect(invalid_message1).not_to be_valid

    invalid_message2 = SecretMessage.create(message: "")
    expect(invalid_message2).not_to be_valid

    valid_message = SecretMessage.create(message: "i like vegemite")
    expect(valid_message).to be_valid
  end
end
