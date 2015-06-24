# NAME #

XML::FeedPP -- Parse/write/merge/edit RSS/RDF/Atom syndication feeds

# SYNOPSIS #

Get an RSS file and parse it:
```
    my $source = 'http://use.perl.org/index.rss';
    my $feed = XML::FeedPP->new( $source );
    print "Title: ", $feed->title(), "\n";
    print "Date: ", $feed->pubDate(), "\n";
    foreach my $item ( $feed->get_item() ) {
        print "URL: ", $item->link(), "\n";
        print "Title: ", $item->title(), "\n";
    }
```
Generate an RDF file and save it:
```
    my $feed = XML::FeedPP::RDF->new();
    $feed->title( "use Perl" );
    $feed->link( "http://use.perl.org/" );
    $feed->pubDate( "Thu, 23 Feb 2006 14:43:43 +0900" );
    my $item = $feed->add_item( "http://search.cpan.org/~kawasaki/XML-TreePP-0.02" );
    $item->title( "Pure Perl implementation for parsing/writing xml file" );
    $item->pubDate( "2006-02-23T14:43:43+09:00" );
    $feed->to_file( "index.rdf" );
```
Convert some RSS/RDF files to Atom format:
```
    my $feed = XML::FeedPP::Atom->new();                # create empty atom file
    $feed->merge( "rss.xml" );                          # load local RSS file
    $feed->merge( "http://www.kawa.net/index.rdf" );    # load remote RDF file
    my $now = time();
    $feed->pubDate( $now );                             # touch date
    my $atom = $feed->to_string();                      # get Atom source code
```
# DESCRIPTION #

`XML::FeedPP` is an all-purpose syndication utility that parses and
publishes RSS 2.0, RSS 1.0 (RDF), Atom 0.3 and 1.0 feeds.
It allows you to add new content, merge feeds, and convert among
these various formats.
It is a pure Perl implementation and does not require any other
module except for XML::TreePP.

# METHODS FOR FEED #

## XML::FeedPP->new() ##
```
$feed = XML::FeedPP->new( "index.rss" );
```
This constructor method creates an `XML::FeedPP` feed instance. The only
argument is the local filename.  The format of $source must be one of
the supported feed formats -- RSS, RDF or Atom -- or execution is
halted.
```
$feed = XML::FeedPP->new( "http://use.perl.org/index.rss" );
```
The URL on the remote web server is also available as the first argument.
[LWP::UserAgent](http://search.cpan.org/dist/LWP-UserAgent) is required to download it.
```
$feed = XML::FeedPP->new( "<?xml?><rss version=..." );
```
The XML source code is also available as the first argument.
```
$feed = XML::FeedPP::RSS->new( $source );
```
This constructor method creates an instance for an RSS 2.0 feed.
The first argument is optional, but must be valid an RSS source if specified.
This method returns an empty instance when $source is undefined.
```
$feed = XML::FeedPP::RDF->new( $source );
```
This constructor method creates an instance for RSS 1.0 (RDF) feed.
The first argument is optional, but must be an RDF source if specified.
This method returns an empty instance when $source is undefined.
```
$feed = XML::FeedPP::Atom->new( $source );
```
This constructor method creates an instance for an Atom 0.3/1.0 feed.
The first argument is optional, but must be an Atom source if specified.
This method returns an empty instance when $source is undefined.

Atom 1.0 feed is supported since `XML::FeedPP` version 0.30.
Atom 0.3 is still default however.
```
$feed = XML::FeedPP::RSS->new( link => $link, title => $tile, ... );
```
This constructor method creates an instance
which has `link`, `title` elements etc.

## $feed->load() ##
```
$feed->load( $source );
```
This method loads an RSS/RDF/Atom file,
much like `new()` method does.

## $feed->merge() ##
```
$feed->merge( $source );
```
This method merges an RSS/RDF/Atom file into the existing $feed
instance. Top-level metadata from the imported feed is incorporated
only if missing from the present feed.

## $feed->to\_string() ##
```
$string = $feed->to_string( $encoding );
```
This method generates XML source as string and returns it.  The output
$encoding is optional, and the default encoding is 'UTF-8'.  On Perl
5.8 and later, any encodings supported by the Encode module are
available.  On Perl 5.005 and 5.6.1, only four encodings supported by
the Jcode module are available: 'UTF-8', 'Shift\_JIS', 'EUC-JP' and
'ISO-2022-JP'.  'UTF-8' is recommended for overall compatibility.

## $feed->to\_file() ##
```
$feed->to_file( $filename, $encoding );
```
This method generate an XML file.  The output $encoding is optional,
and the default is 'UTF-8'.

## $feed->add\_item() ##
```
$item = $feed->add_item( $link );
```
This method creates a new item/entry and returns its instance.
A mandatory $link argument is the URL of the new item/entry.

## $feed->add\_item() ##
```
$item = $feed->add_item( $srcitem );
```
This method duplicates an item/entry and adds it to $feed.
$srcitem is a `XML::FeedPP::*::Item` class's instance
which is returned by `get_item()` method, as described above.

## $feed->add\_item() ##
```
$item = $feed->add_item( link => $link, title => $tile, ... );
```
This method creates an new item/entry
which has `link`, `title` elements etc.

## $feed->get\_item() ##
```
$item = $feed->get_item( $index );
```
This method returns item(s) in a $feed.
A valid zero-based array $index returns the corresponding item in the feed.
An invalid $index yields undef.
If $index is undefined in array context, it returns an array of all items.
If $index is undefined in scalar context, it returns the number of items.

## $feed->match\_item() ##
```
@items = $feed->match_item( link => qr/.../, title => qr/.../, ... );
```
This method finds item(s) which match all regular expressions given.
This method returns an array of all matched items in array context.
This method returns the first matched item in scalar context.

## $feed->remove\_item() ##
```
$feed->remove_item( $index );
```
This method removes an item/entry from $feed, where $index is a valid
zero-based array index.

## $feed->clear\_item() ##
```
$feed->clear_item();
```
This method removes all items/entries from the $feed.

## $feed->sort\_item() ##
```
$feed->sort_item();
```
This method sorts the order of items in $feed by `pubDate`.

## $feed->uniq\_item() ##
```
$feed->uniq_item();
```
This method makes items unique. The second and succeeding items
that have the same link URL are removed.

## $feed->normalize() ##
```
$feed->normalize();
```
This method calls both the `sort_item()` and `uniq_item()` methods.

## $feed->limit\_item() ##
```
$feed->limit_item( $num );
```
Removes items in excess of the specified numeric limit. Items at the
end of the list are removed. When preceded by `sort_item()` or
`normalize()`, this deletes more recent items.

## $feed->xmlns() ##
```
$feed->xmlns( "xmlns:media" => "http://search.yahoo.com/mrss" );
```
Adds an XML namespace at the document root of the feed.

## $feed->xmlns() ##
```
$url = $feed->xmlns( "xmlns:media" );
```
Returns the URL of the specified XML namespace.

## $feed->xmlns() ##
```
@list = $feed->xmlns();
```
Returns the list of all XML namespaces used in $feed.

# METHODS FOR CHANNEL #

## $feed->title() ##
```
$feed->title( $text );
```
This method sets/gets the feed's `title` element,
returning its current value when $title is undefined.

## $feed->description() ##
```
$feed->description( $html );
```
This method sets/gets the feed's `description` element in plain text or HTML,
returning its current value when $html is undefined.
It is mapped to `content` element for Atom 0.3/1.0.

## $feed->pubDate() ##
```
$feed->pubDate( $date );
```
This method sets/gets the feed's `pubDate` element for RSS,
returning its current value when $date is undefined.
It is mapped to `dc:date` element for RDF,
`modified` for Atom 0.3, and `updated` for Atom 1.0.
See also L</DATE AND TIME FORMATS> section below.

## $feed->copyright() ##
```
$feed->copyright( $text );
```
This method sets/gets the feed's `copyright` element for RSS,
returning its current value when $text is undefined.
It is mapped to `dc:rights` element for RDF,
`copyright` for Atom 0.3, and `rights` for Atom 1.0.

## $feed->link() ##
```
$feed->link( $url );
```
This method sets/gets the URL of the web site as the feed's `link` element,
returning its current value when the $url is undefined.

## $feed->language() ##
```
$feed->language( $lang );
```
This method sets/gets the feed's `language` element for RSS,
returning its current value when the $lang is undefined.
It is mapped to `dc:language` element for RDF,
`feed xml:lang=""` for Atom 0.3/1.0.

## $feed->image() ##
```
$feed->image( $url, $title, $link, $description, $width, $height )
```
This method sets/gets the feed's `image` element and its child nodes,
returning a list of current values when any arguments are undefined.

# METHODS FOR ITEM #

## $item->title() ##
```
$item->title( $text );
```
This method sets/gets the item's `title` element,
returning its current value when the $text is undefined.

## $item->description() ##
```
$item->description( $html );
```
This method sets/gets the item's `description` element in HTML or plain text,
returning its current value when $text is undefined.
It is mapped to `content` element for Atom 0.3/1.0.

## $item->pubDate() ##
```
$item->pubDate( $date );
```
This method sets/gets the item's `pubDate` element,
returning its current value when $date is undefined.
It is mapped to `dc:date` element for RDF,
`modified` for Atom 0.3, and `updated` for Atom 1.0.
See also L</DATE AND TIME FORMATS> section below.

## $item->category() ##
```
$item->category( $text );
```
This method sets/gets the item's `category` element.
returning its current value when $text is undefined.
It is mapped to `dc:subject` element for RDF, and ignored for Atom 0.3.

## $item->author() ##
```
$item->author( $name );
```
This method sets/gets the item's `author` element,
returning its current value when $name is undefined.
It is mapped to `dc:creator` element for RDF,
`author` for Atom 0.3/1.0.

## $item->guid() ##
```
$item->guid( $guid, isPermaLink => $bool );
```
This method sets/gets the item's `guid` element,
returning its current value when $guid is undefined.
It is mapped to `id` element for Atom, and ignored for RDF.
The second argument is optional.

## $item->set() ##
```
$item->set( $key => $value, ... );
```
This method sets customized node values or attributes.
See also L</ACCESSOR AND MUTATORS> section below.

## $item->get() ##
```
$value = $item->get( $key );
```
This method returns the node value or attribute.
See also L</ACCESSOR AND MUTATORS> section below.

## $item->link() ##
```
$link = $item->link();
```
This method returns the item's `link` element.

# ACCESSOR AND MUTATORS #

This module understands only subset of `rdf:*`, `dc:*` modules
and RSS/RDF/Atom's default namespaces by itself.
There are NO native methods for any other external modules, such as `media:*`.
But `set()` and `get()` methods are available to get/set
the value of any elements or attributes for these modules.
```
$item->set( "module:name" => $value );
```
This sets the value of the child node:
```
    <item><module:name>$value</module:name>...</item>
```
```
$item->set( "module:name@attr" => $value ); 
```
This sets the value of the child node's attribute:
```
    <item><module:name attr="$value" />...</item>
```
```
$item->set( "@attr" => $value ); 
```
This sets the value of the item's attribute:
```
    <item attr="$value">...</item>
```
```
$item->set( "hoge/pomu@hare" => $value ); 
```
This code sets the value of the child node's child node's attribute:
```
    <item><hoge><pomu attr="$value" /></hoge>...</item>
```
# DATE AND TIME FORMATS #

`XML::FeedPP` allows you to describe date/time using any of the three
following formats:
```
$date = "Thu, 23 Feb 2006 14:43:43 +0900"; 
```
This is the HTTP protocol's preferred format and RSS 2.0's native
format, as defined by RFC 1123.
```
$date = "2006-02-23T14:43:43+09:00"; 
```
W3CDTF is the native format of RDF, as defined by ISO 8601.
```
$date = 1140705823; 
```
The last format is the number of seconds since the epoch,
`1970-01-01T00:00:00Z`.
You know, this is the native format of Perl's `time()` function.

# MODULE DEPENDENCIES #

`XML::FeedPP` requires only [XML::TreePP](http://search.cpan.org/dist/XML-TreePP)
which likewise is a pure Perl implementation.
The standard [LWP::UserAgent](http://search.cpan.org/dist/LWP-UserAgent) is required
to download feeds from remote web servers.
`Jcode.pm` is required to convert Japanese encodings on Perl 5.005
and 5.6.1, but is NOT required on Perl 5.8.x and later.

# AUTHOR #

Yusuke Kawasaki, http://www.kawa.net/

# COPYRIGHT AND LICENSE #

Copyright (c) 2006-2008 Yusuke Kawasaki. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.