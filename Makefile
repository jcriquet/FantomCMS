build : proj fui testExt

run : build
	- bin/fcms

proj :
	- fan src/proj/build.fan

fui :
	- fan src/fui/build.fan

testExt :
	- fan src/testExt/build.fan
