PREFIX = /usr/local

.PHONY:	check install

bin/detenc: bin src/detenc
	cp src/detenc bin/

bin:
	mkdir -p bin

src/detenc:
	$(MAKE) -C src

check: bin/detenc
	cd test && rake test

clean:
	rm -f bin/*
	$(MAKE) -C src clean

install: bin/detenc
	install -m 0755 $< $(PREFIX)/bin
