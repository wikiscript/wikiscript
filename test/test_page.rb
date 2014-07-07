# encoding: utf-8


require 'helper'


class TestPage < MiniTest::Unit::TestCase

  def setup
    Wikiscript.lang = :en
  end

  def test_austria_en
    page = Wikiscript::Page.new( 'Austria' )
    text = page.text

    ## print first 600 chars
    pp text[0..600]

    ## check for some snippets
    assert( /{{Infobox country/ =~ text ) 
    assert( /common_name = Austria/ =~ text )
    assert( /capital = \[\[Vienna\]\]/ =~ text )
    assert( /The origins of modern-day Austria date back to the time/ =~ text )
  end

  def test_sankt_poelten_en
    page = Wikiscript::Page.new( 'Sankt_Pölten' )
    text = page.text

    ## print first 600 chars
    pp text[0..600]

    ## check for some snippets
    assert( /{{Infobox Town AT/ =~ text ) 
    assert( /Name\s+=\s+Sankt Pölten/ =~ text )
    assert( /'''Sankt Pölten''' \(''St. Pölten''\) is the capital city of/ =~ text )
  end

end # class TestPage

