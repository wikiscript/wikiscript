
require_relative 'wikipedia'



def csv_encode( values )
  ## quote values that incl. a comma
  values.map do |value|
    if value.index(',')
      puts "** rec with field with comma:"
      pp values
      %Q{"#{value}"}
    else
      value
    end
  end.join( ',' )
end

def save_recs( path, recs, headers: )
  FileUtils.mkdir_p( File.dirname( path ) ) ## make sure path exits

  File.open( path, 'w:utf-8') do |f|
    f.write( headers.join( ',' ) )
    f.write( "\n" )
    recs.each do |rec|
      f.write( csv_encode( rec ))
      f.write( "\n")
    end
  end
end




pages = [
  #  'A.F.C. Bournemouth',
  #  'Arsenal F.C.',
  #  'Everton F.C.',
  #  'Fulham F.C.',

  'Austria',
  'Belgium',
  'Argentina',
]


recs, redirects, normalized = Wikipedia.query_pageprops( pages )

puts " #{recs.size} rec(s):"
pp recs

path = './props/o/wikidata.csv'
save_recs( path, recs, headers: ['Name', 'Q', 'Desc'])

puts "bye"


