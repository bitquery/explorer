class SearchController < ApplicationController
  def show
    if request.post?
      redirect_to search_path(params[:query], network: params[:network])
    end
    @query = params[:query]
  end
end
