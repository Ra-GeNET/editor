require 'test_helper'

class ExtmapsControllerTest < ActionController::TestCase
  setup do
    @extmap = extmaps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:extmaps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create extmap" do
    assert_difference('Extmap.count') do
      post :create, extmap: { lang: @extmap.lang, suffix: @extmap.suffix }
    end

    assert_redirected_to extmap_path(assigns(:extmap))
  end

  test "should show extmap" do
    get :show, id: @extmap
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @extmap
    assert_response :success
  end

  test "should update extmap" do
    patch :update, id: @extmap, extmap: { lang: @extmap.lang, suffix: @extmap.suffix }
    assert_redirected_to extmap_path(assigns(:extmap))
  end

  test "should destroy extmap" do
    assert_difference('Extmap.count', -1) do
      delete :destroy, id: @extmap
    end

    assert_redirected_to extmaps_path
  end
end
