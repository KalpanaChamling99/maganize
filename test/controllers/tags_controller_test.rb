# frozen_string_literal: true

require 'test_helper'

class TagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tag = tags(:longform)
  end

  test 'should get index' do
    get tags_url
    assert_response :success
  end

  test 'should show tag' do
    get tag_url(@tag)
    assert_response :success
  end
end
