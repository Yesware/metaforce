require 'spec_helper'

describe Metaforce::AbstractClient do
  let(:instance) { described_class.new(options) }

  describe 'private #authentication_handler' do
    context 'when the client uses a username and password' do
      let(:options) { { username: 'homer', password: 'marge' } }

      it 'returns the Metaforce::Login.authentication_handler' do
        instance.send(:authentication_handler).
            should equal Metaforce::Login.authentication_handler
      end
    end

    context 'when the client uses OAuth 2' do
      let(:options) do
        {
          refresh_token: 'refresh',
          client_id: 'id',
          client_secret: 'secret'
        }
      end

      it 'returns the Metaforce::Refresh.authentication_handler' do
        instance.send(:authentication_handler).
            should equal Metaforce::Refresh.authentication_handler
      end
    end
  end
end
