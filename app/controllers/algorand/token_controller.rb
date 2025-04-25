require 'ostruct'

module Algorand
  class TokenController < NetworkController
    layout 'tabs'

    before_action :set_id
    before_action :query_graphql

    QUERY = <<-GRAPHQL.freeze
      query($network: AlgorandNetwork!, $id: Int!) {
        algorand(network: $network) {
          transactions(txCurrency: {is: $id}, options: {limit: 1}) {
            currency {
              name
              symbol
            }
          }
        }
      }
    GRAPHQL

    private

    def set_id
      @id = params[:id].to_i
    end

    def query_graphql
      if @id == @network[:currency]
        @native_token = true
        @id = 0
        @token_info  = OpenStruct.new(name: @network[:currency].to_s)
        return
      end

      cache_key = "algorand:token_info:#{@network[:network]}:#{@id}"

      if Rails.cache.exist?(cache_key)
        @token_info = Rails.cache.read(cache_key)
      else
        @token_info = begin
                        resp     = Graphql::V1.query_with_retry(
                          QUERY,
                          variables: { network: @network[:network], id: @id },
                          context:   { authorization: @streaming_access_token }
                        )
                        currency = resp.data.algorand.transactions.first&.currency

                        if currency
                          currency
                        else
                          BitqueryLogger.warn("[Algorand::TokenController] no currency for id=#{@id}")
                          OpenStruct.new(name: @id.to_s)
                        end
                      rescue JSON::ParserError, Net::ReadTimeout, StandardError => e
                        BitqueryLogger.error("[Algorand::TokenController] GraphQL error #{e.class}: #{e.message}")
                        OpenStruct.new(name: @id.to_s)
                      end

        Rails.cache.write(cache_key, @token_info, expires_in: 1.day)
      end
    end
  end
end
