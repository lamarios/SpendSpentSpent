# MCP Server

SpendSpentSpent comes with a built-in MCP server so you can use a chatbot to interact with the service.

## Generate an API Key

To get started, you need to generate an API Key. Go to settings -> Api Keys and create a new key then copy it.

## Add the mcp server to your LLM Application

Add a new MCP server using a remote setup, the url should be: `<url of your SSS installtion>/mcp`. Example your SSS installation is running on `https://sss.mydomain.com`, then the MCP server url is `https://sss.mydomain.com/mcp`. The type of the server (if required to choose) is **HTTP Stream**.