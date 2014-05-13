require 'spec_helper'

describe CommentsController do
  let(:user) { FactoryGirl.create :user }
  let(:ticket) do
    project = Project.create! name: "Ticketee"
    project.tickets.create title: "State transitions", description: "Can't be hacked", user: user
  end
  let(:state) { State.create! name: "New" }

  context "Given a signed in user without 'change states' permission" do
    before { sign_in user }

    context "When she tries to hack transitioning a state via 'state_id'" do
      before do
        post :create, { comment: { text: "Hacked!", state_id: state.id },
                        ticket_id: ticket.id }
        ticket.reload
      end

      it "gets a ticket with nil state" do
        expect(ticket.state).to be_nil
      end
    end
  end

  context "Given a signed in user without 'tag' permission" do
    before { sign_in user }

    context "When she tries to tag a ticket creating a comment" do
      before do
        post :create, { comment: { text: "Tag!", tag_names: "one two" },
                        ticket_id: ticket.id }
        ticket.reload
      end

      it "gets a ticket with empty tags" do
        expect(ticket.tags).to be_empty
      end
    end
  end
end
