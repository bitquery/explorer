class SearchController < ApplicationController
  def show
    if request.post?
      redirect_to search_path(params[:query])
    end
    @query = params[:query]
  end
end
