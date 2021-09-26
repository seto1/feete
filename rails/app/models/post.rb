class Post < ApplicationRecord
  validates :text, presence: true
end
