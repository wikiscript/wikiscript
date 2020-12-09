###
#  a little abstract syntax tree for wikitext/script

module Wikitree


class Node
  # Node children list; # redefined in descendants
  def children() []; end

  def to_text()  "!! FIX: to be done"; end
  def to_wiki()  "!! FIX: to be done"; end
end  ## class Node



class Collection < Node   ## "composite/compound/collection) node with children
  attr_reader :children

  def initialize( children )
    @children = children
  end
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


end # module Wikitext

