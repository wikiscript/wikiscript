###
#  to run use
#     ruby -I ./lib -I ./test test/test_file.rb


require 'helper'


class TestFile < MiniTest::Test

  def test_samples
    nodes = Wikiscript::Parser.new( <<TXT ).parse
   [[File:The Brabanconne.ogg|center]]
   [[File:Land der Berge Land am Strome instrumental.ogg|center]]
   [[File:La Marseillaise.ogg|alt=sound clip of the Marseillaise French national anthem]]

   [[File:Royal Coat of Arms of the United Kingdom.svg|x100px]]
   [[File:Royal Coat of Arms of the United Kingdom (Scotland).svg|x100px]]

   [[File:Solvognen-00100.jpg
       |thumb
       |left
       |The gilded side of the [[Trundholm sun chariot]] dating from the Nordic Bronze Age]]
TXT
    pp nodes
  end

  def test_infobox
    nodes = Wikiscript::Parser.new( <<TXT ).parse
  {{center|[[File:Sint Maarten National Anthem (Instrumental) Oh Sweet Sint Maarten Land.ogg]]}}
TXT
    pp nodes
  end

  def test_syntax
    nodes = Wikiscript::Parser.new( <<TXT ).parse

  [[File:Name|Type|Border|Location|Alignment|Size|link=Link|alt=Alt|page=Page|lang=Langtag|Caption]]
  [[File:Name|thumb|alt=Alt|Caption]]
TXT
    pp nodes
  end

end # class TestFile
