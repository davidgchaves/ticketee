require 'spec_helper'

feature "Creating Comments" do
  context "Given a user with 'view' (project) permission" do
    let!(:user) { FactoryGirl.create :user }
    let!(:project) { FactoryGirl.create :project }
    let!(:ticket) { FactoryGirl.create :ticket, project: project, user: user }

    before do
      define_permission! user, "view", project
      FactoryGirl.create :state, name: "Open"
      sign_in_as! user
    end

    context "When she adds a comment to a ticket" do
      before do
        visit "/"
        click_link project.name
        click_link ticket.title

        fill_in "Text", with: "Added a comment!"
        select "Open", from: "State"
        click_button "Create Comment"
      end

      scenario "succeeds" do
        expect(page).to have_content "Comment has been created."
      end

      scenario "can see the comment" do
        within "#comments" do
          expect(page).to have_content "Added a comment!"
        end
      end

      scenario "can see the new comment status" do
        within "#ticket .states .state_open" do
          expect(page).to have_content "Open"
        end
      end

       scenario "can see the change in the ticket status" do
         within "#comments" do
           expect(page).to have_content "State: Open"
         end
       end
    end

    context "When she adds a blank comment to a ticket" do
      before do
        visit "/"
        click_link project.name
        click_link ticket.title

        click_button "Create Comment"
      end

      scenario "fails" do
        expect(page).to have_content "Comment has not been created."
      end

      scenario "gets the message 'Text can't be blank'" do
        expect(page).to have_content "Text can't be blank"
      end
    end
  end
end
