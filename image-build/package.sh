#! /bin/sh
FILE_NAME=git-repo.txt

TMP_DIR=/app/tmp
APP_DIR=/app
MODULE_DIR=devh-module
AUTH_DIR=auth-service
API_MODULE=api-module
API_MODULE_VERSION=v1
EXCEPTION_MODULE=exception-module
EXCEPTION_MODULE_VERSION=v1
LIBS_SUFFIX=build/libs/

function reset_src_dir() 
{
        echo "Reset source code directories..."
        rm -rf $TMP_DIR/$MODULE_DIR
        rm -rf $TMP_DIR/$AUTH_DIR
}

function git_clone() 
{
        cd $TMP_DIR
        echo "Clone source code from git repository..."
        while IFS= read -r line;
        do
                $line
        done < $FILE_NAME
        cd $APP_DIR
}

function change_db_network()
{
        sed 's/localhost/'$DB_NETWORK'/g' \
        $TMP_DIR/$AUTH_DIR/src/main/resources/application.yml >> $TMP_DIR/$AUTH_DIR/src/main/resources/application.yml_tmp \
        && mv $TMP_DIR/$AUTH_DIR/src/main/resources/application.yml_tmp $TMP_DIR/$AUTH_DIR/src/main/resources/application.yml
}

function gradle_build()
{
        echo "Start gradle build..."
        gradle --exclude-task test --project-dir $TMP_DIR/$MODULE_DIR/$API_MODULE build
        gradle --exclude-task test --project-dir $TMP_DIR/$MODULE_DIR/$EXCEPTION_MODULE build
        gradle --exclude-task test --project-dir $TMP_DIR/$AUTH_DIR build
}

function copy_jar()
{
        cp -f $TMP_DIR/$AUTH_DIR/build/libs/$AUTH_DIR-v1.jar $APP_DIR
}

function rm_tmp()
{
        rm -rf $TMP_DIR
}

reset_src_dir
git_clone
change_db_network
gradle_build
copy_jar
rm_tmp