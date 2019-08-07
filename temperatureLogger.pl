use strict;
use warnings;
use v5.10;	# For say
use DBI;	# For database access

my $temperatureRecordInterval = 5;
my $tempSensorSerial = '<DS18B20 serial>';
my $temperatureSensorName = "Appartement binnen";

my $db_dsn = "DBI:mysql:<database>:<host>:<port>";
my $db_username = "";
my $db_password = '';


for (;;) {
	my $temperature = ReadTemperature($tempSensorSerial);
	if (defined $temperature) {
		WriteTemperatureToDatabase($db_dsn, $db_username, $db_password, $temperatureSensorName, $temperature);
	}
	sleep $temperatureRecordInterval;
}

sub ReadTemperature {
	my $tempSensorSerial = $_[0];

	open (my $fileHandle, '<', '/sys/bus/w1/devices/' . $tempSensorSerial . '/w1_slave')
		or die "Unable to open file, $!";

	my @temp_file=<$fileHandle>;

	close ($fileHandle)
		or warn "Unable to close the file handle: $!";

	print $temp_file[0];
	print $temp_file[1];

	if ($temp_file[0] =~ /YES/) {
		# print "goeie.\n";
		my @string_parts = split /t=/, $temp_file[1];
		my $temperature = $string_parts[1] / 1000;
		# print "Temperature = $temperature\n";
		return $temperature;
	}
	print "Temperature reading was not valid.\n";
	return undef;
}

sub WriteTemperatureToDatabase {
	my ($dsn, $username, $password, $temperatureName, $temperatureValue) = @_;

	# connect to MySQL database
	my %attr = ( PrintError=>0,  	# turn off error reporting via warn()
		     RaiseError=>1);   	# turn on error reporting via die()

	my $dbh = DBI->connect($dsn,$username,$password, \%attr);

	say "Connected to MySQL database.";

	my $query = "INSERT INTO Temperatures (Name, Temperature)
		VALUES (?, ?)";

	my $stmt = $dbh->prepare($query);

	if ($stmt->execute($temperatureName, $temperatureValue)) {
		say "Insertion was great success!";
	}

	$stmt->finish();

	$dbh->disconnect();
}
