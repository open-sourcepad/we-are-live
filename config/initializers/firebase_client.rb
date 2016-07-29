class FirebaseClient
  def initialize
    Firebase::Client.new(base)
  end

  private
  def base
    'https://we-are-live.firebaseio.com/'
  end
end
