class User < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
    has_secure_password
  after_destroy :ensure_an_admin_remains
  has_attached_file :photo, :styles => { :small => "150x150>" }
  # validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  before_save :create_user
  has_many :albums ,:dependent => :destroy
  accepts_nested_attributes_for :albums
  attr_accessible :name, :oauth_expires_at, :oauth_token, :provider, :uid,:password, :password_confirmation, :photo
  def create_user
    self.password_digest = Digest::SHA1.hexdigest(self.password) unless self.password.nil?
  end

  class << self
    def authenticate?(name, password)
      user = User.find_by_name name
      (user && user.password_digest == Digest::SHA1.hexdigest(password)) ? user : nil
    end

    def from_omniauth(auth)
      where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.name = auth.info.name
        user.oauth_token = auth.credentials.token
        user.oauth_expires_at = Time.at(auth.credentials.expires_at)
        user.password_digest ='nil'
        user.save!
      end
    end
  end

  private

  def ensure_an_admin_remains
    if User.count.zero?
      raise "Can't delete last user"
    end
  end
end
