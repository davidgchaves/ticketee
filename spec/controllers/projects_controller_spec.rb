require 'spec_helper'

describe ProjectsController do
  context "A signed in user" do
    let(:user) { FactoryGirl.create :user }
    before { sign_in user }

    context "when attempting to access the show action without permission" do
      let(:project) { FactoryGirl.create :project }
      before { get :show, id: project.id }

      it "gets redirected to the projects root page" do
        expect(response).to redirect_to projects_path
      end

      it "gets alerted that the resource could not be found" do
        expect(flash[:alert]).to eq "The project you were looking for could not be found."
      end
    end

    context "when attempting to access a resource that no longer exists" do
      before { get :show, id: "resource-that-no-longer-exists" }

      it "gets redirected to the projects root page" do
        expect(response).to redirect_to projects_path
      end

      it "gets alerted that the resource could not be found" do
        expect(flash[:alert]).to eq "The project you were looking for could not be found."
      end
    end
  end

  context "A non-admin user" do
    let(:user) { FactoryGirl.create :user }
    {new: :get, create: :post, edit: :get, update: :put, destroy: :delete}.each do |action, method|
      before do
        sign_in user
        send method, action, id: FactoryGirl.create(:project)
      end

      context "when attempting to access the #{action} action" do
        it "gets redirected to the root page" do
          expect(response).to redirect_to root_path
        end

        it "gets alerted that she must be an admin to do that" do
          expect(flash[:alert]).to eq "You must be an admin to do that."
        end
      end
    end
  end
end
