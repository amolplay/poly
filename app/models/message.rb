class Message < ActiveRecord::Base
  has_many :comments, :as => :commentable
  validates_presence_of :title,:description
end
