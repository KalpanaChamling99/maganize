# frozen_string_literal: true

require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = categories(:culture)
  end

  test 'should get index' do
    get categories_url
    assert_response :success
  end

  test 'should show category by slug' do
    get category_url(@category)
    assert_response :success
  end

  test 'should show category by id' do
    get category_url(@category.id)
    assert_response :success
  end
end
