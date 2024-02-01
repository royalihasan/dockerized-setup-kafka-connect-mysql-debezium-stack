-- Create a user 'debezium' with access from any host, identified by the password 'dbz'
CREATE USER 'debezium'@'%' IDENTIFIED WITH mysql_native_password BY 'dbz';

-- Create a user 'replicator' with access from any host, identified by the password 'replpass'
CREATE USER 'replicator'@'%' IDENTIFIED BY 'replpass';

-- Grant specific privileges to 'debezium' user
GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'debezium';

-- Grant specific privileges to 'replicator' user
GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'replicator';

-- Create a database named 'demo'
CREATE DATABASE demo;

-- Grant specific privileges on the 'demo' database to 'connect_user'
GRANT SELECT, INSERT, UPDATE, DELETE ON demo.* TO connect_user;

-- Grant all privileges on the 'demo' database to 'debezium' user from any host
GRANT ALL PRIVILEGES ON demo.* TO 'debezium'@'%';
