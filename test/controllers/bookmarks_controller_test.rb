# frozen_string_literal: true

require 'test_helper'

class BookmarksControllerTest < ActionDispatch::IntegrationTest
  test 'should get index without params (loading state)' do
    get bookmarks_url
    assert_response :success
  end

  test 'should get index with valid article ids' do
    article = articles(:one)
    get bookmarks_url, params: { ids: article.id.to_s }
    assert_response :success
  end

  test 'should get index with multiple ids' do
    ids = "#{articles(:one).id},#{articles(:two).id}"
    get bookmarks_url, params: { ids: ids }
    assert_response :success
  end

  test 'should get index with non-existent ids (empty state)' do
    get bookmarks_url, params: { ids: '0' }
    assert_response :success
  end
end
