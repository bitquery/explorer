class Diem::AddressController < NetworkController
  layout 'tabs'

  before_action :query_graphql

  QUERY_CURRENCIES = BitqueryGraphql::Client.parse  <<-'GRAPHQL'
   query($network: DiemNetwork!, $address: String!) {
              diem(network: $network){
    						transfers(receiver: {is: $address}, options: {desc: "count"}){
      							currency {
                      address
                      symbol
                      name
                    }
      							count
    						}
              }
            }
  GRAPHQL

  private

  def query_graphql
    @address = params[:address]
    if action_name == 'money_flow'
      result = BitqueryGraphql::Client.query(QUERY_CURRENCIES,
                                             variables: { network: @network[:network], address: @address }).data.diem
      if result.try(:transfers)
        @currencies = result.transfers.map(&:currency).sort_by do |c|
                        c.address == '-' ? 0 : 1
                      end.uniq { |x| x.address }
      end
    end
  end
end
