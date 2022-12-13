module Everscale
  class MessageController < NetworkController
    layout 'tabs'

    before_action :set_message_hash
    before_action :breadcrumb

    def show; end

    private

    def set_message_hash
      @message_hash = params[:hash]
    end

    def breadcrumb
      return if action_name != 'show'
    end
  end
end


