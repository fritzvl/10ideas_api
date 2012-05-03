require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe IdeasController do
  include Devise::TestHelpers
  setup_user

  # This should return the minimal set of attributes required to create a valid
  # Idea. As you add validations to Idea, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {essential: "Some great test controller idea"}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # IdeasController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all ideas as @ideas" do
      get :index, {:format => :json, :auth_token => @user.authentication_token}
      assigns(:ideas).should == Idea.current_ideas_for(subject.current_user)
    end

    it "responses with ideas in JSON format" do
      idea = Idea.create! valid_attributes
      get :index, {:format => :json, :auth_token => @user.authentication_token}
      JSON.is_json?(response.body).should be_true
    end

    it "responses with today data only" do
      10.times { Fabricate(:user) }
      get :index, {:format => :json, :auth_token => @user.authentication_token}
      assigns(:ideas).should == Idea.current_ideas_for(subject.current_user)
    end


  end

  describe "GET by_date" do

    it "responses by ideas for the specific date" do
      idea=Fabricate(:idea, :user_id => @user.id, :created_at => Date.yesterday-1.day)
      get :by_date, {:date => (Date.yesterday-1.day).strftime, :auth_token => @user.authentication_token}
      assigns(:ideas).should == [idea]
    end

  end

  describe "GET show" do
    it "assigns the requested idea as @idea" do
      idea = Idea.create! valid_attributes
      get :show, {:id => idea.to_param, :auth_token => @user.authentication_token}
      assigns(:idea).should eq(idea)
    end

    it "responses with idea in JSON format" do
      idea = Idea.create! valid_attributes
      get :show, {:id => idea.to_param, :format => :json, :auth_token => @user.authentication_token}
      JSON.is_json?(response.body).should be_true
    end

  end


  describe "POST create" do
    describe "with valid params" do
      it "creates a new Idea" do
        expect {
          post :create, {:idea => valid_attributes, :auth_token => @user.authentication_token}
        }.to change(Idea, :count).by(1)
      end

      it "assigns a newly created idea as @idea" do
        post :create, {:idea => valid_attributes, :auth_token => @user.authentication_token}
        assigns(:idea).should be_a(Idea)
        assigns(:idea).should be_persisted
      end

      it "responses with created idea in JSON format" do
        post :create, {:idea => valid_attributes, :format => :json, :auth_token => @user.authentication_token}
        response.should be_success
        JSON.is_json?(response.body).should be_true
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved idea as @idea" do
        # Trigger the behavior that occurs when invalid params are submitted
        Idea.any_instance.stub(:save).and_return(false)
        post :create, {:idea => {}, :auth_token => @user.authentication_token}
        assigns(:idea).should be_a_new(Idea)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Idea.any_instance.stub(:save).and_return(false)
        post :create, {:idea => {}, :format => :json, :auth_token => @user.authentication_token}
        response.should_not be_success
        response.status.should be 422
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested idea" do
        idea = Idea.create! valid_attributes
        # Assuming there are no other ideas in the database, this
        # specifies that the Idea created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Idea.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => idea.to_param, :idea => {'these' => 'params'}, :auth_token => @user.authentication_token, :format => :json}
      end

      it "assigns the requested idea as @idea" do
        idea = Idea.create! valid_attributes
        put :update, {:id => idea.to_param, :idea => valid_attributes, :auth_token => @user.authentication_token, :format => :json}
        assigns(:idea).should eq(idea)
      end

      it "responses with updated idea in JSON format" do
        idea = Idea.create! valid_attributes
        put :update, {:id => idea.to_param, :idea => valid_attributes, :auth_token => @user.authentication_token, :format => :json}
        response.should be_success
        JSON.is_json?(response.body).should be_true
      end
    end

    describe "with invalid params" do
      it "assigns the idea as @idea" do
        idea = Idea.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Idea.any_instance.stub(:save).and_return(false)
        put :update, {:id => idea.to_param, :idea => {}, :auth_token => @user.authentication_token, :format => :json}
        assigns(:idea).should eq(idea)
      end

      it "re-renders the 'edit' template" do
        idea = Idea.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Idea.any_instance.stub(:save).and_return(false)
        put :update, {:id => idea.to_param, :idea => {}, :auth_token => @user.authentication_token, :format => :json}
        response.should_not be_success
        response.status.should be 422
      end
    end
  end

  describe "PUT publish" do
    describe "with valid params" do
      it "changes idea state to public" do
        idea = Idea.create! valid_attributes
        Idea.any_instance.stub(:publish!).and_return(true)
        put :publish, {:id => idea.to_param, :auth_token => @user.authentication_token, :format => :json}
        response.should be_success
        JSON.is_json?(response.body).should be_true
      end
    end
  end

  describe "PUT vote" do
    describe "with valid params" do
      it "vote for idea " do
        owner=Fabricate(:user)
        attributes=valid_attributes
        attributes[:user_id]=owner.id
        idea = Idea.create! attributes
        put :vote, {:id => idea.to_param, :auth_token => @user.authentication_token, :format => :json}
        response.should be_success
        JSON.is_json?(response.body).should be_true
      end

      it "should not be able for own idea" do
        attributes=valid_attributes
        attributes[:user_id]=@user.id
        idea = Idea.create! attributes
        put :vote, {:id => idea.to_param, :auth_token => @user.authentication_token, :format => :json}
        response.should_not be_success
        JSON.is_json?(response.body).should be_true
      end

    end
  end

  describe "DELETE destroy" do
    it "destroys the requested idea" do
      idea = Idea.create! valid_attributes
      expect {
        delete :destroy, {:id => idea.to_param, :auth_token => @user.authentication_token, :format => :json}
      }.to change(Idea, :count).by(-1)
    end

    it "redirects to the ideas list" do
      idea = Idea.create! valid_attributes
      delete :destroy, {:id => idea.to_param, :auth_token => @user.authentication_token, :format => :json}
      response.should be_success
    end

    it "redirects to the ideas list" do
      idea = Idea.create! valid_attributes
      delete :destroy, {:id => idea.to_param, :auth_token => @user.authentication_token, :format => :json}
      JSON.is_json?(response.body).should be_true
    end

  end

end
