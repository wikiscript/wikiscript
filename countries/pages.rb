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

##rows = rows[0..3]

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

  ## note: change path (used for disk cache)!!
  ## todo/fix:  check return code!!!
  ##   abort/fail if NOT 200!!!
  Webget.text( url, path: path )
end

puts "  #{rows.size} row(s)"
puts


puts "bye"

__END__

todo/fix:

>Åland Islands<   path=>Åland_Islands.txt<, try url=>https://en.wikipedia.org/w/index.php?title=Åland Islands&action=raw<
sleep 3 sec(s)...
Traceback (most recent call last):
      7: from countries/pages.rb:37:in `<main>'
      6: from countries/pages.rb:37:in `each'
      5: from countries/pages.rb:50:in `block in <main>'
      4: from lib/ruby/gems/2.7.0/gems/webget-0.2.4/lib/webget/webget.rb:69:in `text'
      3: from lib/ruby/gems/2.7.0/gems/webclient-0.2.0/lib/webclient/webclient.rb:73:in `get'
      2: from lib/ruby/2.7.0/uri/common.rb:234:in `parse'
      1: from lib/ruby/2.7.0/uri/rfc3986_parser.rb:73:in `parse'
lib/ruby/2.7.0/uri/rfc3986_parser.rb:21:in `split': URI must be ascii only "https://en.wikipedia.org/w/index.php?title=\\u00C5land Islands&action=raw" (URI::InvalidURIError)
