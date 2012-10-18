require 'spec_helper'

describe Talk do
  describe "validattions" do
    it { should validate_presence_of(:room_id) }
    it { should validate_presence_of(:user_id) }
  end
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:room) }
  end
end
