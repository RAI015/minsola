if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      # Amazon S3用の設定
      provider: 'AWS',
      region: 'ap-northeast-1',
      aws_access_key_id: Rails.application.credentials.aws[:access_key_id],
      aws_secret_access_key: Rails.application.credentials.aws[:secret_access_key]
    }
    config.fog_directory = Rails.application.credentials.aws[:s3_bucket]
    config.asset_host = Rails.application.credentials.aws[:fog_asset_host]

    config.cache_storage = :fog
    config.cache_dir = 'tmp/image-cache'
  end
end
