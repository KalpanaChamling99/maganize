module ApplicationHelper
  include LucideRails::RailsHelper

  # Renders a sortable column header link for admin tables.
  # current_sort / current_direction come from the controller (@sort / @direction).
  def admin_sort_link(label, column, current_sort:, current_direction:)
    active   = current_sort == column
    next_dir = (active && current_direction == "asc") ? "desc" : "asc"

    link_to(request.params.merge(sort: column, direction: next_dir, page: nil),
            class: "inline-flex items-center gap-1 hover:text-gray-700 transition-colors #{active ? "text-gray-900" : "text-gray-400"}") do
      concat label
      concat(content_tag(:span, class: "w-3 h-3 shrink-0") do
        if active && current_direction == "asc"
          raw('<svg viewBox="0 0 10 10" fill="currentColor"><path d="M5 2l4 6H1z"/></svg>')
        elsif active
          raw('<svg viewBox="0 0 10 10" fill="currentColor"><path d="M5 8l4-6H1z"/></svg>')
        else
          raw('<svg viewBox="0 0 10 10" fill="currentColor" opacity="0.35"><path d="M5 1l3 4H2zm0 8L2 5h6z"/></svg>')
        end
      end)
    end
  end

  # Returns an inline style string for a category badge using the stored hex color.
  def category_badge_style(category)
    color = category.color.presence rescue nil
    color ||= "#ef4444"
    "background-color: #{color}"
  end

  # Returns an array of page numbers and :gap symbols for the pagination partial.
  # Always shows first/last page and a window of pages around the current page.
  def paginate_range(collection, window: 2)
    current = collection.current_page
    total   = collection.total_pages
    inner   = ((current - window)..(current + window)).select { |p| p >= 1 && p <= total }
    pages   = ([1] + inner + [total]).uniq.sort

    result = []
    pages.each_with_index do |page, i|
      result << :gap if i > 0 && page > pages[i - 1] + 1
      result << page
    end
    result
  end
end
