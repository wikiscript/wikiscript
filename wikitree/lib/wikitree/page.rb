module Wikitree


## quick hack
##    add alt_text options true|false
##         if false than do NOT use alt text for to_text

def self.alt_text()  defined?(@alt_text) ? @alt_text : true; end
def self.alt_text?()  alt_text; end
def self.alt_text=(value)  @alt_text = value; end



class Page < Node     ##  change to Pagelink - why? wiki page link - use a different name - why? why not?
  def initialize( name, alt_text=nil )
    @name     = name   ## use page_name - why? why not?
    @alt_text = alt_text
  end


  def to_text_v0
    text = @alt_text ? @alt_text : @name
    " #{text} "
  end

  def to_text
    ## note: wrap for now in leading and trailing space!! - fix space issue sometime!!
    puts "[debug] Page#to_text  alt_text? #{Wikitree.alt_text?}"
    if @alt_text  &&  Wikitree.alt_text?
      " #{@alt_text} "
    else
      ## " ‹#{@href}› "
      " #{@name} "
    end
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
