build:
	go build .

run:
	sh bin/start.sh

logs:
	tail -F /tmp/orca.log