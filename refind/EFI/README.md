To mount an EFI boot partition, follow these steps:

1. Discover the volume identifier for your EFI boot partition.

Run this command:

diskutil list

The output should look something like this:

/dev/disk0
 #: TYPE                     NAME          SIZE       IDENTIFIER
 0: GUID_partition_scheme                  *251.0 GB  disk0
 1: EFI                                    209.7 MB   disk0s1
 2: Apple_HFS                Macintosh HD  250.1 GB   disk0s2
 3: Apple_Boot               Recovery HD   650.0 MB   disk0s3
 

In this case, the volume identifier of the EFI partition is disk0s1

2. Create a mount point.

A mount point is a directory where a non-booted volume is mounted.  On Mac OS X, mount points are typically created in /Volumes.  We can create a directory called efi within /Volumes by running the following command:

mkdir /Volumes/efi

3. Mount the EFI partition at the efi mount point.

Run the command:

sudo mount -t msdos /dev/disk0s1 /Volumes/efi