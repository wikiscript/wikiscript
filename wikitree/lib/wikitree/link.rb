module Wikitree



class Link < Node     ## fix: change to just weblink / Link - why? why not? - web link - use a different name just link - why? why not?
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
      "#<link #{@href} | #{@alt_text}>"
    else
      "#<link #{@href}>"
    end
  end
end


end # module Wikitext
