module AuthenticationHelpers
  def sign_in_as!(user)
    visit "/signin"
    fill_in "Name", with: user.name
    fill_in "Password", with: user.password
    click_button "Sign in"

    expect(page).to have_content "Signed in successfully."
    expect(page).to have_content "Signed in as #{user.email}"
  end

  def sign_in(user)
    session[:user_id] = user.id
  end
end

RSpec.configure do |c|
  c.include AuthenticationHelpers, type: :feature
  c.include AuthenticationHelpers, type: :controller
end
