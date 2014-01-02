#!/usr/bin/perl -w
use strict;
use CGI;
use CGI::Carp;
use Email::Send;
use Mail::Verify;

my $mailserver =  "mx1.balanced.spunky.mail.dreamhost.com";

my $q = new CGI;
my $msg = $q->param("message");
my $from = $q->param("from");
my $subject = $q->param("subject");
my $redirect = $q->param("redirect");
my @to;
push(@to, $q->param("email1")) if $q->param("email1");
push(@to, $q->param("email2")) if $q->param("email2");
push(@to, $q->param("email3")) if $q->param("email3");
push(@to, $q->param("email4")) if $q->param("email4");
push(@to, $q->param("email5")) if $q->param("email5");
push(@to, $q->param("email6")) if $q->param("email6");


my $email_ck = Mail::Verify::CheckAddress( $from );
unless($email_ck){
  my $sender = Email::Send->new({mailer => 'SMTP'});
  $sender->mailer_args([Host => $mailserver]);
  
  foreach my $rcpt(@to){
    my $fullmsg = "
To: $rcpt
From: $from
Subject: $subject

$msg
";
#  carp "send: $fullmsg";
    $sender->send($fullmsg);
  }
}else{
  carp("Error, Ivalid from address $from");
}
if($redirect){
  print $q->redirect($redirect);
}else{
  carp "No redirect";
  print $q->redirect($q->referer);
}
