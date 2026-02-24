class AdminUser < ApplicationRecord
  has_secure_password

  enum :role, { viewer: 0, author: 1, editor: 2, admin: 3, root_admin: 4 }

  validates :name,  presence: true
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  before_save { self.email = email.downcase.strip }

  def self.authenticate_by_email(email, password)
    user = find_by(email: email.to_s.downcase.strip)
    user&.authenticate(password) ? user : nil
  end

  # Returns true if this user's role is >= the given role level
  def at_least?(role_name)
    self.class.roles[self.role] >= self.class.roles[role_name.to_s]
  end

  # Returns true if this user can manage (edit/delete) another user
  def can_manage?(other_user)
    return false if other_user == self
    return false if other_user.at_least?(:root_admin) && !root_admin?
    at_least?(:admin) && self.class.roles[self.role] > self.class.roles[other_user.role]
  end

  ROLE_LABELS = {
    "viewer"     => "Viewer",
    "author"     => "Author",
    "editor"     => "Editor",
    "admin"      => "Admin",
    "root_admin" => "Root Admin"
  }.freeze

  ROLE_COLORS = {
    "viewer"     => "bg-gray-100 text-gray-600",
    "author"     => "bg-blue-100 text-blue-700",
    "editor"     => "bg-purple-100 text-purple-700",
    "admin"      => "bg-amber-100 text-amber-700",
    "root_admin" => "bg-red-100 text-red-700"
  }.freeze
end
