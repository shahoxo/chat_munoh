require 'spec_helper'

describe RoomsController do
  include_context "login_stub"

  describe "POST create" do
    let(:room) { FactoryGirl.attributes_for(:room, user_id: user.to_param) }

    describe "with valid params" do
      it "creates a new Rooms" do
        expect{post :create, {room: room}}.to change(Room, :count).by(1)
      end

      it "redirects to the created room" do
        post :create, {room: room}
        response.should redirect_to(rooms_url)
      end
    end

    describe "with invalid params" do
      before do
        Room.any_instance.stub(:save).and_return(false)
      end

      it "do not create a new Rooms" do
        expect{post :create, {room: room}}.to_not change(Room, :count)
      end

      it "assigns a newly created but unsaved room as @room" do
        post :create, {room: room}
        assigns(:room).should be_a_new(Room)
      end

      it "re-renders the 'new' template" do
        post :create, {room: room}
        response.should render_template(:new)
      end
    end
  end

  describe "PUT update" do
  end

  describe "DELETE destroy" do
  end
end
