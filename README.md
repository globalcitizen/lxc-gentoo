lxc-gentoo: Linux Containers Gentoo Guest Template Script
=========================================================

https://github.com/globalcitizen/lxc-gentoo

The script creates a root filesystem and config
file suitable for initializing a Gentoo guest
within an LXC (Linux Containers) environment.

While normally run interactively, the script also
accepts input from various environment variables.


Requirements
------------
 - Recent Linux kernel (>=3.2.x recommended)
    http://www.kernel.org/
 - lxc userspace utilities
    (Gentoo: 'emerge lxc')


November 2012 Updates
---------------------
 - Various contributed minor improvements around
   locking, indentation, shell syntax, etc.
 - Don't drop 'fowner' capability, as it breaks
   portage's ability to chown.
 - Don't create /etc/init.d/net.eth0 unless DHCP
   is specified.

October 2012 Updates
--------------------
 - Migrate stage3 URL from 'arch' to 'subarch'
   basis, as per Gentoo Release Guidelines.


September 2012 Updates
----------------------

 - Default network config has changed. Instead
   of assuming a bridge setup, we use simpler 
   'veth' based tunnels direct to the host,
   which now appear as 'guestname' in the
   host's interface list.  (Also resolves an
   apparently outstanding bug related to random
   MAC assignment, see http://bit.ly/QWAkOy )

 - Generated guests now attempt to aggressively 
   drop capabilities ('man 7 capabilities') in
   a bid to plug known security issues, also to
   pre-mount /proc and remove /sys for the same
   purpose.  (See also: http://bit.ly/SSDbY0 )

 - Add DHCP support

 - SSH setup code dropped as out of scope

 - More OpenRC related fixes for faster startup.

 - Various minor updates


History
-------

 The project was originally hosted at...
  http://sourceforge.net/projects/lxc-gentoo/
 
 It was moved to github by Julien Sanchez at:
  https://github.com/gentooboontoo/lxc-gentoo

 This was then forked again by the original 
 author in order to move project hosting to 
 github.
  https://github.com/globalcitizen/lxc-gentoo

 Since then it has seen contributions from
 many parties.
