require 'spec_helper'

describe Metaforce::Job::CRUD do
  let(:client) { double('client') }
  let(:method) { :my_method }
  let(:args) { double('args') }
  let(:instance) { described_class.new(client, method, args) }

  describe '#perform' do
    let(:response) { double('response') }

    before(:each) do
      client.stub(method).and_return(response)
    end

    it 'calls the client' do
      client.should_receive(method).with(args)

      instance.perform
    end

    it 'returns the client response' do
      instance.perform.should == response
    end
  end
end
