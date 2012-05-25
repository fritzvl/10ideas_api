require 'spec_helper'

describe Api::SessionsController do
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

  describe "POST user data for the authentication" do

    before :each do
       user=User.create(valid_attributes)
    end

    it "authenticates with valid password" do
      post :create, {:user=>{:email => valid_attributes[:email], :password => valid_attributes[:password]}, :format => :json}
      response.should be_successful
      JSON.is_json?(response.body).should be_true
    end

  end

end