require 'rest-client'
require 'feedjira'

module Rss
  class Parse < ApplicationService
    def initialize(url)
      @url = url
    end

    def call
      return Rails.cache.fetch(url) if already_cached?('url')

      http = RestClient.get(url)
      feed = Feedjira.parse(http.body)

      Rails.cache.write(url, 'test', expires_in: 8.hours.to_i)

      feed
    end

    private

    attr_reader :url

    def already_cached?(url)
      Rails.cache.exist?(url)
    end
  end
end
