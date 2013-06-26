require 'spec_helper'

describe GroupsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group) }
  let(:group_admin) { FactoryGirl.create(:group, admin_id: user.id) }

  before (:each) {
    controller.stub(:current_user).and_return(user)
    controller.stub(:authenticate_user!).and_return(true)
  }

  describe "GET 'index'" do
    it "responds http success" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    # it "loads all of the groups into ???????" do
    #   get :index
    #   expect(assigns(:created_groups)).to eq(group_admin)
    #   # expect(assigns(:created_groups)).to match_array([post1, post2])
    # end
  end

end
