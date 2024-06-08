# encoding: utf-8


class Player   # Player record
  
  attr_accessor :no, :pos,
                :name, :name_wiki,
                :club, :club_wiki,
                :clubnat,
                :caps, :goals

  def to_rec
    no_str   = @no.nil?    ? '-' : "#{@no}"
    caps_str = @caps.nil?  ? '-' : '%3d/%-3d' % [@caps,@goals]

    buf = String.new
    buf << "%4s  "  % "#{no_str},"
    buf << "%-33s  " % "#{@name},"
    buf << "%3s  "   % "#{@pos},"
    buf << '  '
    buf << "%8s  "    % "#{caps_str},"
    buf << "#{norm_wiki(@club_wiki)} "   ## note - use club_wiki
    buf << "(#{@clubnat})"  if @clubnat
    buf
  end


  ##########
  # helpers
  def norm_wiki( str )
    #  normalize wiki links (remove qualifiers) e.g.
    #
    #  Fenerbahçe S.K. (football)  => Fenerbahçe S.K. 
    #  Al-Ittihad Club (Jeddah)    => Al-Ittihad Club
 
    str = str.sub( '(football)', '' ).
              sub( '(Jeddah)', '').strip
    str
  end

end # class Player
