require 'spec_helper'

describe User do

  def valid_attributes
    {email: "test@test.com", password: "testpassword", password_confirmation: "testpassword"}
  end

  it "creates user with valid attributes" do
    user=User.create!(valid_attributes)
    user.should be_valid
  end

end
