# distcc-tools

Here you will find the following SlackBuilds that will build packages to set up
a Slackware-based distcc "build farm".


## distcc-masq-client

This package sets up a 'masquerade mode' distcc client for gcc (including g++,
objc and gfortran) and clang/clang++.

After installing distcc-masq-client, please configure it by editing the file
/etc/distcc/hosts -- you should change '127.0.0.1' to the distcc host
specification for your servers.  This file sets the system-wide default.

Or you can configure distcc for a particular user by setting the DISTCC_HOSTS
environment variable in the user's profile, for example

```
export DISTCC_HOSTS="bighost/4 tinyhost"
```

For details of the format of /etc/distcc/hosts and the DISTCC_HOSTS
environment variable, see 'man distcc', section 'HOST SPECIFICATIONS'.


## distcc-masq-server

This package sets up a 'masquerade mode' distcc server for gcc (including g++,
objc and gfortran) and clang/clang++.

The server and the clients should all have the same versions of Slackware
(i.e. all running 14.1, or all running the same revision of -current).

To start the distccd daemon automatically on boot, you must add these lines in
/etc/rc.d/rc.local:

```
if [ -x /etc/rc.d/rc.distccd ]; then
  /etc/rc.d/rc.distccd start
fi
```

You must also edit the file /etc/distcc/clients.allow to add your networks
and/or hosts that will be allowed to use the server, for example,

````
127.0.0.1
192.168.3.0/24
````

### Cross compilation

On x86_64 only, the server supports full multiarch cross compilation -- it can
build for i486 and x86_64, and for arm if the arm-x-toolchain package is
installed.  Only one running instance of distccd is required.

* To compile for Slackware 64 (x86_64) clients, and to cross-compile for 32 bit
Slackware clients (i486 etc), you don't need to do anything.  Slackware's
64 bit gcc packages already support 32 bit cross-compilation :-)

* To cross-compile for Slackware ARM clients, you need to specify the option
'ARMX=yes' and install the arm-x-toolchain package (gfortran not supported).

* Other configurations are not supported.

## arm-x-toolchain

This is Stuart Winter's x-toolchain (from the Slackware ARM devtools),
packaged to work with distcc-masq-client and distcc-masq-server.  It is
intended to be installed on a distcc server, and called from a Slackware ARM
client using masquerade mode.  The distcc server should be running either
Slackware64 (x86_64) or Slackware (i486).

If your client system is running Slackware ARM 14.1, you should install
arm-x-toolchain version 14.1 on your distcc server.  This is the default.
Your client system should be fully patched -- that is, it should
have been updated with the packages gcc-4.8.4-arm-1_slack14.1 and
gcc-g++-4.8.4-arm-1_slack14.1.

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


## Notes

  * Slackware's distcc does not support ipv6, zeroconf or GSS-API.
  * For security reasons you should only use distcc on networks that you trust.
  * These SlackBuilds do not support 'pump mode'.


### Compilation failures

When a compilation fails for any reason, distcc will always apply a "backoff
period" of 60 seconds.  During this time, all compilations will be run on the
client, and the following message will be displayed:

```
distcc[pid] (dcc_build_somewhere) Warning: failed to distribute, running locally instead
```

This is normal behaviour.  Many packages use ./configure scripts that rely on
compilation failures to discover information about the build environment, and
therefore distcc may show the above message during the first minute of building
a package.

A few packages simply will not build with distcc.
These SlackBuilds.org packages are known to fail:
gdal, urbanlightscape, klibc, mpv, fwbuilder, virtualbox

To temporarily disable distcc within a client process, you can unset the
DISTCC_HOSTS environment variable.  (This is a change to the upstream behaviour,
which would apply the system-wide defaults if DISTCC_HOSTS is unset.)

To disable distcc completely, you can block execution of the system-wide
profile script:

```
chmod ugo-x /etc/profile.d/distcc-masq-client.*
```


### References

For a full description of 'masquerade mode', see 'man distcc', section
'MASQUERADING'.

Slackware ARM's x-toolchain can be found at
ftp://ftp.arm.slackware.com/slackwarearm/slackwarearm-devtools/x-toolchain/
