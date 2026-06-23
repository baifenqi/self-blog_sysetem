USE mysql;
UPDATE user SET authentication_string='' WHERE user='root' AND host='localhost';
FLUSH PRIVILEGES;