class Idea
  include Mongoid::Document
  include Mongoid::Timestamps

  field :essential, :type => String
  field :public, :type => Boolean
  field :votes, :type => Array
  field :score, :type => Integer

  belongs_to :user


  validates_presence_of :essential

  scope :current_ideas_for, ->(user) { all_of(:user_id => user.id, :created_at.gte => Date.today, :created_at.lt => (Date.today+1.day)) }
  scope :ideas_for_by_date, ->(user, date) { all_of(:user_id => user.id, :created_at.gte => Date.parse(date), :created_at.lt => (Date.parse(date)+1.day)) }
  scope :public_ideas_for_today, all_of(:public => true, :created_at.gte => Date.today, :created_at.lt => (Date.today+1.day))
  scope :public_ideas_by_date, ->(date) { all_of(:public => true, :created_at.gte => Date.parse(date), :created_at.lt => (Date.parse(date)+1.day)) }
  scope :winners_by_date, ->(date) {
    all_of(:public => true,:score.gt=>0 ,:created_at.gte => Date.parse(date), :created_at.lt => (Date.parse(date)+1.day)).desc(:score).limit(3)
  }

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
      self.score||=0
      self.score+=1
      save
    else
      false
    end
  end

end
