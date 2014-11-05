build : proj fui testExt loginExt securityExt borderPane

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
borderPane :
	-- cd src/borderPane; ../../bin/fan build.fan
