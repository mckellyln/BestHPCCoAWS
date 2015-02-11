#!/usr/bin/perl
# This code is executed after installing HPCCSystems on all box.
#
# Note: The following example assumes you are in the directory, $share/naveens_data
#  These 2 assume there are 4 instances
#  mountHPCCSystems2LargeDeviceOnAllInstances.pl ec2-user public_ips.txt tlh_keys_us_west_2.pem
#

$user = shift @ARGV; # arg 1
$public_ips = shift @ARGV;# arg 2
$pem = shift @ARGV;# arg 3

# Get all public ips
open(IN,$public_ips) || die "Can't open for input: \"$public_ips\"\n";
while(<IN>){
   next if /^\s*$/;
   chomp;
   $esp = $_ if $. == 1;
   push @public_ips, $_;
}
close(IN);

#Stop HPCC on all instances.
for( my $i=$#public_ips; $i >= 0; $i--){ 
  my $ip=$public_ips[$i];
  print("ssh -t -i $pem $user\@$ip \"sudo service hpcc-init stop && sudo service dafilesrv stop\"\n");
  system("ssh -t -i $pem $user\@$ip \"sudo service hpcc-init stop && sudo service dafilesrv stop\"");
}

#Mount /var/lib/HPCCSystem on large storage device
for( my $i=$#public_ips; $i >= 0; $i--){ 
  my $ip=$public_ips[$i];
  print("ssh -t -i $pem $user\@$ip \"perl mountHPCCSystems2LargeDevice.pl\"\n");
  system("ssh -t -i $pem $user\@$ip \"perl mountHPCCSystems2LargeDevice.pl\"");
}

