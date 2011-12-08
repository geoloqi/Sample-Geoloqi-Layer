Encoding.default_internal = 'UTF-8'
require 'rubygems'
require 'geoloqi'
require 'json'
require 'yaml'

config = YAML.load_file('config.yml')['geoloqi'] if File.exists?('config.yml')

# Put your geoloqi access token in the config.yml file
# Get your access token from https://developers.geoloqi.com/getting-started
geoloqi = Geoloqi::Session.new :access_token => config['accessToken'], :config => {:throw_exceptions => false}

# Create a layer
response = geoloqi.post 'layer/create', {
  'name' => 'My Sweet Layer'
}
layer_id = response['layer_id']

# This is sample data. You probably want to get data from your own data source.
places = [
  {
    'title'       => 'Place 1',
    'description' => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In eget placerat ipsum. Cras molestie laoreet diam eu tincidunt. Curabitur nulla tellus, suscipit sed porta nec, malesuada nec nisl.',
    'url'         => 'http://example.com',
    'latitude'    => 45.102837,
    'longitude'   => -122.439933
  },
  {
    'title'       => 'Place 2',
    'description' => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In eget placerat ipsum.',
    'url'         => 'http://example.com',
    'latitude'    => 45.238723,
    'longitude'   => -122.334875
  }
]

places.each do |place|


  # Create a place
  # See https://developers.geoloqi.com/api/place/create
  response = geoloqi.post 'place/create', {

    'layer_id'    => layer_id,             # layer_id: create the place on the specified layer
    'name'        => place['title'],         # title: the title of the place will appear in the user's timeline
    'description' => place['description'], # description: the description will appear on the place page
    'latitude'    => place['latitude'],
    'longitude'   => place['longitude'],
    'radius'      => 400                   # radius: in meters

  }


  puts ''
  puts '## Place data'
  puts place.inspect                # output the item in your data source

  puts ''
  puts '## Place create response'
  puts response.inspect             # output the response from Geoloqi


  # Create a trigger to send a message when a user gets to the place
  # See https://developers.geoloqi.com/api/trigger/create
  response = geoloqi.post 'trigger/create', {

    'place_id' => response['place_id'],
    'type'     => 'message',                 # message: notification will be delivered to the user via push notification or SMS
    'text'     => place['description'],      # text: this is the message that will be selt
    'url'      => 'http://example.org',      # url: if a URL is provided, the push notification will have a "view" button, and a short URL will be appended to the SMS
    'one_time' => 1                          # one_time: If set to 1, the user will only get this message one time. Set to 0 to send it each time they arrive

  }


  puts ''
  puts 'Geoloqi trigger create response'
  puts response.inspect
  
  
end

puts 'Finished'
