# == Schema Information
#
# Table name: school_configurations
#
#  id           :integer         not null, primary key
#  config_key   :string(255)
#  config_value :string(255)
#

class SchoolConfiguration < ActiveRecord::Base
   STUDENT_ATTENDANCE_TYPE_OPTIONS = ['Daily', 'SubjectWise']
  
validate :validate
  def validate
    if self.config_key == "StudentAttendanceType"
      errors.add(:config_key, "Student Attendance Type should be any one of #{STUDENT_ATTENDANCE_TYPE_OPTIONS}") unless STUDENT_ATTENDANCE_TYPE_OPTIONS.include?(self.config_value)
    end
    
  end

  class << self

    def get_config_value(key)
      c = find_by_config_key(key)
      c.nil? ? nil : c.config_value
    end
  
    def save_institution_logo(upload)
      directory, filename = "#{RAILS_ROOT}/public/uploads/image", 'institute_logo.jpg'
      path = File.join(directory, filename) # create the file path
      File.open(path, "wb") { |f| f.write(upload['datafile'].read) } # write the file
    end

    def available_modules
      modules = find_all_by_config_key('AvailableModules')
      modules.map(&:config_value)
    end

    def set_config_values(values_hash)
      values_hash.each_pair { |key, value| set_value(key.to_s.camelize, value) }
    end

    def set_value(key, value)
      config = find_by_config_key(key)
      config.nil? ? SchoolConfiguration.create(:config_key => key, :config_value => value) : config.update_attribute(:config_value, value)
    end

    def get_multiple_configs_as_hash(keys)
      conf_hash = {}
      keys.each { |k| conf_hash[k.underscore.to_sym] = get_config_value(k) }
      conf_hash
    end

  end

end
