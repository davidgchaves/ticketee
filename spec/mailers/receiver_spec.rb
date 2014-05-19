require "spec_helper"

describe Receiver do
  let(:project) { FactoryGirl.create :project }
  let(:ticket_owner) { FactoryGirl.create :user }
  let(:ticket) { FactoryGirl.create :ticket, project: project, user: ticket_owner }
  let(:commenter) { FactoryGirl.create :user }
  let(:comment) { Comment.new ticket: ticket, user: commenter, text: "Text comment" }

  context "When Notifier sends an email" do
    let(:sent_email) { Notifier.comment_updated comment, ticket_owner }

    context "Then the reply email" do
      let(:reply_text) { "This is a brand new comment." }
      let(:reply_email) { build_reply_email_with sent_email, reply_text }

      it "changes the ticket's comment count by 1" do
        expect{Receiver.parse reply_email}.to change(ticket.comments, :count).by 1
      end

      it "contents the text from the reply" do
        Receiver.parse reply_email
        expect(ticket.comments.last.text).to eq reply_text
      end
    end
  end

  def build_reply_email_with(sent_email, reply_text)
    Mail.new(from: commenter.email,
             subject: "Re: #{sent_email.subject}",
             body: %Q{ #{reply_text}
                       #{sent_email.body} },
             to: sent_email.reply_to)
  end
end
