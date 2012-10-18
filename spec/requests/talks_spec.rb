# encoding: utf-8
require 'spec_helper'

describe "Talks" do
  include_context "twitter_login"
  let(:room) { FactoryGirl.create(:room) }
  let(:user) { FactoryGirl.create(:user) }
  let(:talk) { FactoryGirl.build(:talk) }
  
  describe "GET /rooms/:room_id/talks" do
    before { visit room_talks_path(room_id: room.to_param) }

    describe "have css, talk-list, send-talk" do
      it { page.should have_css('div.talk-list') }
      it { page.should have_css('div.send-talk') }
    end
  end

  describe "POST /rooms/:room_id/talks" do

    before do
      visit room_talks_path(room_id: room.to_param)
      fill_in 'talk_log', with: talk.log
      click_button "Create Talk"
    end

    it{ page.current_path.should eq room_talks_path(room_id: room.to_param) }

  end
end
