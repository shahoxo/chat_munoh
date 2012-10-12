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

    context "GET /room/:room_id/talks" do
      include_context "twitter_login"

      before { click_link room.title }
      it { page.current_path.should eq room_talks_path(room_id: room.to_param) }
    end
  end
end
