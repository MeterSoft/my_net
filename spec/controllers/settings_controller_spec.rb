require 'spec_helper'

describe SettingsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:setting) { FactoryGirl.create(:setting, user_id: user) }

  before (:each) {
    controller.stub(:current_user).and_return(user)
    controller.stub(:authenticate_user!).and_return(true)
  }

  context "#edit" do
    before { get :edit, id: user }

    it { expect(response).to be_success }
    it { expect(response.status).to eq(200) }
    it { expect(assigns(@settings)).to_not be_empty }
  end

  context "#update" do
    let(:setting_attr) { FactoryGirl.attributes_for(:setting, city: false) }
    before { put :update, id: setting, setting: setting_attr }

    it { expect(response.status).to eq(302) } # redirect
    it { expect(assigns(@settings)).to_not be_empty }
    it "update sity attr" do
      setting.reload
      expect(setting.city).to be_false
    end
    it { should redirect_to(edit_setting_path) }

  end

end