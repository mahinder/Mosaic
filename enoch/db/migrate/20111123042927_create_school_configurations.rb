class CreateSchoolConfigurations < ActiveRecord::Migration
  def self.up
    create_table :school_configurations do |t|
      t.string :config_key
      t.string :config_value
    end
    create_default
  end

  def self.down
    drop_table :school_configurations
  end

  def self.create_default
    SchoolConfiguration.create config_key: "InstitutionName", config_value: ""
    SchoolConfiguration.create config_key: "InstitutionAddress", config_value: ""
    SchoolConfiguration.create config_key: "InstitutionPhoneNo", config_value: ""
    SchoolConfiguration.create config_key: "StudentAttendanceType", config_value: "Daily"
    # SchoolConfiguration.create config_key: "CurrencyType", config_value: "$"
    #SchoolConfiguration.create config_key : "ExamResultType", config_value : "Marks"
    SchoolConfiguration.create config_key: "AdmissionNumberAutoIncrement", config_value: "1"
    SchoolConfiguration.create config_key: "EmployeeNumberAutoIncrement", config_value: "1"
    SchoolConfiguration.create config_key: "TotalSmsCount", config_value:"0"
    SchoolConfiguration.create config_key: "AvailableModules", config_value:"HR"
    SchoolConfiguration.create config_key: "AvailableModules", config_value:"Finance"
    # SchoolConfiguration.create :config_key => "NetworkState", :config_value=>"Online"
    SchoolConfiguration.create :config_key => "FinancialYearStartDate", :config_value=>'01-04-2012'
    SchoolConfiguration.create :config_key => "FinancialYearEndDate", :config_value=>'31-03-2013'
    SchoolConfiguration.create :config_key => "AutomaticLeaveReset", :config_value => "0"
    SchoolConfiguration.create :config_key => "LeaveResetPeriod", :config_value => "4"
    SchoolConfiguration.create :config_key => "LastAutoLeaveReset", :config_value => nil
    SchoolConfiguration.create :config_key => "ShiftStartTime", :config_value => '09:00:00'
    SchoolConfiguration.create :config_key => "ShiftEndTime", :config_value => '14:00:00'
    SchoolConfiguration.create :config_key => "SmsEnabled", :config_value => "0"
    SchoolConfiguration.create :config_key => "School_name", :config_value => 'Mount Carmel School'
    SchoolConfiguration.create :config_key => "School_domain", :config_value => ''
    SchoolConfiguration.create :config_key => "OwnSiteUrl", :config_value => ''
    SchoolConfiguration.create :config_key => "BoardSiteUrl", :config_value => ''
  end

end
