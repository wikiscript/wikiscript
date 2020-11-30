###
#  to run use
#     ruby -I ./lib -I ./test test/test_nodes.rb


require 'helper'


class TestNodes < MiniTest::Test

  def test_page
    page = Wikitree::Page.new( 'La Florida, Chile', 'La Florida' )

    assert_equal ' La Florida ', page.to_text
    assert_equal '[[La Florida, Chile|La Florida]]', page.to_wiki
  end

end # class TestNodes


