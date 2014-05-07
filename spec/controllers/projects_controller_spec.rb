require 'spec_helper'

describe ProjectsController do
  context "When a signed in user" do
    let(:user) { FactoryGirl.create :user }
    before { sign_in user }

    context "accesses #show without 'view' (project) permission" do
      let(:project) { FactoryGirl.create :project }
      before { get :show, id: project.id }

      it "gets redirected to projects#index" do
        expect(response).to redirect_to projects_path
      end

      it "gets the message 'the project could not be found'" do
        expect(flash[:alert]).to eq "The project you were looking for could not be found."
      end
    end

    context "requires a missing project" do
      before { get :show, id: "missing-project" }

      it "gets redirected to projects#index" do
        expect(response).to redirect_to projects_path
      end

      it "gets the message 'the project could not be found'" do
        expect(flash[:alert]).to eq "The project you were looking for could not be found."
      end
    end

    {new: :get, create: :post, edit: :get, update: :put, destroy: :delete}.each do |action, method|
      before do
        send method, action, id: FactoryGirl.create(:project)
      end

      context "accesses ##{action}" do
        it "gets redirected to the root page" do
          expect(response).to redirect_to root_path
        end

        it "gets the message 'you must be an admin'" do
          expect(flash[:alert]).to eq "You must be an admin to do that."
        end
      end
    end
  end
end
