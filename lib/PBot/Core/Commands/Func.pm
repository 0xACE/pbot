# File: Func.pm
#
# Purpose: Special `func` command that executes built-in functions with
# optional arguments. Usage: func <identifier> [arguments].
#
# Intended usage is with command-substitution (&{}) or pipes (|{}).
#
# For example:
#
# factadd img /call echo https://google.com/search?q=&{func uri_escape $args}&tbm=isch
#
# The above would invoke the function 'uri_escape' on $args and then replace
# the command-substitution with the result, thus escaping $args to be safely
# used in the URL of this simple Google Image Search factoid command.

# SPDX-FileCopyrightText: 2021 Pragmatic Software <pragma78@gmail.com>
# SPDX-License-Identifier: MIT

package PBot::Core::Commands::Func;
use parent 'PBot::Core::Class';

use PBot::Imports;

sub initialize {
    my ($self, %conf) = @_;

    $self->{pbot}->{commands}->register(sub { $self->cmd_func(@_) }, 'func', 0);
}

sub cmd_func {
    my ($self, $context) = @_;

    my $func = $self->{pbot}->{interpreter}->shift_arg($context->{arglist});

    if (not defined $func) {
        return "Usage: func <keyword> [arguments]; see also: func help";
    }

    if (not exists $self->{pbot}->{functions}->{funcs}->{$func}) {
        return "[No such func '$func']"
    }

    my @params;

    while (defined(my $param = $self->{pbot}->{interpreter}->shift_arg($context->{arglist}))) {
        push @params, $param;
    }

    my $result = $self->{pbot}->{functions}->{funcs}->{$func}->{subref}->(@params);

    $result =~ s/\x1/1/g; # strip CTCP code

    return $result;
}

1;
