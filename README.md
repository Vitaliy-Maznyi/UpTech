# UpTech

## API Endpoints

| HTTP Method | ENDPOINT  | USAGE  | RETURNS | REQUIRES TOKEN |
|-------------|-----------|--------|:---------:|:----------------:|
GET  | /        | get list of events | events | NO |
POST | /users   | save new user info to db | - | NO |
POST | /oauth/token | get an access token | access token | NO |
GET  | /api/v1/events | get list of events | events | NO |
GET  | /api/v1/events?due={TIMESTAMP} | get list of closest events | closest events | NO |
POST | /api/v1/events | create new event | - | YES |
GET  | /api/v1/events/{id} | get event | event | YES |
PATCH| /api/v1/events/{id} | update event | - | YES |
DELETE| /api/v1/events/{id} | delete event | - | YES |
POST | /api/v1/events/{event_id}/comments | create new comment | - | YES |
DELETE| /api/v1/events/{event_id}/comments/:id | delete comment | - | YES |
POST | /api/v1/events/{event_id}/invite/{id} | invite user to your event | - | YES |
DELETE| /api/v1/events/{event_id}/expel/{id} | expel user from your event | - | YES |
GET  | /api/v1/feed| get latest changes of your events | list of activities in user's events | YES |

## Usage examples

### Create new user
Sign up with POST request to `http://yourdomain.com/users` with following JSON in the body:
```json
{
  "user": {
    "username": "Billy",
    "password": "secret",
    "password_confirmation": "secret"
  }
}
```

### Get access token
Sign in with POST request to `http://yourdomain.com/oauth/token` and the following keys in the body:
```json
{
  "grant_type": "password",
  "username": "Billy",
  "password": "secret"
}
```
You should see your access token in response:
```json
{
  "access_token": "3c086a9bde9aa1afc2b4b92aa02efff0c84b0110f82a06fd057b00e9c6cf6dee",
  "token_type": "bearer",
  "expires_in": 86400,
  "scope": "api",
  "created_at": 1485519402
}
```

If you use POSTMAN, you could add access token to Headers as:

**key:** `Authorization` **value:** `Bearer 3c086a9bde9aa1afc2b4b92aa02efff0c84b0110f82a06fd057b00e9c6cf6dee`

### Create new event
POST request to `http://yourdomain.com/api/v1/events` and the following keys in the body:
```json
{
	"name": "New event",
	"time": "2017-05-21 12:00:00",
	"place": "Porter Maidan",
	"purpose": "Birthday party",
	"image" : "data:image/png;base64,iVBORw0..."
 }
```
`image` key is optional. Pass image as base64 string if you want to attach image to event

###Update event
PATCH request to `http://yourdomain.com/api/v1/events/1` and the following keys in the body:
```json
{
	"name": "New event edited",
	"time": "2017-05-21 12:00:00",
	"place": "Porter Maidan",
	"purpose": "Birthday party",
	"image" : ""
 }
```

###Create comment
POST request to `http://yourdomain.com/api/v1/events/1/comments` and the following keys in the body:
```json
{
	"content":"just a new comment",
	"image":""
}
```
`image` key is optional. Pass image as base64 string if you want to attach image to comment

###Delete comment
DELETE request to `http://yourdomain.com/api/v1/events/1/comments/1` with empty body

###Invite user to event
POST request to `http://yourdomain.com/api/v1/events/1/invite/2` with empty body

###Expel user to event
DELETE request to `http://yourdomain.com/api/v1/events/1/expel/2` with empty body


