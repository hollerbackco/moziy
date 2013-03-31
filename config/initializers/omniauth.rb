options = {}

unless Rails.env.production?
  ENV["GOOGLE_KEY"] = "776895925899-nt4a2aoqtsn9ufirikhar562l5clu545.apps.googleusercontent.com"
  ENV["GOOGLE_SECRET"] = "_9652ym02qpx3avj2b-hfew8"
  options = {:client_options => {:ssl => {:ca_file => '/usr/local/etc/openssl/certs/cert.pem'}}}
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], options
end
