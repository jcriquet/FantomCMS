build : proj fui testExt loginExt securityExt

run : build
	- bin/fcms

proj :
	- cd src/proj; ../../bin/fan build.fan

fui :
	- cd src/fui; ../../bin/fan build.fan

testExt :
	- cd src/testExt; ../../bin/fan build.fan

loginExt :
	- cd src/loginExt; ../../bin/fan build.fan
securityExt :
	- cd src/securityExt; ../../bin/fan build.fan
