require 'spec_helper'

describe Group do

	let(:user) { FactoryGirl.create(:user) }
	let(:group) { FactoryGirl.create(:group) }

	context "associations" do
	  it { should have_many(:users) }
	  it { should have_many(:group_user) }
	  it { should have_many(:posts) }
	end

	context 'validation' do
	  it 'should valid' do
	    FactoryGirl.build(:group).should be_valid
	  end

	  it 'should not valid group_name' do
	    FactoryGirl.build(:group, group_name: '').should_not be_valid
	  end

	  it 'should not valid group_description' do
	    FactoryGirl.build(:group, group_description: '').should_not be_valid
	  end

	  it 'should not valid group_type' do
	    FactoryGirl.build(:group, group_type: '').should_not be_valid
	  end
	end

	context "members" do
	  it "should not have user" do
	  	group.members.should_not eq([user])
	  end

	  it 'should have user' do
	    group.members << user
	  	group.members.should eq([user])
	  end
	end

	context 'include_user?' do
	  it 'should_not include' do
	    group.include_user?(user).should be_false
	  end

	  it 'should include' do
	  	group.members << user
	    group.include_user?(user).should be_true
	  end
	end

	context 'group type' do
	  let(:group_private) { FactoryGirl.create(:group, group_type: Group::PRIVATE) }
	  
	  it 'group type should be public' do
	    group.public?.should eq(true)
	  end

	  it 'group type should be private' do
	    group_private.private?.should be_true
	  end
	end

end
