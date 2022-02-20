module Flow
  class BlockController < NetworkController
    layout 'tabs'

    before_action :set_block

    def show; end

    def collections; end

    def transactions; end

    private

    def set_block
      @height = params[:number]
    end

    def breadcrumb
#       @breadcrumbs << { name: "#{t("tabs.#{controller_name}.show.name")}: #{@height.truncate(15)}",
#                         url: "#{locale_path_prefix}#{@network[:network]}/block/#{@height}" }

#       return if action_name == 'show'

#       @breadcrumbs << { name: "#{t("tabs.#{controller_name}.#{action_name}.name")}" }
    end
  end
end
