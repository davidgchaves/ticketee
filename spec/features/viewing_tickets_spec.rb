require 'spec_helper'

feature "Viewing Tickets" do
  let(:user) { FactoryGirl.create :user }
  let!(:project) { FactoryGirl.create :project, name: "Vim" }
  let!(:ticket) do
    ticket = FactoryGirl.create :ticket, project: project, title: "Make it shiny!", description: "Gradients! Starbursts! Oh my!"
    ticket.update user: user
    ticket
  end

  before do
    visit '/'
  end

  scenario "Viewing tickets for a given project" do
    click_link project.name

    expect(page).to have_content ticket.title

    click_link ticket.title
    within "#ticket h2" do
      expect(page).to have_content ticket.title
    end

    expect(page).to have_content ticket.description
  end
end
