# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_page_reader.rb


require 'helper'


class TestPageReader < MiniTest::Test

  def test_basic
    nodes = Wikiscript.parse( <<TXT )
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

    pp nodes

    assert_equal 4, nodes.size
    assert_equal [:h1, 'Heading 1'],  nodes[0]
    assert_equal [:h2, 'Heading 2'],  nodes[1]
    assert_equal [:h3, 'Heading 3'],  nodes[2]
    assert_equal [:table, [['header1', 'header2', 'header3'],
                           ['row1cell1', 'row1cell2', 'row1cell3'],
                           ['row2cell1', 'row2cell2', 'row2cell3']]],  nodes[3]
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

    nodes = page.parse
    pp nodes

    assert_equal 4, nodes.size
    assert_equal [:h1, 'Heading 1'],  nodes[0]
    assert_equal [:h2, 'Heading 2'],  nodes[1]
    assert_equal [:h3, 'Heading 3'],  nodes[2]
    assert_equal [:table, [['header1', 'header2', 'header3'],
                           ['row1cell1', 'row1cell2', 'row1cell3'],
                           ['row2cell1', 'row2cell2', 'row2cell3']]],  nodes[3]
  end

  def test_each
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

    nodes = []
    page.each do |node|
      nodes << node
    end
    pp nodes

    assert_equal 4, nodes.size
    assert_equal [:h1, 'Heading 1'],  nodes[0]
    assert_equal [:h2, 'Heading 2'],  nodes[1]
    assert_equal [:h3, 'Heading 3'],  nodes[2]
    assert_equal [:table, [['header1', 'header2', 'header3'],
                           ['row1cell1', 'row1cell2', 'row1cell3'],
                           ['row2cell1', 'row2cell2', 'row2cell3']]],  nodes[3]
  end

end # class TestPageReader
