module Wikitree


##############################
## Ref (Citation footnote)
##  - check: rename to RefInline or such - why? why not?
class Ref < Collection
  attr_reader :name, :group
  attr_accessor :count   ## note: read/write - gets resolved/set in pass 2

  def initialize( nodes=[], name: nil, group: nil )
    super( nodes )

    @name  = name
    @group = group

    @count = nil
  end

  def to_text
    ## todo/fix:  return [1], [2] or [a], [b] or such
    if @group
      "[#{@group}^#{@count}]"
    else
      "[^#{@count}]"
    end
  end
  def to_wiki
    text = @children.map{|node| node.to_wiki}.join( ' ' )

    parts = []
    parts << %Q{name="#{@name}"}    if @name
    parts << %Q{group="#{@group}"}  if @group

    buf = String.new('')
    buf << "<ref"
    buf << " #{parts.join(' ')}"  if parts.size > 0
    buf << ">#{text}</ref>"
  end


  def inspect
    parts = []
    parts << @name               if @name
    parts << "group: #{@group}"  if @group

    buf = String.new('')
    buf << "#<ref "
    buf << "#{parts.join( ', ' )} "   if parts.size > 0
    buf << "#{@children.inspect}>"
    buf
  end

  def pretty_print(pp)
    parts = []
    parts << @name               if @name
    parts << "group: #{@group}"  if @group

    pp.text "#<ref "
    pp.text parts.join( ', ' )   if parts.size > 0
    pp.breakable
    pp.pp @children
    pp.text ">"
  end
end


### check: rename to NamedRef or RefNamed or RefRef or  such - why? why not?
class Refname < Node
  attr_reader :name, :group
  attr_accessor :count   ## note: read/write - gets resolved/set in pass 2

  def initialize( name, group=nil )
    @name  = name
    @group = group

    @count = nil
  end

  def to_text
    ## todo/fix:  return [1], [2] or [a], [b] or such
    if @group
      "[#{@group} ^#{@count}]"  ## e.g. [note 1], [group 1] or such
    else
      "[^#{@count}]"
    end
  end
  def to_wiki
    ## todo/fix: add (optional) group too
    if @group
      %Q{<ref name="#{@name}" group="#{@group}"/>}
    else
      %Q{<ref name="#{@name}" />}
    end
  end

  def inspect
    ## todo/fix: add (optional) group too
    if @group
      "#<refname #{@name}, group: #{@group}>"
    else
      "#<refname #{@name}>"
    end
  end
end  # class Refname

end # module Wikitext
