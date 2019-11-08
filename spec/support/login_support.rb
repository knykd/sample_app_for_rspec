module LoginSupport
  def login_as(user)
    visit login_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: "password"
    click_button "Login"
    expect(page).to have_content 'Login successful'
    expect(current_path).to eq root_path
  end
end
