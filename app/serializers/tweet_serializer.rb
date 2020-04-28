class TweetSerializer < ActiveModel::Serializer
  attributes :id, :tweet, :user_id
end
