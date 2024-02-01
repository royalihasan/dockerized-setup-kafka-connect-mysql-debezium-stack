# Dockerized Setup for Kafka Connect with MySQL and Debezium Stack

## Overview

This project provides a Dockerized environment for setting up a Kafka Connect stack with MySQL and Debezium. The
configuration is orchestrated using Docker Compose, allowing for easy deployment and scalability.

### Prerequisites

Make sure you have Docker and Docker Compose installed on your machine.

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

### Clone the Repository

```bash
git clone https://github.com/royalihasan/dockerized-setup-kafka-connect-mysql-debezium-stack.git
cd dockerized-setup-kafka-connect-mysql-debezium-stack
```

## Technology Stack

### 1. Redpanda

- **Description:** Redpanda is a Kafka-compatible event streaming platform.
- **Image:** [docker.redpanda.com/redpandadata/redpanda:latest](https://hub.docker.com/r/redpandadata/redpanda)
- **Configuration:**
    - Listens on ports `9092` and `29092`.
    - Overprovisioning, CPU affinity, and memory allocation settings.

### 2. Redpanda Console

- **Description:** Redpanda Console is a web-based tool for managing and monitoring Redpanda deployments.
- **Image:** [docker.redpanda.com/redpandadata/console:latest](https://hub.docker.com/r/redpandadata/console)
- **Configuration:**
    - Depends on the `redpanda` service.
    - Exposes port `8080`.

### 3. Debezium Connect

- **Description:** Debezium Connect captures changes from MySQL and publishes them to Kafka.
- **Image:** [debezium/connect:latest](https://hub.docker.com/r/debezium/connect)
- **Configuration:**
    - Depends on the `redpanda` service.
    - Exposes port `8083`.
    - Bootstrap servers, group ID, storage topics, and converters configuration.

### 4. Debezium UI

- **Description:** Debezium UI is a web-based interface for monitoring Debezium connectors.
- **Image:** [debezium/debezium-ui](https://hub.docker.com/r/debezium/debezium-ui)
- **Configuration:**
    - Depends on the `connect` service.
    - Exposes port `9090`.
    - Configured to connect to Debezium Connect at `http://connect:8083/`.

### 5. MySQL

- **Description:** MySQL database serving as a source for Debezium Connect.
- **Image:** [mysql:latest](https://hub.docker.com/_/mysql)
- **Configuration:**
    - Exposes port `3306`.
    - Sets up root password and user credentials.

### 6. PostgreSQL

- **Description:** PostgreSQL database (optional) serving as an alternative source for Debezium Connect.
- **Image:** [postgres:latest](https://hub.docker.com/_/postgres)
- **Configuration:**
    - Exposes port `5432`.
    - Sets up user credentials.

These instructions will help you get the project up and running on your local machine for development and testing
purposes.

---

## Prepare a MYSQL Database For CDC By Enabling `Binlog` in DB

**Step:1 Create a new User and Set `PRIVILEGES`**

_Firstly, Login into your `MYSQL` Database_

```shell
docker exec -it mysql bash -c 'mysql -u root -p$MYSQL_ROOT_PASSWORD'
```

_And paste the Query Which is Down mentioned_

```mysql
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
```

**Step2: Create a `CUSTOMER` table in `demo` Database**

```mysql
use demo;
create table CUSTOMERS
(
    id          INT PRIMARY KEY,
    first_name  VARCHAR(50),
    last_name   VARCHAR(50),
    email       VARCHAR(50),
    gender      VARCHAR(50),
    club_status VARCHAR(8),
    comments    VARCHAR(90),
    create_ts   timestamp DEFAULT CURRENT_TIMESTAMP,
    update_ts   timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

**Step3: Populate Data into the `CUSTOMERS` Table**

```mysql
insert into CUSTOMERS (id, first_name, last_name, email, gender, club_status, comments)
values (1, 'Rica', 'Blaisdell', 'rblaisdell0@rambler.ru', 'Female', 'bronze', 'Universal optimal hierarchy');
insert into CUSTOMERS (id, first_name, last_name, email, gender, club_status, comments)
values (2, 'Ruthie', 'Brockherst', 'rbrockherst1@ow.ly', 'Female', 'platinum', 'Reverse-engineered tangible interface');
insert into CUSTOMERS (id, first_name, last_name, email, gender, club_status, comments)
values (3, 'Mariejeanne', 'Cocci', 'mcocci2@techcrunch.com', 'Female', 'bronze',
        'Multi-tiered bandwidth-monitored capability');
insert into CUSTOMERS (id, first_name, last_name, email, gender, club_status, comments)
values (4, 'Hashim', 'Rumke', 'hrumke3@sohu.com', 'Male', 'platinum', 'Self-enabling 24/7 firmware');
insert into CUSTOMERS (id, first_name, last_name, email, gender, club_status, comments)
values (5, 'Hansiain', 'Coda', 'hcoda4@senate.gov', 'Male', 'platinum', 'Centralized full-range approach');
```

> Now Your Database is Ready!

---
