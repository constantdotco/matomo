CP=cp
FIND=find
SED=sed

function organizePackage() {

	if [ ! -f "composer.phar" ]
	then
		EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
		php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
		ACTUAL_SIGNATURE="$(php -r "echo hash_file('SHA384', 'composer-setup.php');")"

		if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
		then
			>&2 echo 'ERROR: Invalid installer signature'
			rm composer-setup.php
			exit 1
		fi
		php composer-setup.php --quiet || die "Error installing composer "
		rm composer-setup.php
	fi
	# --ignore-platform-reqs in case the building machine does not have one of the packages required ie. GD required by cpchart
	php composer.phar install --no-dev -o --ignore-platform-reqs || die "Error installing composer packages"

	# delete most submodules
	for P in $(git submodule status | egrep -v $SUBMODULES_PACKAGED_WITH_CORE | awk '{print $2}')
	do
		rm -Rf ./$P
	done

	# ------------
	# WARNING:
	# if you add files below, also update the Integration test in ReleaseCheckListTest.php
	# in isFileDeletedFromPackage()
	# ------------

	echo -e "Deleting un-needed files..."

	rm -rf composer.phar
	rm -rf vendor/bin/
	rm -rf vendor/twig/twig/test/
	rm -rf vendor/twig/twig/doc/
	rm -rf vendor/symfony/console/Symfony/Component/Console/Resources/bin
	rm -rf vendor/tecnickcom/tcpdf/examples
	rm -rf vendor/tecnickcom/tcpdf/CHANGELOG.TXT
	rm -rf vendor/guzzle/guzzle/docs/
	rm -rf vendor/davaxi/sparkline/tests
	rm -rf vendor/php-di/php-di/benchmarks/
	rm -rf vendor/geoip2/geoip2/.gitmodules
	rm -rf vendor/geoip2/geoip2/.php_cs
	rm -rf vendor/maxmind-db/reader/ext/
	rm -rf vendor/maxmind-db/reader/autoload.php
	rm -rf vendor/maxmind-db/reader/CHANGELOG.md
	rm -rf vendor/maxmind/web-service-common/dev-bin/
	rm -rf vendor/maxmind/web-service-common/CHANGELOG.md
	rm -rf vendor/php-di/invoker/doc/
	rm -rf vendor/szymach/c-pchart/doc
	rm -rf vendor/leafo/lessphp/docs
	rm -rf vendor/container-interop/container-interop/docs
	rm -rf vendor/pear/archive_tar/docs

	# Delete un-used files from the matomo-icons repository
	rm -rf plugins/Morpheus/icons/src*
	rm -rf plugins/Morpheus/icons/tools*
	rm -rf plugins/Morpheus/icons/flag-icon-css*
	rm -rf plugins/Morpheus/icons/submodules*
	rm -rf plugins/Morpheus/icons/.git*
	rm -rf plugins/Morpheus/icons/.travis.yml
	rm -rf plugins/Morpheus/icons/*.py
	rm -rf plugins/Morpheus/icons/*.sh
	rm -rf plugins/Morpheus/icons/*.json
	rm -rf plugins/Morpheus/icons/*.lock
	rm -rf plugins/Morpheus/icons/*.svg
	rm -rf plugins/Morpheus/icons/*.txt
	rm -rf plugins/Morpheus/icons/*.php
	rm -rf plugins/Morpheus/icons/*.yml

	rm -rf plugins/Example*

	# Delete un-used fonts
	rm -rf vendor/tecnickcom/tcpdf/fonts/ae_fonts_2.0
	rm -rf vendor/tecnickcom/tcpdf/fonts/dejavu-fonts-ttf-2.33
	rm -rf vendor/tecnickcom/tcpdf/fonts/dejavu-fonts-ttf-2.34
	rm -rf vendor/tecnickcom/tcpdf/fonts/freefont-20100919
	rm -rf vendor/tecnickcom/tcpdf/fonts/freefont-20120503
	rm -rf vendor/tecnickcom/tcpdf/fonts/freemon*
	rm -rf vendor/tecnickcom/tcpdf/fonts/cid*
	rm -rf vendor/tecnickcom/tcpdf/fonts/courier*
	rm -rf vendor/tecnickcom/tcpdf/fonts/aefurat*
	rm -rf vendor/tecnickcom/tcpdf/fonts/dejavusansb*
	rm -rf vendor/tecnickcom/tcpdf/fonts/dejavusansi*
	rm -rf vendor/tecnickcom/tcpdf/fonts/dejavusansmono*
	rm -rf vendor/tecnickcom/tcpdf/fonts/dejavusanscondensed*
	rm -rf vendor/tecnickcom/tcpdf/fonts/dejavusansextralight*
	rm -rf vendor/tecnickcom/tcpdf/fonts/dejavuserif*
	rm -rf vendor/tecnickcom/tcpdf/fonts/freesansi*
	rm -rf vendor/tecnickcom/tcpdf/fonts/freesansb*
	rm -rf vendor/tecnickcom/tcpdf/fonts/freeserifb*
	rm -rf vendor/tecnickcom/tcpdf/fonts/freeserifi*
	rm -rf vendor/tecnickcom/tcpdf/fonts/pdf*
	rm -rf vendor/tecnickcom/tcpdf/fonts/times*
	rm -rf vendor/tecnickcom/tcpdf/fonts/uni2cid*

	rm -rf vendor/szymach/c-pchart/src/Resources/fonts/advent_light*
	rm -rf vendor/szymach/c-pchart/src/Resources/fonts/Bedizen*
	rm -rf vendor/szymach/c-pchart/src/Resources/fonts/calibri*
	rm -rf vendor/szymach/c-pchart/src/Resources/fonts/Forgotte*
	rm -rf vendor/szymach/c-pchart/src/Resources/fonts/MankSans*
	rm -rf vendor/szymach/c-pchart/src/Resources/fonts/pf_arma_five*
	rm -rf vendor/szymach/c-pchart/src/Resources/fonts/Silkscreen*
	rm -rf vendor/szymach/c-pchart/src/Resources/fonts/verdana*

	# not needed js files
	rm -rf node_modules/angular/angular.min.js.gzip
	rm -rf node_modules/angular/angular.js
	rm -rf node_modules/angular/bower.json

	rm -rf node_modules/angular-animate/angular-animate.min.js.gzip
	rm -rf node_modules/angular-animate/angular-animate.js
	rm -rf node_modules/angular-animate/bower.json

	rm -rf node_modules/angular-sanitize/angular-sanitize.min.js.gzip
	rm -rf node_modules/angular-sanitize/angular-sanitize.js
	rm -rf node_modules/angular-sanitize/bower.json

	rm -rf node_modules/angular-cookies/angular-cookies.min.js.gzip
	rm -rf node_modules/angular-cookies/angular-cookies.js
	rm -rf node_modules/angular-cookies/bower.json

	rm -rf node_modules/chroma-js/Makefile
	rm -rf node_modules/chroma-js/bower.json
	rm -rf node_modules/chroma-js/chroma.js
	rm -rf node_modules/chroma-js/doc
	rm -rf node_modules/chroma-js/readme.md
	rm -rf node_modules/chroma-js/src
	rm -rf node_modules/chroma-js/test

	rm -rf node_modules/iframe-resizer/js/iframeResizer.contentWindow.js
	rm -rf node_modules/iframe-resizer/js/iframeResizer.js
	rm -rf node_modules/iframe-resizer/src/ie8.polyfils.js
	rm -rf node_modules/iframe-resizer/src/iframeResizer.contentWindow.js
	rm -rf node_modules/iframe-resizer/src/iframeResizer.js
	rm -rf node_modules/iframe-resizer/test-main.js
	rm -rf node_modules/iframe-resizer/bower.json
	rm -rf node_modules/iframe-resizer/gruntfile.js
	rm -rf node_modules/iframe-resizer/karma-conf.js

	rm -rf node_modules/jquery/dist/jquery.js
	rm -rf node_modules/jquery/bower.json
	rm -rf node_modules/jquery/src
	rm -rf node_modules/jquery/external/sizzle/dist/sizzle.js

	rm -rf node_modules/jquery-ui-dist/component.json
	rm -rf node_modules/jquery-ui-dist/external
	rm -rf node_modules/jquery-ui-dist/images
	rm -rf node_modules/jquery-ui-dist/index.html
	rm -rf node_modules/jquery-ui-dist/jquery-ui.css
	rm -rf node_modules/jquery-ui-dist/jquery-ui.js
	rm -rf node_modules/jquery-ui-dist/jquery-ui.structure.css
	rm -rf node_modules/jquery-ui-dist/jquery-ui.theme.css

	rm -rf node_modules/jquery.browser/Gruntfile.js
	rm -rf node_modules/jquery.browser/bower.json
	rm -rf node_modules/jquery.browser/test
	rm -rf node_modules/jquery.browser/dist/jquery.browser.js

	rm -rf node_modules/jquery.dotdotdot/bower.json
	rm -rf node_modules/jquery.dotdotdot/gulpfile.js
	rm -rf node_modules/jquery.dotdotdot/index.html
	rm -rf node_modules/jquery.dotdotdot/dotdotdot.jquery.json
	rm -rf node_modules/jquery.dotdotdot/src/jquery.dotdotdot.js
	rm -rf node_modules/jquery.dotdotdot/src/jquery.dotdotdot.min.umd.js

	rm -rf node_modules/jquery.scrollto/jquery.scrollTo.js
	rm -rf node_modules/jquery.scrollto/scrollTo.jquery.json
	rm -rf node_modules/jquery.scrollto/bower.json
	rm -rf node_modules/jquery.scrollto/changes.txt
	rm -rf node_modules/jquery.scrollto/demo
	rm -rf node_modules/jquery.scrollto/tests

	rm -rf node_modules/materialize-css/Gruntfile.js
	rm -rf node_modules/materialize-css/extras
	rm -rf node_modules/materialize-css/js
	rm -rf node_modules/materialize-css/sass
	rm -rf node_modules/materialize-css/dist/js/materialize.js
	rm -rf node_modules/materialize-css/dist/css/materialize.css

	rm -rf node_modules/mousetrap/Gruntfile.js
	rm -rf node_modules/mousetrap/mousetrap.js
	rm -rf node_modules/mousetrap/tests
	rm -rf node_modules/mousetrap/plugins

	rm -rf node_modules/ng-dialog/CONTRIBUTING.md
	rm -rf node_modules/ng-dialog/Gruntfile.js
	rm -rf node_modules/ng-dialog/bower.json
	rm -rf node_modules/ng-dialog/css
	rm -rf node_modules/ng-dialog/example
	rm -rf node_modules/ng-dialog/karma.conf.js
	rm -rf node_modules/ng-dialog/protractor.conf.js
	rm -rf node_modules/ng-dialog/server.js
	rm -rf node_modules/ng-dialog/tests

	rm -rf node_modules/qrcodejs2/bower.json
	rm -rf node_modules/qrcodejs2/index-svg.html
	rm -rf node_modules/qrcodejs2/index.html
	rm -rf node_modules/qrcodejs2/index.svg
	rm -rf node_modules/qrcodejs2/jquery.min.js
	rm -rf node_modules/qrcodejs2/qrcode.js

	rm -rf node_modules/sprintf-js/CONTRIBUTORS.MD
	rm -rf node_modules/sprintf-js/README.md
	rm -rf node_modules/sprintf-js/src

	rm -rf node_modules/visibilityjs/ChangeLog.md
	rm -rf node_modules/visibilityjs/component.json
	rm -rf node_modules/visibilityjs/index.d.ts
	rm -rf node_modules/visibilityjs/index.js
	rm -rf node_modules/visibilityjs/README.md

	rm -f libs/jqplot/jqplot.core.js
	rm -f libs/jqplot/jqplot.lineRenderer.js
	rm -f libs/jqplot/jqplot.linearAxisRenderer.js
	rm -f libs/jqplot/jqplot.themeEngine.js
	rm -f libs/jqplot/plugins/jqplot.barRenderer.js
	rm -f libs/jqplot/plugins/jqplot.pieRenderer.js

	rm -f $(find config -type f -name '*.ini.php' -not -name global.ini.php)
	rm -f config/config.php

	# ------------
	# WARNING: Did you read the WARNING above?
	# ------------

	rm -rf libs/PhpDocumentor-1.3.2/
	rm -rf libs/FirePHPCore/
	rm -rf libs/open-flash-chart/php-ofc-library/ofc_upload_image.php

	rm -rf tmp/*
	rm -f misc/updateLanguageFiles.sh
	rm -f misc/others/db-schema*
	rm -f misc/others/diagram_general_request*
	rm -f .coveralls.yml .scrutinizer.yml .phpstorm.meta.php
	rm -f .lfsconfig
	rm -f HIRING.md
	rm -rf .github/

	# delete unwanted folders, recursively
	for x in .git .github ; do
		find . -name "$x" -exec rm -rf {} \; 2>/dev/null
	done

	# delete unwanted files, recursively
	for x in .gitignore .gitmodules .gitattributes .bowerrc .bower.json bower.json \
		.coveralls.yml .editorconfig .gitkeep .jshintrc .php_cs .travis.sh \
		phpunit.xml.dist phpunit.xml .phpcs.xml.dist phpcs.xml Gruntfile.js karma.conf.js \
		*.map .travis.yml installed.json package.json package-lock.json \
		composer.json composer.lock; do
		find . -name "$x" -exec rm -f {} \;
	done

	cp tests/README.md ../

	# Delete all `tests/` and `Tests/` folders
	find ./ -iname 'tests' -type d -prune -exec rm -rf {} \;
	mkdir tests
	mv ../README.md tests/

	# Remove and deactivate the TestRunner plugin in production build
	$SED -i '/Plugins\[\] = TestRunner/d' config/global.ini.php
	rm -rf plugins/TestRunner

	cp misc/How\ to\ install\ Matomo.html ..

	if [ -d "misc/package" ]
	then
		rm -rf misc/package/
	fi

	$FIND ./ -type f -printf '%s ' -exec md5sum {} \; \
		| grep -v "user/.htaccess" \
		| egrep -v 'manifest.inc.php|vendor/autoload.php|vendor/composer/autoload_real.php' \
		| $SED '1,$ s/\([0-9]*\) \([a-z0-9]*\) *\.\/\(.*\)/\t\t"\3" => array("\1", "\2"),/;' \
		| sort \
		| $SED '1 s/^/<?php\n\/\/ This file is automatically generated during the Matomo build process \
namespace Piwik;\nclass Manifest {\n\tstatic $files=array(\n/; $ s/$/\n\t);\n}/' \
		> ./config/manifest.inc.php

}

organizePackage
