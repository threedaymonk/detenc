CC = gcc
CFLAGS = -Wall
OBJECTS = detenc.o libdetenc.o one_byte_detector.o utf8_detector.o

.PHONY: clean

detenc: $(OBJECTS)
	$(CC) $(CFLAGS) $(OBJECTS) -o $@

detenc.o: detenc.c libdetenc.h usage.inc
	$(CC) $(CFLAGS) -c $<

libdetenc.o: libdetenc.c detectors.h
	$(CC) $(CFLAGS) -c $<
	
%.o : %.c
	$(CC) $(CFLAGS) -c $<

usage.inc: usage.txt
	sed 's/^/"/;s/$$/\\n"/' < $< > $@

clean:
	rm -f detenc *.o usage.inc
