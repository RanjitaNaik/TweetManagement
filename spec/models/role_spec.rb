require 'rails_helper'

RSpec.describe Role, type: :model do
  describe 'relationships' do
    it { expect(described_class.reflect_on_association(:resource).macro).to eq :belongs_to }
  end
end
