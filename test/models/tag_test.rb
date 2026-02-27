# frozen_string_literal: true

require 'test_helper'

class TagTest < ActiveSupport::TestCase
  # ── Callbacks ─────────────────────────────────────────────────────────────
  test 'generates slug from name on save' do
    tag = Tag.create!(name: 'Long Form')
    assert_equal 'long-form', tag.slug
  end

  test 'does not overwrite an existing slug' do
    tag = Tag.create!(name: 'Essay', slug: 'custom-essay')
    assert_equal 'custom-essay', tag.slug
  end

  # ── to_param ──────────────────────────────────────────────────────────────
  test 'to_param returns the slug' do
    assert_equal tags(:longform).slug, tags(:longform).to_param
  end

  # ── Associations ──────────────────────────────────────────────────────────
  test 'can have articles through article_tags' do
    assert_respond_to tags(:longform), :articles
  end
end
