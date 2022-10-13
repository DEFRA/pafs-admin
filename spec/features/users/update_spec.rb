# frozen_string_literal: true

RSpec.describe "Update a user", type: :feature do
  let(:admin) { create(:admin, :pso) }
  let(:user) { create(:user, :pso) }
  let!(:area) { create(:rma_area, name: "North East") }

  before do
    login_as(admin)
  end

  context "when updating a users area" do
    it "updating the user with a new area" do
      visit("/admin/users/#{user.id}/edit")
      select("North East", from: "Main Area")

      expect do
        click_on "Save"
        expect(page).to have_content("Manage users")
      end.to change { user.reload.updated_at }

      expect(user.reload.areas.map(&:name)).to eql(["North East"])
    end
  end
end
