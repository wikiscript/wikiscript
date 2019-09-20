# encoding: utf-8

module Wikiscript

  class Client

    include LogUtils::Logging

    SITE_BASE = 'http://{lang}.wikipedia.org/w/index.php'

    ### API_BASE  = 'http://en.wikipedia.org/w/api.php'

    def initialize( opts={} )
      @opts   = opts
      @worker = Fetcher::Worker.new
    end

    ## change to: wikitext or raw why? why not? or to raw? why? why not?
    def text( title, lang: Wikiscript.lang )
      ## todo/fix: convert spaces to _ if not present for wikipedia page title - why ?? why not ???

      ## note: replace lang w/ lang config if present e.g.
      ##   http://{lang}.wikipedia.org/w/index.php
      # becomes
      #   http://en.wikipedia.org/w/index.php  or
      #   http://de.wikipedia.org/w/index.php  etc
      base_url = SITE_BASE.gsub( "{lang}", lang )
      params   = { action: 'raw',
                   title:  title }

      get( base_url, params )
    end

private
    def build_query( h )
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

      response = @worker.get_response( uri_string )

      if response.code == '200'
        t = response.body
        ###
        # NB: Net::HTTP will NOT set encoding UTF-8 etc.
        # will mostly be ASCII
        # - try to change encoding to UTF-8 ourselves
        logger.debug "t.encoding.name (before): #{t.encoding.name}"
        #####
        # NB: ASCII-8BIT == BINARY == Encoding Unknown; Raw Bytes Here

        ## NB:
        # for now "hardcoded" to utf8 - what else can we do?
        # - note: force_encoding will NOT change the chars only change the assumed encoding w/o translation
        t = t.force_encoding( Encoding::UTF_8 )
        logger.debug "t.encoding.name (after): #{t.encoding.name}"
        ## pp t
        t
      else
        logger.error "fetch HTTP - #{response.code} #{response.message}"
        nil
      end
    end

  end # class Client
end # Wikiscript
