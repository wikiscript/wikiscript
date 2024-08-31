##
#  download wikitext pages (.txt)
#     content_type: text/x-wiki
#
#  to run use:
#    $ ruby download.rb


$LOAD_PATH.unshift( File.expand_path( '../wikiscript/lib' ))
require 'wikiscript'

require 'cocos'   ## move upstream to wikiscript!!!



# title = '2023–24_UEFA_Champions_League_group_stage'
title = '2024–25_UEFA_Champions_League_league_phase'

page = Wikiscript.get( title )
pp page


def slugify( title )
  ## change to "plain ascii" dash
  slug = title.gsub( '–', '-' )
  slug
end

slug = slugify( title )
path = "./o/#{slug}.txt"
write_text( path, page.text )


puts "bye"