require 'spec_helper'

feature "Ticket Notifications" do
  let!(:bob) { FactoryGirl.create :user, email: "bob@example.com" }
  let!(:ana) { FactoryGirl.create :user, email: "ana@example.com" }
  let!(:project) { FactoryGirl.create :project }
  let!(:ticket) { FactoryGirl.create :ticket, project: project, user: ana }

  before { ActionMailer::Base.deliveries.clear }

  context "Given Ana created a ticket in a project" do
    before { define_permission! ana, "view project", project }

    context "And given Bob has permission to 'view' that project" do
      before do
        sign_in_as! bob
        define_permission! bob, "view project", project
      end

      context "When he creates a comment in Ana's ticket" do
        before do
          visit "/"
          click_link project.name
          click_link ticket.title
          fill_in "Text", with: "Is it out yet?"
          click_button "Create Comment"
        end

        scenario "Then she receives an email notification with a link to the ticket" do
          ana_email = find_email! ana.email
          email_subject = "[ticketee] #{project.name} - #{ticket.title}"

          expect(ana_email.subject).to include email_subject

          click_first_link_in_email ana_email
          within "#ticket h2" do
            expect(page).to have_content ticket.title
          end
        end
      end
    end
  end
end
