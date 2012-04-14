class Idea
  include Mongoid::Document
  include Mongoid::Timestamps

  field :essential, :type => String
  field :public, :type => Boolean

  belongs_to :user

  validates_presence_of :essential

  scope :current_ideas_for, ->(user) { all_of(:user_id=>user.id,:created_at.gte => Time.parse(Date.today.to_s))}
  scope :ideas_for_by_date, ->(user, date) { all_of(:user_id=>user.id,:created_at => Time.parse(date.to_s))}

end
