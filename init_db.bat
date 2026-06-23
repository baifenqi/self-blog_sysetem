@echo off
cd /d "C:\Program Files\MySQL\MySQL Server 8.0\bin"
mysql -uroot blog_system < "D:\codelearng\BlogSystem\src\main\resources\db\init.sql"
echo Database initialized successfully!
pause