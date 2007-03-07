use strict;
use warnings;

use Test::More;
use Image::ObjectDetect;

my $cascade;
if (exists $ENV{CASCADE_NAME}) {
    $cascade = $ENV{CASCADE_NAME};
} else {
    $cascade = '/usr/local/share/opencv/haarcascades/haarcascade_frontalface_alt2.xml';
    unless (-f $cascade) {
        Test::More->import(skip_all => "no username and password set, skipped.");
        exit;
    }
}
plan tests => 5;

my @faces = Image::ObjectDetect::detect($cascade, 't/test.jpg');
is(scalar @faces, 5); # 5 persons

my $face = shift @faces;
ok(exists $face->{x});
ok(exists $face->{y});
ok(exists $face->{width});
ok(exists $face->{height});

