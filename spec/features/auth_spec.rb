require 'spec_helper'
require 'rails_helper'



feature "the signup process" do
  before :each do
    visit "/users/new"
  end

  it "has a new user page" do
    expect(page).to have_content "Sign Up"
    expect(page).to have_content "Username"
    expect(page).to have_content "Password"
  end


  feature "signing up a user" do
    it "shows username on the homepage after signup" do
      fill_in "Username", with: "Tevy"
      fill_in "Password", with: "tevytevy"
      click_button 'Sign Up'
      expect(page).to have_content 'Tevy'
    end
  end

end

feature "logging in" do
  before :each do
    visit "/session/new"
    User.create(username: "Tevy", password: "tevytevy")
  end

  it "shows username on the homepage after login" do
    fill_in "Username", with: "Tevy"
    fill_in "Password", with: "tevytevy"
    click_button 'Sign In'
    expect(page).to have_content "Tevy"
  end

end

feature "logging out" do
  before :each do
    visit "/goals"
    User.create(username: "Tevy", password: "tevytevy")
  end

  it "begins with logged out state" do
    expect(page).to have_content "Sign In"
    expect(page).to have_content "Sign Up"
  end

  it "doesn't show username on the homepage after logout" do
    visit "/session/new"
    fill_in "Username", with: "Tevy"
    fill_in "Password", with: "tevytevy"
    click_button 'Sign In'
    click_button 'Sign Out'
    expect(page).not_to have_content "Tevy"
  end

end
