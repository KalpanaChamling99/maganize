class Admin::SettingsController < Admin::BaseController
  before_action -> { require_permission(:manage_collections) }

  def show
    @collections = Collection.order(:title)
    @featured_ids = Collection.featured.pluck(:id)
  end

  def update
    featured_ids = Array(params.dig(:settings, :featured_collection_ids)).map(&:to_i).select(&:positive?)
    Collection.find_each do |c|
      c.update_column(:featured, featured_ids.include?(c.id))
    end
    redirect_to admin_settings_path, notice: "Homepage settings saved."
  end
end
