require 'feedjira'
require 'net/http'
require 'uri'

module Rss
  class Parse < ApplicationService
    def initialize(url)
      @url = url
    end

    def call
      Rails.cache.fetch(url, expires_in: 8.hours) do
        uri = URI.parse(url)
        response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', open_timeout: 3,
                                                       read_timeout: 3) do |http|
          request = Net::HTTP::Get.new(uri)
          http.request(request)
        end

        Feedjira.parse(response.body)
      end
    rescue StandardError
      nil
    end

    private

    attr_reader :url
  end
end
