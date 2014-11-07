<<<<<<< HEAD
build : proj fui loginExt securityExt borderPane homescreenExt mainExt
=======
build : db proj fui mainExt homescreenExt loginExt settingsExt securityExt pagesExt
>>>>>>> master

run : build
	- bin/fcms

db :
	- cd src/db; ../../bin/fan build.fan

proj :
	- cd src/proj; ../../bin/fan build.fan

fui :
	- cd src/fui; ../../bin/fan build.fan

mainExt :
	- cd src/mainExt; ../../bin/fan build.fan

homescreenExt :
	- cd src/homescreenExt; ../../bin/fan build.fan

loginExt :
	- cd src/loginExt; ../../bin/fan build.fan

settingsExt :
	- cd src/settingsExt; ../../bin/fan build.fan

securityExt :
	- cd src/securityExt; ../../bin/fan build.fan
borderPane :
	-- cd src/borderPane; ../../bin/fan build.fan
