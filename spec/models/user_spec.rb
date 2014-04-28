require 'spec_helper'

describe User do
  describe "'has_secure_password' built-in functionality" do
    it "saves the user when password and password_confirmation match" do
      user = User.new name: "David", password: "pw", password_confirmation: "pw"
      user.save
      expect(user).to be_valid
    end

    it "saves the user without a password confirmation" do
      user_with_no_password_confirmation = User.new name: "David", password: "pw"
      user_with_no_password_confirmation.save
      expect(user_with_no_password_confirmation).to be_valid
    end

    it "does not save the user without a password" do
      user_with_no_password = User.new name: "David"
      user_with_no_password.save
      expect(user_with_no_password).to_not be_valid
    end

    it "does not save the user when password and password_confirmation don't match" do
      user_with_wrong_password_confirmation = User.new name: "David", password: "pw", password_confirmation: "boo"
      user_with_wrong_password_confirmation.save
      expect(user_with_wrong_password_confirmation).to_not be_valid
    end

    it "authenticates with a correct password" do
      user = User.create name: "David", password: "pw", password_confirmation: "pw"
      expect(user.authenticate "pw").to be
    end

    it "does not authenticate with an incorrect password" do
      user = User.create name: "David", password: "pw", password_confirmation: "pw"
      expect(user.authenticate "pw1").to_not be
    end
  end
end
