# cvmfs-server-docker

Run an apache web server ith cvmfs enabled.

## Configuration

See example directory for more details.

### Capabilities

The container must be run as root and with the `SYS_ADMIN`.

### Ports

80/tcp, HTTP port from apache web server.

### Volumes

- `/var/spool/cvmfs` is the state of the CVMFS server, must be persistent.
- `/srv/cvmfs` are the data served by apache, must be persistent.
- `/sys/fs/cgroup:/sys/fs/cgroup:ro` (+ SYS_ADMIN capability) permits systemd to work.
- (optional, but recommended) `/etc/cvmfs/server.local` the CVMFS server config.
- `/etc/cvmfs-setup/env` configure the replication.

The format looks like this:

```sh
CVMFS_REPO<idx>_NAME=<name>
CVMFS_REPO<idx>_URL=<url>
CVMFS_REPO<idx>_KEYS=<path to key directory>
CVMFS_REPO<idx>_OPTIONS='-o <owner> <other options>'
```

The owner option is mandatory, otherwise the container will be stuck.

Example:

```sh
CVMFS_REPO0_NAME=stdenv.sion.csquare.run
CVMFS_REPO0_URL=http://cvmfs.ch1.csquare.run/cvmfs/stdenv.sion.csquare.run
CVMFS_REPO0_KEYS=/etc/cvmfs/keys/sion.csquare.run
CVMFS_REPO0_OPTIONS='-o root'
```
