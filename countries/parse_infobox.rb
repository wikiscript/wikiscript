$LOAD_PATH.unshift( "./wikiscript-parser/lib" )
$LOAD_PATH.unshift( "./wikitree/lib" )

require 'wikiscript/parser'


require_relative 'templates'    ## wikipedia template helpers


module Wikitree
class Template
  include TemplateHelper
end # class Template
end # module Wikitree


def parse_infobox( text )   ## note: returns a data hash
  puts "==> parse_infobox:"
  puts text[0..200]
  puts

  parser = Wikiscript::Parser.new( text )
  nodes = parser.parse

  puts "#{nodes.size} node(s):"
  ## pp nodes

  refs = Wikiscript::References.new( nodes )  ## note: (SIDE EFFECT!) will auto-number reference (nodes)

  infobox = Wikiscript::Infobox.new( nodes[0] )
  data = infobox.to_json

  ## adding refs
  puts "adding refs:"
  refs = refs.to_json
  pp refs
  data.merge!( refs )
  data
end



rows = [
 ['Austria', 'Europe'],
 ['Belgium', 'Europe'],
 ['France', 'Europe'],
 ['United_Kingdom', 'Europe'],

 ['United_States', 'North America'],
 ['Mexico', 'North America'],

 ['Argentina', 'South America'],
]


rows.each do |row|
  name = row[0]
  path = "./wikipedia/infoboxes/en/#{name}.txt"

  text = File.open( path, 'r:utf-8') { |f| f.read }
  data = parse_infobox( text )

  File.open( "./countries/tmp2/#{name}.json", 'w:utf-8') { |f| f.write( JSON.pretty_generate( data )) }
end

puts "bye"

