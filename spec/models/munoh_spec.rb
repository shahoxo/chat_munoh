require 'spec_helper'

describe Munoh do
  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "associations" do
    it { should have_many(:rooms) }
  end

  describe "#valid_twitter_name?" do
    context "with valid value" do
      subject { FactoryGirl.build(:munoh) }
      it { should be_valid_twitter_name }
    end

    context "with invalid value" do
      subject { FactoryGirl.build(:munoh, twitter_name: nil) }
      it { should_not be_valid_twitter_name}
    end
  end

  describe "#try_to_get_valid_response" do
    before do
      Twitter::Client.any_instance.stub(:user_timeline).and_return([])
    end

    let!(:munoh) { FactoryGirl.create(:munoh) }
    named_let(:new_twitter_name) { munoh.twitter_name = "still_unsave_twitter_name" }
    named_let(:old_twitter_name) { Munoh.find(munoh).twitter_name }

    context "with exception" do

      subject { munoh.twitter_name }

      context "too many requests" do
        before do
          munoh.twitter_name = "still_unsave_twitter_name"
          Munoh.any_instance.stub(:retrieve_phrases_on_timeline).and_raise(Twitter::Error::TooManyRequests)
          munoh.try_to_get_valid_response
        end
        it { should eq old_twitter_name }
      end

      context "not found" do
        before do
          munoh.twitter_name = "still_unsave_twitter_name"
          Munoh.any_instance.stub(:retrieve_phrases_on_timeline).and_raise(Twitter::Error::NotFound)
          munoh.try_to_get_valid_response
        end

        it { should eq old_twitter_name }
      end

      context "forbidden" do
        before do
          munoh.twitter_name = "still_unsave_twitter_name"
          Munoh.any_instance.stub(:retrieve_phrases_on_timeline).and_raise(Twitter::Error::Forbidden)
          munoh.try_to_get_valid_response
        end

        it { should eq old_twitter_name }
      end
    end

    context "without exception" do
      before do
        Munoh.any_instance.should_receive(:valid_twitter_name?).and_return(true)
        Munoh.any_instance.should_receive(:retrieve_phrases_on_timeline).and_return(true)
      end

      it "should receive method 'retrieve_phrases_on_timeline'" do
        munoh.try_to_get_valid_response
      end
    end

  end

  describe "#retrieve_phrases_on_timeline" do
    include_context "request_to_twitter_stub"

    let!(:munoh) { FactoryGirl.create(:munoh) }
    let!(:tweet) { Twitter::Tweet.new(id: 1, in_reply_to_status_id: 123456, text: "tweet!") }

    before do
      Twitter::Client.any_instance.stub(:user_timeline).and_return([tweet])
      Munoh.any_instance.stub(:find_source_tweet).and_return("first tweet")
      Munoh.any_instance.stub(:find_source_owner).and_return("tweet owner")
      munoh.retrieve_phrases_on_timeline
    end

    subject { munoh.phrases }
    it { should have(1).items }
    it "should have keyword 'first tweet' on first object" do
      subject.first.keyword.should eq "first tweet"
    end
    it "should have reply 'tweet!' on first object" do
      subject.first.reply.should eq "tweet!"
    end
  end

  describe "#find_source_tweet" do
    include_context "request_to_twitter_stub"

    let!(:munoh) { FactoryGirl.create(:munoh) }
    let!(:tweet) { Twitter::Tweet.new(id: 1, in_reply_to_status_id: 123456, text: "tweet!") }
    named_let(:extracted_tweet) { tweet.text }

    subject{ munoh.find_source_tweet(tweet.in_reply_to_status_id) }

    context "with exception" do
      context "not found" do
        before do
          Twitter::Client.any_instance.stub(:status).and_raise(Twitter::Error::NotFound)
        end

        it { should be_nil }
      end

      context "forbidden" do
        before do
          Twitter::Client.any_instance.stub(:status).and_raise(Twitter::Error::Forbidden)
        end

        it { should be_nil }
      end
    end

    context "without exception" do
      before do
        Twitter::Client.any_instance.stub(:status).and_return(tweet)
      end

      it { should eq extracted_tweet }
    end
  end

  describe "#find_source_owner" do
    let!(:munoh) { FactoryGirl.build(:munoh) }
    let!(:twitter_user) { Twitter::User.new(id: 12345, name: "owner") }
    named_let(:extracted_user_name) { twitter_user.name }

    subject{ munoh.find_source_owner(twitter_user.id) }

    context "with exception" do
      context "not found" do
        before do
          Twitter::Client.any_instance.stub(:user).and_raise(Twitter::Error::NotFound)
        end

        it { should be_nil }
      end

      context "forbidden" do
        before do
          Twitter::Client.any_instance.stub(:user).and_raise(Twitter::Error::Forbidden)
        end

        it { should be_nil }
      end
    end
    context "without exception" do
      before do
        Twitter::Client.any_instance.stub(:user).and_return(twitter_user)
      end

      it { should eq extracted_user_name }
    end
  end

  describe "#format_reply" do
    let!(:munoh) { FactoryGirl.build(:munoh) }

    context "with '@username'" do
      it { munoh.format_reply("hoge-user","hoge-user method test!").should eq "[user_name] method test!"}
    end

    context "without '@username'" do
      it { munoh.format_reply("hoge-user","method test!").should eq "method test!" }
    end

    context "with nil" do
      it { munoh.format_reply(nil, "method test!").should eq "method test!" }
    end
  end

  describe "#remove_noise" do
    let!(:munoh) { FactoryGirl.build(:munoh) }

    context "with 'http://hoge'" do
      it{munoh.remove_noise("http://hoge tweet!").should eq "tweet!"}
    end

    context "with '@hoge'" do
      it{munoh.remove_noise("@hoge tweet!").should eq "tweet!"}
    end
  end
end
