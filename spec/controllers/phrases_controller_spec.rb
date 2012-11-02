require 'spec_helper'

describe PhrasesController do
  include_context "login_stub"
  include_context "request_to_twitter_stub"

  let!(:munoh) { FactoryGirl.create(:munoh)}
  let!(:phrase) { FactoryGirl.create(:phrase, munoh: munoh)}

  describe "GET 'index'" do
    it "returns http success" do
      get 'index', munoh_id: munoh.to_param
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new', munoh_id: munoh.id
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit', munoh_id: munoh.id, id: phrase.id
      response.should be_success
    end
  end

  describe "POST create" do
    let(:phrase_params) { FactoryGirl.attributes_for(:phrase, munoh_id: munoh.to_param)  }
    
    describe "with valid params" do
      it "creates a new phrases" do
        expect{post :create, {munoh_id: munoh.to_param, phrase: phrase_params}}.to change(Phrase, :count).by(1)
      end

      it "redirects to munoh phrases url" do
        post :create, {munoh_id: munoh.to_param, phrase: phrase_params}
        response.should redirect_to(munoh_phrases_url)
      end
    end
    
    describe "with invalid params" do
      before do
        Phrase.any_instance.stub(:save).and_return(false)
      end

      it "do not create a new talk" do
        expect{post :create, {munoh_id: munoh.to_param, phrase: phrase_params}}.to_not change(Phrase, :count)
      end

      it "assigns a newly created but unsaved phrase as @phrase" do
        post :create, {munoh_id: munoh.to_param, phrase: phrase_params}
        assigns(:phrase).should be_a_new(Phrase)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested talk" do
      expect{ delete :destroy, {munoh_id: munoh.to_param, id: phrase.to_param} }.to change(Phrase, :count).by(-1)
    end

    it "redirects to the talk list" do
      delete :destroy, {munoh_id: munoh.to_param, id: phrase.to_param}
      response.should redirect_to(munoh_phrases_url munoh_id: munoh.to_param)
    end
  end
end
