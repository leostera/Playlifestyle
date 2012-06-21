all: run

run:
	@nodemon -w app -w config -w server run.coffee