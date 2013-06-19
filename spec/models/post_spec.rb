require "spec_helper"

describe Post do
	let(:current_user) { FactoryGirl.create(:user) }

	context 'association' do
		it { should belong_to(:creator) }
		it { should belong_to(:receiver) }
		it { should belong_to(:user) }
		it { should belong_to(:parent) }
		it { should belong_to(:group) }
		it { should have_many(:replies) }
	end

	context 'validation message' do
		let(:invalid_post) { FactoryGirl.build(:post, message: nil) }
		let(:valid_post) { FactoryGirl.build(:post) }
		
		it { invalid_post.should_not be_valid }
		it { valid_post.should be_valid }
	end
end