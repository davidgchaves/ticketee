require 'spec_helper'

feature "Editing Tickets" do
  let!(:project) { FactoryGirl.create :project }
  let!(:user) { FactoryGirl.create :user }
  let!(:ticket) do
    ticket = FactoryGirl.create :ticket, project: project
    ticket.update user: user
    ticket
  end

  context "Given the user has been authenticated and has view permission over the project" do
    before do
      sign_in_as! user
      define_permission! user, "view", project

      visit "/"
      click_link project.name
      click_link ticket.title
      click_link "Edit Ticket"
    end

    context "Updating a ticket with valid info" do
      before do
        fill_in "Title", with: "Make it really shiny!"
        click_button "Update Ticket"
      end

      scenario "succeeds" do
        expect(page).to have_content "Ticket has been updated."
      end

      scenario "displays the updated content" do
        within "#ticket h2" do
          expect(page).to have_content "Make it really shiny!"
        end
      end

      scenario "doesn't display the old content" do
        expect(page).to_not have_content ticket.title
      end
    end

    context "Updating a ticket with invalid info" do
      before do
        fill_in "Title", with: ""
        click_button "Update Ticket"
      end

      scenario "fails" do
        expect(page).to have_content "Ticket has not been updated."
      end
    end
  end
end
