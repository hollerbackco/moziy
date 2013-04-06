ActiveAdmin.register Feed do
  index do
    column :feed_type
    column :slug
    column :source_name
    column :source_url
    column :airings_count do |feed|
      feed.channel.airings.count
    end

    default_actions
  end
  form do |f|
    f.inputs "Channel Slug" do
      f.input :slug
    end
    f.inputs "Source Type" do
      f.input :feed_type, :as => :select, :collection => Feed::FEED_TYPES
      f.input :source_name, :hint => "Mandatory if feedtype is youtube or vimeo: enter a username here"
      f.input :source_url, :hint => "Mandatory if feedtype is a website: enter the url to the rss feed"
    end
    f.buttons
  end
end
