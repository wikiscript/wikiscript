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

title = '2023–24_UEFA_Champions_League_group_stage'

slug = slugify( title )
path = "./o/#{slug}.txt"
page = Wikiscript.read( path )
## pp page



# text = read_text( "./o/groups.txt")
text = read_text( "./o/2024-25_matches.txt")

nodes = Wikiscript.parse( text )
pp nodes

puts "  #{nodes.size} node(s)"


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


write_json( "./o/2024-25_matches.json", boxes )


puts "bye"