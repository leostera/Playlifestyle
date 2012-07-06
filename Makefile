all: run

run:
	@nodemon -w app -w config -w server run.coffee

deploy:
	@SS_ENV=production nodemon -w app -w config -w server run.coffee