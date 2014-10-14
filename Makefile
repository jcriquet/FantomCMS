SOURCES    = build.fan
DOC	   = doc/*
OTHER      = Makefile
EXECBIN    = fan
SRCFILES   = ${SOURCES} ${DOC} ${OTHER}

build :
	- fan build.fan

run : build
	- fan FantomCMS::FantomCMS

# To add a commit, use the m variable. Example:
# make ci m="this is a commit"
ci :
	- git add ${SRCFILES}
	- git commit -m "$m"
