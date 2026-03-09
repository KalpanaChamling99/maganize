class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar

  ROLES = %w[viewer].freeze

  before_create { self.role ||= "viewer" }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, allow_nil: true

  before_save { self.email = email.downcase }
end
