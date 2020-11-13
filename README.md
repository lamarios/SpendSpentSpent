# SpendSpentSpent

SpendSpentSpent (SSS) is an easy to use self hosted expense tracker. The goal of this application is to make creating new expense as easy and as quick as possible. The application features are  split into 3 pages


[Demo instance](https://sss.ftpix.com)

## Spend (center page)

- Add expense categories
- Add expenses with option to enable location
- Add recurring expense

## Spent (right page)
- Selected month day by day expenses details and location if enabled
- Delete expenses

## Spent (left page)

- Monthly and yearly graphs to compare overall expenses and categories expenses by month or year.


# Run
## Environment variables
| Name | Default | Required | Comments |
| --- | --- | --- | --- |
|SALT| (none) | **Yes** | Required for password hashing | 
| DB_PATH | ./SSS | No (Hardcoded in docker container, can't be changed) | Location of the DB file or a full [JDBC connection url](https://www.codejava.net/java-se/jdbc/jdbc-database-connection-url-for-common-databases) (H2DB and MySQL supported) |
| DB_USER | (none) | No | db username if using JDBC url for connection | 
| DB_PASS | (none) | No | db password if using JDBC url for connection | 
| ALLOW_SIGNUP | 0 | No | 1 = allow signups, 0 = Do not allow signups |
| ANNOUNCEMENT_MESSAGE | (none) | No | Show a message on the login screen, ex: ANNOUNCEMENT_MESSAGE="Welcome to my SpendSpentSpent instance". See demo instance to see what it looks like |

SMTP environment variables are necessary if you want to enable the forgot password function and recurring expense notification emails.

| Name | Default | Required (based on if you want SMTP services enabled) | Comments |
| --- | --- | --- | --- |
| ROOT_URL | http://localhost:8080 | No | The base URL used in the links in email sent to users |
| SMTP_HOST | (none) | Yes | |
| SMTP_PORT | 0 | Yes | |
| SMTP_USERNAME | (none) | No | |
| SMTP_PASSWORD | (none) | No | |
| SMTP_FROM | (none) | Yes | Who will be the sender of the email | 
| SMTP_TRANSPORT_STRATEGY | SMTP | Yes | Possible values: SMTP, SMTPS, SMTP_TLS |


## Docker

This is the easiest way to run SSS 

```
docker run -t -v "/path/to/your/save-folder:/config" \
	-v "/etc/localtime:/etc/localtime:ro" \
	-e "SALT=somerandomstring" \
	-p "9001:9001" \
	gonzague/spendspentspent
```

The SALT environment variable is required especially if you want to use password protection to the application. Once set, **do not change it** while running against the same config folder.

With docker compose:

```yml
 sss:
  container_name: sss
  image: gonzague/spendspentspent
  restart: unless-stopped
  ports:
   - "9001:9001"
  volumes:
   - ./SpendSpentSpent/config:/config
   - /etc/localtime:/etc/localtime:ro
  environment:
   SALT: somerandomstring
```

## From the jar file

You will need to have *Java 9* to be installed on your machine to be able to run SSS

```
 SALT=somerandomestring DB_PATH=/path/to/save/file  java -Dserver.port=9001 -jar /app/SpendSpentSpent.jar
```


# Update

## Docker
```
docker pull gonzague/spendspentspent
```

and restart your container

## Jar File

Download the lastest JAR file from the release page and run it the same way.

