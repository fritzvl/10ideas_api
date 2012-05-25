class Idea
  include Mongoid::Document
  include Mongoid::Timestamps

  field :essential, :type => String
  field :public, :type => Boolean
  field :votes, :type => Array

  belongs_to :user


  validates_presence_of :essential

  scope :current_ideas_for, ->(user) { all_of(:user_id => user.id, :created_at.gte => Time.parse(Date.today.to_s)) }
  scope :ideas_for_by_date, ->(user, date) { all_of(:user_id => user.id, :created_at => Time.parse(date.to_s)) }
  scope :public_ideas_for_today, all_of(:public => true, :created_at.gte => Time.parse(Date.today.to_s),:created_at.lt => Time.parse((Date.today+1.day).to_s))

  def publish!
    update_attribute(:public, true)
  end

  def vote!(user)
    unless user==self.user
      unless self.votes.nil?
        self.votes.push user._id unless  votes.include?(user._id)
      else
        self.votes=[user.id]
      end
      save
    else
      false
    end
  end

end
