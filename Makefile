install:
	bundle install
	yarn install

start_development:
	bin/rails server

test: install
	rspec .
