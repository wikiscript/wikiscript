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



### fix/todo: change name to find_infobox or such
def parse_page( txt, path: )
  ## parse templates only e.g {{}}
  ##  until we find Infobox country or dependency!!!!

  parser = Wikiscript::Parser.new( txt )

  ## note: remove all html comments for now - why? why not?
  ## <!-- Area rank should match .. -->
  txt = txt.gsub( /<!--.+?-->/m ) do |m|  ## note: use .+? (non-greedy match)
      ## puts " removing comment >#{m}<"
      ''
  end

  input = StringScanner.new( txt )

   node = nil
   i=0
   ## note: pos(itions) are BYTE positions (not characters!!!)
   pos_begin = 0
   pos_end = 0
   loop do
     parser.skip_whitespaces( input )
     break if input.eos?

     ## todo/fix:  check for expected {{ template begin!!!!
     ##  why? why not?

     pos_begin = input.pos
     node = parser.parse_template( input )
     pos_end   = input.pos
     puts "#{[i+1]} (#{pos_begin},#{pos_end}) >#{node.name}<"
     if node.name.downcase.start_with?( 'infobox' )
      puts "!! bingo - cut off at:"
      puts ">#{input.peek( 100 )}< ..."
      break
     end
     i += 1
   end

   ##
   ## alternative - track input pos for (original/verbatim) template source
   ##               (instead of regenerate from ast) - why? why not?

   if node
     ## note: pos(itions) are BYTE positions (not charachters!!!)
     ## hack: change to BINARY encoding (ASCII-8BIT) and back to UTF-8
     txt.force_encoding( Encoding::BINARY )
     src = txt[pos_begin..pos_end]
     src.force_encoding( Encoding::UTF_8 ) ## change back to UTF-8
     txt.force_encoding( Encoding::UTF_8 )

     File.open( "./countries/o/#{path}", 'w:utf-8') {|f| f.write( src ) }
   end
end



######################
## cache root for wikipedia .txt pages
root = "#{Webcache.root}/en.wikipedia.org"

##
rows = rows[0..5]

rows.each do |row|
  title = row['Name']
  path = "#{title.gsub( ' ', '_' )}.txt"
  puts "   >#{title}<   path=>#{path}<"

  txt = File.open( "#{root}/#{path}", 'r:utf-8') {|f| f.read }
  pp txt[1..200]
  puts

  parse_page( txt, path: path )
end

puts "  #{rows.size} row(s)"
puts


puts "bye"