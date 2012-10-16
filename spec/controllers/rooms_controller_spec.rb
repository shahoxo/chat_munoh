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
    let(:room) { FactoryGirl.create(:room) }

    describe "with valid params" do
      let(:edit_room) { FactoryGirl.attributes_for(:room, {title: "edited"}) }

      it "updates the requested room" do
        Room.any_instance.should_receive(:update_attributes).with('these' => 'params')
        put :update, {id: room.to_param, room: {'these' => 'params'}}
      end

      it "redirects to the rooms" do
        put :update, {id: room.to_param, room: edit_room}
        response.should redirect_to(rooms_url)
      end
    end

    describe "with invalid params" do
      before do
        Room.any_instance.stub(:update_attributes).and_return(false)
      end

      it "re-renders the 'edit' template" do
        put :update, {id:room.to_param, room: {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
  end
end
