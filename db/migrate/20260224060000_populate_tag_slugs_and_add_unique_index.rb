class PopulateTagSlugsAndAddUniqueIndex < ActiveRecord::Migration[7.1]
  def up
    Tag.find_each do |tag|
      next if tag.slug.present?
      slug = tag.name.parameterize
      # Ensure uniqueness by appending id if slug already taken
      slug = "#{slug}-#{tag.id}" if Tag.where(slug: slug).where.not(id: tag.id).exists?
      tag.update_column(:slug, slug)
    end

    add_index :tags, :slug, unique: true
  end

  def down
    remove_index :tags, :slug
  end
end
