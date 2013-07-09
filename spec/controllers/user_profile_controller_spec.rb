require 'spec_helper'

describe UserProfileController do
  let(:user) { FactoryGirl.create(:user) }
  let(:valid_params_avatar) { FactoryGirl.attributes_for(:user, first_name: 'testing') }
  let(:valid_params) { FactoryGirl.attributes_for(:user, first_name: 'testing', avatar: nil) }

  before(:each) {
    controller.stub(:current_user).and_return(user)
    controller.stub(:authenticate_user!).and_return(true)
  }

  describe "#update" do
    context "should avatar present" do
      before { put :update, id: user.id, user: valid_params_avatar }
      it { assigns(:user).should_not be_nil }
      it { assigns(:user).should be_valid }
    end

    context "should not avatar" do
      before { put :update, id: user.id, user: valid_params }
      it { assigns(:user).should_not be_nil }
      it { assigns(:user).should be_valid }
      it { should redirect_to(main_page_path(user.id)) }
    end

  end
end