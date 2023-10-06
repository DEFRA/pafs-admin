# frozen_string_literal: true

module Features
  module AuthenticationSteps
    def login_as(user)
      visit "/"

      expect(page).to have_css("h1", text: "Sign in")

      fill_in "Email", with: user.email
      fill_in "Password", with: "Secr3tP@ssw0rd"
      click_button "Sign in"

      expect(page).to have_css("h1", text: "Manage users")
    end
  end
end
