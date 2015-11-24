require 'spec_helper'
require 'rails_helper'

feature "goals" do
  feature "Goals Index Page" do
    before :each do
      user = User.create!(username: 'jeff', password: 'abcdef')
      goal1 = Goal.create(title: 'tie shoes', description: 'bunny ear method not allowed',
          visibility: 'Private', status: 'pending', user_id: user.id)
      goal2 = Goal.create(title: 'Call Grandma',
          description: 'Not during wheel of fortune (7:30PM)',
          visibility: 'Public', status: 'pending', user_id: user.id)
      sign_up("mike")
    end

    it "doesn't let you go to the goals page if you're not signed in" do
      click_button("Sign Out")
      visit "/goals"
      expect(page).to have_content "Sign In"
      expect(page).not_to have_content "Goals"
    end

    it "is viewable to signed in users" do
      visit goals_url
      expect(page).to have_content "Goals"
    end

    it "has an add goal button" do
      visit goals_url
      expect(page).to have_button "Add Goal"
    end

    it "displays all the goals of the signed in user" do
      sign_in('jeff')
      visit goals_url
      expect(page).to have_content('tie shoes')
    end

    it "displays only the public goals of other users" do
      visit goals_url
      expect(page).to have_content('Call Grandma')
    end


    it "doesn't display the private goals of other users" do
      visit goals_url
      expect(page).not_to have_content('tie shoes')
    end
  end
  feature "Adding a Goal" do
    before(:each) do
      sign_up('mike')
      click_button('Add Goal')
    end

    it "takes you to a new form when clicking add goal from index page" do
      expect(page).to have_content "New Goal"
    end


    it "contrains all the necessary fields" do
      expect(page).to have_content "Title"
      expect(page).to have_content "Description"
      expect(page).to have_content "Visibility"
      expect(page).to have_content "Due Date"
      expect(page).to have_content "Status"
      expect(page).to have_button "Create New Goal"
    end

    it "preforms the necessary validations" do
      click_button "Create New Goal"
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Description can't be blank"
    end

    it "take you back to the goal index page when you save" do
      fill_in "Title", with: 'Buy TP'
      fill_in "Description", with: 'Two ply, at least (preferably 3)'
      click_button "Create New Goal"
      expect(page).to have_content 'Goals'
    end

    it "the goals index page has the new goal" do
      fill_in "Title", with: 'Buy TP'
      fill_in "Description", with: 'Two ply, at least (preferably 3)'
      click_button "Create New Goal"
      expect(page).to have_content 'Buy TP'
    end
  end
end
#
# feature "logging in" do
#   before :each do
#     visit "/session/new"
#     User.create(username: "Tevy", password: "tevytevy")
#   end
#
#   it "shows username on the homepage after login" do
#     fill_in "Username", with: "Tevy"
#     fill_in "Password", with: "tevytevy"
#     click_button 'Sign In'
#     expect(page).to have_content "Tevy"
#   end
#
# end
#
# feature "logging out" do
#   before :each do
#     visit "/goals"
#     User.create(username: "Tevy", password: "tevytevy")
#   end
#
#   it "begins with logged out state" do
#     expect(page).to have_content "Sign In"
#     expect(page).to have_content "Sign Up"
#   end
#
#   it "doesn't show username on the homepage after logout" do
#     visit "/session/new"
#     fill_in "Username", with: "Tevy"
#     fill_in "Password", with: "tevytevy"
#     click_button 'Sign In'
#     click_button 'Sign Out'
#     expect(page).not_to have_content "Tevy"
#   end
#
# end
