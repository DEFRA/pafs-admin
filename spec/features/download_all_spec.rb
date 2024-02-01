# frozen_string_literal: true

RSpec.describe "Download all" do
  let(:download_filename) { PafsCore::Download::All::FILENAME }
  let(:meta_filename) { "#{download_filename}.meta" }
  let(:meta) { PafsCore::Download::Meta.load(meta_filename) }
  let(:user) { create(:back_office_user, :pso) }
  let!(:project) { create(:project, creator: user) }

  def remove_meta_file
    FileUtils.rm(Rails.public_path.join("tmp", meta_filename))
  rescue Errno::ENOENT # rubocop:disable Lint/SuppressedException
  end

  before do
    login_as(user)
  end

  context "without a previously generated download" do
    before do
      remove_meta_file
    end

    it "shows the blank slate" do
      visit "/admin/download"
      expect(page).to have_content("The complete FCRM1 has not yet been generated")
      expect(page).to have_button("Generate FCRM1")
      expect(page).to have_no_css("a", text: "Proposals (Excel document)")
    end
  end

  context "with a failed generation" do
    before do
      meta.create({ last_update: Time.now.utc, status: "failed" })
    end

    it "shows the failed slate" do
      visit "/admin/download"
      expect(page).to have_content("An error occurred while generating the FCRM1")
      expect(page).to have_button("Generate FCRM1")
      expect(page).to have_no_css("a", text: "Proposals (Excel document)")
    end
  end

  context "with a pending generation" do
    before do
      meta.create({ last_update: Time.now.utc, status: "pending" })
    end

    it "shows the pending slate" do
      visit "/admin/download"
      expect(page).to have_content("The complete FCRM1 is being generated")
      expect(page).to have_button("Generate FCRM1")
      expect(page).to have_no_css("a", text: "Proposals (Excel document)")
    end
  end

  context "with a successful generation" do
    before do
      meta.create({ last_update: Time.now.utc, status: "complete" })
    end

    it "shows the complete slate" do
      visit "/admin/download"
      expect(page).to have_content("FCRM1 generation completed at")
      expect(page).to have_button("Generate FCRM1")
      expect(page).to have_css("a", text: "Proposals (Excel document)")
    end
  end

  it "Generating a new download" do
    visit "/admin/download"
    click_on "Generate FCRM1 for all projects"

    expect(page).to have_content("The complete FCRM1 is being generated")
    expect(page).to have_no_css("a", text: "Proposals (Excel document)")

    sleep(2)
    visit "/admin/download"
    expect(page).to have_content("FCRM1 generation completed at")
    expect(page).to have_css("a", text: "Proposals (Excel document)")
  end
end
