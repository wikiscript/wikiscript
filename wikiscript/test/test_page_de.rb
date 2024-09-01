###
#  to run use
#     ruby test/test_page_de.rb


require_relative 'helper'


class TestPageDe < Minitest::Test

  def setup
    Wikiscript.lang = :de
  end

  def test_st_poelten_de
    page = Wikiscript::Page.get( 'St._Pölten' )
#    [debug] GET /w/index.php?action=raw&title=St._P%C3%B6lten uri=http://de.wikipedia.org/w/index.php?action=raw&title=St._P%C3%B6lten, redirect_limit=5
#    [debug] 301 TLS Redirect location=https://de.wikipedia.org/w/index.php?action=raw&title=St._P%C3%B6lten
#    [debug] GET /w/index.php?action=raw&title=St._P%C3%B6lten uri=https://de.wikipedia.org/w/index.php?action=raw&title=St._P%C3%B6lten, redirect_limit=4
#    [debug] 200 OK


    text = page.text

    ## print first 600 chars
    pp text[0..600]

    ## check for some snippets
    assert /{{Infobox Gemeinde in Österreich/ =~ text
    assert /Name\s+=\s+St\. Pölten/ =~ text
    assert /'''St\. Pölten''' \(amtlicher Name,/ =~ text
    ## assert /Die Stadt liegt am Fluss \[\[Traisen \(Fluss\)\|Traisen\]\]/ =~ text
  end

end # class TestPageDe
