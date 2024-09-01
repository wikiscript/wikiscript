######
#  to run use:
#    $ ruby convert.rb


require 'cocos'


def slugify( title )
  ## change to "plain ascii" dash
  slug = title.gsub( '–', '-' )
  slug
end

def squish( str )
   ## auto-fix team names
   ##   e.g. Galatasaray S.K. (football)
   str = str.sub( '(football)', '' )

   ## remove references for now
   ##  e.g. !!{{refn | group=note | name=Ukraine}}
   str = str.sub( /!!\{\{refn.+?$/, '' )

   ## classic
   str = str.strip.gsub( /[ ]{1,}/, ' ' )
   ## more
   ## remove space before commas
   ## e.g. Stadion Wankdorf , Bern
   str = str.gsub( /[ ]+(?=,)/, '' )  # with positive lookahead
   ## remove inside spaces for brackets
   ## e.g. ( 20:00 UTC+0 )
   str = str.gsub( /[ ]+(?=\))/,  '' )  # with positive lookahead
   str = str.gsub( /(?<=\()[ ]+/, '' )  # with positive lookbehind
   str
end




def convert( title )
  slug = slugify( title )
  path = "./o/#{slug}.json"

  ## convert (and flatten) json to tabular csv
  data = read_json( path )
  ## pp data

  rows = []
  data.each do |round, matches|
     matches.each do |m|

       team1 = squish( m['team1']['text'] )
       team2 = squish( m['team2']['text'] )
       ## (SCO)  Celtic F.C.
       ##  move to the end
       ##   todo - assert text starts with (SCO) or such
       team2_parts = team2.split( ' ', 2 )  # 2 == two parts max.
       team2 = team2_parts[1] + " " + team2_parts[0]

       time = squish( m['time']['text'] )
       ## split time
       time, time_local = time.split( ' ', 2 )

       row = [ round,
               squish( m['date']['text'] ),
               time,
               time_local || '',
               team1,
               squish( m['score']['text'] ),
               team2,
               squish( m['stadium']['text'] )
             ]
       rows << row
     end
  end

  headers = ['round', 'date',
             'time',
             'time_local',
             'team1', 'score', 'team2',
             'stadium']
  outpath = "./o/#{slug}.csv"
  write_csv( outpath, rows, headers: headers )
end



titles = [
 '2023–24_UEFA_Champions_League_group_stage',
 '2024–25_UEFA_Champions_League_league_phase',
]

titles.each do |title|
   convert( title )
end


puts "bye"