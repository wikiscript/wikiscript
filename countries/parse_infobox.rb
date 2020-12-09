$LOAD_PATH.unshift( "./wikiscript-parser/lib" )
$LOAD_PATH.unshift( "./wikitree/lib" )

require 'wikiscript/parser'


require_relative 'templates'    ## wikipedia template helpers


module Wikitree
class Template
  include TemplateHelper
end # class Template
end # module Wikitree



def sanitize( txt )
  puts "  [debug] sanitize"

  ## <div style=\"display:inline-block;margin-top:0.4em;\"> center </div>
  txt = txt.gsub( /<div[^\/>]*>
               ([^\<]*)
             <\/div>/xim ) do |m|
          puts "  remove div container: #{m}"
          $1  # remove enclosing div; keep content!!
        end
  ## <sup>2</sup>
  txt = txt.gsub( /<sup>
                     ([^\<]*)
                   <\/sup/xim ) do |m|
                      $1  # remove sup; keep content!!
                   end

  ## replace br(reaks) with ++ (NOT space) for now - why? why not?
  ##  <br/>
  txt = txt.gsub(  /<br[ ]*\/>/i ) do |_|
             ' ++ '
        end

  ## remove emphasis/bold
  txt = txt.gsub( /'{2,}/, '' )

  ## squish
  ##  add non-breaking space too (if ever present) ??
  txt = txt.gsub( /[ \t\n\r]{2,}/, ' ' )
  txt.strip
end



row =
 ['Austria','Europe']
#  'Belgium'
#  'Mexico'
#  'France'
#  'United_States'
#  'Argentina'
#   ['United_Kingdom', 'Europe']

name = row[0]
path = "./wikipedia/infoboxes/en/#{name}.txt"


text = File.open( path, 'r:utf-8') { |f| f.read }

puts text[0..200]
puts

nodes = Wikiscript.parse( text )



puts "#{nodes.size} node(s):"
pp nodes

infobox = nodes[0]


puts "#{infobox.name} - #{infobox.params.size} param(s):"

data = {}

infobox.params.each_with_index do |param,i|
  puts "  [#{i+1}] #{param.name}:"
  puts "text: #{param.to_text}"
  puts "source: #{param.to_wiki}"
  puts

  data[ param.name ] = sanitize( param.to_text )
end

## data filter - remove empty items
data = data.reduce({}) do |h,(name,value)|
                            if value.empty?
                              puts "  skipping/removing >#{name}< - empty"
                            else
                              h[name] = value
                            end
                            h
                        end


File.open( "./countries/tmp2/#{name}.json", 'w:utf-8') { |f| f.write( JSON.pretty_generate( data )) }


puts "bye"



