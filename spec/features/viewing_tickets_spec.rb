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

  context "Given the user has been authenticated and has view permission over the project" do
    before do
      sign_in_as! user
      define_permission! user, "view", project

      visit "/"
    end

    context "Viewing tickets for a given project" do
      before { click_link project.name }

      scenario "displays associated tickets" do
        expect(page).to have_content shiny_ticket.title
        expect(page).to have_content dark_ticket.title
      end

      context "viewing a concrete ticket" do
        before { click_link shiny_ticket.title }

        scenario "displays the ticket title" do
          within "#ticket h2" do
            expect(page).to have_content shiny_ticket.title
          end
        end

        scenario "displays the ticket description" do
          expect(page).to have_content shiny_ticket.description
        end
      end
    end
  end
end
