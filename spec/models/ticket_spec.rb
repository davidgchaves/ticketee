require 'spec_helper'

describe Ticket do
  it "fails validation with a short description" do
    ticket = Ticket.new(description: "Too short")
    expect(ticket.errors_on(:description)).to include "is too short (minimum is 10 characters)"
  end
end
