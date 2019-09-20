# encoding: utf-8

module Wikiscript

  class Page

    include LogUtils::Logging

    attr_reader :title

    def initialize( title, text: nil )
      ## todo: check title
      ## replace title spaces w/ _ ????
      ##  to allow "pretty" titles - why? why not??

      @title = title
      @text  = text
    end

    def text
      @text ||= download_text   # cache text (from request)
    end

    def download_text
      Client.new.text( @title )
    end

    def parse   ## todo/change: use/find a different name e.g. doc/elements/etc. - why? why not?
      PageReader.parse( text )
    end
  end # class Page
end # Wikiscript
