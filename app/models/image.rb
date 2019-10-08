require 'uri'

class Image < ApplicationRecord
  acts_as_taggable

  validates :url,
            presence: true,
            format: { with: URI.regexp(%w[http https]), message: 'is invalid url' }
end
