require 'spec_helper'

describe Room do
  describe "validateions" do
    it { should validate_presence_of(:title) }
  end

  describe "association" do
    it { should belong_to(:owner) }
    it { should have_many(:talks) }
    it { should belong_to(:munoh) }
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

  describe "#active_users" do
    let(:room) { FactoryGirl.create(:room) }
    let!(:active_user) { FactoryGirl.create(:user) }
    let!(:passive_user) { FactoryGirl.create(:user) }
    let!(:active_talk) { FactoryGirl.create(:talk, user_id: active_user.to_param, created_at: 3.minutes.ago) }
    let!(:passive_talk) { FactoryGirl.create(:talk, user_id: passive_user.to_param, created_at: 6.years.ago) }
    it { room.active_users.should include active_user }
    it { room.active_users.should_not include passive_user }
  end
end
