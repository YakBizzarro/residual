# Android specific build targets

# These must be incremented for each market upload
ANDROID_VERSIONCODE = 1
ANDROID_PLUGIN_VERSIONCODE = 1

JAVA_FILES = \
	ResidualVM.java \
	ResidualVMEvents.java \
	ResidualVMApplication.java \
	ResidualVMActivity.java \
	EditableSurfaceView.java \
	Unpacker.java

JAVA_FILES_PLUGIN = \
	PluginProvider.java

JAVA_FILES_GEN = \
	Manifest.java \
	R.java

PATH_DIST = $(srcdir)/dists/android
PATH_RESOURCES = $(PATH_DIST)/res

PORT_DISTFILES = $(PATH_DIST)/README.Android
DIST_ANDROID_CONTROLS = $(PATH_DIST)/assets/arrows.tga

RESOURCES = \
	$(PATH_RESOURCES)/values/strings.xml \
	$(PATH_RESOURCES)/layout/main.xml \
	$(PATH_RESOURCES)/layout/splash.xml \
	$(PATH_RESOURCES)/drawable/gradient.xml \
	$(PATH_RESOURCES)/drawable/residualvm.png \
	$(PATH_RESOURCES)/drawable/residualvm_big.png

PLUGIN_RESOURCES = \
	$(PATH_RESOURCES)/values/strings.xml \
	$(PATH_RESOURCES)/drawable/residualvm.png

# FIXME: find/mark plugin entry points and add all this back again:
#LDFLAGS += -Wl,--gc-sections
#CXXFLAGS += -ffunction-sections -fdata-sections -fvisibility=hidden -fvisibility-inlines-hidden

AAPT = $(ANDROID_SDK)/platform-tools/aapt
ADB = $(ANDROID_SDK)/platform-tools/adb
DX = $(ANDROID_SDK)/platform-tools/dx
APKBUILDER = $(ANDROID_SDK)/tools/apkbuilder
JAVAC ?= javac
JAVACFLAGS = -source 1.5 -target 1.5

ANDROID_JAR = $(ANDROID_SDK)/platforms/android-8/android.jar

PATH_BUILD = ./build.tmp
PATH_BUILD_ASSETS = $(PATH_BUILD)/assets
PATH_BUILD_CLASSES_MAIN_TOP = $(PATH_BUILD)/classes.main
PATH_BUILD_CLASSES_PLUGIN_TOP = $(PATH_BUILD)/classes.plugin

PATH_STAGE_PREFIX = build.stage
PATH_STAGE_MAIN = $(PATH_STAGE_PREFIX).main

PATH_REL = org/residualvm/residualvm
PATH_SRC_TOP = $(srcdir)/backends/platform/android
PATH_SRC = $(PATH_SRC_TOP)/$(PATH_REL)

PATH_GEN_TOP = $(PATH_BUILD)/java
PATH_GEN = $(PATH_GEN_TOP)/$(PATH_REL)
PATH_CLASSES_MAIN = $(PATH_BUILD_CLASSES_MAIN_TOP)/$(PATH_REL)
PATH_CLASSES_PLUGIN = $(PATH_BUILD_CLASSES_PLUGIN_TOP)/$(PATH_REL)

FILE_MANIFEST_SRC = $(srcdir)/dists/android/AndroidManifest.xml
FILE_MANIFEST = $(PATH_BUILD)/AndroidManifest.xml
FILE_DEX = $(PATH_BUILD)/classes.dex
FILE_DEX_PLUGIN = $(PATH_BUILD)/plugins/classes.dex
FILE_RESOURCES = resources.ap_
FILE_RESOURCES_MAIN = $(PATH_BUILD)/$(FILE_RESOURCES)

SRC_GEN = $(addprefix $(PATH_GEN)/, $(JAVA_FILES_GEN))

CLASSES_MAIN = $(addprefix $(PATH_CLASSES_MAIN)/, $(JAVA_FILES:%.java=%.class))
CLASSES_GEN = $(addprefix $(PATH_CLASSES_MAIN)/, $(JAVA_FILES_GEN:%.java=%.class))
CLASSES_PLUGIN = $(addprefix $(PATH_CLASSES_PLUGIN)/, $(JAVA_FILES_PLUGIN:%.java=%.class))

APK_MAIN = residualvm.apk
APK_PLUGINS = $(patsubst plugins/lib%.so, residualvm-engine-%.apk, $(PLUGINS))

$(FILE_MANIFEST): $(FILE_MANIFEST_SRC)
	@$(MKDIR) -p $(@D)
	sed "s/@ANDROID_VERSIONCODE@/$(ANDROID_VERSIONCODE)/" < $< > $@

$(SRC_GEN): $(FILE_MANIFEST) $(filter %.xml,$(RESOURCES)) $(ANDROID_JAR)
	@$(MKDIR) -p $(PATH_GEN_TOP)
	$(AAPT) package -m -J $(PATH_GEN_TOP) -M $< -S $(PATH_RESOURCES) -I $(ANDROID_JAR)

$(PATH_CLASSES_MAIN)/%.class: $(PATH_GEN)/%.java $(SRC_GEN)
	@$(MKDIR) -p $(@D)
	$(JAVAC) $(JAVACFLAGS) -cp $(PATH_SRC_TOP) -d $(PATH_BUILD_CLASSES_MAIN_TOP) -bootclasspath $(ANDROID_JAR) $<

$(PATH_CLASSES_MAIN)/%.class: $(PATH_SRC)/%.java $(SRC_GEN)
	@$(MKDIR) -p $(@D)
	$(JAVAC) $(JAVACFLAGS) -cp $(PATH_SRC_TOP):$(PATH_GEN_TOP) -d $(PATH_BUILD_CLASSES_MAIN_TOP) -bootclasspath $(ANDROID_JAR) $<

$(PATH_CLASSES_PLUGIN)/%.class: $(PATH_SRC)/%.java
	@$(MKDIR) -p $(@D)
	$(JAVAC) $(JAVACFLAGS) -cp $(PATH_SRC_TOP) -d $(PATH_BUILD_CLASSES_PLUGIN_TOP) -bootclasspath $(ANDROID_JAR) $<

$(FILE_DEX): $(CLASSES_MAIN) $(CLASSES_GEN)
	$(DX) --dex --output=$@ $(PATH_BUILD_CLASSES_MAIN_TOP)

$(FILE_DEX_PLUGIN): $(CLASSES_PLUGIN)
	@$(MKDIR) -p $(@D)
	$(DX) --dex --output=$@ $(PATH_BUILD_CLASSES_PLUGIN_TOP)

$(PATH_BUILD)/%/AndroidManifest.xml: $(PATH_DIST)/mkplugin.sh $(srcdir)/configure $(PATH_DIST)/plugin-manifest.xml
	@$(MKDIR) -p $(@D)
	$(PATH_DIST)/mkplugin.sh $(srcdir)/configure $* $(PATH_DIST)/plugin-manifest.xml $(ANDROID_PLUGIN_VERSIONCODE) $@

$(PATH_STAGE_PREFIX).%/res/values/strings.xml: $(PATH_DIST)/mkplugin.sh $(srcdir)/configure $(PATH_DIST)/plugin-manifest.xml
	@$(MKDIR) -p $(@D)
	$(PATH_DIST)/mkplugin.sh $(srcdir)/configure $* $(PATH_DIST)/plugin-strings.xml $(ANDROID_PLUGIN_VERSIONCODE) $@

$(PATH_STAGE_PREFIX).%/res/drawable/residualvm.png: $(PATH_RESOURCES)/drawable/residualvm.png
	@$(MKDIR) -p $(@D)
	$(CP) $< $@

$(FILE_RESOURCES_MAIN): $(FILE_MANIFEST) $(RESOURCES) $(ANDROID_JAR) $(DIST_FILES_THEMES) $(DIST_FILES_ENGINEDATA) $(DIST_ANDROID_CONTROLS)
	$(INSTALL) -d $(PATH_BUILD_ASSETS)
	$(INSTALL) -c -m 644 $(DIST_FILES_THEMES) $(DIST_FILES_ENGINEDATA)  $(DIST_ANDROID_CONTROLS) $(PATH_BUILD_ASSETS)/
	work_dir=`pwd`; \
	for i in $(PATH_BUILD_ASSETS)/*.zip; do \
		echo "recompress $$i"; \
		cd "$$work_dir"; \
		$(RM) -rf $(PATH_BUILD_ASSETS)/tmp; \
		$(MKDIR) $(PATH_BUILD_ASSETS)/tmp; \
		unzip -q $$i -d $(PATH_BUILD_ASSETS)/tmp; \
		cd $(PATH_BUILD_ASSETS)/tmp; \
		zip -r ../`basename $$i` *; \
	done
	@$(RM) -rf $(PATH_BUILD_ASSETS)/tmp
	$(AAPT) package -f -0 "" -M $< -S $(PATH_RESOURCES) -A $(PATH_BUILD_ASSETS) -I $(ANDROID_JAR) -F $@

$(PATH_BUILD)/%/$(FILE_RESOURCES): $(PATH_BUILD)/%/AndroidManifest.xml $(PATH_STAGE_PREFIX).%/res/values/strings.xml $(PATH_STAGE_PREFIX).%/res/drawable/residualvm.png plugins/lib%.so $(ANDROID_JAR)
	$(AAPT) package -f -M $< -S $(PATH_STAGE_PREFIX).$*/res -I $(ANDROID_JAR) -F $@

$(APK_MAIN): $(EXECUTABLE) $(FILE_RESOURCES_MAIN) $(FILE_DEX)
	$(INSTALL) -d $(PATH_STAGE_MAIN)/common/lib/armeabi
	$(INSTALL) -c -m 644 libresidualvm.so $(PATH_STAGE_MAIN)/common/lib/armeabi/
	$(STRIP) $(PATH_STAGE_MAIN)/common/lib/armeabi/libresidualvm.so
	$(APKBUILDER) $@ -z $(FILE_RESOURCES_MAIN) -f $(FILE_DEX) -rf $(PATH_STAGE_MAIN)/common || { $(RM) $@; exit 1; }

residualvm-engine-%.apk: plugins/lib%.so $(PATH_BUILD)/%/$(FILE_RESOURCES) $(FILE_DEX_PLUGIN)
	$(INSTALL) -d $(PATH_STAGE_PREFIX).$*/apk/lib/armeabi/
	$(INSTALL) -c -m 644 plugins/lib$*.so $(PATH_STAGE_PREFIX).$*/apk/lib/armeabi/
	$(STRIP) $(PATH_STAGE_PREFIX).$*/apk/lib/armeabi/lib$*.so
	$(APKBUILDER) $@ -z $(PATH_BUILD)/$*/$(FILE_RESOURCES) -f $(FILE_DEX_PLUGIN) -rf $(PATH_STAGE_PREFIX).$*/apk || { $(RM) $@; exit 1; }

all: $(APK_MAIN) $(APK_PLUGINS)

clean: androidclean

androidclean:
	@$(RM) -rf $(PATH_BUILD) $(PATH_STAGE_PREFIX).* *.apk release

# remove debugging signature
release/%.apk: %.apk
	@$(MKDIR) -p $(@D)
	@$(RM) $@
	$(CP) $< $@.tmp
	zip -d $@.tmp META-INF/\*
	jarsigner $(JARSIGNER_FLAGS) $@.tmp release
	zipalign 4 $@.tmp $@
	$(RM) $@.tmp

androidrelease: $(addprefix release/, $(APK_MAIN) $(APK_PLUGINS))

androidtestmain: $(APK_MAIN)
	$(ADB) install -r $(APK_MAIN)
	$(ADB) shell am start -a android.intent.action.MAIN -c android.intent.category.LAUNCHER -n org.residualvm.residualvm/.Unpacker

androidtest: $(APK_MAIN) $(APK_PLUGINS)
	@set -e; for apk in $^; do \
		$(ADB) install -r $$apk; \
	done
	$(ADB) shell am start -a android.intent.action.MAIN -c android.intent.category.LAUNCHER -n org.residualvm.residualvm/.Unpacker

# used by buildbot!
androiddistdebug: all
	$(MKDIR) debug
	$(CP) $(APK_MAIN) $(APK_PLUGINS) debug/
	for i in $(DIST_FILES_DOCS) $(PORT_DISTFILES); do \
		sed 's/$$/\r/' < $$i > debug/`basename $$i`.txt; \
	done

.PHONY: androidrelease androidtest
