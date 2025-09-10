# SpendSpentSpent

SpendSpentSpent (SSS) is an easy to use self hosted expense tracker. The goal of this application is to make creating
new expense as easy and as quick as possible. The application features are split into 3 pages:

[Demo instance](https://sss.ftpix.com)

[Get on the play store](https://github.com/lamarios/SpendSpentSpent)

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

| Name                 | Default | Required | Comments                                                                                                                                                                        |
|----------------------|---------|----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| SALT                 | (none)  | **Yes**  | Required for password hashing                                                                                                                                                   | 
| DB_PATH              | (none)  | **Yes**  | A full postgres [JDBC connection url](https://www.codejava.net/java-se/jdbc/jdbc-database-connection-url-for-common-databases). Example: `jdbc:postgresql://localhost:5432/sss` |
| DB_USER              | (none)  | **Yes**  |                                                                                                                                                                                 | 
| DB_PASSWORD          | (none)  | **Yes**  |                                                                                                                                                                                 | 
| ALLOW_SIGNUP         | 0       | No       | 1 = allow signups, 0 = Do not allow signups                                                                                                                                     |
| ANNOUNCEMENT_MESSAGE | (none)  | No       | Show a message on the login screen, ex: ANNOUNCEMENT_MESSAGE="Welcome to my SpendSpentSpent instance". See demo instance to see what it looks like                              |
| FILES_PATH           | ./files | No       | Where to store the pictures uploaded by the users                                                                                                                               |

### Email

SMTP environment variables are necessary if you want to enable the forgot password function and recurring expense
notification emails.

| Name                    | Default               | Required (based on if you want SMTP services enabled) | Comments                                              |
|-------------------------|-----------------------|-------------------------------------------------------|-------------------------------------------------------|
| ROOT_URL                | http://localhost:8080 | No                                                    | The base URL used in the links in email sent to users |
| SMTP_HOST               | (none)                | **Yes**                                               |                                                       |
| SMTP_PORT               | 0                     | **Yes**                                               |                                                       |
| SMTP_USERNAME           | (none)                | No                                                    |                                                       |
| SMTP_PASSWORD           | (none)                | No                                                    |                                                       |
| SMTP_FROM               | (none)                | **Yes**                                               | Who will be the sender of the email                   | 
| SMTP_TRANSPORT_STRATEGY | SMTP                  | **Yes**                                               | Possible values: SMTP, SMTPS, SMTP_TLS                |

### AI (ollama / openai)

SSS supports analyzing images using ollama or open ai (or a compatible server) to find prices or tags about images
attached to an expense.
The default models tested well with a RX6600XT GPU (8GB VRAM).

| Name            | Default      | Comments                                                                                                                         | 
|-----------------|--------------|----------------------------------------------------------------------------------------------------------------------------------|
| OLLAMA_API_URL  | (none)       | The url of the ollama instance. Do not use together with OPENAI_API_URL                                                          | 
| OLLAMA_API_KEY  | (none)       | API Key to talk to the ollama server                                                                                             |
| OPENAI_API_URL  | (none)       | The url of the open ai compatible instance. Do not use together with OPENAI_API_URL                                              | 
| OPENAI_API_KEY  | (none)       | API Key to talk to the open ai compatible server                                                                                 |
| AI_VISION_MODEL | qwen2.5vl:7b | Which vision model to use. This model will be used to generate picture description                                               |
| AI_TEXT_MODEL   | qwen3:8b     | Which text model to use. This model will take the description and generate tags and find the best expense category for a picture |

### OIDC

SSS Supports SSO by implementing OIDC. You will need to set up your OIDC client as a Public Client and enable PKCE.
Here are the used callback urls:

```
com.spendspentspent.app:/oidcRedirect 
https://your.spendspentsspent-domain.com/redirect.html
```

| Name                   | Default | Required | Comments                                                                                        |
|------------------------|---------|----------|-------------------------------------------------------------------------------------------------|
| OIDC_DISCOVERY_URL     | (none)  | **Yes**  | The discovery URL of your OIDC provider https://id.example.com/.well-known/openid-configuration |
| OIDC_CLIENT_ID         | (none)  | **Yes**  | Your OIDC client id                                                                             |
| OIDC_AUTO_SIGNUP_USERS | false   | No       | Whether to automatically sign up unknown users                                                  |
| OIDC_NAME              | SSO     | no       | Name of your provider to display on the UI                                                      |

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

 postgres-sss:
   container_name: postgres-sss
   image: postgres:17
   environment:
     POSTGRES_PASSWORD: postgres
     POSTGRES_USER: postgres
     POSTGRES_DB: sss
   volumes:
     - ./sss/db:/var/lib/postgresql/data
```

## From the jar file

You will need to have *Java 9* to be installed on your machine to be able to run SSS

```
 SALT=somerandomestring DB_PATH=<jdbc url>  java -Dserver.port=9001 -jar /app/SpendSpentSpent.jar
```

# Update

## Docker

```
docker pull gonzague/spendspentspent
```

and restart your container

## Jar File

Download the lastest JAR file from the release page and run it the same way.

