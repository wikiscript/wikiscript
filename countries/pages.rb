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


base_url='https://en.wikipedia.org/w/index.php?title={title}&action=raw'
### fetch first two pages
## rows = rows[0..2]
## pp rows


##
## todo/check: use urlencode - which method - from cgi?
##
## https://en.wikipedia.org/w/index.php?title=South%20Georgia%20and%20the%20South%20Sandwich%20Islands&action=raw

rows.each do |row|
  title = row['Name']
  url  = base_url.gsub( '{title}', title )
  path = "#{title.gsub( ' ', '_' )}.txt"
  puts "   >#{title}<   path=>#{path}<, try url=>#{url}<"

  ## test create text file in tmp
  ##   check if () and , can be used in filename too e.g.
  ##    Archipelago of San Andrés, Providencia and Santa Catalina
  ##     => Archipelago_of_San_Andrés,_Providencia_and_Santa_Catalina.txt
  File.open( "./countries/tmp/#{path}", 'w:utf-8') {|f| f.write( 'test' ) }
end

puts "  #{rows.size} row(s)"
puts


puts "bye"