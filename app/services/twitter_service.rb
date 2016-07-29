class TwitterService
  attr_reader :bearer_token

  def initialize
    set_bearer_token
  end

  def search(hashtag)
    query = "?q=#{ CGI.escape("#{ hashtag.downcase } filter:images") }"
    statuses = []
    additional = {
      headers: {
        'Authorization' => "Bearer #{ bearer_token }"
      }
    }

    begin
      url = "#{ twitter_api_base_url }/1.1/search/tweets.json#{ query }"
      resp = HTTParty.get(url, additional)

      statuses << resp['statuses']

      query = resp['search_metadata']['next_results'] if resp['search_metadata']['next_results'].present?
    end while resp['search_metadata']['next_results'].present?

    statuses.flatten.compact.uniq
  end

  private
  def key
    ENV['twitter_consumer_key']
  end

  def secret
    ENV['twitter_consumer_secret']
  end

  def twitter_api_base_url
    ENV['twitter_api_base_url']
  end

  def set_bearer_token
    encoded = Base64.encode64("#{key}:#{secret}".force_encoding('UTF-8')).gsub("\n", '')

    additional = {
      body: {
        grant_type: 'client_credentials'
      },
      headers: {
        'Authorization' => "Basic #{ encoded }",
        'Content-Type' => 'application/x-www-form-urlencoded;charset=UTF-8'
      }
    }

    resp = HTTParty.post("#{ twitter_api_base_url }/oauth2/token", additional)
    @bearer_token = resp['access_token']

    resp
  end
end
