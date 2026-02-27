# frozen_string_literal: true

require 'test_helper'

class TeamMemberTest < ActiveSupport::TestCase
  # ── Validations ───────────────────────────────────────────────────────────
  test 'is valid with name and role' do
    member = TeamMember.new(name: 'Alice Smith', role: 'Writer')
    assert member.valid?
  end

  test 'is invalid without name' do
    member = TeamMember.new(role: 'Writer')
    assert_not member.valid?
    assert_includes member.errors[:name], "can't be blank"
  end

  test 'is invalid without role' do
    member = TeamMember.new(name: 'Alice Smith')
    assert_not member.valid?
    assert_includes member.errors[:role], "can't be blank"
  end

  test 'name must be unique case-insensitively' do
    TeamMember.create!(name: 'Bob Jones', role: 'Editor')
    duplicate = TeamMember.new(name: 'bob jones', role: 'Writer')
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], 'is already taken by another team member'
  end

  # ── Callbacks ─────────────────────────────────────────────────────────────
  test 'generates slug from name on save' do
    member = TeamMember.create!(name: 'Carol White', role: 'Reporter')
    assert_equal 'carol-white', member.slug
  end

  test 'does not overwrite an existing slug' do
    member = TeamMember.create!(name: 'Dan Brown', role: 'Editor', slug: 'custom-dan')
    assert_equal 'custom-dan', member.slug
  end

  # ── to_param ──────────────────────────────────────────────────────────────
  test 'to_param returns the slug' do
    member = team_members(:one)
    assert_equal member.slug, member.to_param
  end

  # ── Associations ──────────────────────────────────────────────────────────
  test 'can have many articles' do
    assert_respond_to team_members(:one), :articles
  end
end
