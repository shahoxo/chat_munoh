# encoding: utf-8
require 'spec_helper'

describe "Rooms" do
  let!(:room) { FactoryGirl.create(:room) }

  describe "GET /rooms without login" do
    before { visit rooms_path }
    it { page.current_path.should eq root_path }
  end

  describe "GET /rooms" do
    include_context "twitter_login"
    before { visit rooms_path }

    describe "have css, room-list" do
      it { page.should have_css('div.room-list') }
    end

    describe "click link to /rooms/:room_id/talks" do
      before { click_link room.title }
      it { page.current_path.should eq room_talks_path(room_id: room.to_param) }
    end

    describe "click link to /rooms/new" do
      before { click_link "新規作成" }
      it { page.current_path.should eq new_room_path }
    end

    describe "click link to /rooms/:id/edit" do
      before { click_link "編集" }
      it { page.current_path.should eq edit_room_path(room) }
    end
  end

  describe "POST /room/create" do
    include_context "twitter_login"
    before do
      visit new_room_path
      fill_in 'room_title', with: room.title
      click_button "新規登録"
    end

    it { page.current_path.should eq rooms_path }
  end

  describe "PUT /room/1/edit" do
    include_context "twitter_login"
    let(:edit_room) { FactoryGirl.build(:room, {title: "edited"}) }

    before do
      visit edit_room_path(room)
      fill_in 'room_title', with: edit_room.title
      click_button "編集"
    end

    it { page.current_path.should eq rooms_path }
  end
end
