module Hedera
  class TopicsController < NetworkController
    layout 'tabs'

    # before_action :set_topic_id, only: %i[show]
    # before_action :breadcrumb, only: %i[show]

    before_action :set_topic_id
    before_action :breadcrumb

    def show; end

    private

    def set_topic_id
      @topic_id = @query = params[:topic_id]
    end

    def breadcrumb
      action_name != 'show' && @breadcrumbs << { name: t("tabs.#{controller_name}.#{action_name}.name") }
    end
  end
end
