lxc-gentoo: Linux Containers Gentoo Guest Template Script
=========================================================

https://github.com/globalcitizen/lxc-gentoo

The script creates a root filesystem and config
file suitable for initializing a Gentoo guest
within an LXC (Linux Containers) environment.

<img alt="LXC Boot Time Screenshot" src="https://github.com/globalcitizen/lxc-gentoo/raw/master/screenshot.jpg">

Typical startup time on modern hardware (even
without an SSD) is under half a second, and 
as hardware detection and kernel bootstrapping
is not required, the init process is largely 
IO bound.

Requirements
------------
 - Recent Linux kernel (>=3.2.x recommended, >=3.7.x actively tested)
    http://www.kernel.org/ (Gentoo: `emerge hardened-sources` / `emerge gentoo-sources` / `emerge vanilla-sources`)
     - Relevant kernel options enabled (try `lxc-checkconfig` or review the documentation at http://en.gentoo-wiki.com/wiki/LXC)
 - Recent lxc userspace utilities
    (Gentoo: `emerge lxc`)

Usage
-----
While normally run interactively, the script also
accepts input from various environment variables.

 - interactive: `lxc-gentoo create`
 - interactive (with environment): `CACHE=/cache lxc-gentoo create`
 - automated: `lxc-gentoo create -q`
 - automated (with environment): `CACHE=/cache lxc-gentoo create -q`

Available environment variables are as follows.

<table>
 <thead>
  <tr>
   <td><b>Property</b></td>
   <td><b>Environment<br>Variable</b></td>
   <td><b>Default<br>Value</b></td>
   <td><b>Notes</b></td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Cache Path</b></td>
   <td><pre>$CACHE</pre></td>
   <td><i>/var/cache/lxc/gentoo</i></td>
   <td>Stores arch/subarch/variant combo specific stage3 tarballs + extracted root filesystem images, plus the latest portage snapshot.</td>
  </tr>
  <tr>
   <td><b>Mirror</b></td>
   <td><pre>$MIRROR</pre></td>
   <td><i>http://distfiles.gentoo.org</i>
   <td>Specifies the location from which the stage3 tarball and portage snapshot should be fetched.</td>
  </tr>
  <tr>
   <td><b>Stage 3 tarball</b></td>
   <td><pre>$STAGE3_TARBALL</pre></td>
   <td><i></i>
   <td>Specifies the location of a custom stage3 tarball. When this option is present, fetching will be skipped</td>
  </tr>
  <tr>
   <td><b>Portage source</b></td>
   <td><pre>$PORTAGE_SOURCE</pre></td>
   <td><i></i>
   <td>path to a custom portage to use. Can be one of:
    <li> a tarball -- will be extracted</li>
    <li> a directory -- will be bind-mounted read-only</li>
    <li> "none" -- do not set up a portage tree</li>
    <li> undefined -- a portage snapshot will be downloaded</li>
   </td>
  </tr>
  <tr>
   <td><b>LXC Container Name</b></td>
   <td><pre>$NAME</pre></td>
   <td><i>gentoo</i></td>
   <td>Used by <i>lxc-start</i>, <i>lxc-stop</i>, etc.</td>
  </tr>
  <tr>
   <td><b>Hostname</b></td>
   <td><pre>$UTSNAME</pre></td>
   <td><i>gentoo</i></td>
   <td>May be altered by DHCP.</td>
  </tr>
  <tr>
   <td><b>IPv4 Address</b></td>
   <td><pre>$IPV4</pre></td>
   <td><i>172.20.0.2/24</i></td>
   <td>The special value <i>dhcp</i> may also be used.</td>
  </tr>
  <tr>
   <td><b>IPv4 Gateway</b></td>
   <td><pre>$GATEWAY</pre></td>
   <td><i>172.20.0.1</i></td>
   <td>Ignored if <i>$IPV4</i> is <i>dhcp</i>.</td>
  </tr>
  <tr>
   <td><b>Guest Root Password</b></td>
   <td><pre>$GUESTROOTPASS</pre></td>
   <td><i>toor</i></td>
   <td>Will be phased out soon.</td>
  </tr>
  <tr>
   <td><b>Gentoo Architecture</b></td>
   <td><pre>$ARCH</pre></td>
   <td><i>amd64</i></td>
   <td>Gentoo architecture code: alpha, amd64, arm, hppa, ia64, ppc, s390, sh, sparc, x86</td>
  </tr>
  <tr>
   <td><b>Gentoo Architecture Variant</b></td>
   <td><pre>$ARCHVARIANT</pre></td>
   <td>(none)</td>
   <td>Usually none, <i>hardened</i> or <i>hardened+nomultilib</i></td>
  </tr>
  <tr>
   <td><b>lxc.conf Location</b></td>
   <td><pre>$CONFFILE</pre></td>
   <td><i>${UTSNAME}.conf</i></td>
   <td>Path at which to generate the <i>lxc.conf</i> file.</td>
  </tr>
 </tbody>
</table>

Updates
-------

___June 2013___
 - Bashisms
 - Cleaner syntax
 - Improved error handling
 - Speedups
 - Better/improved locking
 - More full-featured prompting
 - Portage tree bind mount support
 - Portage workspace now `tmpfs` mounted
 - More verbose download
 - Compress cache at `/var/cache/lxc/gentoo`

___January 2013___
 - Deployment of whizz-bang screenshot eyecandy.
 - Up to date OpenRC fixes for fast and minimalist
   boot (eg. newer OpenRC `net` dependency handling)
 - Additional boot verbosity with `agetty --noclear`
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

___November 2012___
 - Comments regarding recent kernel JIT spraying
   vulnerability: http://bit.ly/T9CkqJ
 - Various contributed minor improvements around
   locking, indentation, shell syntax, etc.
 - Don't drop `CAP_FOWNER` capability, as it breaks
   portage's ability to chown.
 - Don't create `/etc/init.d/net.eth0` unless DHCP
   is specified.

___October 2012___
 - Migrate stage3 URL from `ARCH` to `SUBARCH`
   basis, as per Gentoo Release Guidelines.

___September 2012___
 - Default network config has changed. Instead
   of assuming a bridge setup, we use simpler 
   `veth` based tunnels direct to the host,
   which now appear as ''guestname'' in the
   host's interface list.  (Also resolves an
   apparently outstanding bug related to random
   MAC assignment, see http://bit.ly/QWAkOy )
 - Generated guests now attempt to aggressively 
   drop capabilities (`man 7 capabilities`) in
   a bid to plug known security issues, also to
   pre-mount `/proc` and remove `/sys` for the same
   purpose.  (See also: http://bit.ly/SSDbY0 )
 - Add DHCP support
 - `sshd` setup code dropped as out of scope
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
