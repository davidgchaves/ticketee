require 'spec_helper'

feature "Creating Tickets" do
  let(:project) { FactoryGirl.create :project }
  let(:user) { FactoryGirl.create :user }

  context "Given a user with 'view project' and 'create tickets' permissions" do
    before do
      sign_in_as! user
      define_permission! user, "view project", project
      define_permission! user, "create tickets", project

      visit "/"
      click_link project.name
      click_link "New Ticket"
    end

    context "When she creates a ticket with valid attributes" do
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

    context "When she creates a ticket with blank attributes" do
      before do
        click_button "Create Ticket"
      end

      scenario "fails" do
        expect(page).to have_content "Ticket has not been created."
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Description can't be blank"
      end
    end

    context "When she creates a ticket with two attachments", js: true do
      before do
        fill_in "Title", with: "Add documentation for blink tag"
        fill_in "Description", with: "The blink tag has a speed attribute"

        attach_file "File #1", Rails.root.join("spec/fixtures/speed.txt")
        click_link "Add another file"

        attach_file "File #2", Rails.root.join("spec/fixtures/spin.txt")
        click_button "Create Ticket"
      end

      scenario "succeeds" do
        expect(page).to have_content "Ticket has been created."
      end

      scenario "can see the attachments" do
        within "#ticket .assets" do
          expect(page).to have_content "speed.txt"
          expect(page).to have_content "spin.txt"
        end
      end
    end
  end
end
