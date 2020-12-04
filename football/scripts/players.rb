# encoding: utf-8


class Player   # Player record
  
  attr_accessor :no, :pos,
                :name, :name_wiki,
                :club, :club_wiki,
                :clubnat,
                :caps

  def initialize
  end

  def to_rec
    no_str   = no.nil?    ? '-' : "(#{no})"
    caps_str = caps.nil?  ? '-' : caps.to_s

    buf = ''
    buf << "%4s  "   % no_str
    buf << "%2s  "   % "#{pos}"
    buf << "%-33s  " % "#{name}"
    buf << '## '
    buf << "%4s, "   % caps_str
    buf << "#{club} "
    buf << "(#{clubnat})"  if clubnat
    buf
  end

end # class Player
