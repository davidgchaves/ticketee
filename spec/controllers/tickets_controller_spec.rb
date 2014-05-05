require 'spec_helper'

describe TicketsController do
  let(:user) { FactoryGirl.create :user }
  let(:project) { FactoryGirl.create :project }
  let(:ticket) { FactoryGirl.create :ticket, project: project, user: user }

  context "When a signed-in standard user tries to gain access to a ticket for a project who has no permission to view" do
    before do
      sign_in user
      get :show, id: ticket.id, project_id: project.id
    end

    it "gets redirected to the root path" do
      expect(response).to redirect_to root_path
    end

    it "gets a message stating the project could not be found" do
      expect(flash[:alert]).to eq "The project you were looking for could not be found."
    end
  end
end
