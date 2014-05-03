require 'spec_helper'

feature "Creating Tickets" do
  let(:project) { FactoryGirl.create :project }
  let(:user) { FactoryGirl.create :user }

  context "Given the user has been authenticated and has view permission over the project" do
    before do
      define_permission! user, "view", project
      sign_in_as! user

      click_link project.name
      click_link "New Ticket"
    end

    context "Creating a ticket with valid attributes" do
      before do
        fill_in "Title", with: "Non-standards compliance"
        fill_in "Description", with: "My pages are ugly!"
        click_button "Create Ticket"
      end

      scenario "succeeds" do
        expect(page).to have_content "Ticket has been created."
      end

      scenario "links the ticket with the user who created it" do
        within "#ticket #author" do
          expect(page).to have_content "Created by #{user.email}"
        end
      end
    end

    context "Creating a ticket with blank attributes" do
      before do
        click_button "Create Ticket"
      end

      scenario "fails" do
        expect(page).to have_content "Ticket has not been created."
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Description can't be blank"
      end
    end
  end
end
