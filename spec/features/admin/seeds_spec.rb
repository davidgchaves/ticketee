require 'spec_helper'

feature "Seed Data" do
  context "Running 'seeds.rb'" do
    before { load Rails.root + "db/seeds.rb" }

    scenario "creates an admin user and a project" do
      User.where(email: "admin@example.com").first!
      Project.where(name: "Ticketee Beta").first!
    end
  end
end
