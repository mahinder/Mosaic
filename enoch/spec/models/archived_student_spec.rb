# == Schema Information
#
# Table name: archived_students
#
#  id                   :integer         not null, primary key
#  admission_no         :string(255)
#  class_roll_no        :string(255)
#  admission_date       :date
#  first_name           :string(255)
#  middle_name          :string(255)
#  last_name            :string(255)
#  batch_id             :integer
#  date_of_birth        :date
#  gender               :string(255)
#  blood_group          :string(255)
#  birth_place          :string(255)
#  nationality_id       :integer
#  language             :string(255)
#  religion             :string(255)
#  student_category_id  :integer
#  address_line1        :string(255)
#  address_line2        :string(255)
#  city                 :string(255)
#  state                :string(255)
#  pin_code             :string(255)
#  country_id           :integer
#  phone1               :string(255)
#  phone2               :string(255)
#  email                :string(255)
#  photo_file_name      :string(255)
#  photo_content_type   :string(255)
#  photo_data           :binary(5242880)
#  status_description   :string(255)
#  is_active            :boolean         default(TRUE)
#  is_deleted           :boolean         default(FALSE)
#  immediate_contact_id :integer
#  is_sms_enabled       :boolean         default(TRUE)
#  former_id            :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  photo_file_size      :integer
#

