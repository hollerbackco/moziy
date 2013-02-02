namespace :video do

  desc "fill provider id from body"
  task :set_pid => :environment do

    youtube1_re = /www.youtube.com\/embed\/([a-zA-Z0-9_-]+).*/i
    youtube2_re = /www.youtube.com\/v\/([a-zA-Z0-9_-]+).*/i
    vimeo_re = /player.vimeo.com\/video\/([a-zA-Z0-9_-]+).*/i

    Video.all.each do |v|
      # find the id and source from body (embed code)
      if youtube1_re.match(v.body)
        source = ['youtube', $1, "http://youtu.be/#{$1}"]
        link = "http://"
      elsif youtube2_re.match(v.body)
        source = ['youtube', $1, "http://youtu.be/#{$1}"]
      elsif vimeo_re.match(v.body)
        source = ['vimeo', $1, "http://vimeo.com/#{$1}"]
      else
        puts "#{v.id} nofit #{v.body}"
      end

      unless source.nil?
        v.update_attributes(:source_name => source[0], :source_id => source[1], :source_url => source[2])

        puts "#{v.id} #{source[0]} #{source[1]} #{source[2]}"
      end
    end
  end

  desc "cleanup old"
  task :clean_requests do
    AddVideoRequest.old.destroy_all
  end

end
