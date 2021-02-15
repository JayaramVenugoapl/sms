Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post "inbound/sms", :to => "sms_gatways#inbound"
  post "outbound/sms", :to => "sms_gatways#outbound"
  match "*unmatched", to: "application#routing_error", via: :all
end
