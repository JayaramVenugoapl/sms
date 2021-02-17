class InputValidationService
  attr_accessor :params, :default_params_keys, :error

  def initialize(params)
    @params = params
    @default_params_keys = [:from, :to, :text]
  end

  def call
    validate_params
    validate_value_length
  end
  
  #check for three parameters in request
  def validate_params
    ["text", "from", "to"].each {|sym| raise error("#{sym} is missing", 400) unless params.key? sym}
  end

  #check for number length (6 to 16 digits) and text length (1 to 120 characters)
  def validate_value_length
    params.each do |key, value|
      if key.eql?("text") && !(1..120).member?(value.length)
        raise error("#{key} is invalid", 400)  
      elsif !key.eql?("text") && !(6..16).member?(value.length)
        raise error("#{key} is invalid", 400)  
      end
    end
  end

  private
  def error(error, code)
    Error::CustomError.new(error, code)
  end
end