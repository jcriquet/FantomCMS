buildfast:
	- bin/fan src/build.fan

build: db proj fui homeExt loginExt settingsExt userExt imageExt audioExt themesExt pagesExt uploaderExt securityExt layoutsExt htmlEditorExt galleryExt

run : buildfast
	- bin/fcms

db :
	- cd src/db; ../../bin/fan build.fan

proj :
	- cd src/proj; ../../bin/fan build.fan

fui :
	- cd src/fui; ../../bin/fan build.fan

homeExt :
	- cd src/homeExt; ../../bin/fan build.fan

loginExt :
	- cd src/loginExt; ../../bin/fan build.fan

settingsExt :
	- cd src/settingsExt; ../../bin/fan build.fan

userExt :
	- cd src/userExt; ../../bin/fan build.fan

imageExt :
	- cd src/imageExt; ../../bin/fan build.fan

audioExt :
	- cd src/audioExt; ../../bin/fan build.fan

themesExt :
	- cd src/themesExt; ../../bin/fan build.fan

galleryExt :
	- cd src/galleryExt; ../../bin/fan build.fan

pagesExt :
	- cd src/pagesExt; ../../bin/fan build.fan

uploaderExt :
	- cd src/uploaderExt; ../../bin/fan build.fan

securityExt :
	- cd src/securityExt; ../../bin/fan build.fan

layoutsExt :
	- cd src/layoutsExt; ../../bin/fan build.fan

htmlEditorExt :
	- cd src/htmlEditorExt; ../../bin/fan build.fan
