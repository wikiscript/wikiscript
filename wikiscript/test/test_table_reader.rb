###
#  to run use
#     ruby test/test_table_reader.rb


require_relative 'helper'

class TestTableReader < Minitest::Test

  def test_basic
    table = Wikiscript.parse_table( <<TXT )
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

    assert_equal 3, table.size      ## three rows
    assert_equal ['header1', 'header2', 'header3'], table[0]
    assert_equal ['row1cell1', 'row1cell2', 'row1cell3'], table[1]
    assert_equal ['row2cell1', 'row2cell2', 'row2cell3'], table[2]
  end

  def test_basic_ii     ##  with optional (missing) row divider before headers
    table = Wikiscript.parse_table( <<TXT )
{|
! header1 !! header2 !! header3
|-
| row1cell1 || row1cell2 || row1cell3
|-
| row2cell1 || row2cell2 || row2cell3
|}
TXT

    assert_equal 3, table.size      ## three rows
    assert_equal ['header1', 'header2', 'header3'], table[0]
    assert_equal ['row1cell1', 'row1cell2', 'row1cell3'], table[1]
    assert_equal ['row2cell1', 'row2cell2', 'row2cell3'], table[2]
  end

  def test_basic_iii  # with continuing header column lines
    table = Wikiscript.parse_table( <<TXT )
{|
|-
!
header1
!
header2
!
header3
|-
|
row1cell1
|
row1cell2
|
row1cell3
|-
|
row2cell1
|
row2cell2
|
row2cell3
|}
TXT

    assert_equal 3, table.size      ## three rows
    assert_equal ['header1', 'header2', 'header3'], table[0]
    assert_equal ['row1cell1', 'row1cell2', 'row1cell3'], table[1]
    assert_equal ['row2cell1', 'row2cell2', 'row2cell3'], table[2]
  end


  def test_strip_attributes_and_emphases
    table = Wikiscript.parse_table( <<TXT )
{|
|-
! style="width:200px;"|Club
! style="width:150px;"|City
|-
|[[Biu Chun Rangers]]||[[Sham Shui Po]]
|-
|bgcolor=#ffff44 |''[[Eastern Sports Club|Eastern]]''||[[Mong Kok]]
|-
|[[HKFC Soccer Section]]||[[Happy Valley, Hong Kong|Happy Valley]]
|}
TXT

assert_equal 4, table.size      ## four rows
assert_equal ['Club', 'City'], table[0]
assert_equal ['[[Biu Chun Rangers]]',            '[[Sham Shui Po]]'], table[1]
assert_equal ['[[Eastern Sports Club|Eastern]]', '[[Mong Kok]]'],     table[2]
assert_equal ['[[HKFC Soccer Section]]',         '[[Happy Valley, Hong Kong|Happy Valley]]'],  table[3]
  end

end # class TestTableReader
