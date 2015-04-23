# Drupal core testbot

If you experience that your tests passes locally but Drupal Testbot returns "Failed" it is, most likely, because of differences in LAMP stack configuration.

## Docker to the rescue

You can use Docker to recreate Testbot on your local host (if you are using Linux) or run it on remote server.

## How to run?

````
docker run -ti -e GIT_BRANCH=8.0.x -e GIT_PATCH=http://drupal.org... zaporylie/docker
````

## Credits
zaporylie <jakub@piaseccy.pl>
