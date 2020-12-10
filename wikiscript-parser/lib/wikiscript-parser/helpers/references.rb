module Wikiscript

##  todo/fix: move helpers to wikiscript gem (out of parser!!!)


class References  ## check: rename/use singular - why? why not?
  include SanitizeHelper    # pulls in sanitize( text ) helper


  attr_reader :refs   # add public refs access - why? why not?

  def initialize( nodes )
    ## keep track and auto-number references
    ##  note: references can get grouped
    @refs = {}

    ## todo/check: reset @refs or such - why? why not?
    ##   or only allow one-time resolve via c'tor/initialize - why? why not?

    # resolve references (e.g. auto-number 1,2,3,etc.)
    resolve_refs( nodes )
  end



  def to_json   ## note: returns a data hash (NOT a serialized string)
    ### reorder refs
    ##  lets note (if present go first)
    weight = {'note'=> 1,
              'auto'=> 99999 }

    groups = @refs.keys.sort do |l,r|
                              ## if not found (assume stable sort - use weight 100)
                               (weight[l]||100) <=> (weight[r]||100)
                            end

    data = {}

    groups.each do |group|
       name =  if group == 'auto'
                 'references'
              else
                 group  ## use group name
              end

      h = data[ name ] = {}

      @refs[group].each do |_,rec|  ## note: ignore ref name for now (thus, _)
        idx  = rec[:index]
        node = rec[:node]

        if node.nil? || node == '??'
            puts "!! WARN - missing ref source in (#{name}) - #{rec.inspect}"
            h["[^#{idx}]"] = "??"
        else
            h["[^#{idx}]"] = ref_to_text( node )
        end
      end
    end
    data
  end

  def ref_to_text( refnode )
    nodes = refnode.children
    ## check for cite templates
    cites = nodes.select { |node|
                             node.is_a?( Wikitree::Template) &&
                             node.name.downcase.start_with?( 'cite')
                         }
    if cites.size > 1
      puts "!! ERROR - only one cite (web/book/etc.) expected per ref, found #{cites.size}:"
      pp refnode
      exit 1
    end

   if cites.size == 0
       ## try convert to text
       puts "==> convert to text:"
       pp refnode
       sanitize( refnode.children.map {|node| node.to_text }.join( ' ' ) )
   else
      cite = cites[0]
      data = {}
      data[ 'template' ] = cite.name.downcase

      cite.params.each_with_index do |param,i|
        puts "  [#{i+1}] #{param.name}:"
        puts "text: #{param.to_text}"
        puts "source: #{param.to_wiki}"
        puts
        data[ param.name ] = sanitize( param.to_text )
      end
      data
   end
 end


  ########
  # helpers
  def resolve_refs( nodes )
    ## pp nodes
    puts "resolve_references..."
    _resolve_refs( nodes )

    puts "references:"
    pp @refs
    puts "  #{@refs.keys.size} group(s): #{@refs.keys}"
    puts
  end

  def _resolve_refs( nodes )  ## recursive worker/helper
    nodes.each do |node|
      if node.is_a?( Wikitree::Refname )
        puts "   #{node.inspect}"
        group = node.group || 'auto'  ## use another name for default group?
        group_refs = @refs[ group ] ||= {}
        name  = node.name

        ## check if has been used already??
        stat = group_refs[ name ] ||= { count: 0,
                                        index: group_refs.size+1,
                                        node: '??' }   ## use a (referece) counter for now

        node.count = stat[:index]
        stat[:count] += 1   ## add +1 (reference usage) counter too
      elsif node.is_a?( Wikitree::Ref )
        puts "   #{node.inspect}"
        group = node.group || 'auto'  ## use another name for default group?
        group_refs = @refs[ group ] ||= {}

        ## note: use running (dummy) counter if no name
        ##         e.g. _1, _2, etc.
        name  = node.name || "_#{group_refs.size+1}"

        ## check if has been used already??
        stat = group_refs[ name ] ||= { count: 0,
                                        index: group_refs.size+1,
                                        node: node }   ## use a (referece) counter for now

        if stat[:count] > 0  ## bingo found; ref already in-use (auto-numbered)
          ## add yourself as inline definition too
          ##  todo/check for duplicate/overwrite - why? why not?!!
          stat[:node] = node
        end

        node.count = stat[:index]
        stat[:count] += 1   ## add +1 (reference usage) counter too
      else ## keep on searching/resolving refs...
        if node.children.size > 0
          ## puts "  walk node >#{node.class.name}< w/ #{node.children.size} children"
          _resolve_refs( node.children )
        end
      end
    end
  end


end # class References


end # module Wikiscript
