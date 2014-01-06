require 'spec_helper'

describe Metaforce::Login do
  let(:klass) { described_class.new('foo', 'bar', 'whizbang') }

  describe '.login' do
    before do
      savon.expects(:login).
          with(:username => 'foo', :password => 'barwhizbang').
          returns(:success)
    end

    subject { klass.login }

    it { should be_a Hash }

    its([:sessionId]) do
      should == '00DU0000000Ilbh!AQoAQHVcube9Z6CRlbR9Eg'\
                '8ZxpJlrJ6X8QDbnokfyVZItFKzJsLH'\
                'IRGiqhzJkYsNYRkd3UVA9.s82sbjEbZGUqP3mG6TP_P8'
    end

    its([:metadataServerUrl]) do
      should == \
          'https://na12-api.salesforce.com/services/Soap/m/29.0/00DU0000000Albh'
    end

    its([:serverUrl]) do
      should == \
          'https://na12-api.salesforce.com/services/Soap/u/29.0/00DU0000000Ilbh'
    end
  end
end
