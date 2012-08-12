require 'rubygems'
require 'twitter'
require 'growl'
require 'yaml'
require 'open-uri'

def read_config
  config = YAML.load_file("config.yaml")
  @consumer_key = config["twitter"]["consumer_key"]
  @consumer_secret = config["twitter"]["consumer_secret"]
  @consumer_oauth_token = config["twitter"]["consumer_oauth_token"]
  @consumer_oauth_token_secret = config["twitter"]["consumer_oauth_token_secret"]
end

def initialize_twitter_credentials
  Twitter.configure do |config|
    config.consumer_key = @consumer_key
    config.consumer_secret = @consumer_secret
    config.oauth_token = @oauth_token
    config.oauth_token_secret = @oauth_token_secret
  end
end

def download_profile_image(image_url)
  image_name = File.basename(image_url)
  file_path = "images/#{image_name}"
  # Did I already download this image?
  unless File.exists?(file_path)
    File.open(file_path, 'w') do |output|
      # Download image
      open(image_url) do |input|
        output << input.read
      end
    end
  end
  file_path
end

read_config
initialize_twitter_credentials

@loop = false
@last_id = 1

begin
  searchresult = Twitter.search("agile2012", result: "recent", since_id: @last_id, rpp: 10)
  @last_id = searchresult.max_id

  searchresult.results.each do |tweet|
    image_path = download_profile_image(tweet.profile_image_url)

    Growl.notify do |n|
      n.title = tweet.from_user_name + " (@#{tweet.from_user})"
      n.message = tweet.text
      n.image = image_path
    end
    sleep 1
  end
  sleep 10
end while @loop
