module Metaforce
  module Metadata
    class Client
      module CRUD

        # Public: Create metadata
        #
        # Examples
        #
        #   client._create_metadata(:apex_page,
        #                           :full_name => 'TestPage',
        #                           :label => 'Test page',
        #                           :content => '<apex:page>foobar</apex:page>')
        def _create_metadata(type, metadata={})
          type = type.to_s.camelize
          request :create_metadata do |soap|
            soap.body = {
              :metadata => prepare(metadata)
            }.merge(attributes!(type))
          end
        end

        # Public: Delete metadata
        #
        # Examples
        #
        #   client._delete_metadata(:apex_component, 'Component')
        def _delete_metadata(type, *args)
          type = type.to_s.camelize
          request :delete_metadata do |soap|
            soap.body = {
              :type => type,
              :full_name => args
            }
          end
        end

        # Public: Update metadata
        #
        # Examples
        #
        #   client._update_metadata(:apex_page,
        #                           :full_name => 'TestPage',
        #                           :label => 'Test page',
        #                           :content => '<apex:page>hello world</apex:page>')
        def _update_metadata(type, metadata={})
          type = type.to_s.camelize
          request :update_metadata do |soap|
            soap.body = {
              :metadata => prepare(metadata)
            }.merge(attributes!(type))
          end
        end

        # Public: Read metadata
        #
        # Examples
        #
        #   client._read_metadata(:apex_component, 'Component')
        def _read_metadata(type, *args)
          type = type.to_s.camelize
          request :read_metadata do |soap|
            soap.body = {
              :type => type,
              :full_name => args
            }
          end
        end

        def create_metadata(*args)
          Job::CRUD.new(self, :_create_metadata, args)
        end

        def read_metadata(*args)
          Job::CRUD.new(self, :_read_metadata, args)
        end

        def update_metadata(*args)
          Job::CRUD.new(self, :_update_metadata, args)
        end

        def delete_metadata(*args)
          Job::CRUD.new(self, :_delete_metadata, args)
        end

      private

        def attributes!(type)
          {:attributes! => { 'ins0:metadata' => { 'xsi:type' => "ins0:#{type}" } }}
        end

        # Internal: Prepare metadata by base64 encoding any content keys.
        def prepare(metadata)
          metadata = Array[metadata].compact.flatten
          metadata.each { |m| encode_content(m) }
          metadata
        end

        # Internal: Base64 encodes any :content keys.
        def encode_content(metadata)
          metadata[:content] = Base64.encode64(metadata[:content]) if metadata.has_key?(:content)
        end
        
      end
    end
  end
end
