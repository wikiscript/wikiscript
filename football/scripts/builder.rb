###############################################3
## wiki(text) squads reader for football.db


##
#
# todo: add captain flag  e.g. (c)
# todo: parse birth date too
# todo: parse coach tooo


#############
# some libs/gems
require 'logutils'


########
# our own code

require_relative 'teams'
require_relative 'players'
require_relative 'squads'



class SquadsBuilder

  include LogUtils::Logging

  attr_accessor :include_path, :output_path

  def initialize( include_path, opts = {} )
    @include_path = include_path
    @output_path  = './'  # set default to current directory
  end


  ###
  ## todo: fix? - strip spaces from link and title
  ##   spaces possible? strip in ruby later e.g. use strip - why? why not?

  WIKI_LINK_PATTERN = %q{
    \[\[
      (?<link>[^|\]]+)     # everything but pipe (|) or bracket (])
      (?:
        \|
        (?<title>[^\]]+)
      )?                   # optional wiki link title
    \]\]
  }

##
##  {{National football squad start (goals)}}, or {{Nat fs g start}} in short.
##  -> en.wikipedia.org/wiki/Template:National_football_squad_start_(goals)
##   or
##  {National football squad start}}, or {{Nat fs start}} in short.

  FS_START_REGEX  = /nat fs (g )?start|National football squad start( \(goals\)?)/i

  ## or {{Nat ...  ## use case-insensitive !!!
  FS_PLAYER_REGEX = /nat fs (g )?player|National football squad player/i

  FS_END_REGEX    = /nat fs (g )?end|National football squad end/i



## opt 1)
##   name=[[Manuel Ugarte (footballer)|Manuel Ugarte]]
## opt 2)  
##   name={{sortname|Matt|Turner|dab=soccer}}   or
##    name={{sortname|Tyler|Adams}}


  FS_PLAYER_NAME_REGEX = /\b
                          name=[ ]*#{WIKI_LINK_PATTERN}
                         /ix

FS_PLAYER_SORTNAME_REGEX = /\b
                             name=[ ]*\{\{
                             sortname
                             \|(?<first>[^|]+)    ## first name
                             \|(?<last>[^|\}]+)     ## last name
                             (\|
                               [^}]+?
                              )?      ### skip all before (non-greedy) e.g. |dab=soccer
                              \}\}
                            /ix


  FS_PLAYER_CLUB_REGEX = /\b
                          club=[ ]*#{WIKI_LINK_PATTERN}
                         /ix

  FS_PLAYER_CLUBNAT_REGEX = /\b
                          clubnat=
                            (?<clubnat>[A-Z]{3})
                             \b/ix

  ##
  #  {{birth date and age2|df=y|2024|6|14|1988|2|15}} or
  ##  {{Birth date and age2|2024|6|14|1992|4|30|df=y}}
  FS_PLAYER_BIRTHYEAR_REGEX = /\{\{
                                 birth[ ]date
                                    [^}]+?    ### skip all before (non-greedy) last date
                                    \|(?<year>[0-9]{4})
                                    \|(?<month>[0-9]{1,2})
                                    \|(?<day>[0-9]{1,2})
                                      [^0-9]*?   ## allow more params (with no digits) here
                                  \}\}
                              /ix

  ## todo:
  ##  check for empty (no number) e.g.   no=-      -- see world cup squads 1930
  ##  check for multiple numbers e.g.  no=9 & 8    -- see world cup squads 1930
  FS_PLAYER_NO_REGEX = /\b
                          no=\s*
                           (?<no>[0-9]+)
                        \b/ix

  ## todo:
  ##  check for empty (no caps) e.g.   caps=-      -- see world cup squads 1930
  FS_PLAYER_CAPS_REGEX = /\b
                          caps=
                           (?<caps>[0-9]+)
                          \b/ix
  FS_PLAYER_GOALS_REGEX = /\b
                          goals=
                           (?<goals>[0-9]+)
                          \b/ix


  FS_PLAYER_POS_REGEX = /\b
                           pos=
                           (?<pos>[A-Z]{2,})
                          \b/ix


  def read( name, opts={} )

    ## e.g. world cup 1930 to 1950 has no player nos 
    ##   (allows to skip player nos - will all be nil)
    skip_player_no = opts[:skip_player_no].nil? ? false : opts[:skip_player_no]

    path = "#{include_path}/#{name}.txt"
    logger.debug "  path=#{path}"

    @squads = []
    squad  = nil   ## current squad

    File.readlines( path ).each_with_index do |line,lineno|  # note: starts w/ 0 (use lineno+1)

      ## clean line
      ##   remove {{0}}  - todo: find out what is it good for? what does it mean?
      ##   remove '''
      ###  e.g.
      ##    no='''{{0}}1'''    or no={{0}}1
      ##      becomes
      ##     no=1              or no=1

      line = line.gsub( '{{0}}', '' )  ## remove {{0}}  empty infoset? or what does it mean? check/find out
      line = line.gsub( /'{2,}/, '' )   ## remove italic ('') or bold marker ('''')
      

      logger.debug "line #{lineno+1}"
      logger.debug "   #{line}"


      if line =~ FS_START_REGEX
        logger.debug "start squads block (line #{lineno+1})"
        squad = Squad.new
      elsif line =~ FS_END_REGEX
        logger.debug "end squads block (line #{lineno+1})"
        @squads << squad
      elsif line =~ FS_PLAYER_REGEX
        # logger.debug
        puts "  parse squads player line (line #{lineno+1})"

        player = Player.new
        
        m=FS_PLAYER_NAME_REGEX.match( line )
        if m
          if m[:title]
            player.name      = m[:title]
            player.name_wiki = m[:link]
          else
            player.name      = m[:link]  # (page) link is also used as title
            player.name_wiki = m[:link]
          end
        elsif m=FS_PLAYER_SORTNAME_REGEX.match( line )   ## try variant/option two (ii)
           ## assume (sort)first name + last name is title is link
           pp m     
           name = "#{m[:first]} #{m[:last]}"
           player.name      = name
           player.name_wiki = name 
        else
          puts "!! ERROR - no player name found in line:"
          puts line
          exit 1
        end

        m=FS_PLAYER_BIRTHYEAR_REGEX.match( line )
        if m
          player.birthyear = m[:year].to_i    
        else
          puts " no birthyear in:"
          puts line
          exit 1
        end

        m=FS_PLAYER_CLUB_REGEX.match( line )
        if m
          if m[:title]
            player.club      = m[:title]
            player.club_wiki = m[:link]
          else
            player.club      = m[:link]  # link is also title
            player.club_wiki = m[:link]
          end
        end

        m=FS_PLAYER_CLUBNAT_REGEX.match( line )
        player.clubnat = m[:clubnat]  if m

        unless skip_player_no
          m=FS_PLAYER_NO_REGEX.match( line )
          player.no = m[:no].to_i  if m     # note: convert string to number (integer)
        end

        m = FS_PLAYER_CAPS_REGEX.match( line )
        player.caps  = m[:caps].to_i  if m   # note: convert string to number (integer)
        m = FS_PLAYER_GOALS_REGEX.match( line )
        player.goals = m[:goals].to_i  if m   # note: convert string to number (integer)

        m = FS_PLAYER_POS_REGEX.match( line )
        player.pos = m[:pos] if m

        logger.debug "    #{player.to_rec}"
        squad.players << player
      else
        # skip; do nothing
      end

    end
  end  # method read


  def dump
    ## dump squads
    @squads.each_with_index do |squad,i|
      puts "========================"
      # puts " squad ##{i+1}"
      # puts squad.to_rec

      puts " squad ##{i+1} (sorted)"
      puts squad.to_rec( sort: true, 
                         comments: true )
    end
  end

  
  ## use league_name - why? why not?
  def write( names, league: )   

    ## dump squads
    
    puts " #{@squads.size} squad blocks,  #{names.size} squads recs"
    if @squads.size != names.size
      puts " !!!! squad blocks do NOT match / mismatch"
    end

    @squads.each_with_index do |squad,i|
      team_key = names[i]
      team = TEAMS[ team_key.downcase.to_sym ]

      if team.nil?   # unknow team key
        puts " !!!!! unknown team key >#{team_key}<; no team mapping record/entry found"
        ### crash!! why? why not?
        next
      end

      filename = team[0]
      teamname = team[1]
      append   = team[2].nil? ? false : true

      path = "#{output_path}/#{filename}.txt"

      puts " squad ##{i+1} writing to #{path} (sorted)..."


      filemode = append ? 'a' : 'w'

      File.open( path, filemode ) do |f|
          f << "====================================\n"
          f << "=  #{teamname} - #{league}\n\n"
          f << squad.to_rec( sort: true )
      end

    end
  end  # method write

end  # class SquadsBuilder
