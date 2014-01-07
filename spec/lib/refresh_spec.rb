require 'spec_helper'

describe Metaforce::Refresh do
  let(:args) do
    {
      :refresh_token => 'refresh',
      :client_id => 'id',
      :client_secret => 'secret'
    }
  end
  let(:instance) { described_class.new(args) }
  let(:connection) { double('Faraday') }
  let(:login_url) { 'https://login.salesforce.com' }
  let(:trigger) { instance.refresh }
  let(:params) do
    URI.encode_www_form({ :grant_type => 'refresh_token' }.merge(args))
  end
  let(:success_response) do
    double(status: 200, body: { 'access_token' => 'refreshed' })
  end
  let(:failure_response) do
    double(status: 401,
           body: {
               'error' => 'Unauthorized',
               'error_description' => 'Access Denied'
           })
  end

  before(:each) do
    Faraday.should_receive(:new).with(login_url).
        and_return(connection)
  end

  it 'makes a post request to get a new access token' do
    connection.should_receive(:post) do |*args, &block|
      args.first.should == '/services/oauth2/token'
      request = OpenStruct.new(:body => nil)
      block.call(request)
      request.body.should == params
    end.and_return(success_response)

    trigger
  end

  it 'returns a hash with the new session_id/access_token' do
    connection.stub(:post).and_return(success_response)

    trigger.should == { :session_id => 'refreshed' }
  end

  context 'when the request returns an error' do
    it 'raises an error' do
      connection.stub(:post).and_return(failure_response)

      expect { trigger }.to raise_error('Unauthorized: Access Denied')
    end
  end

  context 'when an authentication callback is specified' do
    let(:callback) { double('Proc') }

    before(:each) do
      args.merge!(:authentication_callback => callback)
    end

    context 'when the request returns an error' do
      it 'does not call the authentication callback' do
        connection.stub(:post).and_return(failure_response)
        callback.should_not_receive(:call)

        expect { trigger }.to raise_error
      end
    end

    it 'calls the callback with the response body' do
      connection.stub(:post).and_return(success_response)
      callback.should_receive(:call).with('access_token' => 'refreshed')

      trigger
    end
  end
end
