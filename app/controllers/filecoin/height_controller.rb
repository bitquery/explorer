class Filecoin::HeightController  < NetworkController
  layout 'tabs'

  def blocks
    @is_block_section = true
  end
end