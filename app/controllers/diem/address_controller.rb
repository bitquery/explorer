class Diem::AddressController < NetworkController
  layout 'tabs'

  before_action :query_graphql

  QUERY_CURRENCIES = BitqueryGraphql::Client.parse <<-'GRAPHQL'
   query($network: DiemNetwork!, $address: String!) {
              diem(network: $network){
    						transfers(receiver: {is: $address}, options: {desc: "count", limit: 100}){
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
      begin
        result = BitqueryGraphql::Client.query(QUERY_CURRENCIES, variables: { network: @network[:network], address: @address }).data.diem
        @currencies = result.transfers.map(&:currency).sort_by { |c| c.address == '-' ? 0 : 1 }.uniq { |x| x.address } if result.try(:transfers)
      rescue Net::ReadTimeout => e
        Raven.capture_exception e
        sleep(1)
        retry
      end
    end
  end

end
