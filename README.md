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


Security Notes
--------------
 - Don't treat guests as root safe
 - Best practice is to be paranoid:
     - Drop most capabilities
     - Keep the filesystem for each guest on a separate logical block device (eg. LVM2 LV)
     - Do not use UIDs on the guest that intsersect with the host system
 - Make sure you never both (1) mount ```proc``` in a guest that you don't trust, and (2) have ```CONFIG_MAGIC_SYSRQ``` 'Magic SysRq Key' enabled in your kernel (which creates ```/proc/sysrq-trigger```) ... as this can be abused for denial of service


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
   <td>Stores arch/subarch/variant combo specific stage3 tarballs and the portage snapshot.</td>
  </tr>
  <tr>
   <td><b>Mirror</b></td>
   <td><pre>$MIRROR</pre></td>
   <td><i>http://distfiles.gentoo.org</i>
   <td>Specifies the location from which the stage3 tarball, portage snapshot and metadata should be fetched.</td>
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
    <li> undefined -- a portage snapshot will be downloaded and extracted into the rootfs</li>
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
   <td><i></i></td>
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
   <td><i>${NAME}.conf</i></td>
   <td>Path at which to generate the <i>lxc.conf</i> file, one of:
    <li> undefined -- config will be placed into ./${NAME}.conf</li>
    <li> a directory -- config will be placed into dir/${NAME}.conf</li>
    <li> file path -- config will be placed into it</li>
   </td>
  </tr>
 </tbody>
</table>


Network Configuration Notes
---------------------------

LXC guests can have zero or more network interfaces, which can be of various
types, and each of which may be configured with zero or more addresses. They
may, regardless of the above, be granted access to zero or more external
networks, real or virtual.

As is typical of Unix (and Linux networking in particular), this basically 
means "you can probably achieve anything you set your mind to, but it's not 
going to be easy".

The `lxc-gentoo` script therefore tries to provide a reasonable default for
normal use cases, ie. by configuring guests to use one `veth`-type interface
that can be connected to the outside world via `iptables`.

Basic connectivity can be established with the following host-side commands:
 - `lxc-start -n guest -f guest.conf`
 - `ifconfig guest x.x.x.x`
   (You should now be able to ping the guest. If not, check your `guest.conf`
    network configuration versus the host-side configuration. Make sure that
    both addresses are in the same range and differ, for example the host
    may be `10.10.10.1` and the guest may be `10.10.10.2`)

Once you have established basic connectivity, external network connectivity
can be established as follows:
 - `sysctl.net.ipv4.ip_forward=1`
   (Optionally also set this in `/etc/systctl.conf` to persist after reboot)
 - `iptables -t nat -A POSTROUTING -o outward-interface -j MASQUERADE`
   (Where `outward-interface` is the name of the interface that carries
    traffic to/from the host and the internet, or other destination that
    you wish to allow the guest to connect to. Different distributions have
    different ways to persist these `iptables` rules, but you can use
    `iptables-save >some-ruleset` and `iptables-restore <some-ruleset` on
    any distribution)

Alternatively to a pure `iptables`-based approach, you may consider
interface bridging. A bridge is like a software-switch interface on the 
host and requires some configuration, ie:
 - install the `bridge-utils` package (gentoo: `emerge bridge-utils`)
 - `brctl addbr br0` (create a bridge (~=software switch backplane))
 - `brctl setfd br0 0` (set forward delay of zero for optimisation)
 - `ifconfig br0 172.20.0.1 255.255.255.0` (select an address range)
 - `brctl addif br0 <guest-interface>` (add guest to bridge)

For further reading, the following resources are recommended:
 - `lxc.conf` man page, ie. `man 5 lxc.conf`.
 - `man 8 iptables`
 - `man 8 brctl`
 - `man 8 ifconfig`; or the modern alternative `man 8 ip`

The following notes describe LXC-specific network topology design
considerations:
 - Guest startup times will be higher if DHCP is used. In addition, DHCP use
   creates a dependency on a valid guest-external DHCP configuration which
   can compromise portability or reliability when executing in different
   environments. As such, if you are planning to use your LXC guests for
   executing what should be reliable, repeated jobs, consider avoiding DHCP.
   Basically it is nothing but a potential source of failure (eg. address
   pool exhaustion, DHCP server configuration expectation differences between
   multiple guests, etc.) and should be removed if your infrastructure can
   be configured to facilitate it. (KISS principal)
 - VLANs have been observed to sometimes come up with unavoidable delays
   (depending upon various factors such as spanning tree configuration and
   intermediate hardware/software). For this reason they are perhaps best
   left for the host system to establish connectivity with and for any LXC
   guest access to be provided via the host `iptables` configuration. The
   ideal setup will depend upon your particular use case. KISS.
 - There have been bugs regarding relative MAC addresses in other LXC 
   interface types in the past, which initially caused us to move toward 
   `veth`-style interface configuration. Bear this in mind if moving back!


Manual QEMU emulation setup
---------------------------
 - enable binfmt_misc support in your kernel.

 - emerge *static* qemu with the relevant architecture enabled in
   QEMU_USER_TARGETS="".
   hint: do this in a native container so you don't have left over
   static binaries on your system :)

 - use either the qemu-provided /etc/init.d/qemu-binfmt script to set
   up the binfmt handlers or something of your own.
   Note that the ARM handler @ qemu-binfmt is broken
   and you will probably have to replace it with the line found here:
   https://bugs.gentoo.org/show_bug.cgi?id=407099

 - copy the staticaly-linked qemu-$ARCH executable into the rootfs
   (do cat /proc/sys/fs/binfmt_misc/$ARCH to see where).

Updates
-------

___January 2014___
 - Resolve issues downloading stage3 archives
 - Set a default, unicode-enabled locale to silence ```perl``` whinging
 - Fallback to local cache when offline
 - Silence errors for antique OpenRC fixes
 - Minor fixes for recent OpenRC releases
 - Working defaults for quiet mode (`lxc-gentoo create -q`)
 - Minor typo fixes

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
