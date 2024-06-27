module Cosmos
  class HeightController < NetworkController
    layout 'tabs'
    before_action :set_variables

    def set_variables
      @is_block_section = true
    end
  end
end
