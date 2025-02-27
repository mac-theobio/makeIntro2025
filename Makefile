## This is [project.Makefile] …

## This section is for Dushoff-style vim-setup and vim targeting
## You can delete it if you don't want it
current: target
-include target.mk
Ignore = target.mk

## vim_session depends on no other files
vim_session:
	bash -cl "vmt"

######################################################################

Sources += $(wildcard *.R)

## A non-trivial dependency with an explicit recipe
calculate.Rout: calculate.R
	R --vanilla < calculate.R > calculate.Rout

Ignore += fev.csv
fev.csv:
	wget -O fev.csv "https://hbiostat.org/data/repo/FEV.csv"

## We can use variables in our recipe to avoid duplication and silliness
analyze.Rout: analyze.R fev.csv
	R --vanilla < $< > $@

## We could also give the recipe line above a variable name... or put it in an included make file

## < takes from stdin 
## > places stuff stdout
## there is also something called stderr

######################################################################

## A makestuff example

fev.Rout: fev.R fev.csv
	$(pipeR)

######################################################################

### Makestuff

Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff

## ln -s ../makestuff . ## Do this first if you want a linked makestuff
Makefile: makestuff/00.stamp
makestuff/%.stamp: | makestuff
	- $(RM) makestuff/*.stamp
	cd makestuff && $(MAKE) pull
	touch $@
makestuff:
	git clone --depth 1 $(msrepo)/makestuff

-include makestuff/os.mk

-include makestuff/pipeR.mk
-include makestuff/texj.mk

-include makestuff/git.mk
-include makestuff/visual.mk
