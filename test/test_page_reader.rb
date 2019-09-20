# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_page_reader.rb


require 'helper'


class TestPageReader < MiniTest::Test

  def test_basic
    el = Wikiscript.parse( <<TXT )
=Heading 1==
==Heading 2==
===Heading 3===

{|
|-
! header1
! header2
! header3
|-
| row1cell1
| row1cell2
| row1cell3
|-
| row2cell1
| row2cell2
| row2cell3
|}
TXT

    pp el

    assert_equal 4, el.size
    assert_equal [:h1, 'Heading 1'],  el[0]
    assert_equal [:h2, 'Heading 2'],  el[1]
    assert_equal [:h3, 'Heading 3'],  el[2]
    assert_equal [:table, [['header1', 'header2', 'header3'],
                           ['row1cell1', 'row1cell2', 'row1cell3'],
                           ['row2cell1', 'row2cell2', 'row2cell3']]],  el[3]
  end

  def test_parse
    page = Wikiscript::Page.new( <<TXT )
=Heading 1==
==Heading 2==
===Heading 3===

{|
|-
! header1
! header2
! header3
|-
| row1cell1
| row1cell2
| row1cell3
|-
| row2cell1
| row2cell2
| row2cell3
|}
TXT

    el = page.parse
    pp el

    assert_equal 4, el.size
    assert_equal [:h1, 'Heading 1'],  el[0]
    assert_equal [:h2, 'Heading 2'],  el[1]
    assert_equal [:h3, 'Heading 3'],  el[2]
    assert_equal [:table, [['header1', 'header2', 'header3'],
                           ['row1cell1', 'row1cell2', 'row1cell3'],
                           ['row2cell1', 'row2cell2', 'row2cell3']]],  el[3]
  end

end # class TestPageReader
