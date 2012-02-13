require 'test_helper'

class PassengersControllerTest < ActionController::TestCase
  setup do
    @passenger = passengers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:passengers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create passenger" do
    assert_difference('Passenger.count') do
      post :create, passenger: @passenger.attributes
    end

    assert_redirected_to passenger_path(assigns(:passenger))
  end

  test "should show passenger" do
    get :show, id: @passenger.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @passenger.to_param
    assert_response :success
  end

  test "should update passenger" do
    put :update, id: @passenger.to_param, passenger: @passenger.attributes
    assert_redirected_to passenger_path(assigns(:passenger))
  end

  test "should destroy passenger" do
    assert_difference('Passenger.count', -1) do
      delete :destroy, id: @passenger.to_param
    end

    assert_redirected_to passengers_path
  end
end
