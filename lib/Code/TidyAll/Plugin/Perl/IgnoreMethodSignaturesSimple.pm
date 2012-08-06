package Code::TidyAll::Plugin::Perl::IgnoreMethodSignaturesSimple;
BEGIN {
  $Code::TidyAll::Plugin::Perl::IgnoreMethodSignaturesSimple::VERSION = '0.01';
}
use strict;
use warnings;
use base qw(Code::TidyAll::Plugin);

sub preprocess_source {
    my ( $self, $source ) = @_;

    for ($source) {

        # Turn method and func into sub
        s/^method (.*)/sub $1 \#__MSS_METHOD/gm;
        s/^func (.*)/sub $1 \#__MSS_FUNC/gm;
    }

    return $source;
}

sub postprocess_source {
    my ( $self, $source ) = @_;

    for ($source) {

        # Turn sub back into method and func
        s/^sub (.*?)\s* \#__MSS_METHOD/method $1/gm;
        s/^sub (.*?)\s* \#__MSS_FUNC/func $1/gm;

        # Add empty parens
        s/^(method|func)(\s*\w+\s*)\{/$1$2\(\) \{/gm;

        # One arg, no spaces inside paren
        s/^(method|func) (\w+) \(\s*([\$\@\%]\w+)\s*\)/$1 $2 \($3\)/gm;

        # Space between method name and paren
        s/^(method|func) (\w+)\(/$1 $2 \(/gm;
    }

    return $source;
}

1;



=pod

=head1 NAME

Code::TidyAll::Plugin::Perl::IgnoreMethodSignaturesSimple - Prep
Method::Signatures::Simple directives for perltidy and perlcritic

=head1 VERSION

version 0.01

=head1 SYNOPSIS

    use Code::TidyAll::Plugin::Perl::IgnoreMethodSignaturesSimple

=head1 DESCRIPTION

This L<tidyall|tidyall> plugin uses a preprocess/postprocess step to convert
L<Method::Signatures::Simple|Method::Signatures::Simple> (C<method> and
C<function>) to specially marked subroutines so that L<perltidy|perltidy> and
L<perlcritic|perlcritic> will treat them as such, and then revert them
afterwards.

The postprocess step also adds an empty parameter list if none is there. e.g.
this

    method foo {

becomes

    method foo () {

=head1 SUPPORT AND DOCUMENTATION

Questions and feedback are welcome, and should be directed to the author.

Bugs and feature requests will be tracked at RT:

    http://rt.cpan.org/NoAuth/Bugs.html?Dist=Code-TidyAll-Plugin-Perl-AlignMooseAttributes
    bug-code-tidyall-plugin-perl-alignmooseattributes@rt.cpan.org

The latest source code can be browsed and fetched at:

    http://github.com/jonswar/perl-code-tidyall-plugin-perl-alignmooseattributes
    git clone git://github.com/jonswar/perl-code-tidyall-plugin-perl-alignmooseattributes.git

=head1 SEE ALSO

L<perltidy|perltidy>

=head1 AUTHOR

Jonathan Swartz <swartz@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Jonathan Swartz.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

