# encoding: utf-8

module Wikiscript

  class Page

    include LogUtils::Logging

    attr_reader :title, :lang


    def self.get( title, lang: Wikiscript.lang )    ## todo/check: add a fetch/download alias - why? why not?
      o = new( title: title, lang: lang )
      o.get  ## "force" refresh text (get/fetch/download)
      o
    end

    def self.read( path )
      text = File.open( path, 'r:utf-8' ).read
      o = new( text, title: "File:#{path}" )   ## use auto-generated File:<path> title path - why? why not?
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
      @text ||= get        # cache text (from request)
    end

    def nodes
      @nodes ||= parse     # cache text (from parse)
    end

    def each   ## loop over all nodes / elements -note: nodes is a (flat) list (array) for now
      nodes.each do |node|
        yield( node )
      end
    end


    def get    ## "force" refresh text (get/fetch/download)
      @nodes = nil  ## note: reset cached parsed nodes too

      @text = Client.new.text( @title, lang: @lang )
      @text
    end
    alias_method :fetch,    :get
    alias_method :download, :get


    def parse   ## todo/change: use/find a different name e.g. doc/elements/etc. - why? why not?
      @nodes = PageReader.parse( text )
      @nodes
    end
  end # class Page
end # Wikiscript
