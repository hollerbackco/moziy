namespace :video do
  
  desc "fill provider id from body"
  task :set_pid => :environment do 
    Video.all.each do |v|
      
      if /http:\/\/www\.youtube\.com\/embed\/([a-zA-Z0-9_-]+).*/i.match(v.body)
        source = ['youtube', $1]
      elsif /www.youtube.com\/v\/([a-zA-Z0-9_-]+).*/i.match(v.body)
        source = ['youtube', $1]
      elsif /player.vimeo.com\/video\/([a-zA-Z0-9_-]+).*/i.match(v.body)
        source = ['vimeo', $1]
      else
        puts "#{v.id} nofit #{v.body}"
        break
      end
      
      v.update_attributes(:source_name => source[0], :source_id => source[1])
      puts "#{v.id} #{source[0]} #{source[1]}"
    end
  end
  
end