# Installation

## Docker

This is the easiest way to run SSS

The SALT environment variable is required especially if you want to use password protection to the application. Once
set, **do not change it** while running against the same database.

With docker compose:

```yml
 sss:
   container_name: sss
   image: gonzague/spendspentspent
   restart: unless-stopped
   ports:
     - "9001:9001"
   volumes:
     - /etc/localtime:/etc/localtime:ro
     - /some/path:/app-files # Where to store the files
   environment:
     SALT: somerandomstring
     DB_PATH: "jdbc:postgresql://postgres-sss:5432/sss"
     DB_USER: "postgres"
     DB_PASSWORD: "postgres"
     TIMEZONE: "Europe/Paris"

 postgres-sss:
   container_name: postgres-sss
   image: postgres:17
   environment:
     POSTGRES_PASSWORD: postgres
     POSTGRES_USER: postgres
     POSTGRES_DB: sss
     TIMEZONE: Europe/Paris
   volumes:
     - ./sss/db:/var/lib/postgresql/data
```

## From the JAR file

You will need to have *Java 21* to be installed on your machine to be able to run SSS

```
 SALT=somerandomestring DB_PATH=<jdbc url>  DB_USER=xxx DB_PASSWORD=yyyy TIMEZONE=Europe/Paris java -Dserver.port=9001 -jar /app/SpendSpentSpent.jar
```

# Update

## Docker

```
docker pull gonzague/spendspentspent
```

and restart your container

## Jar File

Download the lastest JAR file from the release page and run it the same way.

## Accessing the app

If you followed the example above, the app will be available on the port **9001**.