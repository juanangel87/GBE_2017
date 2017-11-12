open(MIarbol,"HCV.tre")|| die "cannot find file\n";
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
		
