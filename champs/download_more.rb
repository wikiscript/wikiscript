##
#  download wikitext pages (.txt)
#     content_type: text/x-wiki
#
#  to run use:
#    $ ruby download_more.rb


$LOAD_PATH.unshift( File.expand_path( '../wikiscript/lib' ))
require 'wikiscript'



# title = 'UEFA_Euro_2024'
# title = 'UEFA_Euro_2020'
# title = 'UEFA_Euro_2016'
# title = 'UEFA_Euro_2024_Group_A'
# title = '2024_Copa_América'
title = '2024_Copa_América_Group_A'
title = '2024_Copa_América_knockout_stage'


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