class SmsGatwaysController < ApplicationController
  before_action :sms_params
  before_action :validate_input
  
  def inbound
    if valid_number?(sms_params[:to])
      InboundService.new(sms_params).call
      respond("", 200, "inbound sms ok")
    else
      respond("to parameter not found", 422)
    end
  end

  def outbound
    if valid_number?(sms_params[:from])
      OutboundService.new(sms_params).call
      respond("", 200, "outbound sms ok")
    else
      respond("to parameter not found", 422)
    end
  end

  private
  def sms_params
    params.permit(:to, :from, :text)
  end
  
  def validate_input
    InputValidationService.new(sms_params).call
  end

  def respond(_error, _status, _message = "")
    json = Error::Helpers::Render.json(_error, _status, _message)
    render json: json, status: _status
  end

  def valid_number?(num)
    return true if account.phone_numbers.find_by(number: num)
    return false
  end
  
end
