# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# #
# # Examples:
# #
# #   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
# #   Mayor.create(name: 'Emanuel', city: cities.first) 

  # @school_name = SchoolConfiguration.create :config_key => 'school_name', :config_value => 'Mount Carmel School'
  # @school_domain = SchoolConfiguration.create :config_key => 'school_domain', :config_value => 'mountcarmelchd.com'
  
   @prenursery1 = Batch.new :name => 'A-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @prenursery2 = Batch.new :name => 'B-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @prenursery11 = Batch.new :name => 'C-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @prenurserycourse = Course.new :course_name => "PreNursery" ,:code => "Prep",:level => 1
   @prenurserycourse.batches = [@prenursery1,@prenursery11,@prenursery2]
   @prenurserycourse.save

   @nursery1 = Batch.new :name => 'A-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @nursery2 = Batch.new :name => 'B-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @nursery11 = Batch.new :name => 'C-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @nurserycourse = Course.new :course_name => "Nursery" ,:code => "Nursery",:level => 2
   @nurserycourse.batches = [@nursery1,@nursery2,@nursery11]
   @nurserycourse.save
   
   @KG1 = Batch.new :name => 'A-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @KG11 = Batch.new :name => 'B-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @KG12 = Batch.new :name => 'C-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @KGCourse = Course.new :course_name => "KG" ,:code => "KG",:level => 3
   @KGCourse.batches = [@KG1,@KG11,@KG12]
   @KGCourse.save
   
   @batch1 = Batch.new :name => 'A-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @batch11 = Batch.new :name => 'B-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @batch12 = Batch.new :name => 'C-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @batch13 = Batch.new :name => 'D-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @course1 = Course.new :course_name => "I" ,:code => "1st",:level => 4
   @course1.batches = [@batch1,@batch11,@batch12,@batch13]
   @course1.save
   
   @batch2 = Batch.new :name => 'A-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @batch22 = Batch.new :name => 'B-2012', :start_date => '2012-04-01' , :end_date =>'2013-03-30'
   @batch23 = Batch.new :name => 'C-2012', :start_date => '2012-04-01' , :end_date =>'2013-03-30'
   @batch24 = Batch.new :name => 'D-2012', :start_date => '2012-04-01' , :end_date =>'2013-03-30'
   @course2 = Course.new :course_name => "II" ,:code => "2nd", :level => 5
   @course2.batches = [@batch2,@batch22,@batch23,@batch24]
   @course2.save
   
   @batch3 = Batch.new :name => 'A-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30' 
   @batch33 = Batch.new :name => 'B-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @batch34 = Batch.new :name => 'C-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30' 
   @batch35 = Batch.new :name => 'D-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   
   @course3 = Course.new :course_name => "III" ,:code => "3rd", :level => 6
   @course3.batches = [@batch3,@batch33,@batch34,@batch35]
   @course3.save
   
   @batch4 = Batch.new :name => 'A-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @batch44= Batch.new :name => 'B-2012', :start_date => '2012-04-01' , :end_date =>'2013-03-30'
 @batch45 = Batch.new :name => 'C-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @course4 = Course.new :course_name => "IV" ,:code => "4th", :level => 7
   @course4.batches = [@batch4,@batch44,@batch45]
   @course4.save       

   @batch5 = Batch.new :name => 'A-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30' 
   @batch55= Batch.new :name => 'B-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
  @batch56 = Batch.new :name => 'C-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30' 
   @course5 = Course.new :course_name => "V" ,:code => "5th", :level => 8
   @course5.batches = [@batch5,@batch55,@batch56]
   @course5.save 
   
   @batch6 = Batch.new :name => 'A-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @batch66= Batch.new :name => 'B-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @batch67 = Batch.new :name => 'C-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @batch68= Batch.new :name => 'D-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
    @course6 = Course.new :course_name => "VI" ,:code => "6th", :level => 9
   @course6.batches = [@batch6,@batch66,@batch67,@batch68]
   @course6.save       
   
   @batch7 = Batch.new :name => 'A-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @batch77= Batch.new :name => 'B-2012', :start_date => '2012-04-01' , :end_date =>'2013-03-30'
   @batch78 = Batch.new :name => 'C-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @batch79= Batch.new :name => 'D-2012', :start_date => '2012-04-01' , :end_date =>'2013-03-30'
   @course7 = Course.new :course_name => "VII" ,:code => "7th", :level => 10
   @course7.batches = [@batch7,@batch77,@batch78,@batch79]
   @course7.save       
   
   @batch8 =  Batch.new :name => 'A-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @batch87= Batch.new :name => 'B-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @batch88 =  Batch.new :name => 'C-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @batch89= Batch.new :name => 'D-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @course8 = Course.new :course_name => "VIII" ,:code => "8th", :level => 11
   @course8.batches = [@batch8,@batch87,@batch88,@batch89]
   @course8.save       
   
   @batch9 = Batch.new :name => 'A-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @batch91= Batch.new :name => 'B-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @batch92 = Batch.new :name => 'C-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @batch93= Batch.new :name => 'D-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @course9 = Course.new :course_name => "IX" ,:code => "9th", :level => 12
   @course9.batches = [@batch9,@batch91,@batch92,@batch93]
   @course9.save       
   
   @batch10 = Batch.new :name => 'A-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30' 
   @batch101= Batch.new :name => 'B-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @batch102 = Batch.new :name => 'C-2012', :start_date => '2012-04-01' , :end_date => '2013-03-30' 
   @course10 = Course.new :course_name => "X" ,:code => "10th", :level => 13
   @course10.batches = [@batch10,@batch101,@batch102]
   @course10.save   
     
   @batch11 = Batch.new :name => 'Commerce', :start_date => '2012-04-01' , :end_date => '2013-03-30' 
   @batch111= Batch.new :name => 'Science', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @course11 = Course.new :course_name => "+1" ,:code => "+1", :level => 14
   @course11.batches = [@batch11,@batch111]
   @course11.save  
     
   @batch12 = Batch.new :name => 'Commerce', :start_date => '2012-04-01' , :end_date => '2013-03-30' 
   @batch121= Batch.new :name => 'Science', :start_date => '2012-04-01' , :end_date => '2013-03-30'
   @course10 = Course.new :course_name => "+2" ,:code => "+2", :level => 15
   @course10.batches = [@batch12,@batch121]
   @course10.save      
   
   
StudentCategory.destroy_all
StudentCategory.create([
  {:name=>"OBC",:is_deleted=>false},
  {:name=>"BC",:is_deleted=>false},
  {:name=>"SC",:is_deleted=>false},
  {:name=>"Differently Enabled",:is_deleted=>false},
  {:name=>"General",:is_deleted=>false}
  ])


Student.destroy_all
# Student.create([
# 
# {:admission_no =>1,:class_roll_no =>1,:admission_date=>Date.today-1.year,:first_name => "Liam",:last_name => "Noah",:batch_id => 1,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"7724/D",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234567, :phone2 =>9874563210,:email =>"student1@enoch.in",:immediate_contact_id => 1,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>2,:class_roll_no =>2,:admission_date=>Date.today-1.year,:first_name => "Sophia",:last_name => "Anderson",:batch_id => 1,:date_of_birth =>Date.today-5.year,:gender => "F",:blood_group =>"B+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>2,:address_line1 =>"424/E",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1244567, :phone2 =>9874563210,:email =>"student2@enoch.in",:immediate_contact_id => 2,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>3,:class_roll_no =>3,:admission_date=>Date.today-1.year,:first_name => "Sofia",:last_name => "Reed",:batch_id => 1,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"474/F",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234578, :phone2 =>9874563210,:email =>"student3@enoch.in",:immediate_contact_id => 3,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>4,:class_roll_no =>4,:admission_date=>Date.today-1.year,:first_name => "Aidan",:last_name => "Grayson",:batch_id => 1,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"47724/G",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234589, :phone2 =>9874563210,:email =>"student4@enoch.in",:immediate_contact_id => 4,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>5,:class_roll_no =>5,:admission_date=>Date.today-1.year,:first_name => "Aden",:last_name => "Taylor",:batch_id => 1,:date_of_birth =>Date.today-5.year,:gender => "F",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>2,:address_line1 =>"428574/H",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234590, :phone2 =>9874563210,:email =>"student5@enoch.in",:immediate_contact_id => 5,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>6,:class_roll_no =>6,:admission_date=>Date.today-1.year,:first_name => "Amelia",:last_name => "Jackson",:batch_id => 1,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>2,:address_line1 =>"424/D",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234665, :phone2 =>9874563210,:email =>"student6@enoch.in",:immediate_contact_id => 6,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>7,:class_roll_no =>1,:admission_date=>Date.today-1.year,:first_name => "Emilia",:last_name => "McKenzie",:batch_id => 2,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"4824/D",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234665, :phone2 =>9874563210,:email =>"student7@enoch.in",:immediate_contact_id => 7,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>8,:class_roll_no =>2,:admission_date=>Date.today-1.year,:first_name => "Jackson",:last_name => "Smith",:batch_id => 2,:date_of_birth =>Date.today-5.year,:gender => "F",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>2,:address_line1 =>"4224/D",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234565, :phone2 =>9874563210,:email =>"student8@enoch.in",:immediate_contact_id => 8,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>9,:class_roll_no =>3,:admission_date=>Date.today-1.year,:first_name => "Jaxon",:last_name => "Harrison",:batch_id => 2,:date_of_birth =>Date.today-5.year,:gender => "F",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"4424/D",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234665, :phone2 =>9874563210,:email =>"student9@enoch.in",:immediate_contact_id => 9,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>10,:class_roll_no =>4,:admission_date=>Date.today-1.year,:first_name => "Olivia",:last_name => "Parker",:batch_id => 2,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>2,:address_line1 =>"424/N",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 12345685 ,:phone2 =>9874563210,:email =>"student10@enoch.in",:immediate_contact_id => 10,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>11,:class_roll_no =>5,:admission_date=>Date.today-1.year,:first_name => "Caleb",:last_name => "Murphy",:batch_id => 2,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"42124/V",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234565, :phone2 =>9874563210,:email =>"student11@enoch.in",:immediate_contact_id => 11,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>12,:class_roll_no =>6,:admission_date=>Date.today-1.year,:first_name => "Kaleb",:last_name => "Sawyer",:batch_id => 2,:date_of_birth =>Date.today-5.year,:gender => "F",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"424/Q",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234565, :phone2 =>9874563210,:email =>"student12@enoch.in",:immediate_contact_id => 12,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>13,:class_roll_no =>1,:admission_date=>Date.today-1.year,:first_name => "Ava",:last_name => "Jones",:batch_id => 3,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"4284/D",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234565, :phone2 =>9874563210,:email =>"student13@enoch.in",:immediate_contact_id => 13,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>14,:class_roll_no =>2,:admission_date=>Date.today-1.year,:first_name => "Oliver",:last_name => "Grady",:batch_id => 3,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>2,:address_line1 =>"48524/U",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234565, :phone2 =>9874563210,:email =>"student14@enoch.in",:immediate_contact_id => 14,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>15,:class_roll_no =>3,:admission_date=>Date.today-1.year,:first_name => "Lily",:last_name => "Lincoln",:batch_id => 3,:date_of_birth =>Date.today-5.year,:gender => "F",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"424/R",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234568, :phone2 =>9874563210,:email =>"student15@enoch.in",:immediate_contact_id => 15,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>16,:class_roll_no =>4,:admission_date=>Date.today-1.year,:first_name => "Grayson",:last_name => "Miller",:batch_id => 3,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"424/A",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234564, :phone2 =>9874563210,:email =>"student16@enoch.in",:immediate_contact_id => 16,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>17,:class_roll_no =>5,:admission_date=>Date.today-1.year,:first_name => "Emma",:last_name => "Presley",:batch_id => 3,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"4424/I",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234565, :phone2 =>9874563210,:email =>"student17@enoch.in",:immediate_contact_id => 17,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>18,:class_roll_no =>6,:admission_date=>Date.today-1.year,:first_name => "Ethan",:last_name => "Dawson",:batch_id => 3,:date_of_birth =>Date.today-5.year,:gender => "F",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>2,:address_line1 =>"4247/D",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234565, :phone2 =>9874563210,:email =>"student18@enoch.in",:immediate_contact_id => 18,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>19,:class_roll_no =>1,:admission_date=>Date.today-1.year,:first_name => "Scarlett",:last_name => "Kennedy",:batch_id => 4,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"42274/M",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234565, :phone2 =>9874563210,:email =>"student19@enoch.in",:immediate_contact_id => 19,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>20,:class_roll_no =>2,:admission_date=>Date.today-1.year,:first_name => "Alexandar",:last_name => "Jefferson",:batch_id => 4,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"42754/Z",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234565, :phone2 =>9874563210,:email =>"student20@enoch.in",:immediate_contact_id => 20,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>21,:class_roll_no =>3,:admission_date=>Date.today-1.year,:first_name => "Audrey",:last_name => "Slater",:batch_id => 4,:date_of_birth =>Date.today-5.year,:gender => "F",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>2,:address_line1 =>"424/Y",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234565, :phone2 =>9874563210,:email =>"student21@enoch.in",:immediate_contact_id => 21,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>22,:class_roll_no =>4,:admission_date=>Date.today-1.year,:first_name => "Owen",:last_name => "Kramer",:batch_id => 4,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"4284/D",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234565, :phone2 =>9874563210,:email =>"student22@enoch.in",:immediate_contact_id => 22,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>23,:class_roll_no =>5,:admission_date=>Date.today-1.year,:first_name => "Harper",:last_name => "Quinn",:batch_id => 4,:date_of_birth =>Date.today-5.year,:gender => "F",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"424/X",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234568, :phone2 =>9874563210,:email =>"student23@enoch.in",:immediate_contact_id =>23,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>24,:class_roll_no =>6,:admission_date=>Date.today-1.year,:first_name => "Benjamin",:last_name => "Connor",:batch_id => 4,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>2,:address_line1 =>"4274/T",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234568, :phone2 =>9874563210,:email =>"student24@enoch.in",:immediate_contact_id => 24,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>25,:class_roll_no =>1,:admission_date=>Date.today-1.year,:first_name => "Abigali",:last_name => "Cassidy",:batch_id => 5,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"42874/O",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234568, :phone2 =>9874563210,:email =>"student25@enoch.in",:immediate_contact_id => 25,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>26,:class_roll_no =>2,:admission_date=>Date.today-1.year,:first_name => "Lucas",:last_name => "Carter",:batch_id => 5,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>2,:address_line1 =>"424/J",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234568, :phone2 =>9874563210,:email =>"student26@enoch.in",:immediate_contact_id => 26,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>27,:class_roll_no =>3,:admission_date=>Date.today-1.year,:first_name => "Chloe",:last_name => "Carson",:batch_id => 5,:date_of_birth =>Date.today-5.year,:gender => "F",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>2,:address_line1 =>"424/L",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234568, :phone2 =>9874563210,:email =>"student27@enoch.in",:immediate_contact_id => 27,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>28,:class_roll_no =>4,:admission_date=>Date.today-1.year,:first_name => "Landon",:last_name => "Campbell",:batch_id => 5,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"424/D",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234568, :phone2 =>9874563210,:email =>"student28@enoch.in",:immediate_contact_id => 28,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>29,:class_roll_no =>5,:admission_date=>Date.today-1.year,:first_name => "Khloe",:last_name => "Brady",:batch_id => 5,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"42214/D",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234856, :phone2 =>9874563210,:email =>"student29@enoch.in",:immediate_contact_id => 29,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>30,:class_roll_no =>6,:admission_date=>Date.today-1.year,:first_name => "Landen",:last_name => "Beckett",:batch_id => 5,:date_of_birth =>Date.today-5.year,:gender => "F",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"424/W",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234856, :phone2 =>9874563210,:email =>"student30@enoch.in",:immediate_contact_id => 30,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>31,:class_roll_no =>1,:admission_date=>Date.today-1.year,:first_name => "Manak",:last_name => "Kumar",:batch_id => 6,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>2,:address_line1 =>"42984/D",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234586, :phone2 =>9874563210,:email =>"student31@enoch.in",:immediate_contact_id => 31,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>32,:class_roll_no =>2,:admission_date=>Date.today-1.year,:first_name => "Karan",:last_name => "Chaudhary",:batch_id => 6,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"421124/B",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1283456, :phone2 =>9874563210,:email =>"student32@enoch.in",:immediate_contact_id => 32,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>33,:class_roll_no =>3,:admission_date=>Date.today-1.year,:first_name => "Amar",:last_name => "Sharma",:batch_id => 6,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"421224/C",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1238456, :phone2 =>9874563210,:email =>"student33@enoch.in",:immediate_contact_id => 33,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>34,:class_roll_no =>4,:admission_date=>Date.today-1.year,:first_name => "Sunil",:last_name => "Rawat",:batch_id => 6,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"421214/P",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234856, :phone2 =>9874563210,:email =>"student34@enoch.in",:immediate_contact_id => 34,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>35,:class_roll_no =>5,:admission_date=>Date.today-1.year,:first_name => "Mahinder",:last_name => "Verma",:batch_id => 6,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"42884/K",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1238456, :phone2 =>9874563210,:email =>"student35@enoch.in",:immediate_contact_id => 35,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>36,:class_roll_no =>6,:admission_date=>Date.today-1.year,:first_name => "Shakti",:last_name => "Singh",:batch_id => 6,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"4724/S",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234856, :phone2 =>9874563210,:email =>"student36@enoch.in",:immediate_contact_id => 36,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>37,:class_roll_no =>1,:admission_date=>Date.today-1.year,:first_name => "Anu",:last_name => "Sharma",:batch_id => 7,:date_of_birth =>Date.today-5.year,:gender => "F",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"42884/K",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234856, :phone2 =>9874563210,:email =>"student37@enoch.in",:immediate_contact_id => 37,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>38,:class_roll_no =>2,:admission_date=>Date.today-1.year,:first_name => "Harpreet",:last_name => "Kaur",:batch_id => 7,:date_of_birth =>Date.today-5.year,:gender => "F",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"4724/S",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1238456, :phone2 =>9874563210,:email =>"student38@enoch.in",:immediate_contact_id => 38,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>39,:class_roll_no =>1,:admission_date=>Date.today-1.year,:first_name => "Mahinder",:last_name => "Kumar",:batch_id => 7,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"42884/K",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1283456, :phone2 =>9874563210,:email =>"student39@enoch.in",:immediate_contact_id => 39,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>40,:class_roll_no =>2,:admission_date=>Date.today-1.year,:first_name => "Sunil",:last_name => "Kumar",:batch_id => 7,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"4724/S",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1238456, :phone2 =>9874563210,:email =>"student40@enoch.in",:immediate_contact_id => 40,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>41,:class_roll_no =>5,:admission_date=>Date.today-1.year,:first_name => "Sanjay",:last_name => "Singh",:batch_id => 7,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"42884/K",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1238456, :phone2 =>9874563210,:email =>"student41@enoch.in",:immediate_contact_id => 41,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>42,:class_roll_no =>6,:admission_date=>Date.today-1.year,:first_name => "Bhawna",:last_name => "Agarwal",:batch_id => 7,:date_of_birth =>Date.today-5.year,:gender => "F",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"4724/S",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1238456, :phone2 =>9874563210,:email =>"student42@enoch.in",:immediate_contact_id => 42,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>43,:class_roll_no =>1,:admission_date=>Date.today-1.year,:first_name => "Nitin",:last_name => "Agarwal",:batch_id => 8,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"42884/K",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234856, :phone2 =>9874563210,:email =>"student43@enoch.in",:immediate_contact_id => 43,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>44,:class_roll_no =>2,:admission_date=>Date.today-1.year,:first_name => "Nupur",:last_name => "Singh",:batch_id => 8,:date_of_birth =>Date.today-5.year,:gender => "F",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"4724/S",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234856, :phone2 =>9874563210,:email =>"student44@enoch.in",:immediate_contact_id => 44,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>45,:class_roll_no =>1,:admission_date=>Date.today-1.year,:first_name => "Nikhil",:last_name => "Pandit",:batch_id => 8,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"42884/K",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1238456, :phone2 =>9874563210,:email =>"student45@enoch.in",:immediate_contact_id => 45,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>46,:class_roll_no =>2,:admission_date=>Date.today-1.year,:first_name => "Aditiya",:last_name => "Kapoor",:batch_id => 8,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"4724/S",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1283456, :phone2 =>9874563210,:email =>"student46@enoch.in",:immediate_contact_id => 46,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>47,:class_roll_no =>5,:admission_date=>Date.today-1.year,:first_name => "Anil",:last_name => "kapoor",:batch_id => 8,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"42884/K",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234856, :phone2 =>9874563210,:email =>"student47@enoch.in",:immediate_contact_id => 47,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>48,:class_roll_no =>6,:admission_date=>Date.today-1.year,:first_name => "Shakti",:last_name => "Singh",:batch_id => 8,:date_of_birth =>Date.today-5.year,:gender => "M",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"4724/S",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1238456, :phone2 =>9874563210,:email =>"student48@enoch.in",:immediate_contact_id => 48,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>49,:class_roll_no =>1,:admission_date=>Date.today-1.year,:first_name => "Laxmi",:last_name => "Jain",:batch_id => 9,:date_of_birth =>Date.today-5.year,:gender => "F",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"42884/K",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1238456, :phone2 =>9874563210,:email =>"student49@enoch.in",:immediate_contact_id => 49,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>50,:class_roll_no =>2,:admission_date=>Date.today-1.year,:first_name => "Aira",:last_name => "Kapur",:batch_id => 9,:date_of_birth =>Date.today-5.year,:gender => "F",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"4724/S",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1234856, :phone2 =>9874563210,:email =>"student50@enoch.in",:immediate_contact_id => 50,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>51,:class_roll_no =>1,:admission_date=>Date.today-1.year,:first_name => "Aditi",:last_name => "Singh",:batch_id => 9,:date_of_birth =>Date.today-5.year,:gender => "F",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"42884/K",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1283456, :phone2 =>9874563210,:email =>"student51@enoch.in",:immediate_contact_id => 51,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""},
# {:admission_no =>52,:class_roll_no =>2,:admission_date=>Date.today-1.year,:first_name => "Nidhi",:last_name => "Chambial",:batch_id => 9,:date_of_birth =>Date.today-5.year,:gender => "F",:blood_group =>"A+", :birth_place => 'India',:nationality_id =>76, :language=> "Hindi",  :religion=> "Hindu", :student_category_id=>1,:address_line1 =>"4724/S",:address_line2 =>"Model Town" , :city=> "Chandigarh",:state => "Chandigarh",:pin_code => 111111, :country_id =>'',:phone1 => 1283456, :phone2 =>9874563210,:email =>"student52@enoch.in",:immediate_contact_id => 52,  :is_sms_enabled =>true, :student_photo_file_name => "" ,:student_photo_content_type=> "",  :student_photo_data => "",   :status_description => ""}
# 
#   
# ])

Guardian.destroy_all
# Guardian.create([
 # {:ward_id =>1,:first_name =>"Jack",:last_name => "Noah", :relation => "Father", :email => "father1@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>2,:first_name =>"Andrew",:last_name => "Anderson", :relation => "Father", :email => "father2@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>3,:first_name =>"Jane",:last_name => "Reed", :relation => "Mother", :email => "mother3@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>4,:first_name =>"Juli",:last_name => "Grayson", :relation => "Mother", :email => "father4@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>5,:first_name =>"Senorita",:last_name => "Taylor", :relation => "Mother", :email => "father5@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>6,:first_name =>"Aalia",:last_name => "Jackson", :relation => "Father", :email => "father6@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>7,:first_name =>"Ahmed",:last_name => "McKenzie", :relation => "Father", :email => "father7@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>8,:first_name =>"Jack",:last_name => "Smith", :relation => "Father", :email => "father8@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>9,:first_name =>"Morrison",:last_name => "Harrison", :relation => "Father", :email => "father9@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>10,:first_name =>"Jake",:last_name => "Parker", :relation => "Father", :email => "father10@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>11,:first_name =>"Alpha",:last_name => "Murphy", :relation => "Father", :email => "father11@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>12,:first_name =>"Beta",:last_name => "Sawyer", :relation => "Father", :email => "father12@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>13,:first_name =>"Gama",:last_name => "Jones", :relation => "Father", :email => "father13@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>14,:first_name =>"Jennifer",:last_name => "Grady", :relation => "Mother", :email => "father14@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>15,:first_name =>"Faisal",:last_name => "Lincoln", :relation => "Father", :email => "father15@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>16,:first_name =>"Bruce",:last_name => "Miller", :relation => "Father", :email => "father16@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>17,:first_name =>"Amid",:last_name => "Presley", :relation => "Father", :email => "father17@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>18,:first_name =>"Clue",:last_name => "Dawson", :relation => "Father", :email => "father18@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>19,:first_name =>"John",:last_name => "Kennedy", :relation => "Father", :email => "father19@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>20,:first_name =>"Johan",:last_name => "Jefferson", :relation => "Father", :email => "father20@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>21,:first_name =>"Kitty",:last_name => "Slater", :relation => "Mother", :email => "father21@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>22,:first_name =>"Abraham",:last_name => "Kramer", :relation => "Father", :email => "father22@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>23,:first_name =>"Lincoln",:last_name => "Quinn", :relation => "Father", :email => "father23@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>24,:first_name =>"Arnold",:last_name => "Connor", :relation => "Father", :email => "father24@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>25,:first_name =>"Bill",:last_name => "Cassidy", :relation => "Father", :email => "father25@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>26,:first_name =>"Clint",:last_name => "Carter", :relation => "Father", :email => "father26@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>27,:first_name =>"Mel",:last_name => "Carson", :relation => "Father", :email => "father27@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>28,:first_name =>"Matt",:last_name => "Campbell", :relation => "Father", :email => "father28@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>29,:first_name =>"Marlon",:last_name => "Brady", :relation => "Father", :email => "father29@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>30,:first_name =>"Orlando",:last_name => "Beckett", :relation => "Father", :email => "father30@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>31,:first_name =>"Arun",:last_name => "Kumar", :relation => "Father", :email => "father31@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>32,:first_name =>"Shashi",:last_name => "Chaudhary", :relation => "Father", :email => "father32@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>33,:first_name =>"Bhaskar",:last_name => "Sharma", :relation => "Father", :email => "father33@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>34,:first_name =>"Amit",:last_name => "Rawat", :relation => "Father", :email => "father34@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>35,:first_name =>"Mahinder",:last_name => "Verma", :relation => "Father", :email => "father35@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>36,:first_name =>"Braham",:last_name => "Singh", :relation => "Father", :email => "father36@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>37,:first_name =>"Sunil",:last_name => "Sharma", :relation => "Father", :email => "father1@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>38,:first_name =>"Karan",:last_name => "Kaur", :relation => "Father", :email => "father2@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>39,:first_name =>"Adiitya",:last_name => "Kumar", :relation => "Father", :email => "father3@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>40,:first_name =>"Pawan",:last_name => "Kumar", :relation => "Father", :email => "father4@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>41,:first_name =>"Sandeep",:last_name => "Singh", :relation => "Father", :email => "father5@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>42,:first_name =>"Manish",:last_name => "Agarwal", :relation => "Father", :email => "father6@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>43,:first_name =>"Palash",:last_name => "Agarwal", :relation => "Father", :email => "father7@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>44,:first_name =>"Pankaj",:last_name => "Singh", :relation => "Father", :email => "father8@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>45,:first_name =>"Salman",:last_name => "Pandit", :relation => "Father", :email => "father9@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>46,:first_name =>"Rajender",:last_name => "Kapoor", :relation => "Father", :email => "father10@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>47,:first_name =>"Kunal",:last_name => "Kapoor", :relation => "Father", :email => "father11@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>50,:first_name =>"Sachin",:last_name => "Singh", :relation => "Father", :email => "father12@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>51,:first_name =>"Sareen",:last_name => "Jain", :relation => "Father", :email => "father13@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"},
 # {:ward_id =>52,:first_name =>"Kamini",:last_name => "Chambial", :relation => "Mother", :email => "father14@enoch.in",:office_phone1 => 1234567, :office_phone2 => 5236214, :mobile_phone => 9865320147, :office_address_line1 => "gggg", :office_address_line2 => "rrrr", :city => "Chandigarh", :state => "Chandigarh",:country_id => 76, :dob => Date.today-45.year, :occupation => "Business", :income => 45212, :education => "12th"}
#  
# ])

# ElectiveSkill.destroy_all
# ElectiveSkill.create([
  # { :name => "Computers",:course_id => 8},
  # { :name => "Arts-Science",:course_id => 9},
  # { :name => "Foriegn Language",:course_id => 11},
  # { :name => "Arts-Science",:course_id => 12}
# ])


Skill.destroy_all
# Skill.create([
 # {:name => "Math", :course_id => 1, :elective_skill_id => nil, :max_weekly_classes => 4, :no_exam => false , :full_name => "Pre Nursery-Maths",:is_active => true , :is_common => false,:code => "Math"},
 # {:name => "English", :course_id => 1,:elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Pre Nursery-English",:is_active => true , :is_common => false,:code => "English"},
 # {:name => "Games", :course_id => 1, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Pre Nursery-Games",:is_active => true , :is_common => false,:code => "Games"},
#  
 # {:name => "Math", :course_id => 2, :elective_skill_id => nil, :max_weekly_classes => 4, :no_exam => false , :full_name => "Nursery-Maths",:is_active => true , :is_common => false,:code => "Math"},
 # {:name => "English", :course_id => 2,:elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Nursery-English",:is_active => true , :is_common => false,:code => "English"},
 # {:name => "Games", :course_id => 2, :elective_skill_id => nil,:max_weekly_classes =>  4 , :no_exam => false , :full_name => "Nursery-Games",:is_active => true , :is_common => false,:code => "Games"},
# 
#  
 # {:name => "Maths", :course_id => 3, :elective_skill_id => nil, :max_weekly_classes => 4, :no_exam => false , :full_name => "KG-Maths",:is_active => true , :is_common => false,:code => "Math"},
 # {:name => "English", :course_id => 3,:elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "KG-English",:is_active => true , :is_common => false,:code => "English"},
 # {:name => "Games", :course_id => 3, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "KG-Games",:is_active => true , :is_common => false,:code => "Games"},
 # {:name => "Hindi", :course_id => 3, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "KG-Hindi",:is_active => true , :is_common => false,:code => "Hindi"},
#  
#  
 # {:name => "Math", :course_id => 4, :elective_skill_id => nil, :max_weekly_classes => 4, :no_exam => false , :full_name => "Grade 1-Maths",:is_active => true , :is_common => false,:code => "Math"},
 # {:name => "English", :course_id => 4,:elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 1-English",:is_active => true , :is_common => false,:code => "English"},
 # {:name => "Games", :course_id => 4, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 1-Games",:is_active => true , :is_common => false,:code => "Games"},
 # {:name => "Hindi", :course_id => 4, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 1-Hindi",:is_active => true , :is_common => false,:code => "Hindi"},
 # {:name => "EVS", :course_id => 4, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 1-EVS",:is_active => true , :is_common => false,:code => "EVS"},  
 # {:name => "G.K.- Moral Science", :course_id => 4, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 1-G.K.- Moral Science",:is_active => true , :is_common => false,:code => "G.K."},
# 
# 
 # {:name => "Maths", :course_id => 5, :elective_skill_id => nil, :max_weekly_classes => 4, :no_exam => false , :full_name => "Grade 2-Maths",:is_active => true , :is_common => false,:code => "Math"},
 # {:name => "English", :course_id => 5,:elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 2-English",:is_active => true , :is_common => false,:code => "English"},
 # {:name => "Games", :course_id => 5, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 2-Games",:is_active => true , :is_common => false,:code => "Games"},
 # {:name => "Hindi", :course_id => 5, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 2-Hindi",:is_active => true , :is_common => false,:code => "Hindi"},
 # {:name => "EVS", :course_id => 5, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 2-EVS",:is_active => true , :is_common => false,:code => "EVS"},  
 # {:name => "G.K.- Moral Science", :course_id => 5, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 2-G.K.- Moral Science",:is_active => true , :is_common => false,:code => "G.K."},
 # {:name => "Computers", :course_id => 5, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 1-Computers",:is_active => true , :is_common => false,:code => "Computers"},
#   
#  
 # {:name => "Maths", :course_id => 6, :elective_skill_id => nil, :max_weekly_classes => 4, :no_exam => false , :full_name => "Grade 3-Maths",:is_active => true , :is_common => false,:code => "Math"},
 # {:name => "English", :course_id => 6,:elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 3-English",:is_active => true , :is_common => false,:code => "English"},
 # {:name => "Games", :course_id => 6, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 3-Games",:is_active => true , :is_common => false,:code => "Games"},
 # {:name => "Hindi", :course_id => 6, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 3-Hindi",:is_active => true , :is_common => false,:code => "Hindi"},
 # {:name => "EVS", :course_id => 6, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 3-EVS",:is_active => true , :is_common => false,:code => "EVS"},  
 # {:name => "G.K.- Moral Science", :course_id => 6, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 3-G.K.- Moral Science",:is_active => true , :is_common => false,:code => "G.K."},
 # {:name => "Computers", :course_id => 6, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 3-Computers",:is_active => true , :is_common => false,:code => "Computers"},
#  
# 
 # {:name => "Maths", :course_id => 7, :elective_skill_id => nil, :max_weekly_classes => 4, :no_exam => false , :full_name => "Grade 4-Maths",:is_active => true , :is_common => false,:code => "Math"},
 # {:name => "English", :course_id => 7,:elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 4-English",:is_active => true , :is_common => false,:code => "English"},
 # {:name => "Games", :course_id => 7, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 4-Games",:is_active => true , :is_common => false,:code => "Games"},
 # {:name => "Hindi", :course_id => 7, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 4-Hindi",:is_active => true , :is_common => false,:code => "Hindi"},
 # {:name => "Science", :course_id => 7, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 4-Science",:is_active => true , :is_common => false,:code => "Science"},  
 # {:name => "SST", :course_id => 7, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 4-SST",:is_active => true , :is_common => false,:code => "SST"},
 # {:name => "G.K.- Moral Science", :course_id => 7, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 4-G.K.- Moral Science",:is_active => true , :is_common => false,:code => "G.K."},
 # {:name => "Computers", :course_id => 7, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 4-Computers",:is_active => true , :is_common => false,:code => "Computers"},
 # {:name => "Punjabi", :course_id => 7, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 4-Punjabi",:is_active => true , :is_common => false,:code => "Punjabi"},
#    
 # {:name => "Maths", :course_id => 8, :elective_skill_id => nil, :max_weekly_classes => 4, :no_exam => false , :full_name => "Grade 5-Maths",:is_active => true , :is_common => false,:code => "Math"},
 # {:name => "English", :course_id => 8,:elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 5-English",:is_active => true , :is_common => false,:code => "English"},
 # {:name => "Games", :course_id => 8, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 5-Games",:is_active => true , :is_common => false,:code => "Games"},
 # {:name => "Hindi", :course_id => 8, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 5-Hindi",:is_active => true , :is_common => false,:code => "Hindi"},
 # {:name => "Science", :course_id => 8, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 5-Science",:is_active => true , :is_common => false,:code => "Science"},  
 # {:name => "SST", :course_id => 8, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 5-SST",:is_active => true , :is_common => false,:code => "SST"},
 # {:name => "G.K.- Moral Science", :course_id => 8, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 5-G.K.- Moral Science",:is_active => true , :is_common => false,:code => "G.K."},
 # {:name => "Computers", :course_id => 8, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 5-Computers",:is_active => true , :is_common => false,:code => "Computers"},
 # {:name => "Punjabi", :course_id => 8, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 5-Punjabi",:is_active => true , :is_common => false,:code => "Punjabi"},
# 
 # {:name => "Maths", :course_id => 9, :elective_skill_id => nil, :max_weekly_classes => 4, :no_exam => false , :full_name => "Grade 6-Maths",:is_active => true , :is_common => false,:code => "Math"},
 # {:name => "English", :course_id => 9,:elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 6-English",:is_active => true , :is_common => false,:code => "English"},
 # {:name => "Games", :course_id => 9, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 6-Games",:is_active => true , :is_common => false,:code => "Games"},
 # {:name => "Hindi", :course_id => 9, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 6-Hindi",:is_active => true , :is_common => false,:code => "Hindi"},
 # {:name => "Science", :course_id => 8, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 6-EVS",:is_active => true , :is_common => false,:code => "Science"},  
 # {:name => "Social Science", :course_id => 9, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 6-Social Science",:is_active => true , :is_common => false,:code => "Social Science"},
 # {:name => "G.K.", :course_id => 9, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 6-G.K.",:is_active => true , :is_common => false,:code => "G.K."},
 # {:name => "Computers", :course_id => 9, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 6-Computers",:is_active => true , :is_common => false,:code => "Computers"},
 # {:name => "Punjabi", :course_id => 9, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 6-Punjabi",:is_active => true , :is_common => false,:code => "Punjabi"},
 # {:name => "Env. Stud.", :course_id => 9, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 6-Env. Stud.",:is_active => true , :is_common => false,:code => "Env. Stud."},
#  
 # {:name => "Maths", :course_id => 10, :elective_skill_id => nil, :max_weekly_classes => 4, :no_exam => false , :full_name => "Grade 7-Maths",:is_active => true , :is_common => false,:code => "Math"},
 # {:name => "English", :course_id => 10,:elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 7-English",:is_active => true , :is_common => false,:code => "English"},
 # {:name => "Games", :course_id => 10, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 7-Games",:is_active => true , :is_common => false,:code => "Games"},
 # {:name => "Hindi", :course_id => 10, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 7-Hindi",:is_active => true , :is_common => false,:code => "Hindi"},
 # {:name => "Science", :course_id => 10, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 7-EVS",:is_active => true , :is_common => false,:code => "Science"},  
 # {:name => "Social Science", :course_id => 10, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 7-Social Science",:is_active => true , :is_common => false,:code => "Social Science"},
 # {:name => "G.K.", :course_id => 10, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 7-G.K.",:is_active => true , :is_common => false,:code => "G.K."},
 # {:name => "Computers", :course_id => 10, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 7-Computers",:is_active => true , :is_common => false,:code => "Computers"},
 # {:name => "Punjabi", :course_id => 10, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 7-Punjabi",:is_active => true , :is_common => false,:code => "Punjabi"},
 # {:name => "Env. Stud.", :course_id => 10, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 7-Env. Stud.",:is_active => true , :is_common => false,:code => "Env. Stud."},
#  
 # {:name => "Maths", :course_id => 11, :elective_skill_id => nil, :max_weekly_classes => 4, :no_exam => false , :full_name => "Grade 8-Maths",:is_active => true , :is_common => false,:code => "Math"},
 # {:name => "English", :course_id => 11,:elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 8-English",:is_active => true , :is_common => false,:code => "English"},
 # {:name => "Games", :course_id => 11, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 8-Games",:is_active => true , :is_common => false,:code => "Games"},
 # {:name => "Hindi", :course_id => 11, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 8-Hindi",:is_active => true , :is_common => false,:code => "Hindi"},
 # {:name => "Science", :course_id => 11, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 8-EVS",:is_active => true , :is_common => false,:code => "Science"},  
 # {:name => "Social Science", :course_id => 11, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 8-Social Science",:is_active => true , :is_common => false,:code => "Social Science"},
 # {:name => "G.K.", :course_id => 11, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 8-G.K.",:is_active => true , :is_common => false,:code => "G.K."},
 # {:name => "Computers", :course_id => 11, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 8-Computers",:is_active => true , :is_common => false,:code => "Computers"},
 # {:name => "Punjabi", :course_id => 11, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 8-Punjabi",:is_active => true , :is_common => false,:code => "Punjabi"},
 # {:name => "Env. Stud.", :course_id => 11, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 8-Env. Stud.",:is_active => true , :is_common => false,:code => "Env. Stud."},
#  
 # {:name => "Maths", :course_id => 12, :elective_skill_id => nil, :max_weekly_classes => 4, :no_exam => false , :full_name => "Grade 9-Maths",:is_active => true , :is_common => false,:code => "Math"},
 # {:name => "English", :course_id => 12,:elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 9-English",:is_active => true , :is_common => false,:code => "English"},
 # {:name => "Games", :course_id => 12, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 9-Games",:is_active => true , :is_common => false,:code => "Games"},
 # {:name => "Hindi", :course_id => 12, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 9-Hindi",:is_active => true , :is_common => false,:code => "Hindi"},
 # {:name => "Science", :course_id => 12, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 9-EVS",:is_active => true , :is_common => false,:code => "Science"},  
 # {:name => "Social Science", :course_id => 12, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 9-Social Science",:is_active => true , :is_common => false,:code => "Social Science"},
 # {:name => "Computers", :course_id => 12, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 9-Computers",:is_active => true , :is_common => false,:code => "Computers"},
 # {:name => "Punjabi", :course_id => 12, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 9-Punjabi",:is_active => true , :is_common => false,:code => "Punjabi"},
#  
 # {:name => "Maths", :course_id => 13, :elective_skill_id => nil, :max_weekly_classes => 4, :no_exam => false , :full_name => "Grade 10-Maths",:is_active => true , :is_common => false,:code => "Math"},
 # {:name => "English", :course_id => 13,:elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 10-English",:is_active => true , :is_common => false,:code => "English"},
 # {:name => "Games", :course_id => 13, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 10-Games",:is_active => true , :is_common => false,:code => "Games"},
 # {:name => "Hindi", :course_id => 13, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 10-Hindi",:is_active => true , :is_common => false,:code => "Hindi"},
 # {:name => "Science", :course_id => 13, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 10-EVS",:is_active => true , :is_common => false,:code => "Science"},  
 # {:name => "Social Science", :course_id => 13, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 10-Social Science",:is_active => true , :is_common => false,:code => "Social Science"},
 # {:name => "Computers", :course_id => 13, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 10-Computers",:is_active => true , :is_common => false,:code => "Computers"},
 # {:name => "Punjabi", :course_id => 13, :elective_skill_id => nil,:max_weekly_classes => 4 , :no_exam => false , :full_name => "Grade 10-Punjabi",:is_active => true , :is_common => false,:code => "Punjabi"}
#  
# ])

# Subject.destroy_all
# Subject.create([
 # {:name => "Maths", :batch_id => 1,:skill_id => 1 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 1,:skill_id => 2 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 1,:skill_id => 3 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
#  
 # {:name => "Maths", :batch_id => 2,:skill_id => 1 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 2,:skill_id => 2 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 2,:skill_id => 3 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
#  
 # {:name => "Maths", :batch_id => 3,:skill_id => 4 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 3,:skill_id => 5 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 3,:skill_id => 6 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
#  
 # {:name => "Maths", :batch_id => 4,:skill_id => 4 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 4,:skill_id => 5 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 4,:skill_id => 6 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
#   
# 
 # {:name => "Maths", :batch_id => 5,:skill_id => 7 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 5,:skill_id => 8 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 5,:skill_id => 9 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
 # {:name => "Hindi", :batch_id => 5,:skill_id => 10 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Hindi", :is_deleted => false},
#  
 # {:name => "Maths", :batch_id => 6,:skill_id => 7 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 6,:skill_id => 8 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 6,:skill_id => 9 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
 # {:name => "Hindi", :batch_id => 6,:skill_id => 10 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Hindi", :is_deleted => false},
#  
#  
 # {:name => "Maths", :batch_id => 7,:skill_id => 11 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 7,:skill_id => 12 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 7,:skill_id => 13 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
 # {:name => "Hindi", :batch_id => 7,:skill_id => 14 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Hindi", :is_deleted => false},
 # {:name => "EVS", :batch_id => 7,:skill_id => 15 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "EVS", :is_deleted => false},
 # {:name => "G.K.- Moral Science", :batch_id => 7,:skill_id => 16 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "G.K.", :is_deleted => false},
#  
 # {:name => "Maths", :batch_id => 8,:skill_id => 11 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 8,:skill_id => 12 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 8,:skill_id => 13 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
 # {:name => "Hindi", :batch_id => 8,:skill_id => 14 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Hindi", :is_deleted => false},
 # {:name => "EVS", :batch_id => 8,:skill_id => 15 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "EVS", :is_deleted => false},
 # {:name => "G.K.- Moral Science", :batch_id => 8,:skill_id => 16 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "G.K.", :is_deleted => false},
#  
 # {:name => "Maths", :batch_id => 9,:skill_id => 17 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 9,:skill_id => 18 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 9,:skill_id => 19 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
 # {:name => "Hindi", :batch_id => 9,:skill_id => 20 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Hindi", :is_deleted => false},
 # {:name => "EVS", :batch_id => 9,:skill_id => 21 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "EVS", :is_deleted => false},
 # {:name => "G.K.- Moral Science", :batch_id => 9,:skill_id => 22 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "G.K.", :is_deleted => false},
 # {:name => "Computers", :batch_id => 9,:skill_id => 23 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Computers", :is_deleted => false},
# 
 # {:name => "Maths", :batch_id => 10,:skill_id => 17 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 10,:skill_id => 18 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 10,:skill_id => 19 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
 # {:name => "Hindi", :batch_id => 10,:skill_id => 20 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Hindi", :is_deleted => false},
 # {:name => "EVS", :batch_id => 10,:skill_id => 21 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "EVS", :is_deleted => false},
 # {:name => "G.K.- Moral Science", :batch_id => 10,:skill_id => 22 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "G.K.", :is_deleted => false},
 # {:name => "Computers", :batch_id => 10,:skill_id => 23 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Computers", :is_deleted => false}, 
#  
 # {:name => "Maths", :batch_id => 11,:skill_id => 24 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 11,:skill_id => 25 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 11,:skill_id => 26 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
 # {:name => "Hindi", :batch_id => 11,:skill_id => 27 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Hindi", :is_deleted => false},
 # {:name => "EVS", :batch_id => 11,:skill_id => 28 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "EVS", :is_deleted => false},
 # {:name => "G.K.- Moral Science", :batch_id => 11,:skill_id => 29 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "G.K.", :is_deleted => false},
 # {:name => "Computers", :batch_id => 11,:skill_id => 30 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Computers", :is_deleted => false},
#  
 # {:name => "Maths", :batch_id => 12,:skill_id => 24 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 12,:skill_id => 25 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 12,:skill_id => 26 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
 # {:name => "Hindi", :batch_id => 12,:skill_id => 27 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Hindi", :is_deleted => false},
 # {:name => "EVS", :batch_id => 12,:skill_id => 28 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "EVS", :is_deleted => false},
 # {:name => "G.K.- Moral Science", :batch_id => 12,:skill_id => 29 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "G.K.", :is_deleted => false},
 # {:name => "Computers", :batch_id => 12,:skill_id => 30 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Computers", :is_deleted => false},
#  
 # {:name => "Maths", :batch_id => 13,:skill_id => 31 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 13,:skill_id => 32 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 13,:skill_id => 33 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
 # {:name => "Hindi", :batch_id => 13,:skill_id => 34 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Hindi", :is_deleted => false},
 # {:name => "Science", :batch_id => 13,:skill_id => 35 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Science", :is_deleted => false},
 # {:name => "SST", :batch_id => 13,:skill_id => 36 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "SST", :is_deleted => false},
 # {:name => "G.K.- Moral Science", :batch_id => 13,:skill_id => 37 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "G.K.", :is_deleted => false},
 # {:name => "Computers", :batch_id => 13,:skill_id => 38 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Computers", :is_deleted => false},
 # {:name => "Punjabi", :batch_id => 13,:skill_id => 39 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Punjabi", :is_deleted => false},
#  
 # {:name => "Maths", :batch_id => 14,:skill_id => 31 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 14,:skill_id => 32 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 14,:skill_id => 33 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
 # {:name => "Hindi", :batch_id => 14,:skill_id => 34 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Hindi", :is_deleted => false},
 # {:name => "Science", :batch_id => 14,:skill_id => 35 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Science", :is_deleted => false},
 # {:name => "SST", :batch_id => 14,:skill_id => 36 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "SST", :is_deleted => false},
 # {:name => "G.K.- Moral Science", :batch_id => 14,:skill_id => 37 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "G.K.", :is_deleted => false},
 # {:name => "Computers", :batch_id => 14,:skill_id => 38 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Computers", :is_deleted => false},
 # {:name => "Punjabi", :batch_id => 14,:skill_id => 39 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Punjabi", :is_deleted => false},
#  
 # {:name => "Maths", :batch_id => 15,:skill_id => 40 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 15,:skill_id => 41 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 15,:skill_id => 42 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
 # {:name => "Hindi", :batch_id => 15,:skill_id => 43 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Hindi", :is_deleted => false},
 # {:name => "Science", :batch_id => 15,:skill_id => 44 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Science", :is_deleted => false},
 # {:name => "SST", :batch_id => 15,:skill_id => 45 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "SST", :is_deleted => false},
 # {:name => "G.K.- Moral Science", :batch_id => 15,:skill_id => 46 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "G.K.", :is_deleted => false},
 # {:name => "Computers", :batch_id => 15,:skill_id => 47 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Computers", :is_deleted => false},
 # {:name => "Punjabi", :batch_id => 15,:skill_id => 48 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Punjabi", :is_deleted => false},
#  
 # {:name => "Maths", :batch_id => 16,:skill_id => 40 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 16,:skill_id => 41 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 16,:skill_id => 42 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
 # {:name => "Hindi", :batch_id => 16,:skill_id => 43 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Hindi", :is_deleted => false},
 # {:name => "Science", :batch_id => 16,:skill_id => 44 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Science", :is_deleted => false},
 # {:name => "SST", :batch_id => 16,:skill_id => 45 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "SST", :is_deleted => false},
 # {:name => "G.K.- Moral Science", :batch_id => 16,:skill_id => 46 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "G.K.", :is_deleted => false},
 # {:name => "Computers", :batch_id => 16,:skill_id => 47 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Computers", :is_deleted => false},
 # {:name => "Punjabi", :batch_id => 16,:skill_id => 48 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Punjabi", :is_deleted => false},
#  
 # {:name => "Maths", :batch_id => 17,:skill_id => 49 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 17,:skill_id => 50 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 17,:skill_id => 51 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
 # {:name => "Hindi", :batch_id => 17,:skill_id => 52 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Hindi", :is_deleted => false},
 # {:name => "Science", :batch_id => 17,:skill_id => 53 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Science", :is_deleted => false},
 # {:name => "Social Science", :batch_id => 17,:skill_id => 54 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Social Science", :is_deleted => false},
 # {:name => "G.K.", :batch_id => 17,:skill_id => 55 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "G.K.", :is_deleted => false},
 # {:name => "Computers", :batch_id => 17,:skill_id => 56 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Computers", :is_deleted => false},
 # {:name => "Punjabi", :batch_id => 17,:skill_id => 57 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Punjabi", :is_deleted => false},
 # {:name => "Env. Stud.", :batch_id => 17,:skill_id => 58 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Env. Stud.", :is_deleted => false},
#  
 # {:name => "Maths", :batch_id => 18,:skill_id => 49 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 18,:skill_id => 50 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 18,:skill_id => 51 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
 # {:name => "Hindi", :batch_id => 18,:skill_id => 52 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Hindi", :is_deleted => false},
 # {:name => "Science", :batch_id => 18,:skill_id => 53 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Science", :is_deleted => false},
 # {:name => "Social Science", :batch_id => 18,:skill_id => 54 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Social Science", :is_deleted => false},
 # {:name => "G.K.", :batch_id => 18,:skill_id => 55 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "G.K.", :is_deleted => false},
 # {:name => "Computers", :batch_id => 18,:skill_id => 56 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Computers", :is_deleted => false},
 # {:name => "Punjabi", :batch_id => 18,:skill_id => 57 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Punjabi", :is_deleted => false},
 # {:name => "Env. Stud.", :batch_id => 18,:skill_id => 58 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Env. Stud.", :is_deleted => false},
#  
 # {:name => "Maths", :batch_id => 19,:skill_id => 59 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 19,:skill_id => 60 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 19,:skill_id => 61 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
 # {:name => "Hindi", :batch_id => 19,:skill_id => 62 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Hindi", :is_deleted => false},
 # {:name => "Science", :batch_id => 19,:skill_id => 63 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Science", :is_deleted => false},
 # {:name => "Social Science", :batch_id => 19,:skill_id => 64 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Social Science", :is_deleted => false},
 # {:name => "G.K.", :batch_id => 19,:skill_id => 65 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "G.K.", :is_deleted => false},
 # {:name => "Computers", :batch_id => 19,:skill_id => 66 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Computers", :is_deleted => false},
 # {:name => "Punjabi", :batch_id => 19,:skill_id => 67 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Punjabi", :is_deleted => false},
 # {:name => "Env. Stud.", :batch_id => 19,:skill_id => 68 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Env. Stud.", :is_deleted => false},
#  
 # {:name => "Maths", :batch_id => 20,:skill_id => 59 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 20,:skill_id => 60 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 20,:skill_id => 61 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
 # {:name => "Hindi", :batch_id => 20,:skill_id => 62 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Hindi", :is_deleted => false},
 # {:name => "Science", :batch_id => 20,:skill_id => 63 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Science", :is_deleted => false},
 # {:name => "Social Science", :batch_id => 20,:skill_id => 64 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Social Science", :is_deleted => false},
 # {:name => "G.K.", :batch_id => 20,:skill_id => 65 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "G.K.", :is_deleted => false},
 # {:name => "Computers", :batch_id => 20,:skill_id => 66 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Computers", :is_deleted => false},
 # {:name => "Punjabi", :batch_id => 20,:skill_id => 67 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Punjabi", :is_deleted => false},
 # {:name => "Env. Stud.", :batch_id => 20,:skill_id => 68 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Env. Stud.", :is_deleted => false},
#  
 # {:name => "Maths", :batch_id => 21,:skill_id => 69 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 21,:skill_id => 70 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 21,:skill_id => 71 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
 # {:name => "Hindi", :batch_id => 21,:skill_id => 72 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Hindi", :is_deleted => false},
 # {:name => "Science", :batch_id => 21,:skill_id => 73 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Science", :is_deleted => false},
 # {:name => "Social Science", :batch_id => 21,:skill_id => 74 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Social Science", :is_deleted => false},
 # {:name => "G.K.", :batch_id => 21,:skill_id => 75 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "G.K.", :is_deleted => false},
 # {:name => "Computers", :batch_id => 21,:skill_id => 76 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Computers", :is_deleted => false},
 # {:name => "Punjabi", :batch_id => 21,:skill_id => 77 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Punjabi", :is_deleted => false},
 # {:name => "Env. Stud.", :batch_id => 21,:skill_id => 78 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Env. Stud.", :is_deleted => false},
#  
 # {:name => "Maths", :batch_id => 22,:skill_id => 69 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 22,:skill_id => 70 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 22,:skill_id => 71 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
 # {:name => "Hindi", :batch_id => 22,:skill_id => 72 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Hindi", :is_deleted => false},
 # {:name => "Science", :batch_id => 22,:skill_id => 73 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Science", :is_deleted => false},
 # {:name => "Social Science", :batch_id => 22,:skill_id => 74 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Social Science", :is_deleted => false},
 # {:name => "G.K.", :batch_id => 22,:skill_id => 75 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "G.K.", :is_deleted => false},
 # {:name => "Computers", :batch_id => 22,:skill_id => 76 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Computers", :is_deleted => false},
 # {:name => "Punjabi", :batch_id => 22,:skill_id => 77 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Punjabi", :is_deleted => false},
 # {:name => "Env. Stud.", :batch_id => 22,:skill_id => 78 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Env. Stud.", :is_deleted => false},
#  
 # {:name => "Maths", :batch_id => 23,:skill_id => 79 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 23,:skill_id => 80 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 23,:skill_id => 81 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
 # {:name => "Hindi", :batch_id => 23,:skill_id => 82 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Hindi", :is_deleted => false},
 # {:name => "Science", :batch_id => 23,:skill_id => 83 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Science", :is_deleted => false},
 # {:name => "Social Science", :batch_id => 23,:skill_id => 84 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Social Science", :is_deleted => false},
 # {:name => "Computers", :batch_id => 23,:skill_id => 85 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Computers", :is_deleted => false},
 # {:name => "Punjabi", :batch_id => 23,:skill_id => 86 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Punjabi", :is_deleted => false},
#  
 # {:name => "Maths", :batch_id => 24,:skill_id => 79 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 24,:skill_id => 80 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 24,:skill_id => 81 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
 # {:name => "Hindi", :batch_id => 24,:skill_id => 82 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Hindi", :is_deleted => false},
 # {:name => "Science", :batch_id => 24,:skill_id => 83 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Science", :is_deleted => false},
 # {:name => "Social Science", :batch_id => 24,:skill_id => 84 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Social Science", :is_deleted => false},
 # {:name => "Computers", :batch_id => 24,:skill_id => 85 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Computers", :is_deleted => false},
 # {:name => "Punjabi", :batch_id => 24,:skill_id => 86 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Punjabi", :is_deleted => false},
#  
 # {:name => "Maths", :batch_id => 25,:skill_id => 87 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 25,:skill_id => 88 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 25,:skill_id => 89 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
 # {:name => "Hindi", :batch_id => 25,:skill_id => 90 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Hindi", :is_deleted => false},
 # {:name => "Science", :batch_id => 25,:skill_id => 91 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Science", :is_deleted => false},
 # {:name => "Social Science", :batch_id => 25,:skill_id => 92 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Social Science", :is_deleted => false},
 # {:name => "Computers", :batch_id => 25,:skill_id => 93 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Computers", :is_deleted => false},
 # {:name => "Punjabi", :batch_id => 25,:skill_id => 94 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Punjabi", :is_deleted => false},
#  
 # {:name => "Maths", :batch_id => 26,:skill_id => 87 , :elective_group_id => nil, :max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "Math", :is_deleted => false},
 # {:name => "English", :batch_id => 26,:skill_id => 88 ,:elective_group_id => nil,:max_weekly_classes => 4 , :no_exams => false , :is_common => false, :code => "English", :is_deleted => false},
 # {:name => "Games", :batch_id => 26,:skill_id => 89 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Games", :is_deleted => false},
 # {:name => "Hindi", :batch_id => 26,:skill_id => 90 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Hindi", :is_deleted => false},
 # {:name => "Science", :batch_id => 26,:skill_id => 91 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Science", :is_deleted => false},
 # {:name => "Social Science", :batch_id => 26,:skill_id => 92 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Social Science", :is_deleted => false},
 # {:name => "Computers", :batch_id => 26,:skill_id => 93 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Computers", :is_deleted => false},
 # {:name => "Punjabi", :batch_id => 26,:skill_id => 94 , :elective_group_id => nil,:max_weekly_classes => 4 ,  :no_exams => false , :is_common => false, :code => "Punjabi", :is_deleted => false},
#  
#      
# ])



#EmployeeCategory.delete_all
# EmployeeCategory.create([
 # {:name => 'Enoch',:prefix => 'Admin',:status => true},
  # {:name => 'Management',:prefix => 'MGMT',:status => true},
  # {:name => 'Teaching',:prefix => 'TCR',:status => true},
  # {:name => 'Non-Teaching',:prefix => 'NTCR',:status => true}
  # ])

#EmployeePosition.delete_all
# EmployeePosition.create([
 # {:name => 'Enoch',:employee_category_id => 1,:status => true},
  # {:name => 'Principal',:employee_category_id => 2,:status => true},
  # {:name => 'HR',:employee_category_id => 2,:status => true},
  # {:name => 'Sr.Teacher',:employee_category_id => 3,:status => true},
  # {:name => 'Jr.Teacher',:employee_category_id => 3,:status => true},
  # {:name => 'Clerk',:employee_category_id => 4,:status => true}
  # ])

#EmployeeDepartment.delete_all
EmployeeDepartment.create([
# {:code => 'Admin',:name => 'Enoch',:status => true},
  {:code => 'School',:name => 'School',:status => true},
  # {:code => 'MAT',:name => 'Mathematics',:status => true},
  # {:code => 'OFC',:name => 'Office',:status => true},
  ])

#EmployeeGrade.delete_all
EmployeeGrade.create([
# {:name => 'Enoch',:priority => 0 ,:status => true,:max_hours_day=>nil,:max_hours_week=>nil},
  {:name => 'A',:priority => 1 ,:status => true,:max_hours_day=>1,:max_hours_week=>5},
  {:name => 'B',:priority => 2 ,:status => true,:max_hours_day=>3,:max_hours_week=>15},
  {:name => 'C',:priority => 3 ,:status => true,:max_hours_day=>4,:max_hours_week=>20},
  {:name => 'D',:priority => 4 ,:status => true,:max_hours_day=>5,:max_hours_week=>25},
  ])

PayrollCategory.delete_all
PayrollCategory.create([
  {:name=>"Basic",:percentage=>nil,:payroll_category_id=>nil,:is_deduction=>false,:status=>true},
  {:name=>"Medical Allowance",:percentage=>3,:payroll_category_id=>1,:is_deduction=>false,:status=>true},
  {:name=>"Travel Allowance",:percentage=>5,:payroll_category_id=>1,:is_deduction=>false,:status=>true},
  {:name=>"Mobile deduction",:percentage=>nil,:payroll_category_id=>nil,:is_deduction=>true,:status=>true},
  {:name=>"PF",:percentage=>5,:payroll_category_id=>1,:is_deduction=>true,:status=>true},
  {:name=>"State tax",:percentage=>3,:payroll_category_id=>5,:is_deduction=>true,:status=>true}
  ])

BankField.delete_all
BankField.create([
  {:name=>"Bank Name",:status=>true},
  {:name=>"Bank Branch",:status=>true},
  {:name=>"Account No",:status=>true},
  ])

AdditionalField.delete_all
AdditionalField.create([
  {:name=>"Liscence Number",:status=>true},
  {:name=>"PAN",:status=>true},
  {:name=>"LIC",:status=>true},
  ])

# Employee.delete_all
# Employee.create([
# {:employee_number => 'E0002',:joining_date => Date.today,:first_name => 'John',:last_name => 'Adam',:email =>'E0002@ezzie.in',
# :employee_department_id => 1,:employee_grade_id => 1,:employee_position_id => 1, :gender =>'M',
# :employee_category_id => 1,:date_of_birth => Date.today-365, :home_country_id => 76, :office_country_id=>76, :nationality_id => 76},
  # {:employee_number => 'E0003',:email =>'E0003@ezzie.in',:joining_date => Date.today,:first_name => 'Unni',:last_name => 'Koroth',
   # :employee_department_id => 2,:employee_grade_id => 2,:employee_position_id => 2,  :gender =>'M',
   # :employee_category_id => 3,:date_of_birth => Date.today-365, :home_country_id => 76, :office_country_id=>76, :nationality_id => 76},
  # {:employee_number => 'E0004',:email =>'E0004@ezzie.in',:joining_date => Date.today,:first_name => 'Vishwajith',:last_name => 'A',
   # :employee_department_id => 2,:employee_grade_id => 1,:employee_position_id => 3, :gender =>'F',
   # :employee_category_id => 3,:date_of_birth => Date.today-365, :home_country_id => 76, :office_country_id=>76, :nationality_id => 76},
  # {:employee_number => 'E0005',:email =>'E0005@ezzie.in',:joining_date => Date.today,:first_name => 'Aravind',:last_name => 'GS',
   # :employee_department_id => 3,:employee_grade_id => 3,:employee_position_id => 4,  :gender =>'M',
   # :employee_category_id => 3,:date_of_birth => Date.today-365, :home_country_id => 76, :office_country_id=>76, :nationality_id => 76},
  # {:employee_number => 'E0006',:email =>'E0006@ezzie.in',:joining_date => Date.today,:first_name => 'Nithin',:last_name => 'Bekal',
   # :employee_department_id => 3,:employee_grade_id => 4,:employee_position_id => 5, :gender =>'M',
   # :employee_category_id => 3,:date_of_birth => Date.today-365, :home_country_id => 76, :office_country_id=>76, :nationality_id => 76},
  # {:employee_number => 'E0007',:email =>'E0007@ezzie.in',:joining_date => Date.today,:first_name => 'Ralu',:last_name => 'RM',
   # :employee_department_id => 4,:employee_grade_id => 5,:employee_position_id => 6, :gender =>'M',
   # :employee_category_id => 4,:date_of_birth => Date.today-365, :home_country_id => 76, :office_country_id=>76, :nationality_id => 76}
  # ])

GradingLevelGroup.create([
  {:grading_level_group_name=>'Default Group',:is_active=>true},
  ])

GradingLevelDetail.create([
    {:grading_level_detail_name   => 'A',:min_score => '90',:grading_level_group_id=>1},
    {:grading_level_detail_name   => 'B',:min_score => '80',:grading_level_group_id=>1},
    {:grading_level_detail_name   => 'C',:min_score => '70',:grading_level_group_id=>1},
    {:grading_level_detail_name   => 'D',:min_score => '60',:grading_level_group_id=>1},
    {:grading_level_detail_name   => 'E',:min_score => '50',:grading_level_group_id=>1},
    {:grading_level_detail_name   => 'F',:min_score => '0',:grading_level_group_id=>1}
    ])
# #user creations
# #User.delete_all
# # User.create([
# # # {:username => 'admin',:password => 'admin123',:first_name => 'Fedena',
# # # :last_name => 'Administrator',:email=> 'admin@fedena.com',:role=> 'Admin'},
   # # {:username => 'EMP1',:password => 'EMP1123',:first_name => 'Unni',
    # # :last_name => 'Koroth',:email=> 'unni@fedena.com',:role=> 'Employee'},
   # # {:username => 'EMP2',:password => 'EMP2123',:first_name => 'Vishwajith',
    # # :last_name => 'A',:email=> 'vishu@fedena.com',:role=> 'Employee'},
   # # {:username => 'EMP3',:password => 'EMP3123',:first_name => 'Aravind',
    # # :last_name => 'GS',:email=> 'aravind@fedena.com',:role=> 'Employee'},
   # # {:username => 'EMP4',:password => 'EMP4123',:first_name => 'Nithin',
    # # :last_name => 'Bekal',:email=> 'nithin@fedena.com',:role=> 'Employee'},
   # # {:username => 'EMP5',:password => 'EMP5123',:first_name => 'Ralu',
    # # :last_name => 'RM',:email=> 'ralu@fedena.com',:role=> 'Employee'},
   # # {:username => '1',:password => '1123',:first_name => 'John',
    # # :last_name => 'Doe',:email=> 'john@fedena.com',:role=> 'Student'},
   # # {:username => '2',:password => '2123',:first_name => 'Samantha',
    # # :last_name => 'Fowler',:email=> 'samantha@fedena.com',:role=> 'Student'}
  # # ])
# 
# # SmsSetting.delete_all
# # SmsSetting.create([
  # # {:settings_key=>"ApplicationEnabled",:is_enabled=>false},
  # # {:settings_key=>"ParentSmsEnabled",:is_enabled=>false},
  # # {:settings_key=>"StudentSmsEnabled",:is_enabled=>false},
  # # {:settings_key=>"StudentAdmissionEnabled",:is_enabled=>false},
  # # {:settings_key=>"ExamScheduleResultEnabled",:is_enabled=>false},
  # # {:settings_key=>"ResultPublishEnabled",:is_enabled=>false},
  # # {:settings_key=>"AttendanceEnabled",:is_enabled=>false},
  # # {:settings_key=>"NewsEventsEnabled",:is_enabled=>false},
  # # {:settings_key=>"EmployeeSmsEnabled",:is_enabled=>false}
  # # ])
