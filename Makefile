prefix=/usr/local
exec_prefix=$(prefix)
bindir=$(exec_prefix)/bin

SRC=./src
BIN=./bin
BIN_STATIC=$(BIN)/x86_64
NAME=fastq-namefilter
CXX=g++

CFLAGS=-O3 -Wextra -Wall -Wconversion -std=c++17 -mtune=native
CFLAGS_STATIC=$(CFLAGS) -static -fdata-sections -ffunction-sections -Wl,--gc-sections -s -march=x86-64 -mtune=generic
INSTALL=install
INSTALL_PROGRAM=$(INSTALL)

.PHONY: all clean
all: fastq-namefilter
static: fastq-namefilter-static

$(SRC)/%.o: %.c
	$(CXX) $(CFLAGS) -c -o $(SRC)/$@ $^

fastq-namefilter: $(SRC)/fastq-namefilter.o
	mkdir -p $(BIN)
	$(CXX) $(CFLAGS) -o$(BIN)/$@ $^
fastq-namefilter-static: $(SRC)/fastq-namefilter.o
	$(MAKE) BIN='$(BIN_STATIC)' CFLAGS='$(CFLAGS_STATIC)'\
		fastq-namefilter

install: $(BIN)/$(NAME) installdirs
	$(INSTALL_PROGRAM) $< $(DESTDIR)$(bindir)
install-strip:
	$(MAKE) INSTALL_PROGRAM='$(INSTALL_PROGRAM) -s' \
		install
installdirs:
	mkdir -p $(DESTDIR)$(bindir)

uninstall:
	rm -f $(DESTDIR)$(bindir)/$(NAME)

clean:
	rm -f $(SRC)/*.o
	rm -rf $(BIN)/fastq-namefilter
