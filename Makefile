build : proj fui testExt

run : build
	- bin/fcms

proj :
	- bin/fan src/proj/build.fan

fui :
	- bin/fan src/fui/build.fan

testExt :
	- bin/fan src/testExt/build.fan
