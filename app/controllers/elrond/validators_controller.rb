module Elrond
  class ValidatorsController < NetworkController
    layout 'tabs'

    before_action :set_validator_hash
    before_action :breadcrumb
    before_action :query_date, only: %i[show]

    QUERY = BitqueryGraphql::Client.parse <<-'GRAPHQL'
             query ($hash: String! $network: ElrondNetwork!){
                elrond(network: $network) { blockValidators(validator: {is: $hash}) { date {date} } }
             }


    GRAPHQL

    def show; end

    private

    def set_validator_hash
      @hash = params[:hash]
    end

    def breadcrumb
      return if action_name != 'show'
    end

    def query_date
      variables = { hash: @hash.to_s,
                    network: @network[:network] }
      @validator_data = BitqueryGraphql::Client.query(QUERY, variables: variables).data.elrond.block_validators[0].date.date
    rescue Net::ReadTimeout => e
      Raven.capture_exception e
      sleep(1)
      retry
    end
  end
end
