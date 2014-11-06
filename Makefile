build : proj fui loginExt homescreenExt mainExt

run : build
	- bin/fcms

proj :
	- cd src/proj; ../../bin/fan build.fan

fui :
	- cd src/fui; ../../bin/fan build.fan

homescreenExt :
	- cd src/homescreenExt; ../../bin/fan build.fan

mainExt :
	- cd src/mainExt; ../../bin/fan build.fan

loginExt :
	- cd src/loginExt; ../../bin/fan build.fan

securityExt :
	- cd src/securityExt; ../../bin/fan build.fan
