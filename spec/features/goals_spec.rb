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

  feature "Goals Show Page" do
    before :each do
      user = User.create!(username: 'jeff', password: 'abcdef')
      goal1 = Goal.create(title: 'tie shoes', description: 'bunny ear method not allowed',
          visibility: 'Private', status: 'pending', user_id: user.id)
      goal2 = Goal.create(title: 'Call Grandma',
          description: 'Not during wheel of fortune (7:30PM)',
          visibility: 'Public', status: 'pending', user_id: user.id)
      sign_in("jeff")
      visit goals_url
      click_link "tie shoes"
    end

    it "brings you to a goal show page when clicking the goal's link on the index page" do
      expect(page).to have_content('bunny ear method not allowed')
    end

    feature "Delete Goal" do
      it "has a delete button on the show page if you are the user who created it" do
        expect(page).to have_button("Delete Goal")
      end

      it "doesn't have a delete button on the show page if you aren't the user who created it" do
        sign_up("mike")
        visit goals_url
        click_link "Call Grandma"
        expect(page).not_to have_button("Delete Goal")
      end

      it "redirects you to the index page when you click the delete button" do
        click_button "Delete Goal"
        expect(page).to have_content("Goals")
      end

      it "reflects that the goal has been deleted when returning to the index page" do
        click_button "Delete Goal"
        expect(page).to have_content("Goals")
        expect(page).not_to have_content("tie shoes")
      end
    end

    feature "Edit Goal Page" do
      it "has an edit button on the show page if you are the user who created it" do
        expect(page).to have_button("Edit Goal")
      end

      it "doesn't have an edit button on the show page if you aren't the user who created it" do
        sign_up("mike")
        visit goals_url
        click_link "Call Grandma"
        expect(page).not_to have_button("Edit Goal")
      end

      it "cannot be visited except by the user who created the goal" do
        sign_up("mike")
        visit edit_goal_url(Goal.find_by(title: 'Call Grandma'))
        expect(page).to have_content "Goal Show Page"
      end

      it "takes you to an edit form when you click the edit button" do
        click_button "Edit Goal"
        expect(page).to have_content("Goal Edit Page")
      end

      it "has the field pre-populated with the values of the goal being edited" do
        click_button "Edit Goal"
        expect(find_field('Title').value).to eq('tie shoes')
        expect(find_field('Description').value).to eq('bunny ear method not allowed')
      end

      feature "Update Goal" do
        it "saves changes when you edit the fields" do
          click_button "Edit Goal"
          fill_in "Description", with: "Not during Wheel of Fortune (7:30 PM) or Matlock (9:00 PM)"
          click_button "Update Goal"
          expect(page).to have_content("Matlock")
        end
      end
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
