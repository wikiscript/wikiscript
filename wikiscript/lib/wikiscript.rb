## stdlibs via cocos
require 'cocos'


## 3rd party gems/libs
## require 'props'

require 'logutils'

module Wikiscript
  Logging = LogUtils::Logging
end



# our own code
require_relative 'wikiscript/version' # let it always go first
require_relative 'wikiscript/client'
require_relative 'wikiscript/table_reader'
require_relative 'wikiscript/page_reader'
require_relative 'wikiscript/outline_reader'
require_relative 'wikiscript/page'



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


  def self.unlink( text )
    ## replace ALL wiki links with title (or link)
    ##  e.g. [[Santiago]] ([[La Florida, Chile|La Florida]])
    ##   =>    Santiago (La Florida)
    text = text.gsub( LINK_PATTERN ) do |_|
      link  = $~[:link]
      title = $~[:title]

      if title
        title
      else
        link
      end
    end

    text.strip
  end
  class << self
    alias_method :flatten_links, :unlink
  end

  def self.parse_link( text )     ## todo/change: find a better name - use match_link/etc. - why? why not?
    ##  find first matching link
    ##   return [nil,nil] if nothing found
    if (m = LINK_PATTERN.match( text ))
      link  = m[:link]
      title = m[:title]

      link  = link.strip     ## remove leading and trailing spaces
      title = title.strip   if title
      [link,title]
    else
      [nil,nil]
    end
  end

  ############################
  ## more convenience shortcuts / helpers
  def self.parse( text )        PageReader.parse( text );  end
  def self.parse_table( text )  TableReader.parse_table( text );  end

  def self.read( path )                             Page.read( path ); end
  def self.get( title, lang: Wikiscript.lang )      Page.get( title, lang: lang ); end
  class << self
    alias_method :fetch,    :get
    alias_method :download, :get
  end

end # module Wikiscript



## add camelcase alias
WikiScript = Wikiscript


puts Wikiscript.banner
