class OutboundService
  attr_accessor :params, :cache_key, :data, :request_count

  def initialize(params)
    @params = params
    @cache_key = "#{params["to"]}/#{params["from"]}"
    @data = Rails.cache.fetch(cache_key)
    @request_count = Rails.cache.fetch("req_count/#{cache_key}")
    cache_request unless request_count
  end

  def call
    is_data_blocked
    is_request_limit_exceeded
    update_request_limit
  end
  
  private
  #block sms if cache is set to 1
  def is_data_blocked
    raise error("sms from #{params["from"]} to #{params["to"]} blocked by STOP request", 422) if data == "1"
  end

  #check for request limit in for same phonenber
  def is_request_limit_exceeded
    raise error("limit reached for from #{params["from"]}", 422) if request_count.to_i >= 50
  end

  def update_request_limit
    Rails.cache.increment("req_count/#{cache_key}") if request_count.to_i < 50
  end

  def cache_request
    Rails.cache.fetch(cache_key, expires_in: 4.hours, raw: true) { 0 } 
    Rails.cache.fetch("req_count/#{cache_key}", expires_in: 24.hours, raw: true) { 0 }
  end  

  def error(error, code)
    Error::CustomError.new(error, code)
  end
  
end