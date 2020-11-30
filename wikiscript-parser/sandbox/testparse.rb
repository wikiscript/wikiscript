$LOAD_PATH.unshift( "./lib" )
$LOAD_PATH.unshift( "../wikitree/lib" )

require 'wikiscript/parser'



module TemplateHelper
  ### add "built-in" template functions
  def _increase()
    " <UP> "
  end

  def _cite_web( *args, **kwargs )
    " <CITE_WEB> "
  end

  def _note( *args )
    " <NOTE> "
  end

  def _ref_label( *args )
    " <REF_LABEL> "
  end
end


module Wikitree
class Template
  include TemplateHelper
end # class Template
end # module Wikitree





path = '../wikipedia/infoboxes/en/Austria.txt'
## path = '../wikipedia/infoboxes/en/Belgium.txt'

text = File.open( path, 'r:utf-8') { |f| f.read }

puts text[0..200]
puts

nodes = Wikiscript.parse( text )
puts "#{nodes.size} node(s):"
pp nodes

infobox = nodes[0]


puts "#{infobox.name} - #{infobox.params.size} param(s):"

infobox.params.each_with_index do |param,i|
  puts "  [#{i+1}] #{param.name}:"
  puts "text: #{param.to_text}"
  puts "source: #{param.to_wiki}"
  puts
end

puts "bye"

