######################################################## A modifier ##################################################################################
CC = g++
CFLAGS = -W -Wall -Wextra -fno-elide-constructors -std=c++1y
SRCD = src
OBJD = obj
BIND = bin
EXENAME = tp1_1
ARCHIVENAME = tp1_1
#Si laissé vide, elle sera set en fonction de si on utilise gcc ou g++. Dans le cas de l'utilisation d'un autre type de fichier a spécifier absolument
SRCEXT = 
HEADEXT =

#Paramètre :
#
#BLACK; RED; GREEN; YELLOW; BLUE; MAGENTA; CYAN; WHITE
#
#Modificateurs:
#
#BOLD; UNDER
#Les modificateurs peuvent être cumulés

ifneq (TPUT_EXIST, )
OK_COLOR = $(GREEN)
WARNING_COLOR = $(UNDER)$(YELLOW)
ERROR_COLOR = $(UNDER)$(BOLD)$(RED)
FILE_COLOR = $(BLUE)
INFO_COLOR= $(WHITE)
endif

######################################################## Ne pas toucher ###############################################################################
ifeq ($(SRCEXT), )
ifeq ($(CC), g++)
SRCEXT = cpp
HEADEXT = hpp
ifeq ($(CC), gcc)
SRCEXT = c
HEADEXT = h
endif
endif
endif


TPUT_EXIST = $(shell command -v tput)

#Couleurs
BOLD = $$(tput bold)
UNDER = $$(tput sgr 0 1)

BLACK = $$(tput setaf 0)
RED = $$(tput setaf 1)
GREEN = $$(tput setaf 2)
YELLOW = $$(tput setaf 3)
BLUE = $$(tput setaf 4)
MAGENTA = $$(tput setaf 5)
CYAN = $$(tput setaf 6)
WHITE = $$(tput setaf 7)
#RESET = $$(tput sgr 0)
RESET = $$(tput sgr 0)$(WHITE)

ERROR_STRING = $(ERROR_COLOR)[ERROR]$(RESET)
WARN_STRING = $(WARNING_COLOR)[WARNING]$(RESET)
OK_STRING = $(OK_COLOR)[OK]$(RESET)

#Fichier
SRC = $(wildcard $(SRCD)/*.$(SRCEXT))
OBJ = $(SRC:$(SRCD)/%.$(SRCEXT)=$(OBJD)/%.o)
BIN = $(BIND)/$(EXENAME)

#Règles
default: $(BIN)	
	
$(OBJD)/%.o: $(SRCD)/%.$(SRCEXT)
	@mkdir -p $(OBJD)
	@echo -n "$(RESET)Linking $(FILE_COLOR)$@$(RESET) ..."
	@$(CC) $(CFLAGS) -o $@ -c $^ 2> make.log || touch make.errors
	@if test -e make.errors; then echo "$(ERROR_STRING)" && cat make.log; elif test -s make.log; then echo "$(WARN_STRING)" && cat make.log; else echo "$(OK_STRING)"; fi;
	@rm -f make.log
	@rm -f make.errors

$(BIN):	$(OBJ)
	@mkdir -p $(BIND)
	@echo -n "Linking $(FILE_COLOR)$@$(RESET) ..."
	@$(CC) $(CFLAGS) -o $(BIN) $^ 2> make.log || touch make.errors
	@if test -e make.errors; then echo "$(ERROR_STRING)" && cat make.log; elif test -s make.log; then echo "$(WARN_STRING)" && cat make.log; else echo "$(OK_STRING)"; fi;
	@rm -f make.log
	@rm -f make.errors
	
clean:
	@rm -f $(BIN)
	@rm -f $(OBJ)
	@echo "$(RESET)Clean !"
	
mrproper:
	@rm -f $(BIN)
	@rm -f $(OBJ)
	@rm -rf $(OBJD)
	@rm -rf $(BIND)
	@rm -f $(ARCHIVENAME).tar.gz
	@echo "$(RESET)Mega clean !"
	
archive : mrproper
	@tar czf $(ARCHIVENAME).tar.gz \
		--transform "s-^-$(ARCHIVENAME)/-" \
		--exclude "*.tar.gz" --exclude "*.o" \
		*
	@echo "Archive $(ARCHIVENAME).tar.gz created !"

#Permet de créer un repertoire propre avec les sources dans un fichier src	
repo :
	@mkdir -p $(SRCD)
	@mv -n *.$(SRCEXT) $(SRCD)
	@mv -n *.$(HEADEXT) $(SRCD)
	@echo "src repository created and files moved !"
	
	


