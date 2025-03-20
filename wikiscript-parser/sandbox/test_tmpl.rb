require_relative 'helper'


##
## <onlyinclude>{{#invoke:sports table|main|style=WDL


txt = <<TXT
<onlyinclude>{{#invoke:sports table|main|style=WDL
|section=Standings
|show_positions=y
|winpoints=2
|team1=ARG|name_ARG={{fb|ARG|1861}}
|team2=CHI|name_CHI={{fb|CHI}}
|team3=FRA|name_FRA={{fb|FRA|1794}}
|team4=MEX|name_MEX={{fb|MEX|1916}}
|update=complete
|win_ARG=3|draw_ARG=0|loss_ARG=0|gf_ARG=10|ga_ARG=4
|win_CHI=2|draw_CHI=0|loss_CHI=1|gf_CHI=5|ga_CHI=3
|win_FRA=1|draw_FRA=0|loss_FRA=2|gf_FRA=4|ga_FRA=3
|win_MEX=0|draw_MEX=0|loss_MEX=3|gf_MEX=4|ga_MEX=13
|res_col_header=Q
|result1=Q |result2=
|col_Q=green1 |text_Q=Advance to the [[1930 FIFA World Cup knockout stage|knockout stage]]
|source=[https://www.espn.com.sg/football/table/_/league/FIFA.WORLD/season/1930 ESPN]
}}</onlyinclude>
TXT
pp txt


nodes = Wikiscript::Parser.new( txt ).parse
pp nodes



puts "bye"
