class New < ApplicationRecord
  validates_uniqueness_of :url
end
