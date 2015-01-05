class RailsCacheDelegator < SimpleDelegator
  EXPIRATION_TIME = 5

  def get(request)
    read(request.hash)
  end

  def set(request, response)
    write(request.hash, response, expires_in: EXPIRATION_TIME.minutes)
  end
end
