### My comments:

Ready to use with foreman - application and database server separated!

DONT FORGET PARAMETRS!!!

foreman parameters for application server

        * wordpress_db_password (well as the database server)
        * wordpress_db_server (ip address or domain name of database server)

foreman parameters for database server

        * wordpress_db_password (as well as the application server)
        * wordpress_app_ip (ip address of application server)



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
