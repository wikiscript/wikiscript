# encoding: utf-8


class Squad   # Squad record

  attr_accessor :players

  def initialize
    @players = []
  end

  POS_TO_I = {
      'GK' => 1,   # goalkeeper
      'DF' => 2,   # defender
      'MF' => 3,   # midfielder
      'FW' => 4,   # forward
      nil  => 5    # unknown pos (let it go last)
  }

  def cmp_by_pos( l, r )
    res =  POS_TO_I[ l.pos] <=> POS_TO_I[ r.pos ]  # pass 1: sort by pos (e.g. GK,DF,MF,FW,nil)
    
    # note: make sure number(no) values are present (e.g. not nil)
    if res == 0 && l.no && r.no
      res =  l.no <=> r.no         # pass 2: sort by (shirt) no (e.g. 1,2,3.etc.)
    end
    res
  end


  def to_rec( opts={} )
    
    sort_by_pos =  opts[:sort] ? true : false

    if sort_by_pos
      players = @players.sort { |l,r| cmp_by_pos( l,r ) }
    else
      players = @players
    end

    last_pos = nil


    buf = ''
    buf << "#   - #{@players.size} players\n"
    buf << "\n"

    players.each do |p|
      if last_pos && last_pos != p.pos   # add newline break for new pos (GK,DF,MF,FW,etc.)
        buf << "\n"
      end

      buf << p.to_rec
      buf << "\n"
      
      last_pos = p.pos
    end

    buf << "\n"
    buf
  end

end # class Squad

