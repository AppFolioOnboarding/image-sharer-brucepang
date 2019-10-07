require 'uri'

class Image < ApplicationRecord
  validates :url,
            presence: true,
            format: { with: URI.regexp(%w[http https]), message: 'is invalid url' }
end
