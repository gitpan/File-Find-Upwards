use 5.008;
use strict;
use warnings;

package File::Find::Upwards;
our $VERSION = '1.100860';
# ABSTRACT: Look for a file in the current directory and upwards
use Path::Class;
use Attribute::Memoize;
use Exporter qw(import);
our @EXPORT = qw(file_find_upwards find_containing_dir_upwards);

sub file_find_upwards : Memoize {
    my $wanted_file = shift;
    my $dir         = dir('.')->absolute;
    my %seen;
    my $result;    # left undef as we'll return undef if we didn't find it
  LOOP: {
        do {
            last if $seen{$dir}++;
            my $file = $dir->file($wanted_file);
            if (-e $file) {
                $result = $file->absolute;
                last LOOP;
            }
        } while ($dir = $dir->parent);
    }
    $result;
}

sub find_containing_dir_upwards : Memoize {
    my $wanted_file = shift;
    my $dir         = dir('.')->absolute;
    my %seen;
    my $result;    # left undef as we'll return undef if we didn't find it
  LOOP: {
        do {
            last if $seen{$dir}++;
            my $file = $dir->file($wanted_file);
            if (-e $file) {
                return $dir;
            }
        } while ($dir = $dir->parent);
    }
    undef;
}
1;


__END__
=pod

=head1 NAME

File::Find::Upwards - Look for a file in the current directory and upwards

=head1 VERSION

version 1.100860

=head1 SYNOPSIS

    use File::Find::Upwards qw(file_find_upwards);

    my $filename = file_find_upwards('myconfig.yaml');
    if ($filename) { rand() }

=head1 DESCRIPTION

Provides functions that can find a file in the current or a parent directory.

=head1 FUNCTIONS

=head2 file_find_upwards

Takes a filename and looks for the file in the current directory. If there is
no such file, it traverses up the directory hierarchy until it finds the file
or until it reaches the topmost directory. If the file is found, the full path
to the file is returned. If the file is not found, undef is returned.

The result is memoized, so repeated calls to the function with the same
filename will return the result of the first call for that filename.

This function is exported automatically.

=head2 find_containing_dir_upwards

Like C<file_find_upwards()>, but reports the directory that contains the file.
A C<Path::Class::Dir> object is returned.

This function is exported automatically.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org/Public/Dist/Display.html?Name=File-Find-Upwards>.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN
site near you, or see
L<http://search.cpan.org/dist/File-Find-Upwards/>.

The development version lives at
L<http://github.com/hanekomu/File-Find-Upwards/>.
Instead of sending patches, please fork this project using the standard git
and github infrastructure.

=head1 AUTHOR

  Marcel Gruenauer <marcel@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2008 by Marcel Gruenauer.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

