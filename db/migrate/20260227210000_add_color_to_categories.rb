class AddColorToCategories < ActiveRecord::Migration[7.1]
  AUTO_COLORS = %w[
    #ef4444 #3b82f6 #16a34a #9333ea #f59e0b #ec4899
    #6366f1 #14b8a6 #f97316 #06b6d4 #f43f5e #7c3aed
  ].freeze

  def up
    add_column :categories, :color, :string

    # Backfill existing categories with a deterministic color based on id
    execute <<~SQL
      UPDATE categories SET color = CASE id % 12
        WHEN 0  THEN '#ef4444'
        WHEN 1  THEN '#3b82f6'
        WHEN 2  THEN '#16a34a'
        WHEN 3  THEN '#9333ea'
        WHEN 4  THEN '#f59e0b'
        WHEN 5  THEN '#ec4899'
        WHEN 6  THEN '#6366f1'
        WHEN 7  THEN '#14b8a6'
        WHEN 8  THEN '#f97316'
        WHEN 9  THEN '#06b6d4'
        WHEN 10 THEN '#f43f5e'
        ELSE         '#7c3aed'
      END
    SQL
  end

  def down
    remove_column :categories, :color
  end
end
