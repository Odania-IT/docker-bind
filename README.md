# Bind

Installs a bind9 server

## Usage

You should mount a volume to "/srv/data". Inside the directory the configuration will be stored.

On startup the default data from bind will be copied to that directory. It will not replace existing files.
The folders under data are:
- etc: Bind configuration files
- lib: generate data under "/var/lib/bind"
- config: Config file for generating the db.local and zone files

## Generating config

### main.yml

The main.yml contains all domain informations. Example:

```
default_subdomains:
  mail: MAIL-SERVER-IP
nameservers:
  - name: NAMESERVER-1-URL
    ip: NAMESERVER-1-IP
  - name: NAMESERVER-2-URL
    ip: NAMESERVER-2-IP
domains:
  example.com:
    ip: 192.168.10.10
  example.de:
    ip: 192.168.10.11
    subdomains:
      www: 192.168.10.10
      other: 192.168.10.12
```

### Rake task

You can run the rake command:

```
rake config:generate
```

to generate the named.conf.local file and the zone files for your configuration. A reload is triggered on the bind server.

## Testing

To test the response from a nameserver dig can be used:

```
dig @NAMESERVER DOMAIN

e.g.: dig @ns.example.com example.com
```

To test the transfer from a slave, you can use the command:

```
dig @NAMESERVER DOMAIN axfr

e.g.: dig @ns.example.com example.com axfr
```

You need to be on a slave that is allowed to request the transfer data.

## Contributors

- Mike Petersen
