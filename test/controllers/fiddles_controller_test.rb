require 'test_helper'

class FiddlesControllerTest < ActionController::TestCase
  setup do
    @fiddle = fiddles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fiddles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fiddle" do
    assert_difference('Fiddle.count') do
      post :create, fiddle: { code: @fiddle.code, title: @fiddle.title }
    end

    assert_redirected_to fiddle_path(assigns(:fiddle))
  end

  test "should show fiddle" do
    get :show, id: @fiddle
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fiddle
    assert_response :success
  end

  test "should update fiddle" do
    patch :update, id: @fiddle, fiddle: { code: @fiddle.code, title: @fiddle.title }
    assert_redirected_to fiddle_path(assigns(:fiddle))
  end

  test "should destroy fiddle" do
    assert_difference('Fiddle.count', -1) do
      delete :destroy, id: @fiddle
    end

    assert_redirected_to fiddles_path
  end
end
