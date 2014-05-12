require 'spec_helper'

feature "Hidden Links" do
  let(:project) { FactoryGirl.create :project }
  let(:user) { FactoryGirl.create :user }
  let(:ticket) { FactoryGirl.create :ticket, project: project, user: user }

  context "Given an anonymous user" do
    context "When visiting the root page" do
      before { visit "/" }

      scenario "cannot see the 'New Project' link" do
        expect(page).to_not have_link "New Project"
      end
    end

    context "When visiting a project page" do
      before { visit project_path project }

      scenario "cannot see the 'Edit Project' link" do
        expect(page).to_not have_link "Edit Project"
      end

      scenario "cannot see the 'Delete Project' link" do
        expect(page).to_not have_link "Delete Project"
      end
    end
  end

  context "Given a regular user has been authenticated" do
    before { sign_in_as! user }

    context "and has no permissions over a project" do

      context "When visiting the root page" do
        before { visit "/" }

        scenario "cannot see the 'New Project' link" do
          expect(page).to_not have_link "New Project"
        end
      end

      context "When visiting the project page" do
        before { visit project_path project }

        scenario "cannot see the 'Edit Project' link" do
          expect(page).to_not have_link "Edit Project"
        end

        scenario "cannot see the 'Delete Project' link" do
          expect(page).to_not have_link "Delete Project"
        end
      end
    end

    context "and has 'view project' and 'create tickets' permissions" do
      before do
        define_permission! user, "view project", project
        define_permission! user, "create tickets", project
      end

      context "When visiting the project page" do
        before { visit project_path(project) }

        scenario "can see the 'New Ticket' link" do
          expect(page).to have_link "New Ticket"
        end
      end
    end

    context "and has 'view project' and 'edit tickets' permissions" do
      before do
        define_permission! user, "view project", project
        define_permission! user, "edit tickets", project
      end

      context "When visiting the project page and clicking on the ticket" do
        before do
          ticket
          visit project_path(project)
          click_link ticket.title
        end

        scenario "can see the 'Edit Ticket' link" do
          expect(page).to have_link "Edit Ticket"
        end
      end
    end

    context "and has 'view project' and 'delete tickets' permissions" do
      before do
        define_permission! user, "view project", project
        define_permission! user, "delete tickets", project
      end

      context "When visiting the project page and clicking on the ticket" do
        before do
          ticket
          visit project_path(project)
          click_link ticket.title
        end

        scenario "can see the 'Delete Ticket' link" do
          expect(page).to have_link "Delete Ticket"
        end
      end
    end

    context "and only has 'view project' permission" do
      before { define_permission! user, "view project", project }

      context "When visiting the project page" do
        before { visit project_path(project) }

        scenario "cannot see the 'New Ticket' link" do
          expect(page).to_not have_link "New Ticket"
        end
      end

      context "When visiting the project page and clicking on a ticket" do
        before do
          ticket
          visit project_path(project)
          click_link ticket.title
        end

        scenario "cannot see the 'Edit Ticket' link" do
          expect(page).to_not have_link "Edit Ticket"
        end

        scenario "cannot see the 'Delete Ticket' link" do
          expect(page).to_not have_link "Delete Ticket"
        end
      end
    end
  end

  context "Given an admin user has been authenticated" do
    let(:admin_user) { FactoryGirl.create :admin_user }
    before { sign_in_as! admin_user }

    context "When visiting the root page" do
      before { visit "/" }

      scenario "can see the 'New Project' link" do
        expect(page).to have_link "New Project"
      end
    end

    context "When visiting a project page" do
      before { visit project_path(project) }

      scenario "can see the 'Edit Project' link" do
        expect(page).to have_link "Edit Project"
      end

      scenario "can see the 'Delete Project' link" do
        expect(page).to have_link "Delete Project"
      end

      scenario "can see the 'New Ticket' link" do
        expect(page).to have_link "New Ticket"
      end
    end

    context "When visiting a project page and clicking on a ticket" do
      before do
        ticket
        visit project_path(project)
        click_link ticket.title
      end

      scenario "can see the 'Edit Ticket' link" do
        expect(page).to have_link "Edit Ticket"
      end

      scenario "can see the 'Delete Ticket' link" do
        expect(page).to have_link "Delete Ticket"
      end
    end
  end
end
