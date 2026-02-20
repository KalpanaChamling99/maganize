json.extract! article, :id, :title, :excerpt, :body, :published_at, :featured, :cover_image, :category_id, :created_at, :updated_at
json.url article_url(article, format: :json)
