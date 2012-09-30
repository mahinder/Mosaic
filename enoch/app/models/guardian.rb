# == Schema Information
#
# Table name: guardians
#
#  id                   :integer         not null, primary key
#  ward_id              :integer
#  first_name           :string(255)
#  last_name            :string(255)
#  relation             :string(255)
#  email                :string(255)
#  office_phone1        :string(255)
#  office_phone2        :string(255)
#  mobile_phone         :string(255)
#  office_address_line1 :string(255)
#  office_address_line2 :string(255)
#  city                 :string(255)
#  state                :string(255)
#  country_id           :integer
#  dob                  :date
#  occupation           :string(255)
#  income               :string(255)
#  education            :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#
class Guardian < ActiveRecord::Base
  belongs_to :country
  belongs_to :ward, :class_name => 'Student'
  validate :validate,:if => lambda { |o| o.current_step == "parents" }
  validate :validate,:guardian_email
  validates :email,:uniqueness=>true,:allow_blank=>true
  validates :first_name, :relation, :presence => true

  def guardian_email
      if User.where( :email => self.email).any?
          errors.add(:email, 'has already been taken')
      end
  end
  
  def validate
    errors.add(:dob, "cannot be a future date.") if self.dob > Date.today unless self.dob.nil?
  end

  def is_immediate_contact?
    ward.immediate_contact_id == id
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def archive_guardian(archived_student)
    guardian_attributes = self.attributes
    guardian_attributes.delete "id"
    guardian_attributes["ward_id"] = archived_student
    self.delete if ArchivedGuardian.create(guardian_attributes)
  end
  
end
