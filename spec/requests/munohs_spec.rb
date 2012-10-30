require 'spec_helper'

describe "munohs" do
  let!(:munohs) { FactoryGirl.create_list(:munoh, 3) }

  describe "GET /munohs without login" do
    before { visit munohs_path }
    it { page.current_path.should eq root_path }
  end

  describe "GET /munohs with login" do
    include_context "twitter_login"
    before { visit munohs_path }

    describe "have css, munoh-list" do
      it { page.should have_css('div.munoh-list') }
    end

    describe "click link to /munohs/new" do
      before { click_link "New" }
      it { page.current_path.should eq new_munoh_path }
    end

    describe "click link to /munohs/:id/edit" do
      before { click_link "Edit" }
      it { page.current_path.should eq edit_munoh_path(munohs.first) }
    end

    describe "click link to /munohs/:munoh_id/phrases" do
      before { click_link "Phrases" }
      it { page.current_path.should eq munoh_phrases_path(munohs.first) }
    end
  end

  describe "POST /munoh/create" do
    include_context "twitter_login"
    let(:new_munoh) { FactoryGirl.build(:munoh, {name: "new"}) }

    before do
      visit new_munoh_path
      fill_in 'munoh_name', with: new_munoh.name
      click_button "Create Munoh"
    end

    it { page.current_path.should eq munohs_path }
  end

  describe "PUT /munoh/1/edit" do
    include_context "twitter_login"
    let(:edit_munoh) { FactoryGirl.build(:munoh, {name: "edited"}) }

    before do
      visit edit_munoh_path(munohs.first)
      fill_in 'munoh_name', with: edit_munoh.name
      click_button "Update Munoh"
    end

    it { page.current_path.should eq munohs_path }
  end

  describe "DELETE /munoh/1" do
    include_context "twitter_login"

    before do
      visit munohs_path
      click_link "Delete"
    end

    it { page.current_path.should eq munohs_path }
  end
end
