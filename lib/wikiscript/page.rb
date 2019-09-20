# encoding: utf-8

module Wikiscript

  class Page

    include LogUtils::Logging

    attr_reader :title, :lang


    def self.get( title, lang: Wikiscript.lang )    ## todo/check: add a fetch/download alias - why? why not?
      o = new( title: title, lang: lang )
      ## o.text   ## "force" download / fetch
      o
    end


    def initialize( text=nil, title: nil, lang: Wikiscript.lang )
      ## todo: check title
      ## replace title spaces w/ _ ????
      ##  to allow "pretty" titles - why? why not??

      @text  = text
      @title = title
      @lang  = lang
    end

    def text
      @text ||= download_text   # cache text (from request)
    end

    def download_text
      Client.new.text( @title, lang: @lang )
    end

    def parse   ## todo/change: use/find a different name e.g. doc/elements/etc. - why? why not?
      PageReader.parse( text )
    end
  end # class Page
end # Wikiscript
