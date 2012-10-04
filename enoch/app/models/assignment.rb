class Assignment < ActiveRecord::Base
  before_save :validate
  def validate
    errors.add(:to_be_completed, "cannot be a past date.") if self.to_be_completed < Date.today unless self.to_be_completed.nil?
  end
   def uploaded_file(incoming_file)
        self.attachment_filename = incoming_file[:attachment].original_filename
        self.attachment_content_type = incoming_file[:attachment].content_type
        self.batch_id =  incoming_file[:batch_assignment]
        self.subject_id =  incoming_file[:subject_assignment]
        unless  incoming_file[:assignment][:students].empty?
        @student= ""
         incoming_file[:assignment][:students].each do |b|
           if @student == ""
             @student = @student + b
            else
              @student = @student+","+ b
            end
          end
         end 
        self.student_id = @student 
        self.to_be_completed = incoming_file[:attachment_datebox].to_date.strftime("%d-%m-%Y")
        self.question = "Please Download the attachement for assignment"
        data = incoming_file[:attachment].read
          if self.save
            Dir.mkdir("#{Rails.root}/public/system")unless Dir.exists?("#{Rails.root}/public/system")
            Dir.mkdir("#{Rails.root}/public/system/attachment")unless Dir.exists?("#{Rails.root}/public/system/attachment")
            dir_name = Dir.mkdir("#{Rails.root}/public/system/attachment/#{self.id}")unless Dir.exists?("#{Rails.root}/public/system/attachment/#{self.id}")
            directory = "#{Rails.root}/public/system/attachment/#{self.id}"
            path = File.join(directory, self.attachment_filename)
            File.open(path, "wb") { |f| f.write(data) }
            @error= false
            return @error
          else
            @error= true
            return @error
          end
    end

    def filename=(new_filename)
        write_attribute("filename", sanitize_filename(new_filename))
    end

    private
    def sanitize_filename(filename)
        #get only the filename, not the whole path (from IE)
        just_filename = File.basename(filename)
        #replace all non-alphanumeric, underscore or periods with underscores
        just_filename.gsub(/[^\w\.\-]/, '_')
    end
end
