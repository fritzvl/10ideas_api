module ControllerMacros
    def setup_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = Fabricate(:user)
      #sign_in user
    end
  end
end