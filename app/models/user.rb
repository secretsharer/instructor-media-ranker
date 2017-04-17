class User < ApplicationRecord
  has_many :votes
  has_many :ranked_works, through: :votes, source: :work

  validates :username, uniqueness: true, presence: true

  def self.create_from_github(auth_hash)
    user = User.new
    user.uid = auth_hash["uid"]
    user.provider = auth_hash["provider"]
    user.username = auth_hash["info"]["name"] #you know if you need [info] on these by inspecting the github auth hash
    user.email = auth_hash["info"]["email"]
    user.save ? user : nil
    return user
  end


end
