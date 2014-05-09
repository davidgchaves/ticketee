module CapybaraHelpers
  def state_line_for(state)
    state = State.find_by! name: state
    "#state_#{state.id}"
  end
end

RSpec.configure do |config|
  config.include CapybaraHelpers, type: :feature
end
