require 'spec_helper'

feature "Searching" do
  let(:user) { FactoryGirl.create :user }
  let(:project) { FactoryGirl.create :project }
  let!(:ticket1) do
    new_state = State.create name: "New"
    FactoryGirl.create :ticket, title: "Ticket1", project: project, user: user,
                                tag_names: "I1", state: new_state
  end

  let!(:ticket2) do
    open_state = State.create name: "Open"
    FactoryGirl.create :ticket, title: "Ticket2", project: project, user: user,
                                tag_names: "I2", state: open_state
  end

  let!(:ticket3) do
    open_state = State.create name: "Open"
    FactoryGirl.create :ticket, title: "Ticket3", project: project, user: user,
                                tag_names: "I2", state: open_state
  end

  context "Given a signed in user with 'view project' and 'tag' permissions" do
    before do
      sign_in_as! user
      define_permission! user, "view project", project
      define_permission! user, "tag", project
    end

    context "When she searches for tickets by tag" do
      before do
        visit "/"
        click_link project.name
        fill_in "Search", with: "tag:I1"
        click_button "Search"
      end

      scenario "she finds them" do
        within "#tickets" do
          expect(page).to have_content ticket1.title
          expect(page).to_not have_content ticket2.title
          expect(page).to_not have_content ticket3.title
        end
      end
    end

    context "When she searches for tickets by state" do
      before do
        visit "/"
        click_link project.name
        fill_in "Search", with: "state:Open"
        click_button "Search"
      end

      scenario "she finds them" do
        within "#tickets" do
          expect(page).to_not have_content ticket1.title
          expect(page).to have_content ticket2.title
          expect(page).to have_content ticket3.title
        end
      end
    end

    context "When she searches for tickets matching the clicked tag" do
      before do
        visit "/"
        click_link project.name
        click_link ticket2.title
        click_link ticket2.tag_names
      end

      scenario "she finds them" do
        within "#tickets" do
          expect(page).to_not have_content ticket1.title
          expect(page).to have_content ticket2.title
          expect(page).to have_content ticket3.title
        end
      end
    end
  end
end
