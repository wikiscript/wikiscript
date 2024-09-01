######
#  to run use:
#    $ ruby convert.rb


$LOAD_PATH.unshift( File.expand_path( '../wikiscript/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../wikiscript-parser/lib' ))
$LOAD_PATH.unshift( File.expand_path( '../wikitree/lib' ))
require 'wikiscript'
require 'wikiscript/parser'



require 'cocos'   ## move upstream to wikiscript!!!


require_relative 'footballbox'



def slugify( title )
  ## change to "plain ascii" dash
  slug = title.gsub( '–', '-' )
  slug
end

def parse_footballboxes( lines )
  text = lines.join( "\n" )
  nodes = Wikiscript.parse( text )

  boxes = []

  nodes.each do |node|
    if node.is_a?( Wikitree::Template )
      puts "OK template - #{node.name}"
      if node.name == 'Football box'
        puts "==> BINGO - try parse/to_json"
        box = Wikiscript::Footballbox.new( node )
        pp box.to_json   ## fix - change to as_json
        boxes << box.to_json
      end
    else
      puts "other skip - #{node.class.name}"
    end
  end
  boxes
end


def parse( title )
  slug = slugify( title )
  path = "./o/#{slug}.txt"

  nodes = Wikiscript::OutlineReader.read( path )
  pp nodes

  inside_heading = nil
  data = {}

  nodes.each do |node|
     node_type = node[0]
     if [:h1,:h2,:h3,:h4].include?( node_type )
          if node_type == :h3 && (node[1].start_with?( 'Group' ) ||
                                  node[1].start_with?( 'Matchday'))
             inside_heading = node[1]
             data[ node[1] ] = []  ## setup array for football boxes
          else
             inside_heading = nil  ## reset
          end
     else
       if inside_heading
          if node_type == :p
             lines = node[1]
             boxes = parse_footballboxes( lines )
             puts "add to #{inside_heading}  #{boxes.size} box(es)"
             data[ inside_heading ] += boxes
          else
             ## skip other (non-paragraph) nodes
          end
       else
          ## skip nodes
       end
     end
  end

  write_json( "./o/#{slug}.json", data )
end


titles = [
  '2023–24_UEFA_Champions_League_group_stage',
  '2024–25_UEFA_Champions_League_league_phase',
]

titles.each do |title|
   parse( title )
end

puts "bye"