require 'spec_helper'

describe Setting do
  context 'associations' do
  	it { should belong_to :user }
  end
end
