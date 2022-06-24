CC=flutter
FMT=format

default: get fmt check fmt

get:
	$(CC) pub get

generate:
	$(CC) pub run build_runner build --delete-conflicting-outputs;

fmt:
	$(CC) $(FMT) .
	$(CC) analyze .

check:
	$(CC) test

clean:
	$(CC) clean

run:
	flutter run -d linux

dep_upgrade:
	$(CC) pub upgrade --major-versions
