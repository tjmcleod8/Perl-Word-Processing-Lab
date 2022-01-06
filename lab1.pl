use 5.32.0;
use warnings;
use strict;

my $filename;

while(1){
    print "Enter a filename: ";
    $filename = <STDIN>; #take filename
    chomp($filename); #take off \n

    if(-e $filename){ #if the file exists
        say "\nSummary of file $filename:";
        wordProccessing();
    }elsif($filename eq "quit"){ #if the user wants to quit the program
        exit;
    }else{ #if there is some error
        my $errorString = $!;
        my $errorNum = $! + 0;
        say "Error $errorNum: $errorString";
    }
}

sub wordProccessing {
    my %dictionary;
    my $totalWords = 0;
    my $totalUniqueWords = 0;
    my %uniqueWords;
	my $uniqueWordCount;
    my $counter = 0;
    open(FH,'<',$filename) or die $!; #open file and catch any error if file cannot open
    while(<FH>){
        $counter++; #for line number
		$_ =~ s/^\s+//; #trims any leading spaces out of the string
        $_ = lc $_; #lowercase all letters so that they will match in dictionary and there are no duplicates
        my @words = split(/\s+/, $_); #put words on line into array to proccess
        my $wordcount = @words; #get the word count for the line
        $totalWords += $wordcount; #keep getting the sum for total word count of document
        foreach (@words){ #increment through each word on the line to see if its in the hash
            if(!exists($uniqueWords{$_})){ #if word is not in line hash for unique words
                $uniqueWords{$_} = 1;
            }
            if(exists($dictionary{$_})){ #if the word is in the file dictionary 
                $dictionary{$_}++;
            }else{ #if the word isnt in the dictionary
                $dictionary{$_} = 1;
            }
        }  
		$uniqueWordCount = %uniqueWords;
        say "Line $counter: $wordcount words\t $uniqueWordCount unique words";
        %uniqueWords = (); #empty hash keys and values     
    }
        $totalUniqueWords = %dictionary;
        say "Total number of words found in the file: $totalWords";
        say "Total number of unique words found in the file: $totalUniqueWords and they are:\n";

        my @keys = sort(keys(%dictionary));
        for(my $i = 0; $i<@keys;$i++){
            if($i % 5 == 0){
                print "\n";
            }
            printf("%15s: %-5s", $keys[$i], $dictionary{$keys[$i]});
        }
        print "\n";
    close(FH);
}