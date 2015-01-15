#!/usr/bin/perl

use warnings;
use strict;

package perl;
use parent '_default';

sub initialize {
  my ($self, %conf) = @_;

  $self->{sourcefile}      = 'prog.pl';
  $self->{execfile}        = 'prog.pl';
  $self->{default_options} = '';
  $self->{cmdline}         = 'perl $options $sourcefile';
}

sub postprocess_output {
  my $self = shift;
  $self->SUPER::postprocess_output;

  $self->{output} =~ s/\s+at $self->{sourcefile} line \d+, near ".*?"//;
  $self->{output} =~ s/\s*Execution of $self->{sourcefile} aborted due to compilation errors.//;
}

1;
