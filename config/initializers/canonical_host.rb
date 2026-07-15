Rails.application.configure do
  config.canonical_host = ENV.fetch("CANONICAL_HOST", "explorer.bitquery.io")
  config.canonical_protocol = ENV.fetch("CANONICAL_PROTOCOL", "https")
end

CANONICAL_HOST = Rails.application.config.canonical_host
CANONICAL_PROTOCOL = Rails.application.config.canonical_protocol
CANONICAL_BASE_URL = "#{CANONICAL_PROTOCOL}://#{CANONICAL_HOST}"
