######
#  to run use:
#    $ ruby convert.rb


$LOAD_PATH.unshift( File.expand_path( '../wikiscript/lib' ))
require 'wikiscript'

require 'cocos'   ## move upstream to wikiscript!!!


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


nodes = page.nodes
pp nodes

puts "bye"