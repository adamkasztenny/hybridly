install:
	bundle install
	yarn install

start_development: install
	bin/rails server

test: install
	rspec .

lint:
	rubocop --fix .

migrate:
	bin/rails db:migrate
