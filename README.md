lxc-gentoo: Linux Containers Gentoo Guest Template Script
=========================================================

https://github.com/globalcitizen/lxc-gentoo

The script creates a root filesystem and config
file suitable for initializing a Gentoo guest
within an LXC (Linux Containers) environment.

![LXC Boot Time Screenshot](https://github.com/globalcitizen/lxc-gentoo/raw/master/screenshot.jpg)

Typical startup time on modern hardware (even
without an SSD) is under half a second, and 
as hardware detection and kernel bootstrapping
is not required, the init process is largely 
IO bound.


Usage
-----
While normally run interactively, the script also
accepts input from various environment variables.

 - interactive: `lxc-gentoo create`
 - interactive (with environment): `CACHE=/cache lxc-gentoo create`
 - automated: `lxc-gentoo create -q`
 - automated (with environment): `CACHE=/cache lxc-gentoo create -q`

Available environment variables are as follows:

<table>
 <thead>
  <tr>
   <td>Property</td>
   <td>Environment<br>Variable</td>
   <td>Default<br>Value</td>
   <td>Notes</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td>LXC Container Name</td>
   <td><pre>NAME</pre></td>
   <td><i>gentoo</i></td>
   <td>Used by <i>lxc-start</i>, <i>lxc-stop</i>, etc.</td>
  </tr>
  <tr>
   <td>Hostname</td>
   <td><pre>UTSNAME</pre></td>
   <td><i>gentoo</i></td>
   <td>May be altered by DHCP.</td>
  </tr>
  <tr>
   <td>IPv4 Address</td>
   <td><pre>IPV4</pre></td>
   <td><i>172.20.0.2/24</i></td>
   <td>The special value <i>dhcp</i> may also be used.</td>
  </tr>
  <tr>
   <td>IPv4 Gateway</td>
   <td><pre>GATEWAY</pre></td>
   <td><i>172.20.0.1</i></td>
   <td>Ignored if <i>IPV4</i> is <i>dhcp</i>.</td>
  </tr>
  <tr>
   <td>Guest Root Password</td>
   <td><pre>GUESTROOTPASS</pre></td>
   <td><i>toor</i></td>
   <td>Will be phased out soon.</td>
  </tr>
  <tr>
   <td>Gentoo Architecture</td>
   <td><pre>ARCH</pre></td>
   <td><i>amd64</i></td>
   <td>Gentoo architecture code.</td>
  </tr>
  <tr>
   <td>Gentoo Subarchitecture</td>
   <td><pre>SUBARCH</pre></td>
   <td><i>amd64</i></td>
   <td>Gentoo subarchitecture code.</td>
  </tr>
  <tr>
   <td>Gentoo Architecture Variant</td>
   <td><pre>ARCHVARIANT</pre></td>
   <td>(none)</td>
   <td>Usually none, <i>hardened</i> or <i>hardened+nomultilib</i></td>
  </tr>
  <tr>
   <td>lxc.conf Location</td>
   <td><pre>CONFFILE</pre></td>
   <td><i>${UTSNAME}.conf</i></td>
   <td>Path at which to generate the <i>lxc.conf</i> file.</td>
  </tr>
 </tbody>
</table>

Requirements
------------
 - Recent Linux kernel (>=3.2.x recommended)
    http://www.kernel.org/
 - lxc userspace utilities
    (Gentoo: 'emerge lxc')


January 2013 Updates
--------------------
 - Deployment of whizz-bang screenshot eyecandy.
 - Up to date OpenRC fixes for fast and minimalist
   boot (eg. newer OpenRC 'net' dep behaviour)
 - Additional boot verbosity with agetty --noclear
 - Fairly significant updates to error handling,
   which should now be relatively reliable.
 - Improved internal and external documentation.
 - Explicit inclusion of GPLv3 license text
 - Cancel the following point; we have a fairly
   large stylistic mismatch in addition to our
   use of GPLv3 and their use of LGPL.  I guess
   that's a good thing in some ways because we
   can continue to hack freely without being
   stylistically constrained ;)
 - Development of this script will soon be moving
   to the main lxc utils repository, which has
   recently moved to github.  While it has not
   yet been committed (a style review is pending
   vs. other scripts), you can find that repo
   over here: https://github.com/lxc/lxc

November 2012 Updates
---------------------
 - Comments regarding recent kernel JIT spraying
   vulnerability: http://bit.ly/T9CkqJ
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
