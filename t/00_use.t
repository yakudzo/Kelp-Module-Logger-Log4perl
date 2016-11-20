#!/usr/bin/perl -Iblib/lib -Iblib/arch -I../blib/lib -I../blib/arch
# 
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 00_use.t'

# Test file created outside of h2xs framework.
# Run this like so: `perl 00_use.t'
#   yakudza <twinhooker@gmail.com>     2016/11/13 20:17:45

#########################

use Test::More;
use Kelp;
use Kelp::Test;
use Test::Output;
use Test::More;
use HTTP::Request::Common;

BEGIN {
    use_ok( Kelp::Module::Logger::Log4perl );
    $ENV{KELP_REDEFINE} = 1;
}


#########################

my %tests = (
    normal            => qr/DEBUG .* normal .* ERROR .* normal .* OFF .* normal .* INFO/mxs,
    separate_file     => qr(DEBUG .* separate_file .* ERROR .* separate_file .* OFF .* separate_file .* INFO)mxs,
    scalar_ref        => qr(DEBUG .* scalar_ref .* ERROR .* scalar_ref .* OFF .* scalar_ref .* INFO)mxs,
    category_selected => qr([^DEBUG] .* ERROR .* category_selected .* OFF .* category_selected .* INFO)mxs,
);

for my $mode (keys %tests) {
    stdout_like( sub { run_t( $mode ) }, $tests{ $mode }, 'Output test' );
}

done_testing;

sub run_t {
    my $test = shift;
    my $app  = Kelp->new(mode => $test);    
    
    can_ok $app, $_ for qw(error debug);
    
    my $t = Kelp::Test->new(app => $app);
    $app->add_route(
        '/log', sub {
            my $self = shift;
            $self->debug("Debug message with $test config.");
            $self->error("Error message with $test config.");
            $self->logger('always', "Critical message with $test config.");
            "ok";
        }
    );
    $t->request(GET '/log')->code_is(200);
}

