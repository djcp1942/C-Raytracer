TARGET = engine
COMPILER = gcc

SRC = src/*.c lib/*.c
LINUX_CFLAGS := -lm -std=c11 -DDISPLAY_TIME -Wno-address-of-packed-member -DUNBOUND_OBJECTS
RELEASE_CFLAGS := -Ofast -DMULTITHREADING -fopenmp
DEBUG_CFLAGS := -Wall -Wextra -Wdouble-promotion -Wpedantic -Wstrict-prototypes -Wshadow -g -Ofast -DDEBUG -fsanitize=address -fsanitize=undefined -Wno-maybe-uninitialized

debug:
	$(COMPILER) $(SRC) -o $(TARGET) $(LINUX_CFLAGS) $(DEBUG_CFLAGS)
release:
	$(COMPILER) $(SRC) -o $(TARGET) $(LINUX_CFLAGS) $(RELEASE_CFLAGS)
clean:
	rm -rf $(TARGET)
