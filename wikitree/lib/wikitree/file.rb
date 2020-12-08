module Wikitree


class File < Node
  attr_reader :name,
              :params

  class Param  ## use a nested param class - why? why not?
    attr_reader :num,     ## note: starts with 1 (NOT 0)
                :name,
                :value
    def initialize( num, name, value )
      @num   = num     # todo/check: rename to index or such - why? why not?
      @name  = name
      @value = value
    end

    def inspect
      if @name
        "#<_#{num} (#{@name}): #{@value.inspect}>"
      else
        "#<_#{num}: #{@value.inspect}>"
      end
    end

    def pretty_print(pp)
      if @name
        pp.text "#<_#{num} (#{@name}): "
      else
        pp.text "#<_#{num}: "
      end
      pp.breakable
      pp.pp @value
      pp.text ">"
    end

    def to_text
      if value.empty?     ## note: value might be nil (convert to "")
        ''
      else
        value.map { |node| node.to_text }.join
      end
    end
    def to_wiki
      if value.empty?     ## note: value might be nil (convert to "")
        ''
      else
        value.map { |node| node.to_wiki }.join
      end
    end

  end  ## (nested) lass Param


  def initialize( name, params )
    @name   = name
    @params = []
    params.each_with_index do |param,i|
      @params << Param.new( i+1, param[0], param[1] )
    end
  end

  def inspect
    "#<file #{@name}: #{@params.inspect}>"
  end

  def pretty_print(pp)
      pp.text "#<file "
      pp.text "#{name}: "
      pp.breakable
      pp.pp @params
      pp.text ">"
  end


  def to_text
    ## todo/fix: add all args too!!!
    ##  use "french" single guillemets to avoid html angle brackets for now - why? why not?
    "‹file: #{@name}›"
  end

  def to_wiki
    ## todo/fix: add all args too!!!
    "[[File:#{name}]]"
  end
end # class File

end # module Wikitree

