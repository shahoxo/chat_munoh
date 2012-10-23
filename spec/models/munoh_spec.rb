require 'spec_helper'

describe Munoh do
  describe "validateions" do
    it { should validate_presence_of(:name) }
  end
end
