#!/usr/bin/perl -w
use strict;
use CGI;
use DBI;
use Petal;
use CGI::Carp;

my %conf = (
	    "dbuser" => "jesse",
	    "dbpassword" => "password",
	    "db" => "petition",
	    "dbserver" => "localhost",
	    "table" => "signatures"
);

my $q = new CGI;

my $dbh = DBI->connect("DBI:mysql:$conf{'db'}:$conf{'dbserver'}", 
                       $conf{'dbuser'}, $conf{'dbpassword'}) || 
    (croak 'failed to connect to database');

my $sth = $dbh->prepare("SELECT * FROM $conf{'table'} ORDER BY id");
$sth->execute || croak $dbh->errstr;


my $template = new Petal ('viewsigs.xhtml');
print $q->header;
print $template->process ("sigs" => $sth->fetchall_arrayref({}));
