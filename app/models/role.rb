class Role < ApplicationRecord
  serialize :permissions, coder: YAML

  has_many :admin_users, dependent: :nullify

  PERMISSION_GROUPS = {
    "Articles"          => %w[view_articles create_articles edit_articles delete_articles],
    "Categories & Tags" => %w[manage_categories manage_tags],
    "Collections"       => %w[manage_collections],
    "Media"             => %w[delete_media],
    "Team Members"      => %w[manage_team_members],
    "Access"            => %w[manage_users manage_roles]
  }.freeze

  ALL_PERMISSIONS = PERMISSION_GROUPS.values.flatten.freeze

  PERMISSION_LABELS = {
    "view_articles"       => "View Articles",
    "create_articles"     => "Create Articles",
    "edit_articles"       => "Edit Articles",
    "delete_articles"     => "Delete Articles",
    "manage_categories"   => "Manage Categories",
    "manage_tags"         => "Manage Tags",
    "manage_collections"  => "Manage Collections",
    "delete_media"        => "Delete Media",
    "manage_team_members" => "Manage Team Members",
    "manage_users"        => "Manage Users",
    "manage_roles"        => "Manage Roles"
  }.freeze

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def can?(permission)
    permissions.include?(permission.to_s)
  end
end
