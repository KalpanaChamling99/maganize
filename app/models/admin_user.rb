class AdminUser < ApplicationRecord
  has_secure_password

  validates :name,  presence: true
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  before_save { self.email = email.downcase.strip }

  def self.authenticate_by_email(email, password)
    user = find_by(email: email.to_s.downcase.strip)
    user&.authenticate(password) ? user : nil
  end
end
