module MediumSdk
  autoload :Client, 'medium_sdk/client'
  autoload :Connection, 'medium_sdk/connection'

  VERSION = '0.0.1'

  class << self
    def new(opts = {})
      MediumSdk::Client.new opts
    end
  end
end
