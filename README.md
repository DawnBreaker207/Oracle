<!--SETUP FORGET -->

```sh
sqlplus / as sysdba
```

-- Open pdb

```sql
ALTER PLUGGABLE DATABASE ORCLPDB OPEN;
```

-- Enter pdb

```sql
ALTER SESSION SET CONTAINER = ORCLPDB;
```

-- reset password

```sql
ALTER USER hr IDENTIFIED BY abc123 ACCOUNT UNLOCK;
```

-- Login Again

```sql
sqlplus hr/abc123@ORCLPDB
```

-- Change user if login with admin

```sql
ALTER SESSION SET CURRENT_SCHEMA = admin
```

-- Run SQL form Github

```sql
@https://raw.githubusercontent.com/DawnBreaker207/Oracle/main/setup.sql
```
