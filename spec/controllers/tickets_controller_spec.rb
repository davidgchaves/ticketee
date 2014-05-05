require 'spec_helper'

describe TicketsController do
  let(:user) { FactoryGirl.create :user }
  let(:project) { FactoryGirl.create :project }
  let(:ticket) { FactoryGirl.create :ticket, project: project, user: user }

  context "When a signed-in standard user" do
    before { sign_in user }

    context "with no permission to view a project" do

      context "tries to get access to a ticket associated with that project" do
        before { get :show, id: ticket.id, project_id: project.id }

        it "gets redirected to the root path" do
          expect(response).to redirect_to root_path
        end

        it "gets a message stating the project could not be found" do
          expect(flash[:alert]).to eq "The project you were looking for could not be found."
        end
      end
    end

    context "with permission to view the project but without permission to create tickets" do
      before { define_permission! user, "view", project }

      context "tries to create a ticket accessing the #new controller action" do
        before { get :new, project_id: project.id }

        it "gets redirected to the project root page" do
          expect(response).to redirect_to project
        end

        it "gets a message stating you can't create tickets for this project" do
          expect(flash[:alert]).to eq "You cannot create tickets on this project."
        end
      end

      context "tries to create a ticket accessing the #create controller action" do
        before { post :create, project_id: project.id }

        it "gets redirected to the project root page" do
          expect(response).to redirect_to project
        end

        it "gets a message stating you can't create tickets for this project" do
          expect(flash[:alert]).to eq "You cannot create tickets on this project."
        end
      end
    end

    context "with permission to view the project but without permission to edit tickets" do
      before { define_permission! user, "view", project }

      context "tries to edit a ticket accessing the #edit controller action" do
        before { get :edit, project_id: project.id, id: ticket.id }

        it "gets redirected to the project root page" do
          expect(response).to redirect_to project
        end

        it "gets a message stating you can't edit tickets for this project" do
          expect(flash[:alert]).to eq "You cannot edit tickets on this project."
        end
      end

      context "tries to update a ticket accessing the #update controller action" do
        before { put :update, project_id: project.id, id: ticket.id, ticket: {} }

        it "gets redirected to the project root page" do
          expect(response).to redirect_to project
        end

        it "gets a message stating you can't edit tickets for this project" do
          expect(flash[:alert]).to eq "You cannot edit tickets on this project."
        end
      end
    end
  end
end
