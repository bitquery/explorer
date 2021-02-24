module Hedera
  class TopicsController < NetworkController
    layout 'tabs'

    before_action :set_topic_id, only: %i[show]
    before_action :breadcrumb, only: %i[show]

    def show; end

    private

    def set_topic_id
      @topic_id = @query = params[:topic_id]
    end

    def breadcrumb
      @breadcrumbs << { name: "#{t("tabs.#{controller_name}.#{action_name}.name")}: #{@topic_id.truncate(15)}" }
    end
  end
end
