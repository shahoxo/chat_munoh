require 'spec_helper'

describe TalksController do
  include_context "login_stub"
  let!(:room) { FactoryGirl.create(:room) }
  describe "GET index" do
    it "returns http success" do
      get 'index', room_id: room.to_param
      response.should be_success
    end
  end

  describe "POST create" do
    let(:talk) { FactoryGirl.attributes_for(:talk, room_id: room.to_param)  }
    describe "with valid params" do
      it "creates a new talks" do
        expect{post :create, {room_id: room.to_param, talk: talk}}.to change(Talk, :count).by(1)
      end

      it "redirects to the talked room" do
        post :create, {room_id: room.to_param, talk: talk}
        response.should redirect_to(room_talks_url(room_id: room.to_param))
      end
    end
    describe "with invalid params" do
      before do
        Talk.any_instance.stub(:save).and_return(false)
      end

      it "do not create a new talk" do
        expect{post :create, {room_id: room.to_param, talk: talk}}.to_not change(Talk, :count)
      end

      it "assigns a newly created but unsaved talk as @talk" do
        post :create, {room_id: room.to_param, talk: talk}
        assigns(:talk).should be_a_new(Talk)
      end
    end
  end
end
