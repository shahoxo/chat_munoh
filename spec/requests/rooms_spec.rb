# encoding: utf-8
require 'spec_helper'

describe "Rooms" do
  describe "GET /rooms" do
    let!(:room) { FactoryGirl.create(:room) }
    before { visit rooms_path }

    context "with login" do
      include_context "twitter_login"
      it { page.should have_css('div.room-list') }
    end

    context "without login" do
      it { page.current_path.should eq root_path }
    end

    context "GET /rooms/:room_id/talks" do
      include_context "twitter_login"

      before { click_link room.title }
      it { page.current_path.should eq room_talks_path(room_id: room.to_param) }
    end

    context "GET /rooms/new" do
      include_context "twitter_login"

      before { click_link "新規作成" }
      it { page.current_path.should eq new_room_path }
    end
  end

  describe "POST /room/create" do
    let!(:room) { FactoryGirl.build(:room) }
    include_context "twitter_login"
    before do
      visit new_room_path
      fill_in 'room_title', with: room.title
      click_button "新規登録"
    end

    it do
    end
  end
end
