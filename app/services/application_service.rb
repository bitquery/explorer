class ApplicationService
  def self.call(*args)
    new(*args).call
  end
end
