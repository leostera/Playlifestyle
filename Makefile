all: run

run:
	@nodemon -w app -w config -w server run.coffee

deploy:
	@SS_ENV=fake_production nodemon -w app -w config -w server run.coffee