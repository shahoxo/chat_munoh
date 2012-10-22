require 'spec_helper'

describe Room do
  describe "validateions" do
    it { should validate_presence_of(:title) }
  end

  describe "association" do
    it { should belong_to(:owner) }
  end

  describe "#owner?" do
    let(:current_user) { FactoryGirl.create(:user) }
    let(:user) { FactoryGirl.create(:user) }

    context "self" do
      let(:room) { FactoryGirl.create(:room, user_id: current_user.to_param) }
      it { room.owner?(current_user).should be_true }
    end

    context "other user" do
      let(:room) { FactoryGirl.create(:room, user_id: user.to_param) }
      it { room.owner?(current_user).should be_false }
    end
  end
end
