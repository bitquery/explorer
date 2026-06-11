# frozen_string_literal: true

require "timeout"

class CachedQuery
  QUERY_VERSION = 1
  TIMEOUT_SECONDS = 3

  class << self
    def fetch(key_parts, expires_in:, query:, variables: {}, context: {}, use_eap: false)
      cache_key = (["cached_query", QUERY_VERSION] + Array(key_parts)).join(":")
      stale_key = "#{cache_key}:stale"

      Rails.cache.fetch(cache_key, expires_in:, race_condition_ttl: 30) do
        result = execute(query:, variables:, context:, use_eap:)
        Rails.cache.write(stale_key, result, expires_in: expires_in * 2) unless result.nil?
        result
      end
    rescue StandardError => e
      Rails.logger.warn("CachedQuery error [#{Array(key_parts).join('/') }]: #{e.message}")
      Rails.cache.read(stale_key)
    end

    private

    def execute(query:, variables:, context:, use_eap:)
      Timeout.timeout(TIMEOUT_SECONDS) do
        Graphql::V2.query_with_retry(query, variables:, context:, use_eap:)
      end
    end
  end
end
