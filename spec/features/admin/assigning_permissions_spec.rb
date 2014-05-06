require 'spec_helper'

feature "Assigning Permissions" do
  let!(:admin) { FactoryGirl.create :admin_user }
  let!(:user) { FactoryGirl.create :user }
  let!(:project) { FactoryGirl.create :project }
  let!(:ticket) { FactoryGirl.create :ticket, project: project, user: user }

  context "Given an admin grants a user 'view' (project) permission" do
    before do
      sign_in_as! admin
      navigate_to_permissions_for_user_screen user

      check_permission_box "view", project

      click_button "Update"
      click_link "Sign out"
    end

    context "When the user signs in" do
      before { sign_in_as! user }

      scenario "Then she can view the project listed" do
        expect(page).to have_content project.name
      end
    end
  end

  context "Given an admin grants a user 'view' (project) and 'create tickets' permissions" do
    before do
      sign_in_as! admin
      navigate_to_permissions_for_user_screen user

      check_permission_box "view", project
      check_permission_box "create_tickets", project

      click_button "Update"
      click_link "Sign out"
    end

    context "When the user signs in" do
      before { sign_in_as! user }

      scenario "Then she can create tickets for that project" do
        click_link project.name
        click_link "New Ticket"
        fill_in "Title", with: "Shiny!"
        fill_in "Description", with: "Make it so!"
        click_button "Create"

        expect(page).to have_content "Ticket has been created."
      end
    end
  end

  context "Given an admin grants a user 'view' (project) and 'edit tickets' permissions" do
    before do
      sign_in_as! admin
      navigate_to_permissions_for_user_screen user

      check_permission_box "view", project
      check_permission_box "edit_tickets", project

      click_button "Update"
      click_link "Sign out"
    end

    context "When the user signs in" do
      before { sign_in_as! user }

      scenario "Then she can update tickets for that project" do
        click_link project.name
        click_link ticket.title
        click_link "Edit Ticket"
        fill_in "Title", with: "Really shiny!"
        click_button "Update Ticket"

        expect(page).to have_content "Ticket has been updated."
      end
    end
  end

  context "Given an admin grants a user 'view' (project) and 'delete tickets' permissions" do
    before do
      sign_in_as! admin
      navigate_to_permissions_for_user_screen user

      check_permission_box "view", project
      check_permission_box "delete_tickets", project

      click_button "Update"
      click_link "Sign out"
    end

    context "When the user signs in" do
      before { sign_in_as! user }

      scenario "Then she can delete tickets for that project" do
        click_link project.name
        click_link ticket.title
        click_link "Delete Ticket"

        expect(page).to have_content "Ticket has been deleted."
      end
    end
  end

  private

    def navigate_to_permissions_for_user_screen(user)
      click_link "Admin"
      click_link "Users"
      click_link user.email
      click_link "Permissions"
    end
end
