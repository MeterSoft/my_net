require 'spec_helper'

describe GroupsController do

  let(:user) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group) }
  let(:group_admin) { FactoryGirl.create(:group, admin_id: user.id) }
  let!(:group_users) { FactoryGirl.create(:group_user, user_id: user.id, group_id: group_admin.id) }
  # let(:group_attr) { FactoryGirl.attributes_for(:group, group_name: 'group_attr') }
  let(:group_build) { FactoryGirl.build(:group) }

  before (:each) {
    controller.stub(:current_user).and_return(user)
    controller.stub(:authenticate_user!).and_return(true)
  }

  
  context "#index" do
    before(:each) { get :index }

    it "responds http success" do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the index template" do
      expect(response).to render_template("index")
    end

    it "loads all of the groups what current_user created" do
      expect(assigns(:created_groups)).to eq([group_admin])
    end

    it 'load user unconnected_groups' do
      expect(assigns(:unconnected_groups)).to eq([group])
    end
  end

  context "#new" do
    before(:each) { get :new }

    it "responds http success" do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the index template" do
      expect(response).to render_template("new")
    end
  end

  context "#show" do
    it "responds http success" do
      get :show, id: group.id
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the show template" do
      get :show, id: group.id
      expect(response).to render_template("show")
    end

    it "get @groups" do
      get :show, id: group.id
      expect(assigns(:groups)).to eq([group_admin])
    end

    it "get @members in group_admin" do
      get :show, id: group_admin.id
      expect(assigns(:members)).to eq([user])
    end

    it "get nil @members in group" do
      get :show, id: group.id
      expect(assigns(:members)).to be_empty
    end
  end

  context "#create" do
    it "save group with attr" do
      post :create
      expect(group_build.save).to be_true
    end
  end

  context "#edit" do
    before(:each) { get :edit, id: group_admin }

    it "responds http success" do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the edit template" do
      expect(response).to render_template("edit")
    end

    it "attributes must be present" do
      expect(assigns(@group)).to be_true
    end
  end

  context "#update" do
    let(:group_attr) { FactoryGirl.attributes_for(:group, group_name: 'update') }
    before(:each) { put :update, id: group_admin.id, group: group_attr }
    
    it "save new group attributes" do
      should redirect_to(group_path(group_admin))
    end

    it "check updated attributes" do
      group_admin.reload
      expect(group_admin.group_name).to eq('update') 
    end
  end

  context "#destroy" do
    it "deletes group" do
      expect { delete :destroy, id: group_admin }.to change(Group,:count).by(-1)
    end

    it "expect redirect after delete" do
      delete :destroy, id: group_admin
      response.should redirect_to(groups_path)
    end
  end
end