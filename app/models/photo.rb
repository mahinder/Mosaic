class Photo < ActiveRecord::Base
  belongs_to :album
  has_attached_file :album_photo, :styles => { :small => "150x150>" }
  validates_attachment_presence :album_photo
  validates_attachment_size :album_photo, :less_than => 5.megabytes
  validates_attachment_content_type :album_photo, :content_type => ['image/jpeg', 'image/png']
  attr_writer :tag_names
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings
  after_save :assign_tags
  attr_accessible :album_photo, :tag_names
  def tag_names
    @tag_names || tags.map(&:name).join(' ')
  end
  
  private
  
  def assign_tags
    if @tag_names
      self.tags = @tag_names.split(',').map do |name|
        Tag.find_or_create_by_name(name)
      end
    end
  end
end
