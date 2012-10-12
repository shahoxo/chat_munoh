require 'spec_helper'

describe "Rooms" do

  describe "GET /rooms" do
    context "with login" do
      before do
        OmniAuth.config.test_mode = true
        OmniAuth.config.mock_auth[:twitter] = {
          "provider" => "twitter",
          "uid" =>  Forgery::Basic.text,
          "info" => { "name" => Forgery::Basic.text }
        }

        visit "/auth/twitter"
        visit rooms_path
      end

       it { page.should have_css('div.room-list') }
    end

    context "without login" do
      before do
        visit rooms_path
      end

       it { page.current_path.should eq root_path }
    end
  end
end
