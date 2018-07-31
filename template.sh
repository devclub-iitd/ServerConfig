#!/usr/bin/env bash

## Usage:
## @param $1 subdomain of the site
## @param $2 port to forward the connection

# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail

### Validation. Error out if the things required for your script are not present
##############################################################################
[[ "${1:-}" ]] || ( echo "Setting a subdomain is required" && exit 1 )
[[ "${2:-}" ]] || ( echo "Specifying a port is required" && exit 1 )

__subdomain=${1}
__port=${2}


cat <<XXX
server
{
	listen 0.0.0.0:80;
	server_name ${__subdomain}.devclub.iitd.ac.in;
	access_log /var/log/nginx/${__subdomain}_access.log;
	error_log /var/log/nginx/${__subdomain}_error.log;

	location / {
		proxy_pass http://localhost:${__port};
		proxy_http_version 1.1;
		proxy_set_header Upgrade \$http_upgrade;
	}
}
XXX
