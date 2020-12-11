## get page props (wikidata id, short desc)
##
## see https://www.mediawiki.org/wiki/API:Pageprops
##     https://en.wikipedia.org/w/api.php?action=help&modules=query
##     https://en.wikipedia.org/w/api.php?action=help&modules=query%2Bpageprops

require 'webclient'

base_url =  "https://en.wikipedia.org/w/api.php?action=query"
base_url << "&prop=pageprops"
## base_url << "&ppprop=wikibase_item"
base_url << "&redirects=1"
base_url << "&format=json"
base_url << "&titles={titles}"

pages = [
#  'A.F.C. Bournemouth',
#  'Arsenal F.C.',
#  'Everton F.C.',
#  'Fulham F.C.',

'Austria',
'Belgium',
'Argentina',
]

## Separate values with | or alternative.
titles = pages.map { |page| page.gsub( ' ', '_') }.join( '|')

##pages.each do |page|
##  page = page.gsub( ' ', '_' )
  url = base_url.sub( '{titles}', titles )

  res = Webclient.get( url )
  if res.status.nok?
    puts "!! ERROR:"
    pp res
    exit 1
  end

  pp res.json
  puts
## end

puts "bye"


__END__


{"batchcomplete"=>"",
 "query"=>
  {"normalized"=>
    [{"from"=>"A.F.C._Bournemouth", "to"=>"A.F.C. Bournemouth"},
     {"from"=>"Arsenal_F.C.", "to"=>"Arsenal F.C."},
     {"from"=>"Everton_F.C.", "to"=>"Everton F.C."},
     {"from"=>"Fulham_F.C.", "to"=>"Fulham F.C."}],
   "redirects"=>[{"from"=>"A.F.C. Bournemouth", "to"=>"AFC Bournemouth"}],
   "pages"=>
    {"2174"=>
      {"pageid"=>2174,
       "ns"=>0,
       "title"=>"Arsenal F.C.",
       "pageprops"=>
        {"page_image"=>"Arsenal_FC.svg",
         "wikibase-badge-Q17437796"=>"1",
         "wikibase-shortdesc"=>
          "Association football club based in Islington, London, England",
         "wikibase_item"=>"Q9617"}},
     "91155"=>
      {"pageid"=>91155,
       "ns"=>0,
       "title"=>"Everton F.C.",
       "pageprops"=>
        {"page_image"=>"Everton_FC_logo.svg",
         "wikibase-shortdesc"=>"Association football club in England",
         "wikibase_item"=>"Q5794"}},
     "11228"=>
      {"pageid"=>11228,
       "ns"=>0,
       "title"=>"Fulham F.C.",
       "pageprops"=>
        {"page_image"=>"Fulham_FC_(shield).svg",
         "wikibase-shortdesc"=>"Association football club in England",
         "wikibase_item"=>"Q18708"}},
     "451121"=>
      {"pageid"=>451121,
       "ns"=>0,
       "title"=>"AFC Bournemouth",
       "pageprops"=>
        {"defaultsort"=>"AFC Bournemouth",
         "page_image"=>"AFC_Bournemouth_(2013).svg",
         "wikibase-shortdesc"=>"Association football club in England",
         "wikibase_item"=>"Q19568"}}}}}



{"batchcomplete"=>"",
 "query"=>
  {"pages"=>
    {"18951905"=>
      {"pageid"=>18951905,
       "ns"=>0,
       "title"=>"Argentina",
       "pageprops"=>
        {"jsonconfig_getdata"=>"1",
         "page_image_free"=>"Flag_of_Argentina.svg",
         "wikibase-shortdesc"=>"country in South America",
         "wikibase_item"=>"Q414"}},
     "26964606"=>
      {"pageid"=>26964606,
       "ns"=>0,
       "title"=>"Austria",
       "pageprops"=>
        {"page_image_free"=>"Flag_of_Austria.svg",
         "wikibase-shortdesc"=>"Country in Central Europe",
         "wikibase_item"=>"Q40"}},
     "3343"=>
      {"pageid"=>3343,
       "ns"=>0,
       "title"=>"Belgium",
       "pageprops"=>
        {"page_image_free"=>"Flag_of_Belgium.svg",
         "wikibase-shortdesc"=>"Country in Western Europe",
         "wikibase_item"=>"Q31"}}}}