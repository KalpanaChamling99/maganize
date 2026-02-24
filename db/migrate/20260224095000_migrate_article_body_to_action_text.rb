class MigrateArticleBodyToActionText < ActiveRecord::Migration[7.1]
  def up
    Article.find_each do |article|
      text = article.read_attribute(:body)
      next if text.blank?

      # Convert plain-text paragraphs (double-newline separated) to HTML
      html = text.split(/\n\n+/).map do |para|
        "<p>#{CGI.escapeHTML(para.strip.gsub(/\n/, "<br>"))}</p>"
      end.join

      ActionText::RichText.create!(
        record_type: "Article",
        record_id:   article.id,
        name:        "body",
        body:        html
      )
    end

    remove_column :articles, :body
  end

  def down
    add_column :articles, :body, :text

    ActionText::RichText.where(record_type: "Article", name: "body").each do |rt|
      Article.where(id: rt.record_id).update_all(body: rt.body.to_plain_text)
    end
  end
end
