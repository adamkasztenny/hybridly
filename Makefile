PROJECT="hybridly"

install:
	bundle install
	yarn install

build:
	docker build -t ${PROJECT} .

start: build
	docker run -e AUTH0_DOMAIN -e AUTH0_CLIENT_ID -e AUTH0_CLIENT_SECRET -d -p 3000:3000 ${PROJECT}

start_development: install
	bin/rails server

test: install
	rspec spec

lint:
	rubocop --fix .

migrate:
	bin/rails db:migrate

seed: migrate
	rake db:seed
