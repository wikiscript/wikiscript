module Wikitree


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
    ##                    Lang-en         => lang_en
    method_name = "_#{@name.downcase.gsub( /[ -]/, '_' )}".to_sym
    if respond_to?( method_name  )

       ## build args / kwargs
       args   = []
       kwargs = {}

       @params.each do |param|
         if param.name
           param_name  = param.name.downcase.gsub( /[ -]/, '_' ).to_sym
           kwargs[ param_name ] = param.to_text
         else
           args << param.to_text
         end
       end

       puts "==> calling template >#{method_name}< with #{args.size} arg(s), #{kwargs.size} kwarg(s):"
       pp args
       pp kwargs

       text = if args.empty? && kwargs.empty?
               send( method_name )
              elsif args.size > 0 && kwargs.empty?
               send( method_name, *args )
              elsif args.empty? && kwargs.size > 0
               send( method_name, **kwargs )
              else  ## assume full-monty/both
               send( method_name, *args, **kwargs )
              end
       puts "   returns: >#{text}<"
       text
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

end # module Wikitree

