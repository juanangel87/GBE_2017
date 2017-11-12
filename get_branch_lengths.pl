open(MIarbol,"XXX.tre")|| die "cannot find file\n"; #replace "XXX.tre" by the file name of the tree to analyze
$output = "branch_lengths";
open(branch_lengths, ">$output");
      while( <MIarbol> )
		{
	        $_ =~ s/\,/\n/g;
		$_ =~ s/\)\:/\n/g; #RegEx which identifies internal branch lengths				
		$_ =~ s/\(//g;
	        $_ =~ s/\)//g;
                $_ =~ s/\;//g;
		if ($_ =~/\:/){   
		$_ =~ s/.*\://g;
		print branch_lengths $_;#it prints all branch lengths into a file
		}
}
		close (branch_lengths);
		
