###
#  a little abstract syntax tree for wikitext/script

module Wikitree

class Node
end


class Text < Node     ## Text run/segement
  def initialize( text )
    @text = text
  end

  def to_text
    ## todo: fix remove possible html stuff - why? why not?
    @text
  end
  def to_wiki() @text; end

  def inspect
    @text.inspect
  end
end


class Page < Node     ## wiki page link - use a different name - why? why not?
  def initialize( name, alt_name=nil )
    @name     = name
    @alt_name = alt_name
  end

  def to_text
    text = @alt_name ? @alt_name : @name
    " #{text} "  ## note: wrap for now in leading and trailing space!! - fix space issue sometime!!
  end
  def to_wiki
    if @alt_name
      "[[#{@name}|#{@alt_name}]]"
    else
      "[[#{@name}]]"
    end
  end

  def inspect
    if @alt_name
      "#<page #{@name} | #{@alt_name}>"
    else
      "#<page #{@name}>"
    end
  end
end


class Template < Node
  attr_reader :name,
              :params

  class Param  ## use a nested param class - why? why not?
    attr_reader :num,     ## note: starts with 1 (NOT 0)
                :name,
                :value
    def initialize( num, name, value )
      @num   = num     # todo/check: rename to index or such - why? why not?
      @name  = name
      @value = value
    end

    def inspect
      if @name
        "#<_#{num} (#{@name}): #{@value.inspect}>"
      else
        "#<_#{num}: #{@value.inspect}>"
      end
    end

    def pretty_print(pp)
      if @name
        pp.text "#<_#{num} (#{@name}): "
      else
        pp.text "#<_#{num}: "
      end
      pp.breakable
      pp.pp @value
      pp.text ">"
    end

    def to_text
      if value.empty?     ## note: value might be nil (convert to "")
        ''
      else
        value.map { |node| node.to_text }.join
      end
    end
    def to_wiki
      if value.empty?     ## note: value might be nil (convert to "")
        ''
      else
        value.map { |node| node.to_wiki }.join
      end
    end

  end  ## (nested) lass Param


  def initialize( name, params )
    @name   = name
    @params = []
    params.each_with_index do |param,i|
      @params << Param.new( i+1, param[0], param[1] )
    end
  end

  def inspect
    "#<template #{@name}: #{@params.inspect}>"
  end

  def pretty_print(pp)
      pp.text "#<template "
      pp.text "#{name}: "
      pp.breakable
      pp.pp @params
      pp.text ">"
  end

  def to_text
    ## build a template method name (e.g. add _ prefix and change space to _ too)
    ##   and dowcase e.g. Infobox country => infobox_country
    method_name = "_#{@name.downcase.gsub( ' ', '_' )}".to_sym
    if respond_to?( method_name  )
       send( method_name )  ## todo/fix: add args too!!!
    else
      ## rebuild template as string
      buf = String.new('')
      buf << "!!{{"
      buf << "#{@name}"
      @params.each do |param|
        buf << " | "
        if param.name
          buf << param.name
          buf << "="
        end
        buf << param.to_text  ## note. param.to_text ONLY returns value (NOT name incl.)
      end
      buf << "}}"
      buf
    end
  end

  def to_wiki
    ## rebuild template as string
    buf = String.new('')
    buf << "{{"
    buf << "#{@name}"
    @params.each do |param|
      buf << " | "
      if param.name
        buf << param.name
        buf << "="
      end
      buf << param.to_wiki  ## note. param.to_text ONLY returns value (NOT name incl.)
    end
    buf << "}}"
    buf
  end
end # class Template

end # module Wikitext

