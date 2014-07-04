# encoding: utf-8


require 'helper'


class TestAustria < MiniTest::Unit::TestCase

  def test_text
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

end # class TestAustria

