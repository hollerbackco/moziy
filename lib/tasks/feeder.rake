namespace :feeder do
  desc "feeder crawl"
  task :crawl => :environment do
    crawler_file = File.read("#{Rails.root}/lib/moziy/feeder/streams.yml")
    crawler_config = YAML.load(crawler_file).symbolize_keys

    crawlers = []

    crawler_config[:website].each do |config|
      crawlers << Moziy::Feeder::Website.new(config.symbolize_keys)
    end

    crawler_config[:youtube].each do |config|
      crawlers << Moziy::Feeder::Youtube.new(config.symbolize_keys)
    end

    crawler_config[:vimeo].each do |config|
      crawlers << Moziy::Feeder::Vimeo.new(config.symbolize_keys)
    end

    crawlers.each do |c|
      c.perform
    end

  end
end
