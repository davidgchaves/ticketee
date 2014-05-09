require "spec_helper"

feature "Creating States" do
  context "Given an admin" do
    before { sign_in_as! FactoryGirl.create :admin_user }

    context "When she creates a state" do
      before do
        navigate_to_new_state_form
        fill_in "Name", with: "Duplicate"
        click_button "Create State"
      end

      scenario "succeeds" do
        expect(page).to have_content "State has been created."
      end
    end

    context "When she creates a blank state" do
      before do
        navigate_to_new_state_form
        click_button "Create State"
      end

      scenario "fails" do
        expect(page).to have_content "State has not been created."
      end
    end
  end

  def navigate_to_new_state_form
    click_link "Admin"
    click_link "States"
    click_link "New State"
  end
end
