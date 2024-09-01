###
#  to run use
#     ruby test/test_link.rb


require_relative 'helper'


class TestLink < Minitest::Test

  def test_unlink
    assert_equal 'Santiago (La Florida)',  Wikiscript.unlink( '[[Santiago]] ([[La Florida, Chile|La Florida]])' )
  end

  def test_parse_link
    link, title = Wikiscript.parse_link( '[[La Florida, Chile|La Florida]]' )
    assert_equal 'La Florida, Chile', link
    assert_equal 'La Florida',        title

    link, title = Wikiscript.parse_link( '[[ La Florida, Chile | La Florida ]]' )
    assert_equal 'La Florida, Chile', link
    assert_equal 'La Florida',        title

    link, title = Wikiscript.parse_link( 'La Florida' )
    assert  link  == nil
    assert  title == nil
  end

end # class TestLink
