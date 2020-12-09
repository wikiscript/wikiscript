module Wikitree


class Template < Collection
  attr_reader :name
  alias_method :params, :children   ### convenience alias for children


  def initialize( name, params )
    super( Param.build( params))   ## note: build/wrap into struct from simple/plain array
    @name = name
  end

  def inspect
    "#<template #{@name}: #{@children.inspect}>"
  end

  def pretty_print(pp)
      pp.text "#<template "
      pp.text "#{name}: "
      pp.breakable
      pp.pp @children
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

       @children.each do |param|
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
      @children.each do |param|
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
    @children.each do |param|
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

