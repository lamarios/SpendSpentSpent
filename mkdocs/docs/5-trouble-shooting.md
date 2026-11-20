# Troubleshooting

## Resetting a password without email

If SMTP is not configured, using **Forgot password ?** on the login screen prints the reset link in the application
logs instead of sending an email:

```s
WARN ... ResetPasswordService : Password reset requested for user@example.org, link valid for 24h: https://sss.example.org/reset-password?reset-id=...
```

As the administrator, find that line (for example with `docker logs sss`) and send the link to the user. The link is
valid for 24 hours and can be used once. Make sure `ROOT_URL` is set to the address of your instance, otherwise the
link will point to `http://localhost:8080`.

## A user can't log in anymore after upgrading

Passwords used to be stored as MD5 hashes. They were moved to bcrypt the next time each user logged in, and the MD5
hashes have now been removed. Users who never logged in since then no longer have a password.

At every startup, SSS prints a reset link for each of those users in the logs:

```s
WARN ... ResetPasswordService : 1 user(s) have no password set (their legacy MD5 password hash was removed). ...
WARN ... ResetPasswordService : Password reset for user@example.org: https://sss.example.org/reset-password?reset-id=...
```

Send the link to the user so they can choose a new password. If the link has expired (after 24 hours), restart SSS to
get a new one. Users who log in with SSO (OIDC) are not affected.

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