# NAME

Kelp::Module::Logger::Log4perl - Log4perl for Kelp applications

# DESCRIPTION

This module provides log interface for Kelp web application. It uses
[Log::Log4perl](https://metacpan.org/pod/Log::Log4perl) instead of [Log::Dispacher](https://metacpan.org/pod/Log::Dispacher). 

# SYNOPSIS

    # conf/config.pl
    {
        'modules' => ['Logger::Log4perl'],
        'modules_init' => {
            'Logger::Log4perl' => {
                'category' => '',
                'conf'     => {
                    'log4perl.rootLogger'                                  => 'TRACE, CommonLog',
                    'log4perl.appender.CommonLog'                          => 'Log::Log4perl::Appender::Screen',
                    'log4perl.appender.CommonLog.layout'                   => 'Log::Log4perl::Layout::PatternLayout::Multiline',
                    'log4perl.appender.CommonLog.layout.ConversionPattern' => '%d{yyyy-MM-dd HH:mm:ss} - %p - %m%n',
                    'log4perl.appender.CommonLog.utf8'                     => '1',
                }
            }
        }
    }

    # lib/MyApp.pm
    sub run {
        my $self = shift;
        my $app  = $self->SUPER::run(@_);
        ...;
        $app->info( 'Kelp is ready to rock!' );
        $app->logger( 'trace', $some_ref_to_dump );

        return $app;
    }

Although module provides alternarive ways of initialization like ["Alternative-initialization" in Log::Log4perl](https://metacpan.org/pod/Log::Log4perl#Alternative-initialization):

    # conf/config.pl

    {
        'modules_init' => {
            'Logger::Log4perl' => {
                'category' => '',
                'conf'     => 'conf/logger.conf',
            }
        }
    };

or even scalar ref:

    {
        'modules' => [ 'Logger::Log4perl' ],
        'modules_init' => {
            'Logger::Log4perl' => {
                'category' => '',
                'conf'     => \<<CONF
    log4perl.rootLogger                                  = DEBUG, CommonLog
    log4perl.appender.CommonLog                          = Log::Log4perl::Appender::Screen
    log4perl.appender.CommonLog.layout                   = Log::Log4perl::Layout::PatternLayout::Multiline
    log4perl.appender.CommonLog.layout.ConversionPattern = %d{yyyy-MM-dd HH:mm:ss} - %p - %m%n
    log4perl.appender.CommonLog.utf8                     = 1
    CONF
           }
        }
    };

# CONFIGURATION

Configuration accepts href with two keys:

## category

The [Log::Log4perl](https://metacpan.org/pod/Log::Log4perl) category to send logs to. Defaults to '' which sends to root logger.

## conf

Configuration for <Log::Log4perl::init> method.

# REGISTERED METHODS

Log methods can take array of scalars or reference as arguments. In case of
reference [Data::Dumper](https://metacpan.org/pod/Data::Dumper) is used to deserialize information.

## debug/info/error

Write log message to $DEBUG/$INFO/$ERROR level.

    # inside controller
    $c->debug( $debug_data );
    $c->info( "my info message." );
    $c->error( @error_messages );

## logger

Write message to one of the following default [Log::Log4perl](https://metacpan.org/pod/Log::Log4perl) log levels:

- trace
- debug
- info
- warn
- error
- fatal
- always

    # inside controller
    $c->logger( 'always', @messages );

# AUTHOR

Konstantin Yakunin

# LICENSE

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.2 or,
at your option, any later version of Perl 5 you may have available.

# BUGS

None reported... yet.

# SEE ALSO

[Log::Log4perl](https://metacpan.org/pod/Log::Log4perl)

[Kelp::Module::Logger](https://metacpan.org/pod/Kelp::Module::Logger)
