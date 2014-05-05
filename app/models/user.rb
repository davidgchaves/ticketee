class User < ActiveRecord::Base
  has_secure_password
  has_many :permissions

  validates_presence_of :email

  def to_s
    "#{email} (#{admin? ? "Admin" : "User"})"
  end
end
