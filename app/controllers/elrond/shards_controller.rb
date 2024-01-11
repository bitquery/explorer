module Elrond
  class ShardsController < NetworkController
    layout 'tabs'

    before_action :set_shard_id
    before_action :breadcrumb

    def show; end

    private

    def set_shard_id
      @shard_id = params[:id]
    end

    def breadcrumb
      @breadcrumbs << { name: "#{t("tabs.#{controller_name}.show.name")}: #{@shard_id.truncate(15)}",
                        url: "#{@network[:network]}/shards/#{@shard_id}" }

      return if action_name == 'show'

      @breadcrumbs << { name: "#{t("tabs.#{controller_name}.#{action_name}.name")}" }
    end
  end
end
