#!/bin/sh

if [ $# -ne 2 ]; then
        echo "Usage: $0 <user name> <database name>";
        exit;
fi;

USERNAME=$1
DATABASE=$2

createuser --no-superuser --no-createdb --no-createrole $USERNAME;
createdb --owner=$USERNAME $DATABASE;
createlang plpgsql $DATABASE;

psql -f postgis-8.4.sql $DATABASE;
psql -f spatial_ref_sys-8.4.sql $DATABASE;

# ensure intarray so that we can do OSM updates
psql -f _int-8.4.sql $DATABASE;

echo "ALTER TABLE geometry_columns OWNER TO $USERNAME;" | psql $DATABASE;
echo "ALTER TABLE spatial_ref_sys OWNER TO $USERNAME;" | psql $DATABASE;