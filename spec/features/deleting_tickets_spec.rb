require 'spec_helper'

feature "Deleting Tickets" do
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

      visit '/'
      click_link project.name
      click_link ticket.title
    end

    context "Deleting a ticket" do
      before do
        click_link "Delete Ticket"
      end

      scenario "succeeds" do
        expect(page).to have_content "Ticket has been deleted."
      end

      scenario "redirects to the project root url" do
        expect(page.current_url).to eq project_url(project)
      end
    end
  end
end
