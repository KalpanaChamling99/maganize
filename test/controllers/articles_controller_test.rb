# frozen_string_literal: true

require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles(:one)
  end

  test 'should get index' do
    get articles_url
    assert_response :success
  end

  test 'should show article' do
    get article_url(@article)
    assert_response :success
  end

  test 'index filters by category' do
    get articles_url, params: { category_id: categories(:culture).id }
    assert_response :success
  end

  test 'index filters by year and month' do
    get articles_url, params: { year: 2026, month: 1 }
    assert_response :success
  end
end
