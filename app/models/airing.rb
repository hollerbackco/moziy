class Airing < ActiveRecord::Base
  belongs_to :video #, :counter_cache => true
  belongs_to :channel
end
