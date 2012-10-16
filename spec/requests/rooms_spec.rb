# encoding: utf-8
require 'spec_helper'

describe "Rooms" do
  let!(:rooms) { FactoryGirl.create_list(:room, 10) }

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
      before { click_link rooms.first.title }
      it { page.current_path.should eq room_talks_path(room_id: rooms.first.to_param) }
    end

    describe "click link to /rooms/new" do
      before { click_link "New" }
      it { page.current_path.should eq new_room_path }
    end

    describe "click link to /rooms/:id/edit" do
      before { click_link "Edit" }
      it { page.current_path.should eq edit_room_path(rooms.first) }
    end
  end

  describe "POST /room/create" do
    include_context "twitter_login"
    let(:new_room) { FactoryGirl.build(:room, {title: "new"}) }

    before do
      visit new_room_path
      fill_in 'room_title', with: new_room.title
      click_button "Create Room"
    end

    it { page.current_path.should eq rooms_path }
  end

  describe "PUT /room/1/edit" do
    include_context "twitter_login"
    let(:edit_room) { FactoryGirl.build(:room, {title: "edited"}) }

    before do
      visit edit_room_path(rooms.first)
      fill_in 'room_title', with: edit_room.title
      click_button "Update Room"
    end

    it { page.current_path.should eq rooms_path }
  end
end
