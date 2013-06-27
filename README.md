Current buildstatus: [![Build Status](https://travis-ci.org/schutm/psnapshot.png)](https://travis-ci.org/schutm/psnapshot)

psnapshot
=========
psnapshot is a filesystem snapshot utility for making backups of local
and remote systems—much like [rsnapshot](http://www.rsnapshot.org/).
However, unlike rsnapshot, psnapshot is not installed on the backup
server, but on client machine. This gives the user the possibility to
create backups to a server which are not under their control and on
which they cannot install additional software.

Apart from the difference outlined above, psnapshot resembles rsnapshot
quite well. The configuration file should look familiar, and the
benefits of rsnapshot are kept as well:
  * [rsync](http://rsync.samba.org) for efficient data transfer
  * hard links for efficient storage
  * no tapes to changes
  * only a configureable number of snapshots are kept, to ensure the
    amount of used disk space will not keep on growing


Installation
------------

### Manually ###
1. Make sure you have to the latest version downloaded
     * [Download the latest release](https://github.com/schutm/psnapshot/zipball/master).
     * Clone the repo:
       `git clone git://github.com/schutm/psnapshot.git`.
2. Copy `psnapshot` to place in the path (normally
   `/usr/local/bin/psnapshot`).
3. Execute `chmod 755 /usr/local/bin/psnapshot` to make it executable.
4. Copy `psnapshot.conf.example` to `/etc/psnapshot.conf`.
5. Modify `/etc/psnapshot.conf` to reflect your preferences.
6. Add a few crontab entries (see crontab.example for an example setup).

### Automatically ###
1. Make sure you have to the latest version downloaded
     * [Download the latest release](https://github.com/schutm/psnapshot/zipball/master).
     * Clone the repo:
       `git clone git://github.com/schutm/psnapshot.git`.
2. Execute `make sysconfdir=/etc install` (use `make` to see more options)
3. Copy or move `/etc/psnapshot.conf.example` to `/etc/psnapshot.conf`.
4. Modify `/etc/psnapshot.conf` to reflect your preferences.
5. Add a few crontab entries (see crontab.example for an example setup).


Bug tracker
-----------
[Open a new issue](https://github.com/schutm/psnapshot/issues) for bugs
or feature requests. Please search for existing issues first.

Bugs or feature request will be fixed in the following order, if time
permits:

1. It has a pull-request with a working and tested fix.
2. It is easy to fix and has benefit to myself or a broader audience.
3. The bug consist of not being POSIX compliant.
4. It puzzles me and triggers my curiosity to find a way to fix.


Acknowledgements
----------------
The array (add_to_list) is derived from Push(https://github.com/vaeth/push),
created by Martin Vath.


Contributing
------------
Anyone and everyone is welcome to [contribute](CONTRIBUTING.md).


License
-------
This software is licensed under the [ISC License](LICENSE).
