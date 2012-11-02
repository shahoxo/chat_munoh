require 'spec_helper'

describe Phrase do
  describe "validateions" do
    it { should validate_presence_of(:reply) }
  end

  describe "association" do
    it { should belong_to(:munoh) }
  end
end
