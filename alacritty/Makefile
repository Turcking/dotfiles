IGNORE_FILES += Makefile
DEFAULT_DESTINATION_DIRECTORY = $(if $(XDG_CONFIG_HOME),$(XDG_CONFIG_HOME),$(HOME)/.config)/alacritty
.DEFAULT_GOAL = help

# Use $(XDG_CONFIG_HOME)/alacritty as default install directory
DESTINATION_DIRECTORY ?= $(DEFAULT_DESTINATION_DIRECTORY)

# Generate stow ignore rules
STOW_IGNORE = $(foreach IGNORE_FILE, $(IGNORE_FILES), --ignore=$(shell perl -e "print \"^\"; print quotemeta(\"\$$ARGV[0]\"); print \"\\$$\";" $(IGNORE_FILE)))

# Set color variables
COLOR ?= TRUE
ifeq ($(COLOR), TRUE)
	ERROR = "[\033[31m!\033[0m]"
	INFO = "[\033[32m+\033[0m]"
	NOTICE = "[\033[33m*\033[0m]"

	HIGHLIGHT = "\033[1m"
	RESUME = "\033[0m"
else
	ERROR = "[!]"
	INFO = "[+]"
	NOTICE = "[*]"

	HIGHLIGHT = ""
	RESUME = ""
endif

help:
	@printf "Environment variables:\n"
	@printf "\n"
	@printf "\t%b%s%b%s\n" $(HIGHLIGHT) "RUN" $(RESUME) ": dry run default, set it to any value to actually run."
	@printf "\t%b%s%b%s\n" $(HIGHLIGHT) "IGNORE_FILES" $(RESUME) ": files ignored by stow."
	@printf "\t%b%s%b%s\n" $(HIGHLIGHT) "DESTINATION_DIRECTORY" $(RESUME) ": install directory, default $(DEFAULT_DESTINATION_DIRECTORY)."
	@printf "\t%b%s%b%s\n" $(HIGHLIGHT) "COLOR" $(RESUME) ": default TRUE, set it to anything else to disable color."
	@printf "\n"
	@printf "Goals:\n"
	@printf "\n"
	@printf "\t%b%s%b%s\n" $(HIGHLIGHT) "help" $(RESUME) ": print this message."
	@printf "\t%b%s%b%s\n" $(HIGHLIGHT) "check" $(RESUME) ": check dependency exists (does not block the install goal)."
	@printf "\t%b%s%b%s\n" $(HIGHLIGHT) "install" $(RESUME) ": install to \$$(DESTINATION_DIRECTORY) (adopts existing files)."
	@printf "\t%b%s%b%s\n" $(HIGHLIGHT) "uninstall" $(RESUME) ": uninstall from \$$(DESTINATION_DIRECTORY)."
	@printf "\n"

check:
	@if which alacritty >> /dev/null; then \
		printf "%b %s\n" $(INFO) "Alacritty found."; \
	else \
		printf "%b %s\n" $(ERROR) "Alacritty not found."; \
	fi  # Check alacritty exists
	@if fc-list ":family=Source Code Pro:style=Regular" | grep -q .; then \
		printf "%b %s\n" $(INFO) "Source Code Pro Regular found."; \
	else \
		printf "%b %s\n" $(ERROR) "Source Code Pro Regular not found."; \
	fi  # Check Source Code Pro Regular exists

install:
	@printf "%b %s\n" $(INFO) "Installing alacritty config files."
	stow -t "$(DESTINATION_DIRECTORY)" -S $(STOW_IGNORE) --adopt $(if $(RUN),,-n) -v .

uninstall:
	@printf "%b %s\n" $(INFO) "Uninstalling alacritty config files."
	stow -t "$(DESTINATION_DIRECTORY)" -D $(STOW_IGNORE) $(if $(RUN),,-n) -v .

.PHONY: help check install uninstall
