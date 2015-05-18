class LinkSerializer < ActiveModel::Serializer
  attributes :id, :title, :url, :upvotes, :downvotes
end
