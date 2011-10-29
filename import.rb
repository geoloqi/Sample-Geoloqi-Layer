Encoding.default_internal = 'UTF-8'
require 'rubygems'
require 'geoloqi'
require 'json'

config = YAML.load_file('config.yml')['geoloqi'] if File.exists?('config.yml')

# Put your geoloqi access token in the config.yml file
# Get your access token from https://developers.geoloqi.com/getting-started
geoloqi = Geoloqi::Session.new :access_token => config['accessToken']

# Create a layer
response = geoloqi.post 'layer/create', {
  :name => "My Sweet Layer"
}
layerID = response['layer_id']

# This is sample data. You probably want to get data from your own data source.
data = [
  {
    :title => "Place 1",
    :description => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In eget placerat ipsum. Cras molestie laoreet diam eu tincidunt. Curabitur nulla tellus, suscipit sed porta nec, malesuada nec nisl.",
    :url => "http://example.com",
    :latitude => 45.102837,
    :longitude => -122.439933
  },
  {
    :title => "Place 2",
    :description => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In eget placerat ipsum.",
    :url => "http://example.com",
    :latitude => 45.238723,
    :longitude => -122.334875
  }
]

data.each{|item|

  # Create a place
  # See https://developers.geoloqi.com/api/place/create
  response = geoloqi.post 'place/create', {
    :layer_id => layerID,                       # layer_id: create the place on the specified layer
    :name => item['title'],                     # title: the title of the place will appear in the user's timeline
    :description => item['description'],        # description: the description will appear on the place page
    :latitude => item['latitude'],
    :longitude => item['longitude'],
    :radius => 400                              # radius: in meters
  }

  # The Geoloqi api returns 409 if the place already exists, and 200 if it was created successfully
  if geoloqi.response.status == 200   
    puts # blank line
    puts "Item"
    puts item # output the item in your data source
    puts "Geoloqi place response"
    puts response # output the response from Geoloqi
    puts "Geoloqi trigger response"

    # Create a trigger to send a message when a user gets to the place
    # See https://developers.geoloqi.com/api/trigger/create
    puts geoloqi.post 'trigger/create', {
      :place_id => response['place_id'],
      :type => 'message',                       # message: notification will be delivered to the user via push notification or SMS
      :text => item['description'],             # text: this is the message that will be selt
      :url => article['url'],                   # url: if a URL is provided, the push notification will have a "view" button, and a short URL will be appended to the SMS
      :one_time => 1                            # one_time: If set to 1, the user will only get this message one time. Set to 0 to send it each time they arrive
    }
  else 
    print '.'
  end
}

puts "Finished"


