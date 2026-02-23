class Admin::MediaController < Admin::BaseController
  def index
    @attachments = ActiveStorage::Attachment
      .where(record_type: "Article", name: "images")
      .includes(:blob, record: :category)
      .order(created_at: :desc)
      .page(params[:page]).per(24)
  end

  def destroy
    attachment = ActiveStorage::Attachment.find(params[:id])
    attachment.purge
    redirect_to admin_media_path, notice: "Image deleted."
  end
end
