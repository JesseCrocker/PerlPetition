#!/usr/bin/perl -w
use lib qw( /home/bfchosting/perlmods/lib/perl/5.8 /home/bfchosting/perlmods/lib/perl/5.8.4
            /home/bfchosting/perlmods/share/perl/5.8 /home/bfchosting/perlmods/share/perl/5.8.4 );

use strict;
use CGI;
use DBI;
use CGI::Carp;
use Email::Send;
use Petal;

$Email::Send::Sendmail::SENDMAIL = '/usr/sbin/sendmail';

my $template_file = "mailtofriend.html";

my %conf = (
	    "dbuser" => "...",
	    dbpassword=> "....",
	    "db" => "...",
	    "dbserver" => "...",
	    "table" => "signatures"
);


my $q = new CGI;

my $dbh = DBI->connect("DBI:mysql:$conf{'db'}:$conf{'dbserver'}", 
                       $conf{'dbuser'}, $conf{'dbpassword'}) || 
    (croak 'failed to connect to database');

my %input_params = $q->Vars;
if(my $data = validate_input(\%input_params)){
  my $sth = $dbh->prepare("INSERT INTO $conf{'table'} (" . 
			  join(", ", keys(%$data)) . ') VALUES (' . 
			  join(", ", map($dbh->quote($_), values(%$data))) 
			  . ')');
  $sth->execute || carp $dbh->errstr;
  if($q->param("list")){
    list_signup($q->param("email"));
  }
}else{
  carp('did not validate input');
}

my $template = new Petal ($template_file);
print $q->header, $template->process (email => $q->param("email"));

sub validate_input{
  my %in = %{shift @_};
  my @reqfields = qw(first_name last_name email city state address);
  my @optfields = qw(comments country);
  my %out;
  foreach my $field (@reqfields){
    if(defined($in{$field})){
      $out{$field} = $in{$field};
    }else{
#      carp "did not find required field $field";
      return;
    }
  }
  foreach my $field (@optfields){
    if(defined($in{$field})){
      $out{$field} = $in{$field};
    }
  }
  return \%out;
}

sub list_signup{
  my $send_sub_to = 'bfc-media@buffalo.wildrockies.org';
  my $email = shift @_;
  my $name = shift @_;
  my $from = 'bfchosting@buffalo.dreamhosters.com';
  my $sender = Email::Send->new({mailer => 'Sendmail'});
  my $msg = "To: $send_sub_to
From: $from
Subject: subscription request from $name - $email

sub $email
";
  $sender->send($msg);
}
