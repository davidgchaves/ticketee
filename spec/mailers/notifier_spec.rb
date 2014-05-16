require 'spec_helper'

describe Notifier do
  context "#comment_updated" do
    let!(:project) { FactoryGirl.create :project }
    let!(:ticket_owner) { FactoryGirl.create :user }
    let!(:ticket) { FactoryGirl.create :ticket, project: project, user: ticket_owner }
    let!(:commenter) { FactoryGirl.create :user }
    let!(:comment) { Comment.new ticket: ticket, user: commenter, text: "Text comment" }
    let!(:title) { "#{ticket.title} for #{project.name} has been updated." }

    let(:email_notification) { Notifier.comment_updated comment, ticket_owner }

    it "sends out an email notification about a ticket's comment" do
      expect(email_notification.to).to include ticket_owner.email
      expect(email_notification.body.to_s).to include title
      expect(email_notification.body.to_s).to include "#{comment.user.email} wrote:"
      expect(email_notification.body.to_s).to include comment.text
    end

    it "correctly sets the Reply-To" do
      address = "youraccount+#{project.id}+#{ticket.id}@example.com"
      expect(email_notification.reply_to).to eq [address]
    end
  end
end
