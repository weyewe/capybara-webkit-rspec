require 'spec_helper'

describe "run with webkit" do
  before(:all) do
    Capybara.current_driver = :webkit
  end

  after(:all) do
    Capybara.use_default_driver
  end

  it "runs something fancy with javascript" do
  	expect( 5 + 5 ).to eq(10)
  end



  context "as a user" do
 	it "adds a news release" do
      # user = create(:user)
      user = User.create(email: 'admin@example.com',
  password: 'secret', password_confirmation: 'secret', admin: true)
      sign_in(user)
      visit root_path
      click_link "News"

      @initial_news_release = NewsRelease.count

      expect(page).to_not have_content "BigCo switches to Rails"
      click_link "Add News Release"

      fill_in "Date", with: "2013-07-29"
      fill_in "Title", with: "BigCo switches to Rails"
      fill_in "Body",
        with: "BigCo has released a new website built with open source."
      click_button "Create News release"

      @final_news_release = NewsRelease.count

      expect( @final_news_release - @initial_news_release).to eq(1)

      expect(current_path).to eq news_releases_path
      expect(page).to have_content "Successfully created news release."
      expect(page).to have_content "2013-07-29: BigCo switches to Rails"
    end
  end 
end

 