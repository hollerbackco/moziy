# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
#

first_video = "http://www.youtube.com/watch?v=STl3eifhkm4"

def create_a_video(v_params)
  video = Video.find_by_source_name_and_source_id(v_params[:source_name], v_params[:source_id])
  if !video
    video = Video.create v_params
  end
  video
end

# create first user
user = User.find_by_username "playback"

if user.blank?
  user = User.create({
          username: "playback",
          email: "jnoh12388@gmail.com",
          password: "fr33clippy"
          })
end


# create first channel
channel = Channel.find_or_create_by_title(:creator_id => user.id, :title => user.username, :slug => user.username)
channel.subscribed_by user
user.primary_channel = channel
user.save

# create first video
if channel.airings.blank?
  channel.airings

  vp = VideoProvider.new first_video
  video_params = vp.get

  video_params.each do |v_params|
    v = create_a_video v_params
    channel.airings.create :video_id => v.id
  end
end

