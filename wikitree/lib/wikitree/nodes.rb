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
  def initialize( name, alt_text=nil )
    @name     = name   ## use page name - why? why not?
    @alt_text = alt_text
  end

  def to_text
    text = @alt_text ? @alt_text : @name
    " #{text} "  ## note: wrap for now in leading and trailing space!! - fix space issue sometime!!
  end
  def to_wiki
    if @alt_text
      "[[#{@name}|#{@alt_text}]]"
    else
      "[[#{@name}]]"
    end
  end

  def inspect
    if @alt_text
      "#<page #{@name} | #{@alt_text}>"
    else
      "#<page #{@name}>"
    end
  end
end


class Weblink < Node     ## web link - use a different name just link - why? why not?
  def initialize( href, alt_text=nil )
    @href     = href
    @alt_text = alt_text   ## todo/check/fix: might just be text NOT alt_text - why? why not?!!!!
  end

  def to_text
    ## keep link - just output alt_text - why? why not?
    if @alt_text
      ## note: do not use HTML-style <> - for now use french style ‹›
      ## " ‹#{@href}› #{@alt_text} "
      " #{@alt_text} "
    else
      ## " ‹#{@href}› "
      " "
    end
  end
  def to_wiki
    if @alt_text
      "[#{@href} #{@alt_text}]"
    else
      "[#{@href}]"
    end
  end

  def inspect
    if @alt_text
      "#<weblink #{@href} | #{@alt_text}>"
    else
      "#<weblink #{@href}>"
    end
  end
end



class Ref < Node     ## Ref (Citation footnote)
  def initialize( nodes=[] )
    @nodes = nodes
  end

  def to_text
    ## todo/fix:  return [1], [2] or [a], [b] or such
    "[*]"
  end
  def to_wiki
    text = @nodes.map{|node| node.to_wiki}.join( ' ' )
    "<ref>#{text}</ref>"
  end

  def inspect
    "#<ref #{@nodes.inspect}>"
  end

  def pretty_print(pp)
    pp.text "#<ref: "
    pp.breakable
    pp.pp @nodes
    pp.text ">"
  end
end



end # module Wikitext

