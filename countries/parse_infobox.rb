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
# ['Austria','Europe']
#  'Belgium'
#  'Mexico'
#  'France'
#  'United_States'
  ['Argentina', 'South America']
#   ['United_Kingdom', 'Europe']

name = row[0]
path = "./wikipedia/infoboxes/en/#{name}.txt"


text = File.open( path, 'r:utf-8') { |f| f.read }

puts text[0..200]
puts

parser = Wikiscript::Parser.new( text )
nodes = parser.parse



puts "#{nodes.size} node(s):"
pp nodes

infobox = nodes[0]


puts "#{infobox.name} - #{infobox.params.size} param(s):"

data = {}
## note: add name of template as first virtual/auto para!!!!
##  might be Infobox country/dependency/settlement etc.
data['template'] = infobox.name.downcase


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



def ref_node_to_json( refnode )
   nodes = refnode.children
   ## check for cite templates
   cites = nodes.select { |node|
                            node.is_a?( Wikitree::Template) &&
                            node.name.downcase.start_with?( 'cite')
                        }
   if cites.size > 1
     puts "!! ERROR - only one cite (web/book/etc.) expected per ref, found #{cites.size}:"
     pp refnode
     exit 1
   end

  if cites.size == 0
      ## try convert to text
      puts "==> convert to text:"
      pp refnode
      sanitize( refnode.children.map {|node| node.to_text }.join( ' ' ) )
  else
     cite = cites[0]
     data = {}
     data[ 'template' ] = cite.name.downcase

     cite.params.each_with_index do |param,i|
       puts "  [#{i+1}] #{param.name}:"
       puts "text: #{param.to_text}"
       puts "source: #{param.to_wiki}"
       puts
       data[ param.name ] = sanitize( param.to_text )
     end
     data
  end
end


def refs_to_json( refs )
  ### reorder refs
  ##  lets note (if present go first)
  weight = {'note'=> 1,
            'auto'=> 99999 }

  groups = refs.keys.sort do |l,r|
                            ## if not found (assume stable sort - use weight 100)
                             (weight[l]||100) <=> (weight[r]||100)
                          end

  data = {}

  groups.each do |group|
     name =  if group == 'auto'
               'references'
            else
               group  ## use group name
            end

    h = data[ name ] = {}

    refs[group].each do |_,rec|  ## note: ignore ref name for now (thus, _)
      idx  = rec[:index]
      node = rec[:node]

      if node.nil? || node == '??'
          puts "!! WARN - missing ref source in (#{name}) - #{rec.inspect}"
          h["[^#{idx}]"] = "??"
      else
          h["[^#{idx}]"] = ref_node_to_json( node )
      end
    end
  end
  data
end




## adding refs
puts "adding refs:"
refs = refs_to_json( parser.refs )
pp refs
data.merge!( refs )


File.open( "./countries/tmp2/#{name}.json", 'w:utf-8') { |f| f.write( JSON.pretty_generate( data )) }


puts "bye"



