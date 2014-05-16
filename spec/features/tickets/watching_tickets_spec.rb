require 'spec_helper'

feature "Watching Tickets" do
  let(:user) { FactoryGirl.create :user }
  let(:project) { FactoryGirl.create :project }

  before do
    define_permission! user, "view project", project
    sign_in_as! user
  end

  context "Given a user created a ticket" do
    let!(:ticket) { FactoryGirl.create :ticket, user: user, project: project }

    before do
      visit "/"
      click_link project.name
      click_link ticket.title
    end

    scenario "Then she can see her email in the watchers list" do
      within "#watchers" do
        expect(page).to have_content user.email
      end
    end

    context "When she clicks the 'Stop watching this ticket' button" do
      before { click_button "Stop watching this ticket" }

      scenario "Then she gets the message 'You are no longer watching this ticket'" do
        expect(page).to have_content "You are no longer watching this ticket."
      end

      scenario "Then she no longer can see her email in the watchers list" do
        within "#watchers" do
          expect(page).to_not have_content user.email
        end
      end
    end
  end
end
