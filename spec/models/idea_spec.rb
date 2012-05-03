require 'spec_helper'

describe Idea do

  def valid_attributes
    {essential: "Some test great idea", public: true}
  end


  describe 'idea creation' do
    it "creates idea with valid attributes" do
      idea=Idea.create!(valid_attributes)
      idea.should be_valid
    end
  end

  describe 'ideas retrieval' do

    it 'retrieves current ideas for the specific user' do
      Fabricate(:user)
      idea=Fabricate(:idea, :user_id => User.first.id, :created_at => Date.today)
      Idea.current_ideas_for(User.first).entries.should == [idea]
    end

    it 'retrieves ideas for the specific user and specific date' do
      Fabricate(:user)
      idea=Fabricate(:idea, :user_id => User.first.id, :created_at => Date.yesterday)
      Idea.ideas_for_by_date(User.first, Date.yesterday).entries.should == [idea]
    end

  end

  describe 'idea publish' do

    it "make idea public on demand" do
      Fabricate(:user)
      idea=Fabricate(:idea, :user_id => User.first.id, :created_at => Date.today)
      idea.publish!
      idea.should be_valid
      idea.should be_public
    end

  end

  describe 'vote for idea' do

    it "vote for idea" do
      owner=Fabricate(:user)
      idea=Fabricate(:idea, :user_id => owner.id, :created_at => Date.today)
      voter=Fabricate(:user)
      idea.vote!(voter).should be_true
      idea.should be_valid
      idea.votes.include?(voter.id).should be_true
    end

    it "should not be able to vote for own idea" do
      owner=Fabricate(:user)
      idea=Fabricate(:idea, :user_id => owner.id, :created_at => Date.today)
      idea.vote!(owner).should_not be_true
      idea.should be_valid
      idea.votes.should be_nil
    end

  end


end
