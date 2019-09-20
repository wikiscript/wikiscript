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
require 'wikiscript/table_reader'
require 'wikiscript/page_reader'
require 'wikiscript/page'



module Wikiscript

  ## for now make lang a global - change why? why not??
  def self.lang=(value)
    @@lang = value.to_s     # use to_s - lets you pass ing :en, :de etc.
  end

  def self.lang
    # note: for now always returns a string e.g. 'en', 'de' etc. not a symbol
    @@lang ||= 'en'
  end

  ##
  ## todo: fix? - strip spaces from link and title
  ##   spaces possible? strip in ruby later e.g. use strip - why? why not?
  ##   todo/change: find a better name - rename LINK_PATTERN to LINK_REGEX - why? why not?
  LINK_PATTERN = %r{
      \[\[
        (?<link>[^|\]]+)     # everything but pipe (|) or bracket (])
        (?:
          \|
          (?<title>[^\]]+)
        )?                   # optional wiki link title
      \]\]
    }x


  def self.unlink( value )
    ## replace ALL wiki links with title (or link)
    ##  e.g. [[Santiago]] ([[La Florida, Chile|La Florida]])
    ##   =>    Santiago (La Florida)
    value = value.gsub( LINK_PATTERN ) do |_|
      link  = $~[:link]
      title = $~[:title]

      if title
        title
      else
        link
      end
    end

    value.strip
  end


  def self.parse_link( value )     ## todo/change: find a better name - use match_link/etc. - why? why not?
    ##  find first matching link
    ##   return [nil,nil] if nothing found
    if (m = LINK_PATTERN.match( value ))
      link  = m[:link]
      title = m[:title]

      link  = link.strip     ## remove leading and trailing spaces
      title = title.strip   if title
      [link,title]
    else
      [nil,nil]
    end
  end

end # module Wikiscript



## add camelcase alias
WikiScript = Wikiscript


puts Wikiscript.banner
