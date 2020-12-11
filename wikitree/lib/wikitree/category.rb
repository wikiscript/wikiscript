module Wikitree


class Category < Node     ##  change to Categorylink - why? why not?
  def initialize( name, alt_text=nil )
    @name     = name   ## use category_name - why? why not?
    @alt_text = alt_text
  end

  def to_text
    text = @alt_text ? @alt_text : @name
    " #{text} "  ## note: wrap for now in leading and trailing space!! - fix space issue sometime!!
  end
  def to_wiki
    if @alt_text
      "[[Category:#{@name}|#{@alt_text}]]"
    else
      "[[Category:#{@name}]]"
    end
  end

  def inspect
    if @alt_text
      "#<category #{@name} | #{@alt_text}>"
    else
      "#<category #{@name}>"
    end
  end
end

end # module Wikitext
