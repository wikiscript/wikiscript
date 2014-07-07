# encoding: utf-8

## stdlibs

require 'net/http'
require 'uri'
require 'cgi'
require 'pp'


## 3rd party gems/libs
## require 'props'

require 'logutils'
require 'fetcher'

# our own code

require 'wikiscript/version' # let it always go first
require 'wikiscript/client'
require 'wikiscript/page'


module Wikiscript

  def self.banner
    "wikiscript/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(__FILE__)) )}"
  end


  ## for now make lang a global - change why? why not??
  def self.lang=(value)
    @@lang = value.to_s     # use to_s - lets you pass ing :en, :de etc.
  end

  def self.lang
    # note: for now always returns a string e.g. 'en', 'de' etc. not a symbol
    @@lang ||= 'en'
  end

end # module Wikiscript



puts Wikiscript.banner
