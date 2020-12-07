############################################
# to run use:
#     ruby countries/pages.rb

require 'webget'   ## note: includes/pulls in csvreader too



rows = CsvHash.read( './data/countries.csv' )


pp rows

## print just page names
puts
rows.each_with_index do |row,i|
  puts "  [#{i+1}] >#{row['Name']}<    ...... in #{row['Region']} / #{row['Category']}"
end

puts "  #{rows.size} row(s)"
puts



def save_page( title )
  base_url='https://en.wikipedia.org/w/index.php?title={title}&action=raw'

  ## todo/check: use %20 for encoding space (or +) - why? why not?
  ## https://en.wikipedia.org/w/index.php?title=South%20Georgia%20and%20the%20South%20Sandwich%20Islands&action=raw
  ## https://en.wikipedia.org/w/index.php?title=South+Georgia+and+the+South+Sandwich+Islands&action=raw

  ##
  ## URI.encode_www_form_component(string, enc=nil)
  ## This method will percent-encode every reserved character,
  ## leaving only *, -, ., 0-9, A-Z, _, a-z intact.
  ## Note: It also substitues space with +.
  title_encoded = URI.encode_www_form_component( title )
  url  = base_url.gsub( '{title}', title_encoded )

  path = "#{title.gsub( ' ', '_' )}.txt"
  puts "   >#{title}<, >#{title_encoded}<  path=>#{path}<, try url=>#{url}<"

  ## note: change path (used for disk cache)!!
  response = Webget.text( url, path: path )
  ## note: exit on get / fetch error - do NOT continue for now - why? why not?
  exit 1   if response.status.nok?    ## e.g.  HTTP status code != 200
end



### fetch first two pages
## rows = rows[0..2]
## pp rows

## rows = rows[0..3]

rows.each do |row|
  title = row['Name']

  save_page( title )
end

puts "  #{rows.size} row(s)"
puts


puts "bye"

