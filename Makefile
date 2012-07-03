all: run

run:
	@nodemon -w app -w config -w server run.coffee

deploy:
	@nodemon -w app -w config -w server deploy.coffee