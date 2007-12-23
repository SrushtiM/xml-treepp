# ----------------------------------------------------------------
    use strict;
    use Test::More tests => 9;
    BEGIN { use_ok('XML::TreePP') };
# ----------------------------------------------------------------
    my $FILES = [qw(
        t/example/hello-en-utf8.xml
        t/example/hello-en-nodecl.xml
        t/example/hello-en-noenc.xml
        t/example/hello-en-latin1.xml
    )];
    &test_main();
# ----------------------------------------------------------------
sub test_main {
    my $tpp = XML::TreePP->new();
    my $prev;
    foreach my $file ( @$FILES ) {
        my $tree = $tpp->parsefile( $file );
        if ( defined $prev ) {
            is( $tree->{root}->{text}, $prev, $file );
        } else {
            like( $tree->{root}->{text}, qr/\S\!/, $file );
            $prev = $tree->{root}->{text};
        }
        my $xml = $tpp->write( $tree );
        like( $xml, qr/^\s*<\?xml[^<>]+encoding="UTF-8"/is, "write encoding" );
    }
}
# ----------------------------------------------------------------
;1;
# ----------------------------------------------------------------
