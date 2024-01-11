module Hedera
  class TopicsController < NetworkController
    layout 'tabs'

    before_action :set_topic_id
    before_action :breadcrumb

    def show; end

    # /hedera/:topic_id/messages
    def messages; end

    private

    def set_topic_id
      @topic_id = @query = params[:topic_id]
    end

    def breadcrumb
      @breadcrumbs << { name: "#{t("tabs.#{controller_name}.show.name")}: #{@topic_id.truncate(15)}",
                        url: "#{@network[:network]}/topics/#{@topic_id}" }

      return if action_name == 'show'

      @breadcrumbs << { name: "#{t("tabs.#{controller_name}.#{action_name}.name")}" }
    end
  end
end
