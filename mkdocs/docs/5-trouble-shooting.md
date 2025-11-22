# Troubleshooting

## database "sss" has a collation version mismatch

There can be an issue where this error keeps showing up in the logs of the application
```s
o.h.engine.jdbc.spi.SqlExceptionHelper   : database "sss" has a collation version mismatch
```

To fix it run the following queries in your database:

```sql
REINDEX DATABASE <your db name>;

ALTER DATABASE <your db name> REFRESH COLLATION VERSION;
```

Then restart your SSS application

### Connecting to the database
If you're running SSS following the docker compose example from the Installation guide.
You can get to the database like this:

``` 
docker exec -it postgres-sss psql -U postgres -d sss
# if it asks for a password, type: postgres
select current_database();
REINDEX DATABASE sss;
ALTER DATABASE sss REFRESH COLLATION VERSION;
exit
```