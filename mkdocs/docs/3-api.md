# API
If you ever want to integrate with SSS via API you can.

## OpenAPI 

The OpenAPI descriptions are here: http://localhost:8080/v3/api-docs
Swagger ui is available at http://localhost:8080/swagger-ui/index.html

## Bruno collection

There is a [non complete api collection](https://github.com/lamarios/SpendSpentSpent/tree/master/bruno-api-collection) for [Bruno](https://www.usebruno.com/).

## Authorization

There are two ways to access the api.

- Use the login endpoint, copy the jwt token and add a header to your request `AUTHORIZATION: Bearer <token>`
- Within the application, create a new api key (Settings -> Api key) copy it and use it with the following header `AUTHORIZATION: <apikey>`
