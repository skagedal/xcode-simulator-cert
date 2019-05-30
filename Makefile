prefix ?= /usr/local
bindir = $(prefix)/bin
libdir = $(prefix)/lib

build:
	swift build -c release --disable-sandbox

install: build
	install ".build/release/xcode-simulator-tool" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/xcode-simulator-tool"

clean:
	rm -rf .build

.PHONY: build install uninstall clean
