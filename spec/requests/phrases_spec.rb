# encoding: utf-8
require 'spec_helper'

describe "Phrases" do
  include_context "twitter_login"
  let!(:munoh) { FactoryGirl.create(:munoh) }
  let!(:phrases) { FactoryGirl.create_list(:phrase, 3, munoh: munoh)}
  
  describe "GET /munohs/:munoh_id/phrases" do
    before { visit munoh_phrases_path(munoh_id: munoh.to_param) }

    describe "have css, talk-list, send-talk, active-user-list" do
      it { page.should have_css('div.phrase-list') }
    end

    describe "have a munoh-list link" do
      before { click_link "Munoh List" }
      it { page.current_path.should eq munohs_path }
    end
  end

  describe "GET /munohs/:munoh_id/phrases/new" do
    before do
      visit new_munoh_phrase_path(munoh_id: munoh.to_param)
      fill_in 'phrase_keyword', with: phrases.first.keyword
      fill_in 'phrase_reply', with: phrases.first.reply
      click_button "Create Phrase"
    end

    it{ page.current_path.should eq munoh_phrases_path(munoh_id: munoh.to_param) }
    it{ page.should have_css('div.phrase-list') }
  end

  describe "GET /munohs/:munoh_id/phrases/:id" do
    before do
      visit edit_munoh_phrase_path(munoh_id: munoh.to_param, id: phrases.first.to_param)
      fill_in 'phrase_keyword', with: phrases.first.keyword
      fill_in 'phrase_reply', with: phrases.first.reply
      click_button "Update Phrase"
    end

    it{ page.current_path.should eq munoh_phrases_path(munoh_id: munoh.to_param) }
    it{ page.should have_css('div.phrase-list') }
  end
  
  describe "DELETE /munohs/:munoh_id/phrases/:phrase_id" do
    before do
      visit munoh_phrases_path(munoh_id: munoh.to_param)
      click_link "delete"
    end

    it{ page.current_path.should eq munoh_phrases_path(munoh_id: munoh.to_param) }
  end
end
