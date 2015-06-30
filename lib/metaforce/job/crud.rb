module Metaforce
  class Job::CRUD < Job
    def initialize(client, method, args)
      super(client)
      @method, @args = method, args
    end

    # All CRUD operations are synchronous starting with version 31, so this can
    # just send the method directly to the client
    def perform
      @client.send(@method, *@args)
    end
  end
end
