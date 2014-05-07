require 'spec_helper'

describe FilesController do
  let(:good_user) { FactoryGirl.create :user }
  let(:bad_user) { FactoryGirl.create :user }
  let(:project) { FactoryGirl.create :project }
  let(:ticket) { FactoryGirl.create :ticket, project: project, user: good_user }
  let(:path) { Rails.root + "spec/fixtures/speed.txt" }
  let(:asset) { ticket.assets.create asset: File.open(path) }

  context "When a signed in user with 'view' (project) permission" do
    before do
      sign_in good_user
      good_user.permissions.create! action: "view", thing: project
    end

    context "requests a project's asset" do
      before { get :show, id: asset.id }

      it "succeeds" do
        expect(response.body).to eq File.read(path)
      end
    end
  end

  context "When a signed in user with no 'view' (project) permission" do
    before { sign_in bad_user }

    context "requests a project's asset" do
      before { get :show, id: asset.id }

      it "gets redirected to the root page" do
        expect(response).to redirect_to root_path
      end

      it "gets the message 'the asset could not be found'" do
        expect(flash[:alert]).to eq "The asset you were looking for could not be found."
      end
    end
  end
end
