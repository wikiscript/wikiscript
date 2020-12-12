require_relative 'wikipedia'


pages = [
  'A.F.C. Bournemouth',
  'Arsenal F.C.',
  'Everton F.C.',
  'Fulham F.C.',

# 'Austria',
# 'Belgium',
# 'Argentina',
]

res = Wikipedia::Metal.query_pageprops( *pages )
pp res.data

print "  #{res.pages.size} page(s) - "
print "#{res.redirects.size} redirect(s), "
print "#{res.normalized.size} normalized:"
print "\n"

res.pages.each do |page|
   puts "#{page.title}   | #{page.wikibase_item} - #{page.wikibase_shortdesc}"
end

puts "bye"


