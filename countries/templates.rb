

module TemplateHelper
  ### add "built-in" template functions


  LANG_NAMES = {
    'de' => 'German',
    'es' => 'Spanish',
    'nl' => 'Dutch',
    'fr' => 'French',
    'la' => 'Latin',
  }


  ## {{native name | de | Republik Österreich}}
  ## {{native name|fr|la République française|nbsp=omit}}
  ## {{native name|et|Eesti Vabariik|võro|Eesti Vabariik|}}
  ##  see https://en.wikipedia.org/wiki/Template:Native_name
  def _native_name( lang, txt, *args, **kwargs )
    ## note: ignore extra args for now - check used for what?
    lang_name = LANG_NAMES[lang] || lang  ## todo/fix: issue warning if NOT found - why? why not?
    " #{txt} (#{lang_name}) "
  end

  ## {{native phrase | nl | \"Eendracht maakt macht\" | italics=off}}
  ## {{native phrase | fr | \"L'union fait la force\" | italics=off}}
  ## {{native phrase | de | \"Einigkeit macht stark\" | italics=off}}
  def _native_phrase( lang, txt, **kwargs )
    lang_name = LANG_NAMES[lang] || lang  ## todo/fix: issue warning if NOT found - why? why not?
    " #{txt} (#{lang_name}) "
  end


  ## {{Lang-en | "National Anthem of the Republic of Austria"}}
  def _lang_en( txt )
    " English: #{txt} "
  end

  ## {{lang|es|Estados Unidos Mexicanos}}
  def _lang( lang, txt, **kwargs )
    " #{txt} "
  end

  ## see france
  ## {{cvt | 551695 | km2}} =>
  ##   551,695 km2 (213,011 sq mi)
  ## {{cvt | 543940.9 | km2}} ( 50th )",
  def _cvt( num, unit )
    ## todo/fix conversion to be done!!!
    " !!{{cvt - #{num} #{unit}}} "
  end

  ##  {{pop density | 67076000 | 643801 | km2}} =>
  ##   116/km2 (300.4/sq mi)
  def _pop_density( num1, num2, unit )
    ## todo/fix conversion to be done!!!
    " !!{{pop density -  #{num1.to_i/num2.to_i}/#{unit}}} "
  end

  ## {{unbulleted list |   Bundeshymne der Republik Österreich  (German)
  ##                   | ( "National Anthem of the Republic of Austria" )
  ##                   |  center }}
  ## {{ublist | item_style=white-space:nowrap; | 69.0% Christianity  | —57.0% Catholicism  | —8.7% Eastern Orthodoxy  | —3.3% Other Christian  | 22.0% No religion  | 7.9% Islam  | 1.1% Other }}",
  def _unbulleted_list( *args, **kwargs )
    ## strip formatting - always last?
    items = args.select { |arg| ['center'].include?( arg.strip ) ? false : true }
    items.join( ', ')
  end
  alias_method :_ublist, :_unbulleted_list
  alias_method :_ubl,    :_unbulleted_list


  ## {{plainlist | * Hungarian * Slovene * Burgenland Croatian <ref></ref><ref></ref>}}",
  def _plainlist( txt, **kwargs )
    item = txt.split( '*' )
    ## cut off/ dummy leading item (before first item marker)
    item.shift

    " #{item.join(', ')} "
  end

  ## {{collapsible list | title=Other traditional mottos:
  ##     | titlestyle=background:transparent;text-align:center;line-height:1.15em;
  ##     | liststyle=text-align:center;white-space:nowrap;
  ##     | \" E pluribus unum \" (la) ++ \"Out of many, one\"
  ##     | \" Annuit cœptis \" (la) ++ \" He has favored our undertakings\"
  ##     | \" Novus ordo seclorum \" (la) ++ \"New order of the ages\" }}",
  def _collapsible_list( *args, **kwargs )
    " #{kwargs[:title]}  #{args.join(', ')} "
  end



  ## {{as of | lc=y | June 2020}}
  ##   => estimate as of June 2020
  def _as_of( *args, **kwargs )
    if args.size == 1
      " as of #{args[0]} "
    else
      " as of #{args.join('/')} "
    end
  end

  ## {{abbr | mm | month}}
  ## {{abbr | dd | day}}
  ## {{abbr | yyyy | year}}
  ## {{abbr | yyyy | year}}
  ## {{abbr | mm | month}}
  ## {{abbr | dd | day}}
  def _abbr( txt1, txt2 )
    " #{txt1} "
  end


  ## {{nobold | and national language }}
  def _nobold( txt )
    " #{txt} "
  end
  ## {{nowrap|
  ## {{no wrap|
  def _nowrap( txt )
    " #{txt} "
  end
  alias_method :_no_wrap, :_nowrap


  ## {{wbr}}
  def _wbr
    ''
  end

  ## {{small | Note: Although Belgium is located in Western European Time / UTC (Z) zone, since 25 February 1940, upon WW2 German occupation , Central European Time / UTC+01:00 was enforced as standard time, with a +0:42:30 offset (and +1:42:30 during DST ) from Brussels LMT (UTC+0:17:30).}}
  def _small( txt )
    " #{txt} "
  end

  ## {{smaller | Note: various other time zones are observed in overseas France...}}
  def _smaller( txt )
    " #{txt} "
  end

  ## {{center |  File:Himno Nacional Mexicano instrumental.ogg }}
  def _center( txt )
   " #{txt} "
  end

  ## {{raise | 0.13em |  constitutional republic }}
  def _raise( style, txt )
    " #{txt} "
  end

  ## {{map caption | location_color=dark green | region=Europe | region_color=dark grey | subregion=the European Union  | subregion_color=green | legend=EU-Austria.svg}}"
  def _map_caption( *args, **kwargs )
    ## return region for now if present
    " #{kwargs[:region]} "
  end

  ##  map switcher for more than one map
  ## {{Switcher|[[File:EU-France (orthographic projection).svg|frameless]]|Show globe
  ##             |[[File:EU-France.svg|upright=1.15|frameless]]|Show map of Europe
  ##             |[[File:France in the World (+Antarctica claims).svg|frameless]]|Show map of French overseas territories
  ##             |default=2}}
  def _switcher( *args, **kwargs )
    " !!{{switcher}} "
  end


 #####
 # explanatory footnote  - auto-add to notes!!!
 ##  (ur, ua, ... - group style??)

  ## {{efn | English is the official language of 32 states;
  ##    English and Hawaiian are both official languages in Hawaii , and English and 20 Indigenous languages are official in Alaska . Algonquian , Cherokee , and Sioux are among many other official languages in Native-controlled lands throughout the country. French is a de facto, but unofficial, language in Maine and Louisiana , while New Mexico law grants Spanish a special status. In five territories, English as well as one or more indigenous languages are official: Spanish in Puerto Rico, Samoan in American Samoa, Chamorro in both Guam and the Northern Mariana Islands. Carolinian is also an official language in the Northern Mariana Islands.!!{{sfn | Cobarrubias | 1983 | p=195}}!!{{sfn | García | 2011 | p=167}}}}
  def _efn( *args, **kwargs )
    ''   ## todo - add "english" footnote (fn) - in pass 2 - why? why not?
  end

  ## {{efn-ur | name=one
  ## | For information about regional languages see Languages of France .}}
  def _efn_ur( *args, **kwargs )
    ''
  end

  ## {{efn-ua | name=altnames
  ##   | Article 35 of the Argentine Constitution gives equal recognition to the names \" United Provinces of the Rio de la Plata \", \"Argentine Republic\" and \"Argentine Confederation\" and using \"Argentine Nation\" in the making and enactment of laws.}}
  def _efn_ua( *args, **kwargs )
    ''
  end

  ###################
  # simple footnote  - auto-add to notes!!

  ## {{sfn | Kidder | Oppenheim | 2007 | p=91}}
  def _sfn( *args, **kwargs )
    ''
  end

  ## {{sfnm | 1a1=Crow | 1y=1992 | 1p=457 | 1ps=:
  ##     \"In the meantime, while the crowd assembled in the plaza continued to shout its demands at the cabildo, the sun suddenly broke through the overhanging clouds and clothed the scene in brilliant light. The people looked upward with one accord and took it as a favorable omen for their cause. This was the origin of the \"sun of May\" which has appeared in the centre of the Argentine flag and on the Argentine coat of arms ever since.\" | 2a1=Kopka | 2y=2011 | 2p=5 | 2ps=: \"The sun's features are those of Inti , the Inca n sun god. The sun commemorates the appearance of the sun through cloudy skies on 25 May 1810, during the first mass demonstration in favor of independence.\"}}
  def _sfnm( *args, **kwargs )
    ''
  end



  ## {{infobox | child=yes
  ##   | regional_languages=See Languages of France
  ##    | label1=Nationality (2018)
  ##   | data1=93.0% French citizens , 7.0% foreign nationals}}
  def _infobox( *args, **kwargs )
    ''
  end


  def _increase
    ##" <UP> "
    " (increase) "
  end

  ## {{decrease}}
  def _decrease
    " (decrease) "
  end


  def _cite_web( *args, **kwargs )
    ## " <CITE_WEB> "
    ''
  end

  ## {{notelist |
  def _notelist( *args, **kwargs )
    ''
  end


  ## {note | ccc}
  # NOTES = {
  #  'aaa' => '[^a]:',
  #  'bbb' => '[^b]:',
  #  'ccc' => '[^c]:',  ## or use ??
  #  'ddd' => '[^d]:',  ## or use ??
  # }


  NOTES = {}
  ## {{note|a|}}  -- with empty "ooverflow" arg at the end
  def _note( ref, *args )
    ## note: ignore "overflow" args for now
    ## warn if missing mapping - why? why not?
     ## " <NOTE> "
     " #{NOTES[ref]} "
  end

  ## {{ref label|iboxb|b|}
  ## check with sometime 3 passed in? ignore for now
  def _ref_label( ref, label, *args )
    NOTES[ ref ] = "[^#{label}]:"
    "[^#{label}]"
  end



  ## usage
  ## {{coord|latitude|longitude|coordinate parameters|template parameters}}
  ## {{coord|dd|N/S|dd|E/W|coordinate parameters|template parameters}}
  ## {{coord|dd|mm|N/S|dd|mm|E/W|coordinate parameters|template parameters}}
  ## {{coord|dd|mm|ss|N/S|dd|mm|ss|E/W|coordinate parameters|template parameters}}
  ##  see https://en.wikipedia.org/wiki/Template:Coord
  ##
  ##  {{coord|38|53|N|77|01|W|display=inline}}}}
  ##  {{coord|40|43|N|74|00|W|display=inline}}}}

  ##
  def _coord( *args, **kwargs )
    ## filter out  for now type:
    coords = args.select { |arg| arg.start_with?( 'type' ) ? false : true }

    ##  57°18′22″N 4°27′32″W
    %Q{#{coords[0]}°#{coords[1]}'#{coords[2]}, #{coords[3]}°#{coords[4]}'#{coords[5]}}
  end

end  # module TemplateHelper


