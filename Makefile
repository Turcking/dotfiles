SUBPROJECTS = $(patsubst %/Makefile,%,$(wildcard */Makefile))
.DEFAULT_GOAL = help

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
	@printf "\t%b%s%b%s\n" $(HIGHLIGHT) "COLOR" $(RESUME) ": default TRUE, set it to anything else to disable color."
	@printf "\n"
	@printf "Goals:\n"
	@printf "\n"
	@printf "\t%b%s%b%s\n" $(HIGHLIGHT) "help" $(RESUME) ": print this message."
	@printf "\t%b%s%b%s\n" $(HIGHLIGHT) "check" $(RESUME) ": check dependencies exists for all subprojects."
	@printf "\t%b%s%b%s\n" $(HIGHLIGHT) "install" $(RESUME) ": install for all subprojects (adopts existing files)."
	@printf "\t%b%s%b%s\n" $(HIGHLIGHT) "uninstall" $(RESUME) ": uninstall for all subprojects."
	@printf "\n"

check:
	@$(foreach SUBPROJECT, $(SUBPROJECTS), RUN=$(RUN) COLOR=$(COLOR) $(MAKE) -C $(SUBPROJECT) --no-print-directory check;)

install:
	@$(foreach SUBPROJECT, $(SUBPROJECTS), RUN=$(RUN) COLOR=$(COLOR) $(MAKE) -C $(SUBPROJECT) --no-print-directory install;)

uninstall:
	@$(foreach SUBPROJECT, $(SUBPROJECTS), RUN=$(RUN) COLOR=$(COLOR) $(MAKE) -C $(SUBPROJECT) --no-print-directory uninstall;)

.PHONY: help check $(addprefix CHECK_, $(SUBPROJECTS)) install uninstall
