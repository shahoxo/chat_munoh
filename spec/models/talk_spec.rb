require 'spec_helper'

describe Talk do
  describe "validations" do
    it { should validate_presence_of(:room_id) }
    it { should validate_presence_of(:user_id) }
  end
  
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:room) }
  end

  describe "#owner?" do
    let(:current_user) { FactoryGirl.create(:user) }
    let(:user) { FactoryGirl.create(:user) }
    let(:room) { FactoryGirl.create(:room) }
  
    context "self" do
      let(:talk) { FactoryGirl.create(:talk, user_id: current_user.to_param) }
      it { talk.owner?(current_user).should be_true }
    end

    context "other user" do
      let(:talk) { FactoryGirl.create(:talk, user_id: user.to_param) }
      it { talk.owner?(current_user).should be_false }
    end
  end

  describe "#in_the_room" do
    let(:user) { FactoryGirl.create(:user) }
    let(:room) { FactoryGirl.create(:room) }
    let(:talks) { FactoryGirl.create_list(:talk, 10, room_id: room.to_param, user_id: user.to_param) }
    it { user.talks.in_the_room(room.id).should == user.talks.where(room_id: room.id) }
  end
end
