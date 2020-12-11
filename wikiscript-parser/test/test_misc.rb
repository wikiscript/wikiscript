###
#  to run use
#     ruby -I ./lib -I ./test test/test_misc.rb


require 'helper'


class TestMisc < MiniTest::Test

  def test_voodoo
    ## see https://en.wikipedia.org/w/index.php?title=New_Orleans_Historic_Voodoo_Museum&action=raw

    nodes = Wikiscript::Parser.new( <<TXT ).parse
'''New Orleans Historic Voodoo Museum''' is a [[Louisiana Voodoo|voodoo]]
[[museum]] in [[New Orleans]], United States, situated between Bourbon and Royal Streets in the centre of
the [[French Quarter]].
<ref>{{cite web|url=http://www.neworleansonline.com/directory/location.php?locationID=1316|title=New Orleans Historic Voodoo Museum|publisher=Neworleansonline.com|accessdate=24 June 2015}}</ref>
Although only a small museum, consisting of two rooms,
it is one of few museums in the world dedicated entirely to
[[Louisiana Voodoo|Vodou art]]. There is a voodoo priest on site giving readings.
<ref name="Frommer's2012">{{cite book|author=Frommer's|title=AARP New Orleans|url=https://books.google.com/books?id=CEXG655tjL8C&pg=PA175|date=22 May 2012|publisher=John Wiley & Sons|isbn=978-1-118-26897-1|page=175}}</ref>
TXT
    pp nodes

    refs = Wikiscript::References.new( nodes )
    pp refs.to_json
  end

  def test_voodoo_ii
    nodes = Wikiscript::Parser.new( <<TXT ).parse
[[Category:African-American history in New Orleans]]
[[Category:French Quarter]]
[[Category:Louisiana Voodoo]]
[[Category:Museums in New Orleans]]
[[Category:Voodoo art]]
[[Category:Religion in New Orleans]]
TXT
    pp nodes
  end

end # class TestMisc
