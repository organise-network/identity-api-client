# frozen_string_literal: true

require File.expand_path("#{File.dirname(__FILE__)}/spec_helper")

describe IdentityApiClient::Member do
  subject(:client) { IdentityApiClient.new(host: 'test.com', api_token: '1234567890abcdef') }

  let(:headers) { { content_type: 'application/json; charset=utf-8' } }
  let(:method) { :post }
  before(:each) do
    stub_request(method, request_path).with(body: expected_request)
                                      .to_return(body: body, status: status, headers: headers)
  end

  describe 'create_trace' do
    subject(:create_trace) do
      client.member.create_trace(email: email, kind: kind, happened_at: happened_at, address: address)
    end

    let(:request_path) { 'https://test.com/api/member_traces' }
    let(:body) { '' }
    let(:email) { 'test@example.org' }
    let(:kind) { 'network_unverified_signup' }
    let(:address) { nil }
    let(:happened_at) { '2023-01-01' }
    let(:expected_request) do
      {
        email: 'test@example.org',
        kind: 'network_unverified_signup',
        details: '',
        happened_at: '2023-01-01',
        api_token: '1234567890abcdef',
        address: address
      }.compact.to_json
    end

    context 'internal server error' do
      let(:status) { 500 }

      it 'returns false' do
        expect(create_trace).to eq false
      end
    end

    describe 'success' do
      let(:status) { 200 }

      it 'returns true' do
        expect(create_trace).to eq true
      end

      context 'with a country' do
        let(:address) do
          {
            country: 'GB',
            source: 'Network'
          }
        end

        let(:expected_request) do
          {
            email: 'test@example.org',
            kind: 'network_unverified_signup',
            details: '',
            happened_at: '2023-01-01',
            api_token: '1234567890abcdef',
            address: {
              country: 'GB',
              source: 'Network'
            }
          }.to_json
        end

        it 'returns true' do
          expect(create_trace).to eq true
        end
      end
    end
  end

  describe 'details' do
    let(:request_path) { 'https://test.com/api/member/details' }

    describe 'failure' do
      let(:expected_request) { {} }
      let(:body) { '' }
      let(:status) { 400 }

      context 'with no email or guid passed' do
        it 'should raise error' do
          expect { client.member.details }.to raise_error 'Must have one of guid or email'
        end
      end
    end

    describe 'success' do
      let(:status) { 200 }

      context 'without load_current_consents' do
        let(:expected_request) { { 'guid' => 'abcdef1234567890', 'api_token' => '1234567890abcdef' }.to_json }
        let(:body) { fixture('details.json') }

        it 'should get member details back from the API' do
          resp = client.member.details(guid: 'abcdef1234567890')

          expect(resp.first_name).to eq('Joe')
          expect(resp.last_name).to eq('Bloggs')
          expect(resp.email).to eq('joe@bloggs.com')
        end
      end

      context 'with load_current_consents' do
        let(:expected_request) do
          { 'guid' => 'abcdef1234567890', 'api_token' => '1234567890abcdef', 'load_current_consents' => true }.to_json
        end
        let(:body) { fixture('details_with_consents.json') }

        it 'should get member details with consents back from the API' do
          resp = client.member.details(guid: 'abcdef1234567890', load_current_consents: true)

          expect(resp.first_name).to eq('Joe')
          expect(resp.last_name).to eq('Bloggs')
          expect(resp.email).to eq('joe@bloggs.com')

          expect(resp.consents.count).to eq 2
          expect(resp.consents[0].public_id).to eq 'terms_of_service_1.0'
        end
      end

      context 'with email passed' do
        let(:expected_request) { { 'email' => 'test@example.com', 'api_token' => '1234567890abcdef' }.to_json }
        let(:body) { fixture('details.json') }

        it 'should get member details back from the API' do
          resp = client.member.details(email: 'test@example.com')

          expect(resp.first_name).to eq('Joe')
          expect(resp.last_name).to eq('Bloggs')
          expect(resp.email).to eq('joe@bloggs.com')
        end
      end
    end
  end
end
