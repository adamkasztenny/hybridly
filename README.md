# Hybridly

A return to office solution :office:

## :star: Features :star:
- Set a limit on the total number of people in the office per day
- Employees can make reservations
- View when others are in the office
- Single-sign on (via [Auth0](https://auth0.com/))

See the [backlog](https://github.com/adamkasztenny/hybridly/projects/1) for planned features.

## Quick Start
You will need an Auth0 account, as well as Docker, make and Ruby 3.0.1 installed for these steps.

1. In Auth0, create a [regular web application](https://auth0.com/docs/applications/set-up-an-application/register-regular-web-applications).
  1. `Allowed Callback URLs` should be `http://localhost:3000/authentication/callback`
  1. `Allowed Web Origins` and `Allowed Origins (CORS)` should be `http://localhost:3000`

1. Run these steps to start the server:
```bash
	export DEFAULT_USER_EMAIL=<the email you plan to log in with>

	# these values will be in the Auth0 application
	export AUTH0_DOMAIN=...
	export AUTH0_CLIENT_ID=...
	export AUTH0_CLIENT_SECRET=...

	make create_secret
	make start
	make seed_container
```
1. Open [localhost:3000](http://localhost:3000) in your browser to use Hybridly!

## Local Development
In addition to the tools above, you will also need Node and Yarn installed for local development.

To start the development server, the steps are the same as above, except run
`make start_development` instead of `make start`, and run `make seed` instead
of `make seed_container`.

To run tests, run `make test`. To run the linter, run `make lint`.
