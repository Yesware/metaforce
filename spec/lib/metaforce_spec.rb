require 'spec_helper'

describe Metaforce do
  describe '#new' do
    let(:klass) { described_class.new(session_id: 'foobar') }
    subject { klass }

    it { should be_a Metaforce::Client }
  end

  describe '.login' do
    let(:args) { {:username => 'foo', :password => 'foobar', :security_token => 'whizbang'} }

    context 'when environment variables are not defined' do
      it 'proxies the login call' do
        Metaforce::Login.should_receive(:new).with('foo', 'foobar', 'whizbang').and_call_original
        Metaforce::Login.any_instance.should_receive(:login)
        described_class.login args
      end
    end

    context 'when environment variables are defined' do
      before do
        ENV['SALESFORCE_USERNAME'] = args[:username]
        ENV['SALESFORCE_PASSWORD'] = args[:password]
        ENV['SALESFORCE_SECURITY_TOKEN'] = args[:security_token]
      end

      after do
        ENV.delete('SALESFORCE_USERNAME')
        ENV.delete('SALESFORCE_PASSWORD')
        ENV.delete('SALESFORCE_SECURITY_TOKEN')
      end

      it 'proxies the login call' do
        Metaforce::Login.should_receive(:new).with('foo', 'foobar', 'whizbang').and_call_original
        Metaforce::Login.any_instance.should_receive(:login)
        described_class.login
      end
    end
  end

  describe '.refresh' do
    let(:args) { { :refresh_token => 'baz' } }

    it 'proxies the refresh call' do
      mock_refresh = double('Metaforce::Refresh')
      Metaforce::Refresh.should_receive(:new).with do |*args|
        options = args.first
        options.should be_instance_of(HashWithIndifferentAccess)
        options[:refresh_token].should == 'baz'
      end.and_return(mock_refresh)
      mock_refresh.should_receive(:refresh)

      described_class.refresh(args)
    end
  end
end
