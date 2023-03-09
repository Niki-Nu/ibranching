PREFIX = /usr

IB = ib
CC = gcc
LD = gcc
STRIP = strip

CFLAGS = -Os -Wall
LDFLAGS = -flto

LIBS =

PROGRAM = ib

IB_HEADERS = $(wildcard *.h.ib)
IB_CFILES  = $(wildcard *.c.ib)
HEADERS = $(patsubst %.h.ib, build/%.h, $(IB_HEADERS))
OBJS = $(patsubst %.c.ib, build/%.o, $(IB_CFILES))
CFILES = $(patsubst %.c.ib, build/%.c, $(IB_CFILES))

all: $(PROGRAM)

build/%.h: %.h.ib
	@echo " IB      $<"
	@$(IB) $< -o $@

build/%.c: %.c.ib
	@echo " IB      $<"
	@$(IB) $< -o $@

build/%.o: build/%.c
	@echo " CC      $<"
	@$(CC) $< $(CFLAGS) -I build -c -o $@ 

$(PROGRAM): $(HEADERS) $(CFILES) $(OBJS)
	@echo " LD      $(PROGRAM)"
	@$(CC) $(LDFLAGS) $(LIBS) $(OBJS) -o $(PROGRAM)
	@echo " STRIP   $<"
	@$(STRIP) $(PROGRAM)

setup_test:
	$(eval IB = ./ib)

test: setup_test clean $(PROGRAM)

bootstrap: $(PROGRAM)

clean:
	@echo " CLEAN"
	@rm -f build/*.h build/*.o build/*.c

install: $(PROGRAM)
	@echo " INSTALL $(PROGRAM)"
	@cp $(PROGRAM) ${PREFIX}/bin/
