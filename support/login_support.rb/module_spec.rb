module LoginModule
  def valid_login(user)
    visit login_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Login"
    expect(page).to have_content 'Login successful'
  end

  RSpec.configure do |config|
    config.include LoginSupport
  end
end
