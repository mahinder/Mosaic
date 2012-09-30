# Configure your SMS API settings
module SmsManagerHelper
  require 'net/http'
  require 'yaml'

  class SmsManager
    attr_accessor :recipients, :message
    def initialize(message, recipients)
      @recipients = recipients
      @message = URI.encode(message)
      @config = YAML.load_file(File.join(RAILS_ROOT,"config","sms_settings.yml"))
      
      unless @config.blank?
        @Type = @config['sms_settings']['Type']
        @sms_url = @config['sms_settings']['host_url']
        @username = @config['sms_settings']['UserName']
        @password = @config['sms_settings']['Password']
        @Mask = @config['sms_settings']['Mask']
        @Typekey = @config['sms_settings']['TypeKey']
        @usernamekey = @config['sms_settings']['UserNameKey']
        @passwordkey = @config['sms_settings']['PasswordKey']
        @Maskkey = @config['sms_settings']['MaskKey']
        @tokey = @config['sms_settings']['Tokey']
        @Messagekey = @config['sms_settings']['MessageKey']
      end

    end

    def send_sms
     
      request = "#{@sms_url}?#{@usernamekey}=#{@username}&#{@passwordkey}=#{@password}&#{@Typekey}=#{@Type}&#{@tokey}=#{@recipients}&#{@Maskkey}=#{@Mask}&#{@Messagekey}=#{@message}"
      cur_request = request
      # @recipients.each do |recipient|
        # if cur_request.length > 1000
          # response = Net::HTTP.get_response(URI.parse(cur_request))
        # cur_request = request
        # end
        # cur_request += ",#{recipient}"
      # end
# 
      # if request.length < cur_request.length
        response = Net::HTTP.get_response(URI.parse(cur_request))
      # end
      cur_request
      #response_string = response.split
      # if response.body =~ /Your message is successfully/
        # # sms_count = Configuration.find_by_config_key("TotalSmsCount")
        # # new_count = sms_count.config_value.to_i+@recipients.size
        # # Configuration.update(sms_count.id,:config_value=>new_count.to_s)
        # puts response.body
      # end
      return response
    end

  end
end