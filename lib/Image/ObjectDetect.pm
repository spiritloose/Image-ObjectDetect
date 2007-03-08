package Image::ObjectDetect;
use strict;
use warnings;
use vars qw($VERSION @ISA @EXPORT);

BEGIN {
    $VERSION = '0.02';
    if ($] > 5.006) {
        require XSLoader;
        XSLoader::load(__PACKAGE__, $VERSION);
    } else {
        require DynaLoader;
        @ISA = qw(DynaLoader);
        __PACKAGE__->bootstrap;
    }
}

sub detect($$) {
    my ($cascade, $file) = @_;
    my $ret = xs_detect($cascade, $file);
    wantarray ? @$ret : $ret;
}

1;
__END__

=head1 NAME

Image::ObjectDetect - detects objects from picture(using opencv)

=head1 SYNOPSIS

  use Image::ObjectDetect;

  my $cascade = 'haarcascade_frontalface_alt2.xml';
  my $file = 'picture.jpg';
  my @faces = Image::ObjectDetect::detect($cascade, $file);
  for my $face (@faces) {
      print $face->{x};
      print $face->{y};
      print $face->{width};
      print $face->{height}, "\n";
  }

=head1 DESCRIPTION

Image::ObjectDetect is a simple module to detect objects from picture using opencv.
It is available at: http://sourceforge.net/projects/opencvlibrary/

=head1 FUNCTIONS

=over 4

=item detect($cascade, $file)

Detects objects from picture.

=back

=head1 AUTHOR

Jiro Nishiguchi E<lt>jiro@cpan.orgE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<http://sourceforge.net/projects/opencvlibrary/>

=cut

