require 'fileutils'

require_relative '../scripts/builder'


  puts 'hello from squad reader/builder'

  #### LogUtils::Logger.root.level = :debug
 LogUtils::Logger.root.level = :info

  srcdir = '../../football.json/_source/squads/euro-cup'
  b = SquadsBuilder.new( srcdir )


  page = 'UEFA_Euro_2024_squads'
  # page = 'UEFA_Euro_2012_squads'
  opts = {}
  b.read( page, opts )
 
  puts
  puts "dump:"
  b.dump


  outpath = "./o/#{page}"
  FileUtils.mkdir_p( outpath ) unless Dir.exist?( outpath )

  b.output_path = outpath
  ## 24 teams (euro 2024)
  teams = %w[
     GER SCO HUN SUI
     ESP CRO ITA ALB
     SVN DEN SRB ENG
     POL NED AUT FRA
     BEL SVK ROU UKR
     TUR GEO POR CZE
  ]
  b.write( teams )


 
puts "bye"

    