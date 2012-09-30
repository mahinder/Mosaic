class SmsTemplate < ActiveRecord::Base
   
validates  :template_code, :text,:presence =>true
  validates  :template_code, :text, :uniqueness => true 

end
