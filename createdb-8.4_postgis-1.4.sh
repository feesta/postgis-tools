#!/bin/sh

# Script for Postgres 8.4 and PostGIS 1.4

# TO DO : check to see that we are the postgres user here
# TO DO: (optional) password hooks

if [ $# -ne 2 ]; then
        echo "Usage: $0 <user name> <database name>";
        exit;
fi;

USERNAME=$1
DATABASE=$2

createuser --no-superuser --no-createdb --no-createrole $USERNAME;
createdb --owner=$USERNAME $DATABASE;
createlang plpgsql $DATABASE;

psql -f /usr/share/postgresql/8.4/contrib/postgis.sql $DATABASE;
psql -f /usr/share/postgresql/8.4/contrib/spatial_ref_sys.sql $DATABASE;
psql -f /usr/share/postgresql/8.4/contrib/postgis_comments.sql $DATABASE;

# ensure intarray so that we can do OSM updates
psql -f _int-8.4.sql $DATABASE;

echo "ALTER TABLE geometry_columns OWNER TO $USERNAME;" | psql -d $DATABASE
echo "ALTER TABLE spatial_ref_sys OWNER TO $USERNAME;" | psql -d $DATABASE

# TO DO : passwords...
# echo "ALTER ROLE $USERNAME PASSWORD '$PASSWORD';" | psql -d $DATABASE
