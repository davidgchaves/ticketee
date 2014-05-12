require 'spec_helper'

feature "Creating Comments" do
  let!(:user) { FactoryGirl.create :user }
  let!(:project) { FactoryGirl.create :project }
  let!(:ticket) { FactoryGirl.create :ticket, project: project, user: user }

  context "Given a user with 'view project' permission" do
    before do
      define_permission! user, "view project", project
      FactoryGirl.create :state, name: "Open"
      sign_in_as! user
    end

    context "When she adds a comment to a ticket" do
      before do
        visit "/"
        click_link project.name
        click_link ticket.title

        fill_in "Text", with: "Added a comment!"
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

    context "When she adds a tag to a ticket" do
      before do
        visit "/"
        click_link project.name
        click_link ticket.title
      end

      scenario "checks if the tag already exists" do
        within "#ticket #tags" do
          expect(page).to_not have_content "bug"
        end
      end

      context "if the tag isn't associated to the ticket" do
        before do
          fill_in "Text", with: "Adding the bug tag"
          fill_in "Tags", with: "bug"
          click_button "Create Comment"
        end

        scenario "creates the ticket" do
          expect(page).to have_content "Comment has been created."
        end

        scenario "adds the tag" do
          within "#ticket #tags" do
            expect(page).to have_content "bug"
          end
        end
      end
    end
  end

  context "Given a user with 'view project' and 'change states' permissions" do
    before do
      define_permission! user, "view project", project
      define_permission! user, "change states", project
      FactoryGirl.create :state, name: "Open"
      sign_in_as! user
    end

    context "When she changes the comment status" do
      before do
        visit "/"
        click_link project.name
        click_link ticket.title

        fill_in "Text", with: "Added a comment!"
        select "Open", from: "State"
        click_button "Create Comment"
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
  end

  context "Given a user with no 'change states' permission" do
    before do
      define_permission! user, "view project", project
      FactoryGirl.create :state, name: "Open"
      sign_in_as! user
    end

    scenario "Then she can't change the state" do
      visit "/"
      click_link project.name
      click_link ticket.title

      expect { find "#comment_state_id" }.to raise_error Capybara::ElementNotFound
    end
  end
end
