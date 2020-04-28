require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { Fabricate(:user) }
  let(:user_instance) { described_class.new }

  describe 'relationships' do
    it { expect(described_class.reflect_on_association(:tweets).macro).to eq :has_many }
  end

  it 'is valid with all the attributes' do
    user_instance.email = 'Test@example.com'
    user_instance.save
    expect(user_instance).to be_valid
  end

  it 'is not valid with out attributes' do
    expect(user_instance).to_not be_valid
  end

  describe '#admin?' do
    context 'when user is non admin' do
      it { expect(user.admin?).to eq false }
    end

    context 'when user is admin' do
      before { user.add_role(:admin) }
      it { expect(user.admin?).to eq true }
    end
  end
end
