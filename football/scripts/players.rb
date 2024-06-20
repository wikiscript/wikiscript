

class Player   # Player record
  
  attr_accessor :no, :pos,
                :name, :name_wiki,
                :club, :club_wiki,
                :clubnat,
                :caps, :goals,
                :birthyear

  def to_rec
    no_str   = @no.nil?    ? '-' : "#{@no}"
    caps_str = @caps.nil?  ? '-' : '%3d/%-3d' % [@caps,@goals]



    buf = String.new
    buf << "%4s  "  % "#{no_str},"
    buf << "%-33s  " % "#{@name},"
    buf << "%3s  "   % "#{@pos},"
    buf << '  '
    buf << "%8s "    % "#{caps_str},"
    buf << "b. #{@birthyear},  "
    buf << "#{norm_wiki(@club_wiki)} "    ## note - use club_wiki
    buf << "(#{norm_clubnat(norm_wiki(@club_wiki),@clubnat)})"   if @clubnat
    buf
  end


  ##########
  # helpers
  def norm_wiki( str )
    if str.nil?
      puts "!! WARN - club_wiki is nil"
      return nil
    end
    #  normalize wiki links (remove qualifiers) e.g.
    #
    #  Fenerbahçe S.K. (football)  => Fenerbahçe S.K. 
    #  Al-Ittihad Club (Jeddah)    => Al-Ittihad Club
    #  Al Shabab FC (Riyadh)       => Al Shabab FC
 
    str = str.sub( '(football)', '' ).
              sub( '(Riyadh)', '' ).
              sub( '(Jeddah)', '').strip
    str
  end


  def norm_clubnat( club, clubnat )
      ## do NOT use league for country now - why? why not?
    # AS Monaco FC (FRA)  => (MCO)
    if club == 'AS Monaco FC'  
       'MCO'
    else
      clubnat
    end
  end


end # class Player
