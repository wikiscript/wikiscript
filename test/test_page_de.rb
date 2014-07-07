# encoding: utf-8


require 'helper'


class TestPageDe < MiniTest::Unit::TestCase

  def setup
    Wikiscript.lang = :de
  end

  def test_st_poelten_de
    page = Wikiscript::Page.new( 'St._Pölten' )
    text = page.text

    ## print first 600 chars
    pp text[0..600]

    ## check for some snippets
    assert( /{{Infobox Gemeinde in Österreich/ =~ text ) 
    assert( /Name\s+=\s+St\. Pölten/ =~ text )
    assert( /'''St\. Pölten''' \(amtlicher Name,/ =~ text )
    assert( /Die Stadt liegt am Fluss \[\[Traisen \(Fluss\)\|Traisen\]\]/ =~ text )
  end

end # class TestPageDe

