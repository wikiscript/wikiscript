module Wikitree

class Page < Node     ##  change to Pagelink - why? wiki page link - use a different name - why? why not?
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


end # module Wikitext
