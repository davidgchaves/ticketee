require 'spec_helper'

feature "Managing States" do
  before { load Rails.root + "db/seeds.rb" }

  context "Given an admin" do
    before { sign_in_as! FactoryGirl.create :admin_user }

    context "When she marks a state as default" do
      before do
        visit "/"
        click_link "Admin"
        click_link "States"
        within state_line_for("New") do
          click_link "Make Default"
        end
      end

      scenario "suceeds" do
        expect(page).to have_content "New is now the default state."
      end
    end
  end
end
