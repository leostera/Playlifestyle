all:
	@nodemon -w app -w config -w server run.coffee

run:
	@coffee run