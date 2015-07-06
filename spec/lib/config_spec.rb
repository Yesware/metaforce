require 'spec_helper'

describe Metaforce do
  describe '.configuration' do
    let(:api_version) { '34.0' }
    subject { Metaforce.configuration }

    before do
      Metaforce.configuration.host = nil
      Metaforce.configuration.api_version = nil
    end

    it { should set_default(:api_version).to(api_version) }

    it { should set_default(:host).to('login.salesforce.com') }

    it do
      should set_default(:endpoint).
          to("https://login.salesforce.com/services/Soap/u/#{api_version}")
    end

    it do
      should set_default(:partner_wsdl).
          to(File.expand_path("../../../wsdl/#{api_version}/partner.xml",
                              __FILE__))
    end

    it do
      should set_default(:metadata_wsdl).
          to(File.expand_path("../../../wsdl/#{api_version}/metadata.xml",
                              __FILE__))
    end
  end
end
