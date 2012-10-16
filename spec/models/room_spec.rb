require 'spec_helper'

describe Room do
  describe "validateions" do
    it { should validate_presence_of(:title) }
  end

  describe "association" do
    it { should belong_to(:user) }
  end
end
