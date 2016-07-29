class FireBaseClient
  def connect
    @connect ||= Firebase::Client.new(base, secret)
  end

  private
  def secret
    ENV['firebase_secret_key']
  end
  def base
    ENV['firebase_database_url']
  end
end
