require 'spec_helper'

describe Talk do
  describe "association" do
    it { should belong_to(:user) }
    it { should belong_to(:room) }
  end
end
