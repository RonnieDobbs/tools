package Group;
use Data::Dumper;
use Log::Log4perl qw(get_logger :levels);
my $logger = Log::Log4perl->get_logger("template"); # needs to match the calling program name. For template.pl, use "template". 

# if I have new() contain this:
#	my $logger = Log::Log4perl->get_logger("template"); 
# and include "logger => $logger," in $self
# then I can access the logger in the functions with this:
#	$self->{logger}->fatal("GROUP.pm CALLED Group::set_name!!!!!!!!");


sub new {
	my $invocant = shift;
	my $class = ref($invocant) || $invocant;
	my $self = {           # Remaining args become attributes
		MEMBERS => [],
		NAME => undef,
		MEMBERFILE => undef,
	};
	bless($self, $class);       # Bestow objecthood
	$logger->fatal("Group::new was just called\n\n\n\n\n\n");
	return $self;
}

sub set_name {
	my $self = shift;
	$logger->fatal("GROUP.pm CALLED Group::set_name!!!!!!!!");
	$self->{NAME} = shift;
}

sub get_name {
	my $self = shift;
	return $self->{NAME}; 
}

sub set_memberfile {
	my $self = shift;
	$self->{MEMBERFILE} = shift;
}

sub get_memberfile {
	my $self = shift;
	return $self->{MEMBERFILE}; 
}


sub set_members {
	my ($self, @m) = @_;
	$logger->fatal("CALLED Group::set_members!!!!!!!!");
	exit;
	push ($self->{MEMBERS}, @m);
}

sub get_members {
	my $self = shift;
	return $self->{MEMBERS}; 
}

sub print_members {
	my $self = shift;
	$logger->info("Members of group " . $self->{NAME} . ":");
	foreach my $m( @{$self->{MEMBERS}} ) {
		$logger->info("\t" . $m);	
	}
}

# Populates $self->{MEMBERS} from $self->{MEMBERFILE}
sub populate {
	my $self = shift;
	if (! $self->{MEMBERFILE}) {
		print STDOUT "FAIL: MEMBERFILE is not populated\n";
		return;
	}
	$logger->debug("memberfile = $self->{MEMBERFILE}");
	open(MF,"<$self->{MEMBERFILE}") or die "Can't open memberfile $self->{MEMBERFILE}: $!\n";
	# Slurp in lines each representing a member.
	# Lines are csv
	my @members = <MF>;
	foreach my $data(@members) {
		chomp $data;
		local $uname; local $email; local $fullName; local $team;
		$logger->debug("data = ($data)");
		sleep 1;
		if ($#data >= 1) {
			($uname,$email,$fullName,$team) = split(',', $data);
			$logger->info("uname, email, fullName, team = ($uname) ($email) ($fullName) ($team)");	
		}
		else {
			$email = "null";
			$fullName = "null";
			$team = "null";
			$logger->info("uname, email, fullName, team = ($uname) ($email) ($fullName) ($team)");	
		}
		push $self->{MEMBERS}, $m;
	}
	close MF;
}

# Populates $self->{MEMBERS} from $self->{MEMBERFILE}
sub populate_simple {
	my $self = shift;
	if (! $self->{MEMBERFILE}) {
		$logger->fatal("FAIL: MEMBERFILE is not populated");
		return;
	}
	open(MF,"<$self->{MEMBERFILE}") or die "Can't open memberfile $self->{MEMBERFILE}: $!\n";
	my @members = <MF>;
	foreach my $m(@members) {
		chomp $m;
		push $self->{MEMBERS}, $m;
	}
	close MF;
}


sub DESTROY {
    my $self = shift;
} 
1;
