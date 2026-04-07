<!--SETUP FORGET -->

sqlplus / as sysdba

-- Open pdb
ALTER PLUGGABLE DATABASE ORCLPDB OPEN;

-- Enter pdb
ALTER SESSION SET CONTAINER = ORCLPDB;

-- reset password
ALTER USER hr IDENTIFIED BY abc123 ACCOUNT UNLOCK;

-- Login Again
sqlplus hr/abc123@ORCLPDB