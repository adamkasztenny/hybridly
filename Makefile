PROJECT="hybridly"
CURRENT_DIRECTORY=$(shell pwd)

install:
	bundle install
	yarn install

create_secret: install
	EDITOR=stub bin/rails credentials:edit

build:
	docker build -t ${PROJECT} .

start: build
	docker run --name ${PROJECT} -e AUTH0_DOMAIN -e AUTH0_CLIENT_ID -e AUTH0_CLIENT_SECRET -e DEFAULT_USER_EMAIL -v $(CURRENT_DIRECTORY)/db:/opt/db -v $(CURRENT_DIRECTORY)/log:/opt/log -d -p 3000:3000 ${PROJECT}

stop:
	docker stop ${PROJECT}

save:
	docker save ${PROJECT}:latest > hybridly-latest.tar

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
