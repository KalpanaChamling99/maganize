# frozen_string_literal: true

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  # ── Validations ───────────────────────────────────────────────────────────
  test 'is valid with a unique name' do
    category = Category.new(name: 'Sports')
    assert category.valid?
  end

  test 'is invalid without a name' do
    category = Category.new
    assert_not category.valid?
    assert_includes category.errors[:name], "can't be blank"
  end

  test 'is invalid with a duplicate name' do
    Category.create!(name: 'Health')
    category = Category.new(name: 'Health')
    assert_not category.valid?
  end

  test 'name uniqueness is case-insensitive' do
    Category.create!(name: 'Music')
    category = Category.new(name: 'music')
    assert_not category.valid?
  end

  # ── Callbacks ─────────────────────────────────────────────────────────────
  test 'generates slug from name on save' do
    category = Category.create!(name: 'Food & Drink')
    assert_equal 'food-drink', category.slug
  end

  test 'does not overwrite an existing slug' do
    category = Category.create!(name: 'Art', slug: 'custom-art')
    assert_equal 'custom-art', category.slug
  end

  test 'auto-assigns a hex color on save' do
    category = Category.create!(name: 'NewCategory')
    assert_match(/\A#[0-9a-f]{6}\z/i, category.color)
  end

  test 'does not overwrite an existing color' do
    category = Category.create!(name: 'Design', color: '#123456')
    assert_equal '#123456', category.color
  end

  # ── to_param ──────────────────────────────────────────────────────────────
  test 'to_param returns the slug' do
    assert_equal categories(:culture).slug, categories(:culture).to_param
  end
end
