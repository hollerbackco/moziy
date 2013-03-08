namespace :feeder do
  desc "feeder crawl"
  task :crawl => :environment do
    Feed.all.each do |feed|
      feed.feed_performer.perform
    end
  end

  task :fill => :environment do
    crawler_file = File.read("#{Rails.root}/lib/moziy/feeder/streams.yml")
    crawler_config = YAML.load(crawler_file).symbolize_keys

    [:website,:youtube,:vimeo].each do |feed_type|
      crawler_config[feed_type].each do |config|
        create_feed feed_type, config.symbolize_keys
      end
    end
  end

  def create_feed(feed_type, args)
    puts args
    Feed.where(slug: args[:slug]).first_or_create! do |feed|
      feed.slug = args[:slug]
      feed.feed_type = feed_type
      feed.source_name = args[:source_name]
      feed.source_url = args[:source_url]
    end
  end
end
