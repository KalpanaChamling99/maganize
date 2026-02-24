class Admin::MediaController < Admin::BaseController
  before_action -> { require_permission(:delete_media) }, only: [:destroy]

  def index
    per = [12, 24, 48].include?(params[:per_page].to_i) ? params[:per_page].to_i : 24
    @attachments = ActiveStorage::Attachment
      .where(record_type: "Article", name: "images")
      .includes(:blob, record: :category)
      .order(created_at: :desc)
      .page(params[:page]).per(per)
  end

  def destroy
    attachment = ActiveStorage::Attachment.find(params[:id])
    attachment.purge
    redirect_to admin_media_path, status: :see_other, notice: "Image deleted."
  end
end
