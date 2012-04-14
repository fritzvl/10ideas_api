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


end
