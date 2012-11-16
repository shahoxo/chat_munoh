require 'spec_helper'

describe MunohsController do
  include_context "login_stub"
  include_context "request_to_twitter_stub"

  describe "POST 'create'" do
    let(:munoh) { FactoryGirl.attributes_for(:munoh) }

    context "with valid params" do
      it "creates a new Munoh" do
        expect{post :create, {munoh: munoh}}.to change(Munoh, :count).by(1)
      end

      it "redirects to the created munoh" do
        post :create, {munoh: munoh}
        response.should redirect_to(munohs_url)
      end
    end

    context "with invalid params" do
      before do
        Munoh.any_instance.stub(:save).and_return(false)
      end

      it "do not create a new Munoh" do
        expect{post :create, {munoh: munoh}}.to_not change(Munoh, :count)
      end

      it "assigns a newly created but unsaved munoh as @munoh" do
        post :create, {munoh: munoh}
        assigns(:munoh).should be_a_new(Munoh)
      end

      it "re-renders the 'new' template" do
        post :create, {munoh: munoh}
        response.should render_template(:new)
      end
    end
  end

  describe "PUT 'update'" do
    let!(:munoh) { FactoryGirl.create(:munoh) }

    context "with valid params" do
      let(:edit_munoh) { FactoryGirl.attributes_for(:munoh, {name: "edited"}) }

      it "updates the requested munoh" do
        Munoh.any_instance.should_receive(:update_attributes).with('these' => 'params')
        put :update, {id: munoh.to_param, munoh: {'these' => 'params'}}
      end

      it "redirects to the munohs" do
        put :update, {id: munoh.to_param, munoh: edit_munoh}
        response.should redirect_to(munohs_url)
      end
    end

    context "with invalid params" do
      before do
        Munoh.any_instance.stub(:update_attributes).and_return(false)
      end

      it "re-renders the 'edit' template" do
        put :update, {id:munoh.to_param, munoh: {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE 'destroy'" do
    let!(:munoh) { FactoryGirl.create(:munoh) }

    it "destroys the requested munoh" do

      expect {
        delete :destroy, {id: munoh.to_param}
      }.to change(Munoh, :count).by(-1)
    end

    it "redirects to the munoh list" do
      delete :destroy, {id: munoh.to_param}
      response.should redirect_to(munohs_url)
    end
  end
end
