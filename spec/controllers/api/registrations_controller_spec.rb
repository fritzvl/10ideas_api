require 'spec_helper'

describe Api::RegistrationsController do
  include Devise::TestHelpers


  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  def valid_attributes
    {:email => "test@test.com", :password => "123456", :password_confirmation => "123456"}
  end

  def invalid_attributes
    {:email => "test@test.com"}
  end

  describe "POST user data for the registrations" do

    it "creates a new User with valid attributes" do
      expect {
        post :create, {:user => valid_attributes, :format => :json}
      }.to change(User, :count).by(1)
    end

    it "registers user with valid attributes" do
      post :create, {:user => valid_attributes, :format => :json}
      JSON.is_json?(response.body).should be_true
    end


    it "not creates a new User with invalid attributes" do
      expect {
        post :create, {:user => invalid_attributes, :format => :json}
      }.not_to change(User, :count).by(1)
    end

    it "not registers user with invalid attributes" do
      post :create, {:user => invalid_attributes, :format => :json}
      response.status.should be 422
    end

    it "not registers user with invalid attributes" do
      post :create, {:user => invalid_attributes, :format => :json}
      JSON.is_json?(response.body).should be_true
    end
  end

  describe "PUT user data for the user data update" do

    before :each do
      @user=Fabricate(:user)
    end


    def updated_attributes
      {:email => "test@test.com", :current_password => @user.password, :password => "1234567", :password_confirmation => "1234567"}
    end


    it "updates the existing User with valid attributes" do
      expect {
        put :update, {:user => updated_attributes, :id => @user.id, :auth_token => @user.authentication_token, :format => :json}
      }.not_to change(User, :count).by(1)
    end

    it "update user with valid attributes" do
      put :update, {:user => updated_attributes, :id => @user.id, :auth_token => @user.authentication_token, :format => :json}
      JSON.is_json?(response.body).should be_true
      response.body.should include("ok")
    end


    it "not updates a new User with invalid attributes" do
      expect {
        put :update, {:user => invalid_attributes, :id => @user.id, :auth_token => @user.authentication_token, :format => :json}
      }.not_to change(User, :count).by(1)
    end

    it "not updates user with valid attributes" do
      put :update, {:user => valid_attributes, :id => @user.id, :auth_token => @user.authentication_token, :format => :json}
      response.status.should be 422
    end


    it "not updates user with valid attributes" do
      put :update, {:user => valid_attributes, :id => @user.id, :auth_token => @user.authentication_token, :format => :json}
      JSON.is_json?(response.body).should be_true
      response.body.should_not include("ok")
    end
  end


end
