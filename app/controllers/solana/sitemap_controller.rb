module Solana
  class SitemapController < NetworkController
    # Solana has no :streaming/:use_eap key in BLOCKCHAINS, so the v2 EVM-style
    # sitemap query used by the ethereum family cannot be reused here -- it would
    # send network: nil. v1 is the only server-side client with a Solana schema.
    #
    # Both transfer aggregations must select `count` even though the sitemap only
    # needs the address: sorting by a field the query does not select is rejected
    # ("Can't use count in sorting"), and Graphql::V1 turns any response error
    # into a raise, which surfaces as a 500 on the whole sitemap.
    QUERY = <<-GRAPHQL.freeze
      query ($network: SolanaNetwork!, $from: ISO8601DateTime) {
        senders: solana(network: $network) {
          transfers(options: {desc: "count", limit: 100}, date: {since: $from}) {
            sender { address }
            count
          }
        }
        receivers: solana(network: $network) {
          transfers(options: {desc: "count", limit: 100}, date: {since: $from}) {
            receiver { address }
            count
          }
        }
        blocks: solana(network: $network) {
          blocks(options: {desc: "height", limit: 100}, date: {since: $from}) {
            height
          }
        }
      }
    GRAPHQL

    # Aggregation cost is flat across a 10-minute and a 30-minute window (~9s
    # either way), so take the wider one for more distinct addresses per crawl.
    WINDOW = 30.minutes

    def index
      @response = Graphql::V1.query_with_retry(
        QUERY,
        variables: { network: @network[:network], from: WINDOW.ago.utc.iso8601 },
        context: { authorization: @streaming_access_token }
      ).data

      @addresses = collect_addresses(@response)
      @block_heights = @response.blocks.blocks.map(&:height).compact_blank
    end

    private

    # The top transfer counterparty on Solana is an unnamed system account that
    # comes back as "", which would emit a bare /solana/address/ URL. A blank
    # segment matches no route and falls through to the catch-all error page.
    def collect_addresses(response)
      senders = response.senders.transfers.map { |t| t.sender&.address }
      receivers = response.receivers.transfers.map { |t| t.receiver&.address }

      (senders + receivers).compact_blank.uniq
    end
  end
end
