###
#  to run use
#     ruby -I ./lib -I ./test test/test_ref.rb


require 'helper'

## test ref(s) - citations / footnotes
class TestRef < MiniTest::Test

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

end # class TestRef
