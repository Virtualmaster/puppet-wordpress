### My comments:

wordpress::db IS NOT USED (is commented in init.pp)

What to do to use with remote mysql (and bind on 0.0.0.0):

        mysql> CREATE DATABASE wordpress;
        mysql> GRANT ALL ON wordpress.* to 'wordpress_db_name'@'wordpress_db_server' identified by 'wordpress_db_password';




### Original readme by jonhadfield:

This will set up an installation of wordpress on Debian and Redhat style distributions.

Installation includes software and configuration for mysql, apache httpd and php module.

__Wordpress version: 3.5__

__Additional software__

_Themes_
* Graphene 1.8
* Suffusion 4.2.8

_Plugins_
* Wordpress importer 0.6

__Usage__

    class {
      wordpress:
      wordpress_db_name =>      "<name of database>",
      wordpress_db_user =>      "<database user>",
      wordpress_db_password =>  "<database password>"
    }
