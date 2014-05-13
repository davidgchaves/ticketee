require 'spec_helper'

describe TicketsController do
  let(:user) { FactoryGirl.create :user }
  let(:project) { FactoryGirl.create :project }
  let(:ticket) { FactoryGirl.create :ticket, project: project, user: user }

  context "When a signed in user with no 'view project' permission" do
    before { sign_in user }

    context "accesses #show" do
      before { get :show, id: ticket.id, project_id: project.id }

      it "gets redirected to the root page" do
        expect(response).to redirect_to root_path
      end

      it "gets the message 'the project could not be found'" do
        expect(flash[:alert]).to eq "The project you were looking for could not be found."
      end
    end
  end

  context "When a signed in user with only 'view project' permission" do
    before do
      sign_in user
      define_permission! user, "view project", project
    end

    context "accesses #new" do
      before { get :new, project_id: project.id }

      it "gets redirected to the projects#show" do
        expect(response).to redirect_to project
      end

      it "gets the message 'you can't create tickets for this project'" do
        expect(flash[:alert]).to eq "You cannot create tickets on this project."
      end
    end

    context "accesses #create" do
      before { post :create, project_id: project.id }

      it "gets redirected to the projects#show" do
        expect(response).to redirect_to project
      end

      it "gets the message 'you can't create tickets for this project'" do
        expect(flash[:alert]).to eq "You cannot create tickets on this project."
      end
    end

    context "accesses #edit" do
      before { get :edit, project_id: project.id, id: ticket.id }

      it "gets redirected to the projects#show" do
        expect(response).to redirect_to project
      end

      it "gets the message 'you can't edit tickets for this project'" do
        expect(flash[:alert]).to eq "You cannot edit tickets on this project."
      end
    end

    context "accesses #update" do
      before { put :update, project_id: project.id, id: ticket.id, ticket: {} }

      it "gets redirected to the projects#show" do
        expect(response).to redirect_to project
      end

      it "gets the message 'you can't edit tickets for this project'" do
        expect(flash[:alert]).to eq "You cannot edit tickets on this project."
      end
    end

    context "accesses #destroy" do
      before { delete :destroy, project_id: project.id, id: ticket.id }

      it "gets redirected to the projects#show" do
        expect(response).to redirect_to project
      end

      it "gets the message 'you can't delete tickets for this project'" do
        expect(flash[:alert]).to eq "You cannot delete tickets on this project."
      end
    end
  end

  context "Given a signed in user with 'view project' and 'create tickets' but without 'tag' permissions" do
    before do
      sign_in user
      define_permission! user, "view project", project
      Permission.create user: user, thing: project, action: "create tickets"
    end

    context "When she tries to tag a ticket" do
      before do
        post :create, { ticket: { title: "Tag!", description: "Brand sparkin' new!", tag_names: "one two" },
                        project_id: project.id }
      end

      it "gets a ticket with empty tags" do
        expect(Ticket.last.tags).to be_empty
      end
    end
  end
end
