module Flow
  class CollectionsController < NetworkController
    layout 'tabs'

    before_action :set_collection_id

    def show; end

    def transactions; end

    private

    def set_collection_id
      @id = params[:hash]
    end

    def breadcrumb
      nil if action_name == 'show'
    end
  end
end
