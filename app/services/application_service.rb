class ApplicationService
  def self.call(*args, **kwargs)
    new(*args, **kwargs).call
  end
end
