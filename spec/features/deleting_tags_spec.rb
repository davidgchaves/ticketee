require 'spec_helper'

feature "Deleting Tags" do
  let(:user) { FactoryGirl.create :user }
  let(:project) { FactoryGirl.create :project }
  let!(:ticket) { FactoryGirl.create :ticket, project: project, tag_names: "this-tag-must-die", user: user }

  context "Given a signed in user with 'view project' and 'tag' permissions" do
    before do
      sign_in_as! user
      define_permission! user, "view project", project
      define_permission! user, "tag", project
    end

    context "When she deletes a tag" do
      before do
        visit "/"
        click_link project.name
        click_link ticket.title
        click_link "delete-this-tag-must-die"
      end

      scenario "succeeds", js: true do
        expect(page).to_not have_content "this-tag-must-die"
      end
    end
  end
end
