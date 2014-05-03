class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :email

  def to_s
    "#{email} (#{admin? ? "Admin" : "User"})"
  end
end
