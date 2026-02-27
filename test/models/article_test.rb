# frozen_string_literal: true

require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  # ── Validations ───────────────────────────────────────────────────────────
  test 'is valid with title and published_at' do
    article = Article.new(title: 'Test Article', published_at: Time.current)
    assert article.valid?
  end

  test 'is invalid without title' do
    article = Article.new(published_at: Time.current)
    assert_not article.valid?
    assert_includes article.errors[:title], "can't be blank"
  end

  test 'is invalid without published_at' do
    article = Article.new(title: 'Test Article')
    assert_not article.valid?
    assert_includes article.errors[:published_at], "can't be blank"
  end

  # ── published? ────────────────────────────────────────────────────────────
  test 'published? is true when published_at is in the past' do
    article = Article.new(title: 'Past', published_at: 1.day.ago)
    assert article.published?
  end

  test 'published? is false when published_at is in the future' do
    article = Article.new(title: 'Future', published_at: 1.day.from_now)
    assert_not article.published?
  end

  test 'published? is false when published_at is nil' do
    article = Article.new(title: 'Draft')
    assert_not article.published?
  end

  # ── Scopes ────────────────────────────────────────────────────────────────
  test 'published scope includes past-published articles' do
    assert_includes Article.published, articles(:one)
  end

  test 'featured scope returns only featured articles' do
    assert_includes Article.featured, articles(:two)
    assert_not_includes Article.featured, articles(:one)
  end

  test 'recent scope orders by published_at descending' do
    dates = Article.recent.pluck(:published_at)
    assert_equal dates, dates.sort.reverse
  end

  # ── Associations ──────────────────────────────────────────────────────────
  test 'can have categories through article_categories' do
    assert_respond_to articles(:one), :categories
  end

  test 'can have tags through article_tags' do
    assert_respond_to articles(:one), :tags
  end
end
