#!/bin/sh

git clone --branch ${GIT_BRANCH} --depth 1 http://git.drupal.org/project/drupal.git checkout

cd checkout

curl ${GIT_PATCH} | git apply -v

php --version

/usr/sbin/mysqld &
sleep 5

/etc/init.d/apache2 start

/.composer/vendor/drush/drush/drush --version

/.composer/vendor/drush/drush/drush si --db-url=mysqli://drupal:drupal@127.0.0.1/drupal --db-su=root -y

/.composer/vendor/drush/drush/drush st

/.composer/vendor/drush/drush/drush en simpletest -y

if [ "${GIT_BRANCH}" = "8.0.x" ]; then
  php ./core/scripts/run-tests.sh --url http://localhost/checkout/ ${TESTS}
else
  php ./scripts/run-tests.sh --url http://localhost/checkout/ ${TESTS}
fi 
