# wikiscript - scripts for wikipedia (get wikitext for page etc.)

* home  :: [github.com/wikiscript/wikiscript](https://github.com/wikiscript/wikiscript)
* bugs  :: [github.com/wikiscript/wikiscript/issues](https://github.com/wikiscript/wikiscript/issues)
* gem   :: [rubygems.org/gems/wikiscript](https://rubygems.org/gems/wikiscript)
* rdoc  :: [rubydoc.info/gems/wikiscript](http://rubydoc.info/gems/wikiscript)


## Usage

Read-only access to wikikpedia pages.
Example - Get wikitext source (via `en.wikipedia.org/w/index.php?action=raw&title=<title>`):


``` ruby
page = Wikiscript::Page.get( '2022_FIFA_World_Cup' )  # same as Wikiscript.get
page.text
```

prints

```
The '''2022 FIFA World Cup''' is scheduled to be the 22nd edition of the [[FIFA World Cup]], 
the quadrennial international men's [[association football]] championship contested by the 
[[List of men's national association football teams|national teams]] of the member associations of [[FIFA]]. 
It is scheduled to take place in [[Qatar]] in 2022. This will be the first World Cup ever to be held 
in the [[Arab world]] and the first in a Muslim-majority country...
```

Or build your own page from scratch (no download):

``` ruby
page = Wikiscript::Page.new( <<TXT, title: '2022_FIFA_World_Cup' )
The '''2022 FIFA World Cup''' is scheduled to be the 22nd edition of the [[FIFA World Cup]], 
the quadrennial international men's [[association football]] championship contested by the 
[[List of men's national association football teams|national teams]] of the member associations of [[FIFA]]. 
It is scheduled to take place in [[Qatar]] in 2022. This will be the first World Cup ever to be held 
in the [[Arab world]] and the first in a Muslim-majority country...
TXT
page.text
```

prints

```
The '''2022 FIFA World Cup''' is scheduled to be the 22nd edition of the [[FIFA World Cup]], 
the quadrennial international men's [[association football]] championship contested by the 
[[List of men's national association football teams|national teams]] of the member associations of [[FIFA]]. 
It is scheduled to take place in [[Qatar]] in 2022. This will be the first World Cup ever to be held 
in the [[Arab world]] and the first in a Muslim-majority country...
```


### Tables

Parse wiki tables into an array.  Example:

``` ruby
table = Wikiscript.parse_table( <<TXT )
{|
|-
! header1
! header2
! header3
|-
| row1cell1
| row1cell2
| row1cell3
|-
| row2cell1
| row2cell2
| row2cell3
|}
TXT

# -or-

table = Wikiscript.parse_table( <<TXT )
{|
! header1 !! header2 !! header3
|-
| row1cell1 || row1cell2 || row1cell3
|-
| row2cell1 || row2cell2 || row2cell3
|}
TXT

# -or-

table = Wikiscript.parse_table( <<TXT )
{|
|-
!
header1
!
header2
!
header3
|-
|
row1cell1
|
row1cell2
|
row1cell3
|-
|
row2cell1
|
row2cell2
|
row2cell3
|}
TXT
```

resulting in:

``` ruby
pp table
#=> [["header1",   "header2",   "header3"],
#    ["row1cell1", "row1cell2", "row1cell3"],
#    ["row2cell1", "row2cell2", "row2cell3"]]
```

Note: `parse_table` will strip/remove (leading) style attributes (e.g. `àttribute="value" |` and (inline) bold and italic emphases (e.g. `''`) from the (cell) text. Example:

``` ruby
table = Wikiscript.parse_table( <<TXT )
{|
|-
! style="width:200px;"|Club
! style="width:150px;"|City
|-
|[[Biu Chun Rangers]]||[[Sham Shui Po]]
|-
|bgcolor=#ffff44 |''[[Eastern Sports Club|Eastern]]''||[[Mong Kok]]
|-
|[[HKFC Soccer Section]]||[[Happy Valley, Hong Kong|Happy Valley]]
|}
TXT
```

resulting in:

``` ruby
pp table
#=> [["Club",                            "City"],
#    ["[[Biu Chun Rangers]]",            "[[Sham Shui Po]]"],
#    ["[[Eastern Sports Club|Eastern]]", "[[Mong Kok]]"],
#    ["[[HKFC Soccer Section]]",         "[[Happy Valley, Hong Kong|Happy Valley]]"]]
```

### Links

Use `parse_link` to split links. Example:

``` ruby
link, title = Wikiscript.parse_link( '[[La Florida, Chile|La Florida]]' )
link   #=> "La Florida, Chile"
title  #=> "La Florida"

link, title = Wikiscript.parse_link( '[[ La Florida, Chile]]' )
link   #=> "La Florida, Chile"
title  #=> nil

link, title = Wikiscript.parse_link( 'La Florida' )
link   #=> nil
title  #=> nil
```

### Document Element Structure

Use `parse` to get the document's element structure.
Note: For now only headings (`h1`, `h2`, `h3`, ...) and tables are supported.
Example:

``` ruby
el = Wikiscript.parse( <<TXT )
=Heading 1==
==Heading 2==
===Heading 3===

{|
|-
! header1
! header2
! header3
|-
| row1cell1
| row1cell2
| row1cell3
|-
| row2cell1
| row2cell2
| row2cell3
|}
TXT

pp el
#=> [[:h1, "Heading 1"],
#    [:h2, "Heading 2"], 
#    [:h3, "Heading 3"],
#    [:table, [["header1", "header2", "header3"],
#              ["row1cell1", "row1cell2", "row1cell3"],
#              ["row2cell1", "row2cell2", "row2cell3"]]]
```


That's all for now. More functionality will get added over time. 



## Install

Just install the gem:

    $ gem install wikiscript


## License

The `wikiscript` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.
