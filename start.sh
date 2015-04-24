#!/bin/sh

git clone --branch ${GIT_BRANCH} --depth 1 http://git.drupal.org/project/drupal.git checkout

cd checkout

curl ${GIT_PATCH} | git apply -v

php --version

echo "date.timezone = Europe/Oslo" >> /usr/local/etc/php/php.ini

/etc/init.d/mysql start
/etc/init.d/apache2 start

/.composer/vendor/drush/drush/drush --version

/.composer/vendor/drush/drush/drush si minimal --db-url=mysqli://drupal:drupal@127.0.0.1/drupal --db-su=root -y

/.composer/vendor/drush/drush/drush vset clean_url 0 -y

/.composer/vendor/drush/drush/drush st

/.composer/vendor/drush/drush/drush en simpletest -y

if [ "${GIT_BRANCH}" = "8.0.x" ]; then
  php ./core/scripts/run-tests.sh --verbose --color --url "http://localhost/checkout/index.php" --concurrency 4 --all
else
  php ./scripts/run-tests.sh --verbose --color --url "http://localhost/checkout/" --concurrency 4 --all
fi 
