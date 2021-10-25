module Elrond
  class AddressController < NetworkController
    layout 'tabs'

    before_action :set_address

    before_action :breadcrumb

    def show; end

    private

    def set_address
      @address = params[:address]
    end

    def breadcrumb
      return if action_name == 'show'
    end
  end
end
