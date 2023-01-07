CC=flutter
FMT=format

default: get fmt

get:
	$(CC) pub get

fmt:
	dart $(FMT) .
	$(CC) analyze .

check:
	$(CC) test

clean:
	$(CC) clean

dep:
	$(CC) pub upgrade

gen:
	$(CC) pub run build_runner build --delete-conflicting-outputs;

run:
	$(CC) run -d linux
