class Diem::SitemapController < NetworkController

  QUERY =  BitqueryGraphql::Client.parse  <<-'GRAPHQL'
           query ($from: ISO8601DateTime){
                   senders: diem($network: DiemNetwork!){
                        transfers(options:{
                          desc: "count", 
                          limit: 100},
                          date: {since: $from }
                          ) {
                  
                            sender(sender: {not: "0x0000000000000000000000000000000000000000"}) {
                              address
                            }
                  
                            count
                  
                        }
                     
                   }

                  receivers: diem($network: DiemNetwork!){
                        transfers(options:{
                          desc: "count", 
                          limit: 100},
                          date: {since: $from }
                          ) {
                  
                            receiver(receiver: {not: "0x0000000000000000000000000000000000000000"}) {
                              address
                            }
                  
                            count
                  
                        }
                      
                  }

						      tokens: diem($network: DiemNetwork!){
                        transfers(options:{
                          desc: "count", 
                          limit: 100},
                          date: {since: $from }
                          ) {
                  
                            currency {
                              address
                              symbol
                            }
                  
                            count
                  
                        }
                     
                   }

           }
  GRAPHQL

  def index
    @response = BitqueryGraphql::Client.query(QUERY, variables: {from: Date.today-10,
                                                                 network: @network[:network]}).data


  end

end
