require "open-uri"

namespace :articles do
  desc "Attach Unsplash-style images (via Picsum) to articles that have none"
  task attach_images: :environment do
    # Seed words per category — gives consistent, relevant imagery
    category_seeds = {
      "Culture"           => "people",
      "Technology"        => "technology",
      "Politics"          => "city",
      "Science"           => "science",
      "Travel"            => "travel",
      "Food & Drink"      => "food",
      "Fashion"           => "fashion",
      "Health & Wellness" => "wellness",
      "Business"          => "office",
      "Environment"       => "forest",
      "Arts"              => "art",
      "Sports"            => "sport",
      "Literature"        => "library",
      "Film & TV"         => "cinema",
      "Music"             => "music",
      "Photography"       => "camera",
      "Architecture"      => "architecture",
      "History"           => "vintage",
      "Education"         => "study",
      "Opinion"           => "writing"
    }

    articles = Article.includes(:category).select { |a| !a.images.attached? }

    if articles.empty?
      puts "All articles already have images. Nothing to do."
      next
    end

    puts "Attaching images to #{articles.count} articles...\n\n"

    success = 0
    failed  = 0

    articles.each_with_index do |article, idx|
      seed   = category_seeds[article.category&.name] || "magazine"
      # picsum.photos/seed/:seed/w/h — deterministic per seed string
      url    = "https://picsum.photos/seed/#{seed}-#{article.id}/1600/900"

      print "  [#{idx + 1}/#{articles.count}] #{article.title.truncate(55)}... "

      begin
        image = URI.open(url, read_timeout: 15)
        article.images.attach(
          io:           image,
          filename:     "article-#{article.id}-cover.jpg",
          content_type: "image/jpeg"
        )
        puts "done"
        success += 1
      rescue => e
        puts "FAILED (#{e.message})"
        failed += 1
      end
    end

    puts "\n#{"─" * 50}"
    puts "  Attached: #{success}   Failed: #{failed}"
    puts "#{"─" * 50}"
  end
end
