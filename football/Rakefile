
require './scripts/builder'


task :default => :build


task :build  do
  puts 'hello from squad reader/builder'

  logger = LogUtils::Logger.root
  logger.level = :info   # :debug, :warn

  b = SquadsBuilder.new( './world-cup' )

  ## [1930,1934,1938,1950,1954,1958,1962,1966,1970,1974,1978,1982,1986,1990,1994,1998,2002,2006,2010,2014].each do |year|
  [2010].each do |year|
    config = YAML.load_file( "./config/world_cup_#{year}.yml" )
    pp config

    page  = config['page']
    teams = config['teams'] # filenames for teams (note: MUST match order in page)

    ## skip player no from 1930-1950
    if [1930,1934,1938,1950].include? year
      opts = { skip_player_no: true }
    else
      opts = {}
    end
    
    b.read( page, opts )
    ## b.dump

    outpath = "./o/#{year}"
    mkdir_p( outpath ) unless Dir.exists?( outpath )

    b.output_path = outpath
    b.write( teams )
  end

end

