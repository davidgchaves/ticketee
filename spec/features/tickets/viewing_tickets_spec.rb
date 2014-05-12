require 'spec_helper'

feature "Viewing Tickets" do
  let(:user) { FactoryGirl.create :user }
  let!(:project) { FactoryGirl.create :project, name: "Vim" }
  let!(:shiny_ticket) do
    ticket = FactoryGirl.create :ticket, project: project, title: "Make it shiny!", description: "Gradients! Starbursts! Oh my!"
    ticket.update user: user
    ticket
  end
  let!(:dark_ticket) do
    ticket = FactoryGirl.create :ticket, project: project, title: "Make it dark!", description: "Welcome to the darkside"
    ticket.update user: user
    ticket
  end

  context "Given a signed in user with 'view project' permission" do
    before do
      sign_in_as! user
      define_permission! user, "view project", project
    end

    context "When she navigates to the project page" do
      before do
        visit "/"
        click_link project.name
    end

      scenario "Then she can see the associated tickets" do
        expect(page).to have_content shiny_ticket.title
        expect(page).to have_content dark_ticket.title
      end

      context "When she navigates to a concrete ticket" do
        before { click_link shiny_ticket.title }

        scenario "Then she can see the ticket's title" do
          within "#ticket h2" do
            expect(page).to have_content shiny_ticket.title
          end
        end

        scenario "Then she can see the ticket's description" do
          expect(page).to have_content shiny_ticket.description
        end
      end
    end
  end
end
