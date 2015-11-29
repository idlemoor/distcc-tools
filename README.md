# distcc-tools

Here you will find the following SlackBuilds that will build packages to set up
a Slackware-based distcc "build farm":

* distcc-masq-client (distcc & ccache 'masquerade mode' client)

* distcc-masq-server (distcc 'masquerade mode' server)

* arm-x-toolchain (gcc and g++ cross compiler for Slackware ARM)

* gcc-legacy (old versions of gcc/g++/objc)


## distcc-masq-client

This package sets up a 'masquerade mode' distcc client for gcc (including g++
and objc) and clang/clang++.

With Slackware-current, this package also integrates full support for ccache
(including ccache without distcc), although ccache is not enabled by default
(see below).

#### Configuring distcc

**After installing distcc-masq-client, please configure it** by editing the file
/etc/distcc/hosts -- you should change '127.0.0.1' to the distcc host
specification for your servers.  This file sets the system-wide default.

Or you can configure distcc for a particular user by setting the DISTCC_HOSTS
environment variable in the user's profile, for example

```
export DISTCC_HOSTS="bigserver/4 tinyserver"
```

For details of the format of /etc/distcc/hosts and the DISTCC_HOSTS
environment variable, see 'man distcc', section 'HOST SPECIFICATIONS'.

#### Configuring ccache

**ccache is not enabled by default**. It can consume large amounts of storage, and
one-off compilation (e.g. successfully building a package from SlackBuilds.org)
is typically 15% slower.  You will only benefit from enabling ccache if you
compile the same source multiple times.

* To enable ccache permanently, please edit the ccache system config file
/etc/ccache.conf -- change the line 'disable = true' to 'disable = false'.

* To use ccache without distcc, please enable ccache as above, and then disable
distcc by editing the file /etc/distcc/hosts -- please delete the line that
contains '127.0.0.1'.

For alternative ways of configuring ccache options, please see 'man ccache',
section 'CONFIGURATION'.

#### Disabling and enabling distcc and ccache

**To disable distcc temporarily**, you can unset the DISTCC_HOSTS environment
variable.  (This is a change to the upstream behaviour, which would apply the
system-wide defaults if DISTCC_HOSTS is unset.)

```
unset DISTCC_HOSTS
```

**To enable distcc temporarily**, you can set the DISTCC_HOSTS environment variable.

```
export DISTCC_HOSTS='myserver,lzo'
```

**To disable ccache temporarily**, you can set the CCACHE_DISABLE environment
variable.

```
export CCACHE_DISABLE=true
```

**To enable ccache temporarily**, you can set the CCACHE_NODISABLE environment
variable.

```
export CCACHE_NODISABLE=true
```


## distcc-masq-server

This package sets up a 'masquerade mode' distcc server for gcc (including g++
and objc) and clang/clang++.

If the server and the clients have different versions of Slackware installed,
you will also need the 'gcc-legacy' package (see below).

**To start the distccd daemon automatically on boot, you must add these lines** in
/etc/rc.d/rc.local:

```
if [ -x /etc/rc.d/rc.distccd ]; then
  /etc/rc.d/rc.distccd start
fi
```

**You must also edit the file /etc/distcc/clients.allow** to add your networks
and/or hosts that will be allowed to use the server, for example,

````
127.0.0.1
192.168.3.0/24
````

#### Cross compilation

On x86_64, the server supports full multiarch cross compilation -- it can
build for x86_64, for i486/i586/i686, and for arm if the arm-x-toolchain package
is installed:

* To compile for Slackware 64 (x86_64) clients, and to cross-compile for 32 bit
Slackware clients (i486 etc), you don't need to do anything.  Slackware's
x86_64 gcc and llvm packages already support i486/i586/i686 cross-compilation.

* To cross-compile for Slackware ARM clients, you need to install the
arm-x-toolchain package on the server.

On i486/i586/i686, the server supports i486/i586/i686 clients, and also arm
clients if the arm-x-toolchain package is installed.

On arm, the server supports arm clients. Cross compilation is not supported.

| server | client | support                  |
|:------:|:------:|:-------------------------|
| x86_64 | x86_64 | yes                      |
| x86_64 | i?86   | yes                      |
| x86_64 | arm    | requires arm-x-toolchain |
| i?86   | x86_64 | no                       |
| i?86   | i?86   | yes                      |
| i?86   | arm    | requires arm-x-toolchain |
| arm    | x86_64 | no                       |
| arm    | i?86   | no                       |
| arm    | arm    | yes                      |


## arm-x-toolchain

This is Stuart Winter's x-toolchain (from the Slackware ARM devtools),
packaged to work with distcc-masq-client and distcc-masq-server.  It is
intended to be installed on a distcc server, and called from a Slackware ARM
client using masquerade mode.  The distcc server should be running either
Slackware64 (x86_64) or Slackware (i486/i586/i686).

If your client system is running Slackware ARM 14.1, you should install
arm-x-toolchain version 14.1 on your distcc server.  This is the default.  Your
client system should be fully patched -- that is, it should have been updated
with the packages gcc-4.8.4-arm-1_slack14.1 and gcc-g++-4.8.4-arm-1_slack14.1.

If your client system is running Slackware ARM -current, you will need to
rebuild and reinstall arm-x-toolchain on your distcc server whenever your
client system's gcc packages are updated. You must use rsync to download
the latest version of x-toolchain to the SlackBuild's directory:

```
rsync -Pva --delete \
  rsync://rsync.slackware.org.uk/slackwarearm/slackwarearm-devtools/x-toolchain/ \
  ./x-toolchain/
```

In this case, the SlackBuild will build a package with a version number of
'current_yyyymmdd'.


## gcc-legacy

This SlackBuild repackages old versions of the gcc compilers from previous
versions of Slackware. It is intended to be installed on a distcc server, for
use by distcc clients running other versions of Slackware.  With this package
installed, the distcc server will be able to build using the same version of
gcc/g++ as the client.

By default, the SlackBuild will repackage gcc from Slackware 14.1 and 14.0.
To specify which Slackware versions should be repackaged, specify the VERSION
environment variable when running the SlackBuild.  Multiple Slackware versions
should be separated by '+', for example

```
VERSION="14.1+14.0" ./gcc-legacy.SlackBuild
```

The gcc-legacy package does not conflict with Slackware's own gcc packages.

clang/clang++ legacy versions are not supported.


## Notes

  * For security reasons you should only use distcc on networks that you trust.
  * These SlackBuilds do not support distcc 'pump mode'.
  * Slackware's distcc does not support ipv6, zeroconf or GSS-API.


#### Compilation failures

When a compilation fails for any reason, distcc will always apply a "backoff
period" of 60 seconds.  During this time, all compilations will be run on the
client, and the following message will be displayed:

```
distcc[pid] (dcc_build_somewhere) Warning: failed to distribute, running locally instead
```

This is normal behaviour.  Many packages use ./configure scripts or cmake
feature tests that rely on compilation failures to discover information about
the build environment, and therefore distcc may show the above message for
up to a minute. However, if the message persists, there may be a problem, and
you can check the log file (/var/log/distccd).

A few packages simply will not build with distcc.
These SlackBuilds.org packages are known to fail:
gdal, urbanlightscape, klibc, mpv, fwbuilder, virtualbox


#### References

For a full description of 'masquerade mode', see 'man distcc', section
'MASQUERADING'.

Slackware ARM's x-toolchain can be found at
ftp://ftp.arm.slackware.com/slackwarearm/slackwarearm-devtools/x-toolchain/

distcc development is now on Github at https://github.com/distcc

ccache development is at https://ccache.samba.org/
