class SecretMessage < ApplicationRecord
  validates :message, presence: true
end
