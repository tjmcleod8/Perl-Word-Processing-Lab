use 5.32.0;
use warnings;
use strict;

my $inputfile = $ARGV[0];
my $outputfile = $ARGV[1];
my $regex;
open(FHWrite, '>', $outputfile) or die $!; #open write file outside all methods since multiple methods use it

if(-e $inputfile){ #if the files exist from arguments
	getRegex();
}else{ #if there is some error
	my $errorString = $!;
	my $errorNum = $! + 0;
	say "Error $errorNum: $errorString";
	print FHWrite "Error $errorNum: $errorString\n";
}

sub getRegex {
	print "Enter a regular expression: ";
	$regex = <STDIN>;
	print FHWrite "Enter a regular expression: $regex";
	chomp($regex); #take off \n
	$regex =~ s/^\s+|\s+$//g; #take off leading and trailing whitespace if there is any
	$_ = $regex; #makes the elsif easier to write

	if($regex eq "//"){
		exit;
	}elsif(/^\/.+\/$/){ #if string begins and ends with / and there are characters between
		regexMatching();
	}else{
		say "Error entering regular expression (Incorrect format)";
		getRegex();
	}
}

sub regexMatching {
    open(FH,'<',$inputfile) or die $!; #open file and catch any error if file cannot open
	my $lineCounter = 0;

	#take off the the regular expression forward slashes from $regex
	my @re = split("", $regex); 
	pop(@re);
	shift(@re);
	$regex = join('', @re);

	while (<FH>){
		chomp($_);
		my $line = $_;
		$lineCounter++;
		my $matches = 0;
		my @match = ();
		my @startingPoint = ();
		my $start = 0;

		while($line ne ""){
			if($line =~ /$regex/){
				$matches++;
				$start += length($`); #keep track of starting position
				push(@match, $&); 
				push(@startingPoint, $start);
				$line = substr($line,length($`)+1); #get string with next starting position
			}else{ #if no match is found
				$line = '';
			}
		}
		
		if($matches > 0){ #if at least 1 match was found
			say "Line $lineCounter has $matches match(es) with starting location(s) shown:";
			print FHWrite "Line $lineCounter has $matches match(es) with starting location(s) shown:\n";
			my $i = 0;
			while($i < @match){
				if($i != 0 && $i % 3 == 0){ #every third match printed go to a new line
					print "\n";
					print FHWrite "\n";
				}
				printf("%15s [%-s]", $match[$i], $startingPoint[$i]); 
				my $outputstring = sprintf("%15s [%-s]", $match[$i], $startingPoint[$i]);
				print FHWrite "$outputstring";
				$i++;
			}
		}else{ #if there are no matches
			say "Line $lineCounter has 0 matches:";
			print FHWrite "Line $lineCounter has 0 matches:";
		}
		print "\n\n";
		print FHWrite "\n\n";
	}

	close(FH);
	getRegex();
}

close(FHWrite);