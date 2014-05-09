require 'spec_helper'

feature "Seed Data" do
  context "Given Rails loads the seed data" do
    before do
      load Rails.root + "db/seeds.rb"
    end

    context "When an admin creates a ticket" do
      let(:admin) do
        admin = User.where(email: "admin@example.com").first!
        admin.password = "password"
        admin
      end
      let!(:project) { Project.where(name: "Ticketee Beta").first! }

      before do
        sign_in_as! admin
        click_link project.name
        click_link "New Ticket"
        fill_in "Title", with: "Comments with state"
        fill_in "Description", with: "Comments always have a state."
        click_button "Create Ticket"
      end

      scenario "Then she sees the seeded comment's states" do
        expect(page).to have_content "New"
        expect(page).to have_content "Open"
        expect(page).to have_content "Closed"
      end
    end
  end
end
