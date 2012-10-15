require 'spec_helper'

describe TalksController do
  let!(:room) { FactoryGirl.create(:room) }
  include_context "login_stub"
  describe "GET 'index'" do
    it "returns http success" do
      get 'index', room_id: room.to_param
      response.should be_success
    end
  end

end
