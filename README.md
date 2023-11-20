# spanner-emulator-init

You're using the spanner emulator and want to have some automated spin up of one or multiple databases? If so, this docker-compose contains your solution!

## Goal

Spanner emulator can be spinned up with multiple commands. Goal of this docker image is to automate these calls and have one single configuration for spinning up a spanner emulator instance containing as many databases with as many tables / dml-scripts as the developer wants to have.

## Configuration

A folder is mounted into the docker image. Within this folder, there can be one or multiple sub-directories. Each of them represents a dedicated database (folder-name = database-name).

Within a database-folder, `ddl`- and `dml`-folders are used for updating the database and executing the sql.

## Example usage

An example usage can be found with [docker-compose.yaml](./docker-compose.yaml). The emulator itself need to be spinned up as a separate service (`spanner-emulator`). The initializer is dependent on this service, and requires following environment arguments:

- `INIT_DIR`: directory, in which the databases are located.
- `INSTANCE_NAME`: name of the instance
- `PROJECT_ID`: id of the google project
- `SPANNER_EMULATOR_URL`: referring to the spanner-emulator-service-name

Next to the environment variables, the right directory need to be mounted into the docker image, so that the script is able to recognize databases.

### Folder-/ file-structure

Here's an example of the structure of spinning up multiple databases with different setups:

```text
init-scripts
│
├── database1
│   │
│   ├── ddl
│   │   │   table1.sql
│   │   │   table2.sql
│   │   │   ...
│   ├── dml
│   │   │   table1.sql
│   │   │   table2.sql
│   │   │   ...
├── database2
│   │
│   ├── ddl
│   │   │   table3.sql
│   │   │   table4.sql
│   │   │   ...
│   ├── dml
│   │   │   table3.sql
│   │   │   table4.sql
│   │   │   ...
└── ...
│   │
│   ├── ddl
│   │   │   ...
│   ├── dml
│   │   │   ...
```