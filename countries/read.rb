############################################
# to run use:
#     ruby countries/pages.rb


$LOAD_PATH.unshift( "./wikiscript-parser/lib" )
$LOAD_PATH.unshift( "./wikitree/lib" )
require 'wikiscript/parser'


require 'webget'   ## note: includes/pulls in csvreader too



rows = CsvHash.read( './data/countries.csv' )

puts "  #{rows.size} row(s)"
puts



######################
## cache root for wikipedia .txt pages
root = "#{Webcache.root}/en.wikipedia.org"

##
## rows = rows[0..5]

#rows = [
#  {'Name' => 'Bulgaria'},
# { 'Name' => 'Hungary' },
# { 'Name' => 'Republic of Ireland' },
#  { 'Name' => 'Serbia' },
#  { 'Name' => 'United Kingdom' },
#  { 'Name' => 'Canada' },
#   { 'Name' => 'Bonaire' },
#]


rows.each do |row|
  title = row['Name']
  path = "#{title.gsub( ' ', '_' )}.txt"
  puts "   >#{title}<   path=>#{path}<"

  txt = File.open( "#{root}/#{path}", 'r:utf-8') {|f| f.read }
  pp txt[0..200]
  puts

  infobox = Wikiscript.find_infobox( txt )
  pp infobox[0..200]
  puts

  File.open( "./countries/o/#{path}", 'w:utf-8') {|f| f.write( infobox ) }
end

puts "  #{rows.size} row(s)"
puts


puts "bye"