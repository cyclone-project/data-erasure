# Cyclone WP4 "data erasure"

Cyclone bioinformatics use cases require that all data are erased when the VM is stopped.
A way to fullfill this requirements is to launch instances from a LiveCD where everything is written in memory only.

This contains necessary files to automate LiveCD creation: a bash script file and a kickstart file.

The kickstart file permits to create a very minimalistic CentOS 6.7 LiveCD that can be used on a cloud:
- root access is not allowed
- cloud-init package is installed, which create a "cloud-user" account 
- the "cloud-user" account can be used with the end user electronic key to connect using ssh
- the "cloud-user" account is a sudoer without password
