# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  context 'validations' do
    # Uniqueness
    it do
      is_expected.to validate_uniqueness_of(:login)
        .case_insensitive
    end
    it do
      is_expected.to validate_uniqueness_of(:github_id)
    end

    # Required fields
    it { is_expected.to validate_presence_of(:login) }
    it { is_expected.to validate_presence_of(:github_id) }
    it { is_expected.to validate_presence_of(:github_token) }
    it { is_expected.to validate_presence_of(:github_url) }
    it { is_expected.to validate_presence_of(:avatar_url) }

    # Has many courses
    it { is_expected.to have_many(:courses).dependent(:destroy) }
  end

  describe '.find_or_create_by' do
    let(:payload) do
      OmniAuth.config.mock_auth[:github]
    end

    it 'creates a new record if it doesn\'t exist' do
      user = User.find_or_create_by(payload)
      expect(user.persisted?).to eq(true)
    end
    it 'returns an existing record details if any' do
      existing_user = create(:user)
      payload[:uid] = existing_user.github_id
      user = User.find_or_create_by(payload)
      expect(existing_user).to eq(user)
    end
  end

  describe '#token' do
    it 'returns `github_token` field' do
      expect(user.token).to eq(user.github_token)
    end
  end

  describe '#to_param' do
    it 'returns `login` field' do
      expect(user.to_param).to eq(user.login)
    end
  end
end
