## get page props (wikidata id, short desc)
##
## see https://www.mediawiki.org/wiki/API:Pageprops
##     https://en.wikipedia.org/w/api.php?action=help&modules=query
##     https://en.wikipedia.org/w/api.php?action=help&modules=query%2Bpageprops

require 'webclient'



module Wikipedia
  class Response
    attr_reader :data
    def initialize( data )
      @data = data
    end
=begin
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
=end

   def normalized
     @normalized ||= @data['query']['normalized'] || []
   end

   def redirects
     @redirects ||= @data['query']['redirects'] || []
   end


   class Page
     def initialize( data )
       @data = data
     end
     def title()     @data['title']; end
     def pageprops() @data['pageprops']; end

     def wikibase_item()       @data['pageprops']['wikibase_item']; end
     def wikibase_shortdesc()  @data['pageprops']['wikibase-shortdesc']; end
   end


   def pages
     @pages ||= begin
                  pages = @data['query']['pages'] || {}
                  pages.to_a   ## convert hash to array (ignore _ - key for now)
                       .map { |_,page| Page.new( page ) }
                end
   end
  end  # class Response




  module Metal
def self.query_pageprops( *titles )

  base_url =  "https://en.wikipedia.org/w/api.php?action=query"
  base_url << "&prop=pageprops"
  ## base_url << "&ppprop=wikibase_item"
  base_url << "&redirects=1"
  base_url << "&format=json"
  base_url << "&titles={titles}"


  ## Separate values with | or alternative.

  ##   todo/fix: change ' ' to '+' via URI.escape comontent - why? why not?
  titles = titles.map { |title| title.gsub( ' ', '_') }.join( '|')

  url = base_url.sub( '{titles}', titles )

  res = Webclient.get( url )
  if res.status.nok?
    puts "!! ERROR:"
    pp res
    exit 1
  end

  Response.new( res.json )
end
end # module Metal




## rename to  autofill/populate/fetch or such - why? why not?
def self.query_pageprops( pages,
                          batch_size: 10,
                          redirects_log:  './redirects.log',
                          normalized_log: './normalized.log' )
  recs = []

  redirects = []
  normalized = []

  sleep_delay_in_s = 1

  ## use a batch of ten for now
  i=0
  pages.each_slice( batch_size ) do |slice|
    if i > 0
      puts "  sleep #{sleep_delay_in_s}..."
      sleep( sleep_delay_in_s )
    end

    res = Metal.query_pageprops( *slice )
    pp res.data

    print "  #{res.pages.size} page(s) - "
    print "#{res.redirects.size} redirect(s), "
    print "#{res.normalized.size} normalized:"
    print "\n"

    res.pages.each do |page|
       puts "#{page.title}   | #{page.wikibase_item} - #{page.wikibase_shortdesc}"
       recs << [page.title, page.wikibase_item, page.wikibase_shortdesc]
    end

    redirects  += res.redirects    if res.redirects.size > 0
    normalized += res.normalized   if res.normalized.size > 0
  end


  if redirects.size > 0
    puts "!! WARN - #{redirects.size} redirects(s):"
    pp redirects

    ## add to redirects.log
    File.open( redirects_log, 'a:utf-8') do |f|
      f.write( "==> #{Time.now} - #{redirects.size} redirect(s):" )
      f.write( "\n" )
      f.write( JSON.pretty_generate( redirects ) )
      f.write( "\n" )
    end
  end

  if normalized.size > 0
    puts "!! WARN - #{normalized.size} normalized:"
    pp normalized

    ## add to normalized.log
    File.open( normalized_log, 'a:utf-8') do |f|
      f.write( "==> #{Time.now} - #{normalized.size} normalized:" )
      f.write( "\n" )
      f.write( JSON.pretty_generate( normalized ) )
      f.write( "\n" )
    end
  end

  ## todo/check: return redirects and normalized too - why? why not?
  [recs, redirects, normalized]
end
end # module Wikipedia



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