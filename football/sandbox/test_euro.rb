require 'fileutils'

require_relative '../scripts/builder'


  puts 'hello from squad reader/builder'

  #### LogUtils::Logger.root.level = :debug
 LogUtils::Logger.root.level = :info

  srcdir = '../../football.json/_source/squads/euro-cup'
  b = SquadsBuilder.new( srcdir )


pages = [
  { name: 'UEFA_Euro_2024_squads',   ## 24 teams (euro 2024)
    teams: %w[
      GER SCO HUN SUI
      ESP CRO ITA ALB
      SVN DEN SRB ENG
      POL NED AUT FRA
      BEL SVK ROU UKR
      TUR GEO POR CZE
     ], 
     league: 'Euro 2024',
  },
  {  name: 'UEFA_Euro_2020_squads', 
     teams: %w[
       ITA SUI TUR WAL
       BEL DEN FIN RUS
       AUT NED MKD UKR
       CRO CZE ENG SCO
       POL SVK ESP SWE
       FRA GER HUN POR
     ],
     league: 'Euro 2021',   ## note - use Euro 2021 (not 2020)
  },
]



pages.each_with_index do |page,i|
  puts "==> #{i+1}/#{pages.size} - #{page[:name]}, #{page[:teams].size} team(s)..."

  opts = {}
  b.read( page[:name], opts )
 
  puts
  puts "dump:"
  b.dump


  outpath = "./o/#{page[:name]}"
  FileUtils.mkdir_p( outpath ) unless Dir.exist?( outpath )

  b.output_path = outpath
  
  b.write( page[:teams], 
           league: page[:league] )
end


puts "bye"

    