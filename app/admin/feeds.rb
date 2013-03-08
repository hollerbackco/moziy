ActiveAdmin.register Feed do
  index do
    column :feed_type
    column :slug
    column :source_name
    column :source_url
  end
end
