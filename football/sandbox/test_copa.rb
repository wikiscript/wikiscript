require 'fileutils'

require_relative '../scripts/builder'


  puts 'hello from squad reader/builder'

  #### LogUtils::Logger.root.level = :debug
 LogUtils::Logger.root.level = :info

  srcdir = '../../football.json/_source/squads/copa-america'
  b = SquadsBuilder.new( srcdir )


pages = [ 
  { name: '2024_Copa_América_squads', # 16(!) teams (6 guests)
    teams: %w[
      ARG PER CHI CAN
      MEX ECU VEN JAM
      USA URU PAN BOL
      BRA COL PAR CRC
   ],
   league: 'Copa América 2024',   ##  for export
  },
  ### note - Copa América 2021
  ##           some teams player replacements during tournament!!!
  ##          add from/until date - why? why not?
  { name: '2021_Copa_América_squads',  # 10 teams
    teams: %w[
      ARG BOL URU CHI PAR
      BRA COL VEN ECU PER
    ],
    league: 'Copa América 2021',   ##  for export
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



    