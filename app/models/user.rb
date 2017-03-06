class User < ApplicationRecord
  has_secure_password

  has_many :user_files, :foreign_key => :user_id ,dependent: :destroy

  validates :name, :email, :password_digest, presence: true
  validates :name, :email, uniqueness: true

  before_create :generate_token, :update_login_time, :init
  before_update :update_login_time

  def generate_token
    loop do
      self.token= SecureRandom.base64 64
      break if User.find_by_token(token).nil?
    end
  end

  def update_login_time
    self.last_login_time= Time.now
  end

  private

  def init
    self.used_storage= 0
  end

end
