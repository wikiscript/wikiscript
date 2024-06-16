

##
#  {{birth date and age2|df=y|2024|6|14|1988|2|15}}
  FS_PLAYER_BIRTHYEAR_REGEX = /\{\{birth[ ]date
                                    [^}]+?    ### skip all before (non-greedy) last date
                                    \|(?<year>[0-9]{4})
                                    \|(?<month>[0-9]{1,2})
                                    \|(?<day>[0-9]{1,2})
                                  \}\}
                              /x


line = "{{nat fs g player|no=1|pos=GK|name=[[Manuel Neuer]]"+
       "|sortname=Neuer, Manuel|"+
       "age={{birth date and age2|df=y|2024|6|14|1986|3|27}}"+
       "|caps=119|goals=0"+
       "|club=[[FC Bayern Munich|Bayern Munich]]|clubnat=GER}}"

puts line


m=FS_PLAYER_BIRTHYEAR_REGEX.match( line )
if m
    pp m
  puts "bingo"
  puts m[:year].to_i    
else
  puts " no birthyear in:"
  puts line
end



puts "bye"