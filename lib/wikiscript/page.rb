# encoding: utf-8

module Wikiscript

  class Page

    include LogUtils::Logging

    attr_reader :title, :text

    def initialize( title )
      ## todo: check title
      ## replace title spaces w/ _ ????
      ##  to allow "pretty" titles - why? why not??

      @title = title
      @text  = nil
    end
    
    def text
      if @text.nil?
        # cache text (from request)
        @text = Client.new.text( @title )
      end
      @text
    end

  end # class Page
end # Wikiscript
