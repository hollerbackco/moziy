raw_config = File.read("#{Rails.root}/config/carrierwave_config.yml")
CARRIERWAVE = YAML.load(raw_config)[Rails.env].symbolize_keys

CarrierWave.configure do |config|
  config.root "#{Rails.root}/tmp/uploads"
  config.fog_credentials = {
    :provider               => 'AWS',                              # required
    :aws_access_key_id      => CARRIERWAVE[:aws_access_key],       # required
    :aws_secret_access_key  => CARRIERWAVE[:aws_secret]#,          # required
    #:region                 => 'eu-west-1'  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = CARRIERWAVE[:s3_bucket_name] #required
  #config.fog_host       = 'https://assets.example.com'            # optional, defaults to nil
  config.fog_public     = true                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end