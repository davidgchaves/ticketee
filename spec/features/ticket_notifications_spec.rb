require 'spec_helper'

feature "Ticket Notifications" do
  let!(:bob) { FactoryGirl.create :user, email: "bob@example.com" }
  let!(:ana) { FactoryGirl.create :user, email: "ana@example.com" }
  let!(:project) { FactoryGirl.create :project }

  before do
    ActionMailer::Base.deliveries.clear
    define_permission! ana, "view project", project
    define_permission! bob, "view project", project
  end

  context "Given Ana created a ticket in a project" do
    let!(:ticket) { FactoryGirl.create :ticket, project: project, user: ana }

    scenario "Then Ana is subscribed as a ticket watcher" do
      expect(ticket.watchers).to include ana
    end

    context "When Bob creates a comment in Ana's ticket" do
      before { bob_creates_a_comment }

      scenario "Then Ana receives an email notification with a link to the ticket" do
        ana_email = find_email! ana.email
        email_subject = "[ticketee] #{project.name} - #{ticket.title}"

        expect(ana_email.subject).to include email_subject

        click_first_link_in_email ana_email
        within "#ticket h2" do
          expect(page).to have_content ticket.title
        end
      end

      scenario "Then Bob is subscribed as a ticket watcher" do
        click_link "Sign out"
        reset_mailer
        ana_creates_a_comment

        expect { find_email! bob.email }.to_not raise_error
        expect { find_email! ana.email }.to raise_error
      end
    end
  end

  def bob_creates_a_comment
    comment_creation_helper bob, "Is it out yet?"
  end

  def ana_creates_a_comment
    comment_creation_helper ana, "Not yet!"
  end

  def comment_creation_helper(user, comment_text)
    sign_in_as! user
    visit "/"
    click_link project.name
    click_link ticket.title
    fill_in "Text", with: comment_text
    click_button "Create Comment"
  end
end
