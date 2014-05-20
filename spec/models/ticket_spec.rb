require 'spec_helper'

describe Ticket do
  it "fails validation with a short description" do
    ticket = Ticket.new description: "Too short"
    expect(ticket.errors_on(:description)).to include "is too short (minimum is 10 characters)"
  end

  it "has a default State of 'New'" do
    new_state = State.where(name: "New").first
    ticket = Ticket.create! title: "Not blank", description: "Large enough..."
    expect(ticket.state).to eq new_state
  end
end
