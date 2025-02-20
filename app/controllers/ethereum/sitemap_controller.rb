module Ethereum
  class SitemapController < NetworkController
    QUERY = <<-GRAPHQL.freeze
query siteMape($network: evm_network, $from: String) {
  EVM(network: $network) {
    miners: MinerRewards(
      orderBy: {descendingByField: "count"}
      where: {Block: {Date: {since: $from}}}
      limit: {count: 1000}
    ) {
      Block {
        Coinbase
      }
      count
    }
    blocks: Blocks(where: {Block: {Date: {since: $from}}}, limit: {count: 3}) {
      Block {
        Number
      }
    }
    nfts: DEXTrades(
      orderBy: {descendingByField: "count"}
      limit: {count: 1000}
      where: {Block: {Date: {since: $from}}, Trade: {Buy: {Currency: {Fungible: false}}, Sell: {Currency: {Fungible: true}}, Success: true}}
    ) {
      Trade {
        Buy {
          Currency {
            SmartContract
          }
        }
      }
      count
    }
    protocols: DEXTrades(
      limit: {count: 300}
      where: {Block: {Date: {since: $from}}, Trade: {Success: true}}
      orderBy: {descendingByField: "count"}
    ) {
      count
      Trade {
        Dex {
          ProtocolName
        }
      }
    }
    senders: Transfers(
      orderBy: {descendingByField: "count"}
      limit: {count: 1000}
      where: {Block: {Date: {since: $from}}}
    ) {
      Transfer {
        Sender
      }
      count
    }
    receivers: Transfers(
      orderBy: {descendingByField: "count"}
      limit: {count: 1000}
      where: {Block: {Date: {since: $from}}}
    ) {
      Transfer {
        Receiver
      }
      count
    }
  }
}

    GRAPHQL

    def index
      @response = Graphql::V2.query_with_retry(QUERY, variables: { network: @network[:streaming], from: Time.zone.today - 10, },
                                               context: { authorization: @streaming_access_token }).data
    end
  end
end
