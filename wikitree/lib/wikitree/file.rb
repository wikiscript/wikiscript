module Wikitree


class File < Collection
  attr_reader  :name
  alias_method :params, :children   ### convenience alias for children


  def initialize( name, params )
    super( Param.build( params ))  ## note: build/wrap into struct from simple/plain array
    @name = name
  end

  def inspect
    "#<file #{@name}: #{@children.inspect}>"
  end

  def pretty_print(pp)
      pp.text "#<file "
      pp.text "#{name}: "
      pp.breakable
      pp.pp @children
      pp.text ">"
  end


  def to_text
    ## todo/fix: add all args too!!!
    ##  use "french" single guillemets to avoid html angle brackets for now - why? why not?
    "‹File: #{@name}›"
  end

  def to_wiki
    ## todo/fix: add all args too!!!
    "[[File:#{name}]]"
  end
end # class File

end # module Wikitree

