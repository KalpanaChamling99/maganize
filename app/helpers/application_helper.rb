module ApplicationHelper
  include LucideRails::RailsHelper

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
