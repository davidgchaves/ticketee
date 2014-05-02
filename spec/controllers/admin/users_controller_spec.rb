require 'spec_helper'

describe Admin::UsersController do
  context "A regular user" do
    let(:user) { FactoryGirl.create :user }
    before { sign_in user }

    it "is not able to access the index action" do
      get "index"
      expect(response).to redirect_to root_path
    end
  end

  context "An admin user" do
    let(:admin_user) { FactoryGirl.create :admin_user }
    before { sign_in admin_user }

    it "is able to access the index action" do
      get "index"
      expect(response).to be_success
    end
  end
end
