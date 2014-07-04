
module Wikiscript

  class Client

    include LogUtils::Logging

    SITE_BASE = 'http://en.wikipedia.org/w/index.php'

    ### API_BASE  = 'http://en.wikipedia.org/w/api.php'

    def initialize( opts={} )
      @opts = opts
    end

    def text( title )
      ## todo/fix: urlencode title ???
      ## fix: use params hash!!!
      get( "action=raw&title=#{title}" )
    end

private
    ### fix: reuse code from fetcher gem!!!!
    ##  do NOT duplicate!!! also cleanup jogo gem!!!!

    def get( params )
      uri = URI.parse( "#{SITE_BASE}?#{params}" )

    
      # new code: honor proxy env variable HTTP_PROXY
      proxy = ENV['HTTP_PROXY']
      proxy = ENV['http_proxy'] if proxy.nil?   # try possible lower/case env variable (for *nix systems) is this necessary??
    
      if proxy
        proxy = URI.parse( proxy )
        logger.debug "using net http proxy: proxy.host=#{proxy.host}, proxy.port=#{proxy.port}"
        if proxy.user && proxy.password
          logger.debug "  using credentials: proxy.user=#{proxy.user}, proxy.password=****"
        else
          logger.debug "  using no credentials"
        end
      else
        logger.debug "using direct net http access; no proxy configured"
        proxy = OpenStruct.new   # all fields return nil (e.g. proxy.host, etc.)
      end

      http_proxy = Net::HTTP::Proxy( proxy.host, proxy.port, proxy.user, proxy.password )

      http = http_proxy.new( uri.host, uri.port )
      response = http.request( Net::HTTP::Get.new( uri.request_uri ))

      if response.code == '200'
        t = response.body
        ## pp t
        t
      else
        logger.error "fetch HTTP - #{response.code} #{response.message}"
        nil
      end
    end

  end # class Client
end # Wikiscript
