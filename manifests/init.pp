# Class: wordpress
#
# This module manages wordpress
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
import '*.pp'
class wordpress(
                $wordpress_db_name='wordpress',
                $wordpress_db_user='wordpress',
                $wordpress_db_password='password',
                $wordpress_db_server='localhost',
                $wordpress_app_directory='/opt/wordpress',
                $wordpress_app_server_name='blog.druidly.com',
                $wordpress_app_server_alias='blog'
                )
{
  $db_name = $wordpress_db_name
  $db_user = $wordpress_db_user
  $db_password = $wordpress_db_password
  $db_server = $wordpress_db_server
  $app_directory = $wordpress_app_directory
  $app_server_name = $wordpress_app_server_name
  $app_server_alias = $wordpress_app_server_alias

  include wordpress::app
  #include wordpress::db
}
