APP_PATH=/Applications/QQ.app/Contents/MacOS
APP_NAME=QQ
BACKUP_NAME=QQ.bak
FRAMEWORK_PATH=QQTweak.framework
FRAMEWORK_NAME=QQTweak
DYLIB_NAME=QQTweak.dylib

debug::
	DYLD_INSERT_LIBRARIES=${FRAMEWORK_PATH}/${FRAMEWORK_NAME} ${APP_PATH}/${APP_NAME} &

install::
	@if ! [[ $EUID -eq 0 ]]; then\
    	echo "This script should be run using sudo or as the root user.";\
    	exit 1;\
	fi
	@if ! [ -f "${APP_PATH}/${APP_NAME}" ]; then\
		echo "Can not find the QQ.";\
		exit 1;\
	fi
	@if ! [ -d "${FRAMEWORK_PATH}" ]; then\
		echo "Can not find the framework, please build first.";\
		exit 1;\
	fi
	@if [ -f "${APP_PATH}/${DYLIB_NAME}" ]; then\
		echo "You're using old version tweak, please uninstall first.";\
		exit 1;\
	fi
	@if [ -d "${APP_PATH}/${FRAMEWORK_PATH}" ]; then\
		rm -rf ${APP_PATH}/${FRAMEWORK_PATH};\
		cp -R ${FRAMEWORK_PATH} ${APP_PATH};\
		echo "Framework found! Replace with new framework successfully!";\
	else \
		cp ${APP_PATH}/${APP_NAME} ${APP_PATH}/${BACKUP_NAME};\
		cp -R ${FRAMEWORK_PATH} ${APP_PATH};\
		./insert_dylib @executable_path/${FRAMEWORK_PATH}/${FRAMEWORK_NAME} ${APP_PATH}/${APP_NAME} ${APP_PATH}/${APP_NAME} --all-yes;\
		echo "Install successfully!";\
	fi

uninstall::
	@if ! [[ $EUID -eq 0 ]]; then\
    	echo "This script should be run using sudo or as the root user.";\
    	exit 1;\
	fi
	@if ! [ -f "${APP_PATH}/${APP_NAME}" ]; then\
		echo "Can not find the QQ.";\
		exit 1;\
	fi
	@if ! [ -f "${APP_PATH}/${BACKUP_NAME}" ]; then\
		echo "Can not find the QQ backup file.";\
		exit 1;\
	fi

	@rm -rf ${APP_PATH}/${DYLIB_NAME};
	@rm -rf ${APP_PATH}/${FRAMEWORK_PATH};
	@mv ${APP_PATH}/${BACKUP_NAME} ${APP_PATH}/${APP_NAME};
	@echo "Uninstall successfully";

clean::
	rm -rf ${FRAMEWORK_PATH}
