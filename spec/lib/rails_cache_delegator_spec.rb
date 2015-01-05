require 'rails_helper'

RSpec.describe RailsCacheDelegator do
  let(:request) { Typhoeus::Request.new('example.com') }
  let(:response) { Typhoeus::Response.new(body: 'test data from www.example.com') }
  let(:rails_cache_delegator) { described_class.new(Rails.cache) }

  describe '#set(request, response)' do
    after { rails_cache_delegator.set(request, response) }

    it 'writes to cache' do
      expect(rails_cache_delegator.__getobj__)
        .to receive(:write)
        .with(request.hash,
              response,
              expires_in: described_class.const_get('EXPIRATION_TIME').minutes)
    end
  end

  describe '#get(request)' do
    before { rails_cache_delegator.set(request, response) }
    after { rails_cache_delegator.get(request) }

    it 'reads from cache' do
      expect(rails_cache_delegator.__getobj__)
        .to receive(:read)
        .with(request.hash)
        .and_return(response)
    end
  end
end
