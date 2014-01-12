EBIN_DIR=ebin
SOURCE_DIR=src
INCLUDE_DIR=include
ERLC_FLAGS=-W0 -Ddebug +debug_info
ERLC=erlc -I $(INCLUDE_DIR) -o $(EBIN_DIR) $(ERLC_FLAGS)
ERL=erl -I -pa ebin -noshell -eval

PARSER_BASE_NAME=selector
LEXER_NAME=$(PARSER_BASE_NAME)_lexer
PARSER_NAME=$(PARSER_BASE_NAME)_parser

SOURCES=$(wildcard $(SOURCE_DIR)/*.erl)
TARGETS=$(SOURCES:$(SOURCE_DIR)/%.erl=$(EBIN_DIR)/%.beam)

default: $(EBIN_DIR) test

$(EBIN_DIR):
	mkdir -p $(EBIN_DIR)

$(SOURCE_DIR)/$(LEXER_NAME).erl: $(SOURCE_DIR)/$(LEXER_NAME).xrl
	$(ERL) 'leex:file("$(SOURCE_DIR)/$(LEXER_NAME)"), halt().'

$(SOURCE_DIR)/$(PARSER_NAME).erl: $(SOURCE_DIR)/$(PARSER_NAME).yrl
	$(ERL) 'yecc:file("$(SOURCE_DIR)/$(PARSER_NAME)"), halt().'

$(EBIN_DIR)/%.beam: $(SOURCE_DIR)/%.erl 
	$(ERLC) $<

test: $(TARGETS) \
	  $(EBIN_DIR)/$(LEXER_NAME).beam \
	  $(EBIN_DIR)/$(PARSER_NAME).beam
	$(ERL) 'selector_test:test(), halt().'

clean:
	rm -f $(SOURCE_DIR)/$(LEXER_NAME).erl
	rm -f $(SOURCE_DIR)/$(PARSER_NAME).erl
	rm -fr $(EBIN_DIR)