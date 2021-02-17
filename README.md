# Twikker

Create a SMS Gatway application

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

General requirements:

- Ruby 2.6.5
- Memcache
- Rails 6.0.2
- PG
- Puma Server
- Dalli

## Running the app

### Check out the repo

```
$ git@github.com:JayaramVenugoapl/sms.git
```

```
$ cd sms
```

### Setup

1. Install pg
2. Install bundler: `gem install bundler`
3. Install gems: `bundle install`
4. Setup DB: `rails db:create db:migrate`.

### Usage

1. Start rails && react server locally

```

$ rails start

```

# REST PI Docs

Where full URLs are provided in responses they will be rendered as if service
is running on 'http://localhost:3000/'.

## Authorization

All API requests require the use of a generated API key. You can find your API key, or generate a new one, by navigating to the /settings endpoint, or clicking the “Settings” sidebar item.

To authenticate an API request, you should provide your email and password in the `Authorization` header as basic authorization token

```
curl --location --request POST 'localhost:3000/inbound/sms'  --header 'Authorization: Basic dGVzdDFAeW9wbWFpbC5jb206cXdlcnR5MTIz'
```

| Parameter | Type     | Description                  |
| :-------- | :------- | :--------------------------- |
| `api_key` | `string` | **Required**. email,password |

## Responses

Many API endpoints return the JSON representation of the resources created or edited. However, if an invalid request is submitted, or some other error occurs, returns a JSON response in the following format:

```javascript
{
  "message" : string,
  "error"    : string
}
```

The `error` attribute contains a message commonly used to indicate errors or, in the case of deleting a resource, success that the resource was properly deleted.

The `message` attribute contains a message commonly used to indicate success string

## Endpoints that require Authentication

Closed endpoints require a valid Token to be included in the header of the
request. A Token can be acquired from the Login view above.

### SMS related

Endpoints for send and receive the SMS that the Authenticated Account has permissions to access.

- `POST /outbound/sms`
- `POST /outbound/sms`

## Status Codes

Returns the following status codes in its API:

| Status Code | Description             |
| :---------- | :---------------------- |
| 200         | `OK`                    |
| 201         | `CREATED`               |
| 400         | `BAD REQUEST`           |
| 404         | `NOT FOUND`             |
| 500         | `INTERNAL SERVER ERROR` |

## Running Tests

1. Make sure "rspec" is installed by running:

   ```sh
       $ bundle show rspec
   ```

   If a path is listed, then rspec is installed.

2. Run rspec for the spec folder through bundle:
   ```sh
       $ bundle exec rspec spec
   ```
