class InboundService
  attr_accessor :params, :cache_key

  def initialize(params)
    @params = params
  end

  def call
    cache_data
    stop_sms
  end
  
  private
  #cache the data with from/to as key as set 0 initial for checking text
  def cache_data
    @cache_key = "#{params["from"]}/#{params["to"]}"
    Rails.cache.fetch(cache_key, expires_in: 4.hours, raw: true) { 0 } 
    Rails.cache.fetch("req_count/#{cache_key}", expires_in: 24.hours, raw: true) { 0 }
  end

  #if request is stop set cache as 1 else 0
  def stop_sms
    cache = Rails.cache.fetch(cache_key)
    stop = params[:text] == "stop"
    is_stopped = cache && cache.include?("0")
    Rails.cache.decrement(cache_key) unless is_stopped && stop
    Rails.cache.increment(cache_key) if is_stopped && stop
  end
  
end