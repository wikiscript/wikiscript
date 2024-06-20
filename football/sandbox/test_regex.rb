

WIKI_LINK_PATTERN = %q{
    \[\[
      (?<link>[^|\]]+)     # everything but pipe (|) or bracket (])
      (?:
        \|
        (?<title>[^\]]+)
      )?                   # optional wiki link title
    \]\]
  }

 FS_PLAYER_NAME_REGEX = /\b
                          name=[ ]*#{WIKI_LINK_PATTERN}
                         /ix


lines = [
   "{{nat fs g player|no=2|pos=DF|"+
   "name=[[Lucas Martínez Quarta]]"+
   "|age={{birth date and age2|2024|6|20|1996|5|10}}|caps=14|goals=0|club=[[ACF Fiorentina|Fiorentina]]|clubnat=ITA}}",

   "{{nat fs g player|no=24|pos=MF|"+
   "name=[[César Pérez (footballer)|César Pérez]]"+
   "|age={{birth date and age2|2024|6|20|2002|11|29}}|caps=3|goals=0|club=[[Unión La Calera]]|clubnat=CHI}}",
]


lines.each_with_index do |line,i|
  puts "==> #{i+1}/#{lines.size}"
  m=FS_PLAYER_NAME_REGEX.match( line )
  if m
    pp m
    puts "bingo"
    pp m[:link]
    pp m[:title]
  else
    puts " no player in:"
    puts line
  end
end


##
#  {{birth date and age2|df=y|2024|6|14|1988|2|15}}
  FS_PLAYER_BIRTHYEAR_REGEX = /\{\{birth[ ]date
                                    [^}]+?    ### skip all before (non-greedy) last date
                                    \|(?<year>[0-9]{4})
                                    \|(?<month>[0-9]{1,2})
                                    \|(?<day>[0-9]{1,2})
                                  \}\}
                              /x


lines = ["{{nat fs g player|no=1|pos=GK|name=[[Manuel Neuer]]"+
         "|sortname=Neuer, Manuel|"+
         "age={{birth date and age2|df=y|2024|6|14|1986|3|27}}"+
         "|caps=119|goals=0"+
         "|club=[[FC Bayern Munich|Bayern Munich]]|clubnat=GER}}",
       ]

      
lines.each_with_index do |line,i|
  puts "==> #{i+1}/#{lines.size}"
  m=FS_PLAYER_BIRTHYEAR_REGEX.match( line )
  if m
    pp m
    puts "bingo"
    puts m[:year].to_i    
  else
    puts " no birthyear in:"
    puts line
  end
end




lines = [ "{{nat fs g player|no=1|pos=GK"+
          "|name={{sortname|Matt|Turner|dab=soccer}}"+
          "|age={{birth date and age2|2024|6|20|1994|6|24}}|caps=41|goals=0|club=[[Nottingham Forest F.C.|Nottingham Forest]]|clubnat=ENG}}",

          "{{nat fs g player|no=4|pos=MF" +
          "|name={{sortname|Tyler|Adams}}" +
          "|age={{birth date and age2|2024|6|20|1999|2|14}}|caps=39|goals=2|club=[[AFC Bournemouth|Bournemouth]]|clubnat=ENG}}",

          "{{nat fs g player|no=2|pos=DF" +
          "|name={{sortname|Cameron|Carter-Vickers}}" +
          "|age={{birth date and age2|2024|6|20|1997|12|31}}|caps=17|goals=0|club=[[Celtic F.C.|Celtic]]|clubnat=SCO}}",
      ]


FS_PLAYER_SORTNAME_REGEX = /\b
name=[ ]*\{\{
   sortname
      \|(?<first>[^|]+)    ## first name
      \|(?<last>[^|\}]+)     ## last name
      (\|
       [^}]+?)?      ### skip all before (non-greedy) e.g. |dab=soccer
   \}\}
/ix


lines.each_with_index do |line,i|
  puts "==> #{i+1}/#{lines.size}"
  m=FS_PLAYER_SORTNAME_REGEX.match( line )
  if m
    pp m
    puts "bingo"
    puts m[:first] + " " + m[:last]     
  else
    puts " no (player) sortname in:"
    puts line
  end
end


puts "bye"