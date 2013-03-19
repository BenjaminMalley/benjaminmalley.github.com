deploy:
	git pull origin source
	rake generate
	rake deploy
