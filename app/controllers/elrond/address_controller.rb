module Elrond
  class AddressController < NetworkController
    layout 'tabs'

    before_action :query_graphql, only: %i[money_flow]

    before_action :set_address
    before_action :breadcrumb

    QUERY = BitqueryGraphql::Client.parse <<-'GRAPHQL'
      query ($network: ElrondNetwork!, $address: String!) {
        elrond(network: $network) {
          transfers(
            options: {desc: "count", limit: 100}
            transferSender: {is: $address}
          ) {
            currency{
              address
              symbol
              name
            }
            count
          }
        }
      }
    GRAPHQL

    def show; end

    private

    def set_address
      @address = params[:address]
    end

    def breadcrumb
      return if action_name == 'show'
    end

    def query_graphql
      begin
        result = BitqueryGraphql::Client.query(QUERY, variables: { network: @network[:network], address: @address }).data.elrond
        @currencies = result.transfers.map(&:currency).sort_by { |c| c.address == '-' ? 0 : 1 }.uniq { |x| x.address } if result.try(:transfers)
      rescue Net::ReadTimeout => e
        Raven.capture_exception e
        sleep(1)
        retry
      end
    end
  end
end
