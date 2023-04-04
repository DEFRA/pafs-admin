# frozen_string_literal: true

RSpec.describe "Update a user" do
  let(:admin) { create(:back_office_user, :pso) }
  let(:user) { create(:user, :pso) }
  let!(:main_area) { create(:rma_area, name: "North East") }

  before do
    login_as(admin)
  end

  context "when updating a users main area" do
    it "updates the user with the new area" do
      visit("/admin/users/#{user.id}/edit")
      select("North East", from: "Main Area")

      expect { click_on "Save" }
        .to change { user.reload.updated_at }
        .and change { user.areas.map(&:name) }.to(["North East"])

      expect(page).to have_content("Manage users")
    end
  end

  context "when removing a users first area" do
    let!(:first_area) { create(:pso_area, name: "South West") }

    before do
      user.areas << first_area
      user.save!
    end

    it "updating the user with a new area" do
      visit("/admin/users/#{user.id}/edit")

      expect(page).to have_content("Edit User")
      expect(user.areas.map(&:name)).to include("South West")

      expect { click_on "remove" }.to change { user.reload.updated_at }

      expect(user.reload.areas.map(&:name)).not_to include("South West")
      expect(page).to have_content("Edit User")
    end
  end
end
