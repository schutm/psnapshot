psnapshot
=========

psnapshot is a filesystem snapshot utility for making backups of local and remote systems—much like [http://www.rsnapshot.org/](rsnapshot). However, unlike rsnapshot, psnapshot is not installed on the backup server, but on client machine. This gives the user the possibility to create backups to a server which are not under their control and on which they cannot install additional software.

Apart from the difference outlined above, psnapshot resembles rsnapshot quite well. The configuration file should look familiar, and the benefits of rsnapshot are kept as well:
  * [rsync.samba.org](rsync) for efficient data transfer
  * hard links for efficient storage
  * no tapes to changes
  * only a configureable number of snapshots are kept, to ensure the amount of used disk space will not keep on growing
