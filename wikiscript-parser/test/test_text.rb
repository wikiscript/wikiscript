###
#  to run use
#     ruby -I ./lib -I ./test test/test_text.rb


require 'helper'


class TestText < MiniTest::Test

  def test_text
    nodes = Wikiscript::Parser.new( <<TXT ).parse
  [1] [2] [3]
  [http://example.com]
TXT

    pp nodes
  end

  def test_text_with_comments
    nodes = Wikiscript::Parser.new( <<TXT ).parse
  [1] [2] [3]
  <!-- comment here --> <!-- another commen here -->
  [http://example.com]<!-- yet another comment here -->
TXT

    pp nodes
  end

  def test_text_ii
    nodes = Wikiscript::Parser.new( <<TXT ).parse
  {1} {2} {3}
  {{1}}
TXT

    pp nodes
  end

  def test_ref
    nodes = Wikiscript::Parser.new( <<TXT ).parse
<ref group="N" name="denonly group=N" />
<ref name="UNHDR">
  [1] [2] [3]
  [http://example.com]
</ref>
TXT

    pp nodes
  end


end # class TestText
