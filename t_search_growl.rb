require 'twitter'
require 'growl'
require 'yaml'
require 'open-uri'

class TSearchGrowl
  attr_accessor :loop, :last_id, :rerun, :max_first, :max, :persistent

  def initialize
    @app_config = YAML.load_file("config.yml")

    Twitter.configure do |config|
      config.consumer_key = @app_config["twitter"]["consumer_key"]
      config.consumer_secret = @app_config["twitter"]["consumer_secret"]
    end

    @loop = true
    @last_id = @app_config["last_id"]
    @rerun = 10
    @max = 25
    @persistent = true
  end

  def search query
    @max = @max_first if !@max_first.nil?
    begin
      searchresult = Twitter.search(query, result: "recent", since_id: @last_id, rpp: @max)
      @last_id = searchresult.max_id
      save_last_id if @persistent

      searchresult.results.reverse_each do |tweet|
        image_path = download_profile_image(tweet.profile_image_url)

        Growl.notify do |n|
          n.title = tweet.from_user_name + " (@#{tweet.from_user})"
          n.message = tweet.text
          n.image = image_path
          n.name = "t_search_growl"
        end
        sleep 0.2
      end
      sleep @rerun
    end while @loop
  end

private

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

  def save_last_id
    @app_config["last_id"] = @last_id
    File.open("config.yml", "w") do |file|
      file.write @app_config.to_yaml
    end
  end

end
