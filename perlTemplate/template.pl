#!/usr/bin/perl -w 

###
# TODO: Pass the logging to the class files (mostly done)
# 		Make the names of the classes user-configurable
#		Make the whole thing create a .pl file and a set of .pm files at execution time.
#			At the moment, setup is done by copying the template.pl file and the .pm files and then doing a string replace on the class names
#		Put the logging conf in a conf file

use lib 'lib';
use Group;
use Apps;
use Data::Dumper;
use Getopt::Long;
use Log::Log4perl qw(get_logger :levels);

# TODO: make this use the name of the generated program as the name of the log.
$DEFAULT_LOGDIR = "logs";
$DEFAULT_LOGFILE = sprintf("%s/%s.log", $DEFAULT_LOGDIR,  &generateFileName("logfile"));
$DEFAULT_LOGLEVEL = "INFO";
$DEFAULT_OUTDIR = "output";
$DEFAULT_OUTFILE = sprintf("%s/%s.out", $DEFAULT_OUTDIR,  &generateFileName("outfile"));
$logger_name = "template";

$opts = GetOptions ('help' => \$help, 'outfile:s' => \$outfile, 'logfile:s' => \$logfile, 'loglevel:s' => \$loglevel);

if ($help) {
	&print_usage();
	exit;
}
if (! $outfile) {
	$outfile = $DEFAULT_OUTFILE;
}

our $logger = &setUpLogging($logger_name);
&setUpOutfile($outfile);

$logger->warn("----- START -----");
$logger->warn("Logging to ($logfile) at loglevel $loglevel");
$logger->warn("Printing output to ($outfile)");

## Logging and output is set up. Now instantiate the classes.


# MAIN PROGRAM #
@applications = [] ; # list of all applications in the Crowd system
@groups = ("ALPS Team", "applications");

$logger->fatal("About to create group objects");
# Create group objects
$group_OSI = Group->new();
$logger->info("Main is about to call Groups set_name");
$group_OSI->set_name("OSI"); 
$logger->info("Main just created a group and set the name to OSI");

# Create an array of App objects
=item
$bamboo = Apps->new();
$bamboo->set_name("bamboo");
$logger->info("Bamboo_groups: ");
#	foreach my $bg(@bamboo_groups) { $logger->info("bg = (" . $bg->get_name() . ")"); # Works }
$bamboo->set_groups(@bamboo_groups);
$bamboo->set_parent("bamboo");
$bamboo->print_groups();
push @app_array, $bamboo;

# Print the group name and the members
foreach $group(@group_array) {
	$logger->info("Group name: " . $group->get_name() . "\n");
	$logger->info("Members of group:\n");
	my $members = $group->get_members();
	print Dumper $members;
	for ( my $i = 0; $i <= $#{ $members }; $i++ ) {
    	$logger->info("\t$members->[$i]->get_name(), ");
	}
}	
=cut
$logger->warn("----- END -----");
close OUTFILE;

##### SUBS START HERE #####

# Prints the output of the run of the program
sub print_output {

}

sub generateFileName {
	my $filename = shift;
	print STDOUT "filename = ($filename)\n";
	# grab the current time
	my @now = localtime();
	my $timeStamp = sprintf("%04d-%02d-%02d_%02d.%02d.%02d", 
                        $now[5]+1900, $now[4]+1, $now[3],
                        $now[2],      $now[1],   $now[0]);
	$filename = "$filename.$timeStamp";
	return $filename;
}

sub getTimestamp {
	my @now = localtime();
	my $timeStamp = sprintf("%04d-%02d-%02d_%02d.%02d.%02d", $now[5]+1900, $now[4]+1, $now[3], $now[2], $now[1], $now[0]);
	return $timeStamp;
}

sub setUpOutfile {
	my ($outfile) = shift;
	if (! -e $DEFAULT_OUTDIR) {
		print STDOUT "DEFAULT_OUTDIR doesn't exist: ($DEFAULT_OUTDIR)\n";
	}

	if (! $outfile) {
		$outfile = $DEFAULT_OUTFILE;
	}
	elsif ($outfile =~ /\//) {
		print STDOUT "outfile specifies a directory ($outfile)\n";
		local ($dir, $file) = split('/', $outfile);
		print STDOUT "dir = ($dir), file = ($file)\n";
		if (! -e $dir) {
			mkdir $dir;
		}
		elsif (! -d $dir) {
			print STDOUT "Directory $dir exists, but it's not a directory.\n";
			exit;
		}
		$outfile = sprintf("%s/%s.out", $dir,  &generateFileName($file));
	}
	else {
		print STDOUT "Printing output to default directory ($DEFAULT_OUTDIR)\n";
		$outfile = sprintf("%s/%s.out", $DEFAULT_OUTDIR,  &generateFileName($outfile));
	}
	print STDOUT "outfile = $outfile\n";
	open(OUTFILE,">$outfile") or die "Can't open outfile ($outfile): $!\n";	
}

sub setUpLogging {
	my $logger_name = shift;
	if (! -e $DEFAULT_LOGDIR) {
		print STDOUT "DEFAULT_LOGDIR doesn't exist: ($DEFAULT_LOGDIR)\n";
	}

	if (! $logfile) {
		$logfile = $DEFAULT_LOGFILE;
	}
	elsif ($logfile =~ /\//) {
		print STDOUT "logfile specifies a directory ($logfile)\n";
		local ($dir, $file) = split('/', $logfile);
		print STDOUT "dir = ($dir), file = ($file)\n";
		if (! -e $dir) {
			mkdir $dir;
		}
		elsif (! -d $dir) {
			print STDOUT "Directory $dir exists, but it's not a directory.\n";
			exit;
		}
		$logfile = sprintf("%s/%s.log", $dir,  &generateFileName($file));
	}
	else {
		print STDOUT "logging to default directory ($DEFAULT_LOGDIR)\n";
		$logfile = sprintf("%s/%s.log", $DEFAULT_LOGDIR,  &generateFileName($logfile));
	}
	print STDOUT "logfile = $logfile\n";
	
	# TODO: check if provided $loglevel is a valid string (TRACE, DEBUG, INFO, WARN, ERROR, FATAL)
	if (! $loglevel) {
		$loglevel = $DEFAULT_LOGLEVEL;
	}
	print STDOUT "loglevel = ($loglevel)\n";
	$logger = get_logger($logger_name);	# Actual call to create the logger object
	$logger->level($loglevel);
	if ( $logger->isTraceEnabled()) {
		print STDOUT "Loglevel is Trace\n";
	}
	elsif ( $logger->isDebugEnabled()) {
		print STDOUT "Loglevel is Debug\n";
	}
	elsif ( $logger->isInfoEnabled()) {
		print STDOUT "Loglevel is Info\n";
	}
	elsif ( $logger->isWarnEnabled()) {
		print STDOUT "Loglevel is Warn\n";
	}
	elsif ( $logger->isErrorEnabled()) {
		print STDOUT "Loglevel is Error\n";
	}
	elsif ( $logger->isFatalEnabled()) {
		print STDOUT "Loglevel is Fatal\n";
	}
	else {
		print STDOUT "Totally lost on the log level\n";
	}
	
	my $appender = Log::Log4perl::Appender->new(
		"Log::Dispatch::File",
		filename => $logfile,
		mode => "append",
	);
	my $screen = Log::Log4perl::Appender->new(
			"Log::Dispatch::Screen",
			mode => "append",
	);
	
	$logger->add_appender($appender);
	$logger->add_appender($screen);
	
	my $layout = Log::Log4perl::Layout::PatternLayout->new( "%d %p: %L %M - %m%n");
	$appender->layout($layout);
	$screen->layout($layout);
	return $logger;
}

# http://perldoc.perl.org/Getopt/Long.html
# : means optional
# = means required
sub print_usage {
	local $var = <<"EOF";

	Creates a perl program file with logging and output set up, and a pair of classes ready for instantiation.
	The sample classes are Groups.pm and Apps.pm

Options:
	--help: help. that's this.
	--logfile (Optional): the file to which the program's logs should be printed.
		Default behavior: Create a file at logs/logfile.YYYY-MM-DD_hh.mm.ss.log
		--logfile foo: log messages to logs/foo.YYYY-MM-DD_hh.mm.ss.log
		--logfile monLogs/foo: log messages to monLogs/foo.YYYY-MM-DD_hh.mm.ss.log
		If the default "logs" directory or the provided custom logging directory doesn't exist it will be created.
	--outfile [file|dir/file] (Optional): the file to which the program output/result should be printed.
		Default behavior: Create a file at output/logfile.YYYY-MM-DD_hh.mm.ss.out
		--outfile foo: log messages to output/foo.YYYY-MM-DD_hh.mm.ss.out
		--outfile monLogs/foo: log messages to monLogs/foo.YYYY-MM-DD_hh.mm.ss.out
		If the default "output" directory or the provided custom output directory doesn't exist it will be created.
	--loglevel (Optional): the Log::Log4perl logging level. Options are TRACE, DEBUG, INFO (default), WARN, ERROR, FATAL
		http://search.cpan.org/~mschilli/Log-Log4perl-1.47/lib/Log/Log4perl.pm

EOF
	print "$var\n";
	exit;
}
