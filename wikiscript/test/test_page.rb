###
#  to run use
#     ruby test/test_page.rb


require_relative 'helper'


class TestPage < Minitest::Test

  def setup
    Wikiscript.lang = :en
  end

  def test_austria_en
    page = Wikiscript::Page.get( 'Austria' )
# [debug] GET /w/index.php?action=raw&title=Austria uri=http://en.wikipedia.org/w/index.php?action=raw&title=Austria, redirect_limit=5
# [debug] 301 TLS Redirect location=https://en.wikipedia.org/w/index.php?action=raw&title=Austria
# [debug] GET /w/index.php?action=raw&title=Austria uri=https://en.wikipedia.org/w/index.php?action=raw&title=Austria, redirect_limit=4
# [debug] 200 OK

    text = page.text

    ## print first 600 chars
    pp text[0..600]

    ## check for some snippets
    assert /{{Infobox country/              =~ text
    assert /common_name[ ]+=[ ]+Austria/    =~ text
    assert /capital[ ]+=[ ]+\[\[Vienna\]\]/ =~ text
    # assert /The origins of modern-day Austria date back to the time/ =~ text
  end


  def test_sankt_poelten_en
    page = Wikiscript::Page.get( 'Sankt_Pölten' )
# [debug] GET /w/index.php?action=raw&title=Sankt_P%C3%B6lten uri=http://en.wikipedia.org/w/index.php?action=raw&title=Sankt_P%C3%B6lten, redirect_limit=5
# [debug] 301 TLS Redirect location=https://en.wikipedia.org/w/index.php?action=raw&title=Sankt_P%C3%B6lten
# [debug] GET /w/index.php?action=raw&title=Sankt_P%C3%B6lten uri=https://en.wikipedia.org/w/index.php?action=raw&title=Sankt_P%C3%B6lten, redirect_limit=4
# [debug] 200 OK

    text = page.text

    ## print first 600 chars
    pp text[0..600]

    ## check for some snippets
    assert /{{Infobox settlement/ =~ text
    assert /name\s+=\s+Sankt Pölten/ =~ text
    # assert /'''Sankt Pölten''' \(''St. Pölten''\) is the capital city of/ =~ text
  end

end # class TestPage
