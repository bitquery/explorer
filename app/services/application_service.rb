class ApplicationService
  def self.call(*)
    new(*).call
  end
end
