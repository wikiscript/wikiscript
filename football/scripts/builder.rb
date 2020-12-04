# encoding: utf-8

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

  FS_START_REGEX  = /(nat fs|National football squad) start/
  FS_PLAYER_REGEX = /(nat fs|National football squad) player/
  FS_END_REGEX    = /(nat fs|National football squad) end/

  FS_PLAYER_NAME_REGEX = /\b
                          name=#{WIKI_LINK_PATTERN}
                         /x

  FS_PLAYER_CLUB_REGEX = /\b
                          club=#{WIKI_LINK_PATTERN}
                         /x

  FS_PLAYER_CLUBNAT_REGEX = /\b
                          clubnat=
                            (?<clubnat>[A-Z]{3})
                             \b/x


  ## todo:
  ##  check for empty (no number) e.g.   no=-      -- see world cup squads 1930
  ##  check for multiple numbers e.g.  no=9 & 8    -- see world cup squads 1930
  FS_PLAYER_NO_REGEX = /\b
                          no=\s*
                           (?<no>[0-9]+)
                        \b/x

  ## todo:
  ##  check for empty (no caps) e.g.   caps=-      -- see world cup squads 1930
  FS_PLAYER_CAPS_REGEX = /\b
                          caps=
                           (?<caps>[0-9]+)
                          \b/x

  FS_PLAYER_POS_REGEX = /\b
                           pos=
                           (?<pos>[A-Z]{2,})
                          \b/x


  def read( name, opts={} )

    ## e.g. world cup 1930 to 1950 has no player nos (allows to skip player nos - will all be nil)
    skip_player_no = opts[:skip_player_no].nil? ? false : opts[:skip_player_no]

    path = "#{include_path}/#{name}.txt"

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
      line = line.gsub( "'''", '' )   ## remove bold marker


      if line =~ FS_START_REGEX
        logger.debug "start squads block (line #{lineno+1})"
        squad = Squad.new
      elsif line =~ FS_END_REGEX
        logger.debug "end squads block (line #{lineno+1})"
        @squads << squad
      elsif line =~ FS_PLAYER_REGEX
        logger.debug "  parse squads player line (line #{lineno+1})"

        player = Player.new
        
        m=FS_PLAYER_NAME_REGEX.match( line )
        if m
          h = {}
          # - note: do NOT forget to turn name into symbol for lookup in new hash (name.to_sym)
          m.names.each { |n| h[n.to_sym] = m[n] } # or use match_data.names.zip( match_data.captures ) - more cryptic but "elegant"??

          if h[:title]
            player.name      = h[:title]
            player.name_wiki = h[:link]
          else
            player.name      = h[:link]  # link is also title
            player.name_wiki = h[:link]
          end
        end

        m=FS_PLAYER_CLUB_REGEX.match( line )
        if m
          h = {}
          # - note: do NOT forget to turn name into symbol for lookup in new hash (name.to_sym)
          m.names.each { |n| h[n.to_sym] = m[n] } # or use match_data.names.zip( match_data.captures ) - more cryptic but "elegant"??

          if h[:title]
            player.club      = h[:title]
            player.club_wiki = h[:link]
          else
            player.club      = h[:link]  # link is also title
            player.club_wiki = h[:link]
          end
        end

        m=FS_PLAYER_CLUBNAT_REGEX.match( line )
        player.clubnat = m[:clubnat]  if m

        unless skip_player_no
          m=FS_PLAYER_NO_REGEX.match( line )
          player.no = m[:no].to_i  if m     # note: convert string to number (integer)
        end

        m = FS_PLAYER_CAPS_REGEX.match( line )
        player.caps = m[:caps].to_i  if m   # note: convert string to number (integer)

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
      puts squad.to_rec( sort: true )
    end
  end

  
  def write( names )

    ## dump squads
    
    puts " #{@squads.size} squad blocks,  #{names.size} squads recs"
    if @squads.size != names.size
      puts " !!!! squad blocks do NOT match / mismatch"
    end

    @squads.each_with_index do |squad,i|
      team_key = names[i]
      team = TEAMS[ team_key.to_sym ]

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
          f << "##############################\n"
          f << "# #{teamname} \n"
          f << squad.to_rec( sort: true )
      end

    end
  end  # method write

end  # class SquadsBuilder
