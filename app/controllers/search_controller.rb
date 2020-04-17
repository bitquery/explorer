class SearchController < ApplicationController
  def show
    if request.post?
      redirect_to search_path(params[:query], network: (params[:network] && !params[:network].empty? ? params[:network] : nil))
    end
    @query = params[:query]
    @network = params[:network] && BLOCKCHAIN_BY_NAME[params[:network]]
  end
end
