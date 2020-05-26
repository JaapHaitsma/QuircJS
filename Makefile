# QuircJS -- Javascript QR-code recognition library
# Copyright (C) 2010-2012 Jaap Haitsma <jaap@haitsma.org>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

EMCC ?= emcc
PYTHON ?= python

WASM_SRC = \
	src/quirc.cpp \
	quirc/lib/decode.c \
	quirc/lib/identify.c \
	quirc/lib/quirc.c \
	quirc/lib/version_db.c \
	src/quirc-glue-wrapper.cpp

WEB_IDL_BINDER_PY = $(shell dirname `which emcc`)/tools/webidl_binder.py
EMCCFLAGS ?= -O3


all: src/quirc.js

src/quirc.js: src/quirc.idl $(WASM_SRC)
	$(PYTHON) $(WEB_IDL_BINDER_PY) src/quirc.idl src/quirc-glue
	$(EMCC) $(EMCCFLAGS) $(WASM_SRC) --post-js src/quirc-glue.js -o src/quirc.js


clean:
	rm -f WebIDLGrammar.pkl
	rm -f src/quirc-glue.cpp
	rm -f src/quirc-glue.js
	rm -f src/quirc.js
	rm -f src/quirc.wasm
	rm -f parser.out
	