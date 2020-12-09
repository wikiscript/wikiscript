module Wikitree


class Param < Collection
  attr_reader :num,     ## note: starts with 1 (NOT 0)
              :name


  ### helper build params structs / nodes
  ##    (from simple/plain array)
  def self.build( params )
    children = []
    params.each_with_index do |param,i|
      children << Param.new( i+1, param[0], param[1] )
    end
    children
  end



  def initialize( num, name, nodes )
    super( nodes )

    @num   = num     # todo/check: rename to index or such - why? why not?
    @name  = name
  end

  def inspect
    if @name
      "#<_#{num} (#{@name}): #{@children.inspect}>"
    else
      "#<_#{num}: #{@children.inspect}>"
    end
  end


  def pretty_print(pp)
    if @name
      pp.text "#<_#{num} (#{@name}): "
    else
      pp.text "#<_#{num}: "
    end
    pp.breakable
    pp.pp @children
    pp.text ">"
  end

  def to_text
    if @children.empty?     ## note: value might be nil (convert to "")
      ''
    else
      @children.map { |node| node.to_text }.join
    end
  end
  def to_wiki
    if @children.empty?     ## note: value might be nil (convert to "")
      ''
    else
      @children.map { |node| node.to_wiki }.join
    end
  end

end  ## class Param

end # module Wikitext
