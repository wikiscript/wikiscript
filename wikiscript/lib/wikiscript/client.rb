
module Wikiscript

  class Client
    include Logging

    SITE_BASE = 'https://{lang}.wikipedia.org/w/index.php'

    ### API_BASE  = 'http://en.wikipedia.org/w/api.php'


    ## change to: wikitext or raw why? why not? or to raw? why? why not?
    def text( title, lang: Wikiscript.lang )
      ## todo/fix: convert spaces to _ if not present for wikipedia page title - why ?? why not ???

      ## note: replace lang w/ lang config if present e.g.
      ##   http://{lang}.wikipedia.org/w/index.php
      # becomes
      #   http://en.wikipedia.org/w/index.php  or
      #   http://de.wikipedia.org/w/index.php  etc
      base_url = SITE_BASE.sub( "{lang}", lang )
      params   = { action: 'raw',
                   title:  title }

      get( base_url, params )
    end

private
    def build_query( h )

      ## todo/fix - check what to use for params encode
      ##   e.g. escape_component or such?
      ##   fix add params upstream to weblclient - why? why not?
      h.map do |k,v|
        "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"
      end.join( '&' )
    end

    def get( base_url, params )
      # note: lets us passing in params as hash e.g.
      #   action: 'raw', title: 'Austria'
      #   key and values will get CGI escaped
      query = build_query( params )

      ## uri = URI.parse( "#{SITE_BASE}?#{params}" )
      ## fix: pass in uri (add to fetcher check for is_a? URI etc.)
      uri_string = "#{base_url}?#{query}"

      response = Webclient.get( uri_string )

      if response.status.ok?
        response.text
      else
        logger.error "HTTP ERROR - #{response.status.code} #{response.status.message}"
        exit 1    ### exit for now on error - why? why not?
        ## nil
      end
    end

  end # class Client
end # Wikiscript
