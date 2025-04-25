module Algorand
  class BlockController < NetworkController
    layout 'tabs'

    before_action :query_date

    QUERY_BLOCK_DATE = <<-GRAPHQL.freeze
      query ($height: Int!, $network: AlgorandNetwork!) {
        algorand(network: $network) {
          blocks(height: {is: $height}) {
            date { date }
          }
        }
      }
    GRAPHQL

    QUERY_LAST_BLOCK = <<-GRAPHQL.freeze
      query ($network: AlgorandNetwork!) {
        algorand(network: $network) {
          blocks {
            maximum(of: block)
          }
        }
      }
    GRAPHQL

    private

    def query_date
      height      = params[:block].to_i
      cache_base  = "algorand:#{@network[:network]}"

      @block_date = cached_fetch("#{cache_base}:date:#{height}", expires_in: 1.day) do
        fetch_block_date(height)
      end

      @is_block_section = true
    rescue StandardError => e
      BitqueryLogger.error("[BlockController] failed to fetch block_date: #{e.class}: #{e.message}")

      @last_block_number = cached_fetch("#{cache_base}:last_block", expires_in: 1.day) do
        fetch_last_block
      end

      redirect_to controller: :block, action: params[:action], block: @last_block_number
    end

    def cached_fetch(key, expires_in:)
      Rails.cache.fetch(key, expires_in: expires_in) do
        BitqueryLogger.info("[CACHE MISS] #{key}")
        yield
      end.tap do |value|
        BitqueryLogger.info("[CACHE HIT] #{key}") if Rails.cache.exist?(key)
      end
    end

    def fetch_block_date(height)
      Graphql::V1
        .query_with_retry(
          QUERY_BLOCK_DATE,
          variables: { height: height, network: @network[:network] },
          context:   { authorization: @streaming_access_token }
        )
        .data
        .algorand
        .blocks
        .first
        &.date
        &.date
    end

    def fetch_last_block
      Graphql::V1
        .query_with_retry(
          QUERY_LAST_BLOCK,
          variables: { network: @network[:network] },
          context:   { authorization: @streaming_access_token }
        )
        .data
        .algorand
        .blocks
        .first
        .maximum
    end
  end
end
