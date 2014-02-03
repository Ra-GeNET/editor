require 'test_helper'

class LangsControllerTest < ActionController::TestCase
  setup do
    @lang = langs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:langs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lang" do
    assert_difference('Lang.count') do
      post :create, lang: { code: @lang.code, title: @lang.title }
    end

    assert_redirected_to lang_path(assigns(:lang))
  end

  test "should show lang" do
    get :show, id: @lang
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lang
    assert_response :success
  end

  test "should update lang" do
    patch :update, id: @lang, lang: { code: @lang.code, title: @lang.title }
    assert_redirected_to lang_path(assigns(:lang))
  end

  test "should destroy lang" do
    assert_difference('Lang.count', -1) do
      delete :destroy, id: @lang
    end

    assert_redirected_to langs_path
  end
end
