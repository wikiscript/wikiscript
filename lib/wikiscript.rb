## stdlibs

require 'net/http'
require 'uri'
require 'json'
require 'pp'
require 'ostruct'


## 3rd party gems/libs
## require 'props'

require 'logutils'


# our own code

require 'wikiscript/version' # let it always go first
require 'wikiscript/client'


module Wikiscript

  def self.banner
    "wikiscript/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(__FILE__)) )}"
  end
  
end # module Wikiscript



puts Wikiscript.banner
