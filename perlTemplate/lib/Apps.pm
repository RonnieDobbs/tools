package Apps;
use Data::Dumper;
use Log::Log4perl qw(get_logger :levels);
my $logger = Log::Log4perl->get_logger("template"); # needs to match the calling program name. For template.pl, use "template". 

$logger->level($DEBUG);

sub new {
	my $invocant = shift;
	my $class = ref($invocant) || $invocant;
	my $self = {           # Remaining args become attributes
		NAME => undef, 		# Application name
		GROUPS => [], 		# List of groups that can access the application
		PARENT => undef,	# Parent application (Ex: app sse_sie_svn_bazooka has parent svn)
	};
	bless($self, $class);       # Bestow objecthood
	return $self;
}

sub set_parent {
	my $self = shift;
	$self->{PARENT} = shift;
}

sub get_parent {
	my $self = shift;
	return $self->{PARENT}; 
}

sub set_name {
	my $self = shift;
	$self->{NAME} = shift;
	$logger->debug("Just set name to $self->{NAME}");
}

sub get_name {
	my $self = shift;
	return $self->{NAME}; 
}

sub set_groups {
	my ($self, @g) = @_;
	push ($self->{GROUPS}, @g);
}

sub get_groups {
	my $self = shift;
	return $self->{GROUPS}; 
}

sub print_groups {
	my $self = shift;
	#print Dumper($self);
	if (! @{$self->{GROUPS}}) {
		$logger->info("Application " . $self->get_name() . " can NOT be accessed by any groups");
	}
	$logger->info("Application " . $self->get_name() . " can be accessed by these groups: ");
	foreach my $g( @{$self->{GROUPS}} ) {
		chomp $g;
		$logger->info("\t" . $g->get_name());
	}
	$logger->info();
}

sub DESTROY {
    my $self = shift;
} 
1;
