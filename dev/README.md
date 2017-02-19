# Services for Centro Direct via Docker

Centro Direct relies on several external services to work correctly, these include:

* Postgres
* Elasticsearch
* Logstash
* Kibana
* Redis
* RabbitMQ
* InfluxDB (not in general use yet)
* Grafana (not in general use yet)

Historically developers have simply installed and run these on their development
machines, which works fine, but is individualized in its setup and maintenance.

This repo is an effort to utilize Docker to create a single, repeatable setup
for these components so that developers have easy access to consistently
configured instances of all of the services that Centro Direct uses.

# Starting and stopping #

## Quick Start ##

* Make sure none of these services are running "locally" on your mac, there will
  port conflicts if they are

* Install Docker (see README.md one level up from here)

* Start up services

        cd docker/dev
        docker-compose up -d

* Configure Centro Direct to use the services
  * Environment Settings

            # These are good to put in a .autoenv.zsh or .zshrc
            export PGUSER=postgres

  * ~/.pgpass file

            localhost:5432:*:postgres:password

  * Configuration Overrides (`configs/development-override.rb` and `configs/test-override.rb`)

            elasticsearch.host = 'localhost'
            message_queue.connection_string = "amqp://guest:guest@localhost:5672"
            hallmonitor.enabled = true
            influxdb.database = 'centro_direct'
            influxdb.host = 'localhost'

## Starting the services ##

You can now run `docker-compose up -d` inside this directory to start the services.

You can verify that they're up by running `docker-compose ps`

## Stopping the services ##

Run `docker-compose stop` from inside this directory

## Completely "resetting" a service to a pristine state

Docker-compose will reuse existing containers between starts and stop if the
configuration for those containers hasn't changed.  But sometimes things
get screwed up over time.  Luckily it's pretty easy to completely "reset"
to pristine condition.

For any service you want to completely reset to pristine simply do a
`docker-compose stop service && docker-compose rm service` followed by
`docker-compose up -d` to restart everything needed.

# Configuring Centro Direct #

Centro Direct relies on configuration settings to know the connection
information for all of these services.  You can override/set these on
your development systems by specifying values in
`configs/development-overrides.rb` and
`configs/test-overrides.rb` (for development and test Rails environments)

## Sample `development-overrides.rb` file ##

    elasticsearch.host = 'localhost'
    message_queue.connection_string = "amqp://guest:guest@localhost:5672"
    hallmonitor.enabled = true
    influxdb.database = 'centro_direct'
    influxdb.host = 'localhost'

## Sample 'test-overrides.rb` file ##

    # Test settings
    elasticsearch.host = 'localhost'
    logging.logstash_enabled = true
    logging.logstash_host = 'localhost'
    logging.logstash_port = 9999
    message_queue.connection_string = "amqp://guest:guest@localhost:5672"

# Accessing the services
## Kibana
Kibana is a tool to search and see logs produced by our system.  After getting
it set up in docker you can access it at [http://localhost:5601](http://localhost:5601).

## Grafana
Grafana is a graphing front end for our metrics data in InfluxDB.  All of our
latency and counts are there for all rails controller actions as well as a lot
of custom metrics.  You can now access it at [http://localhost:3001](http://localhost:3001)

## Other services
Other services started by Docker Compose are listed in the `docker-compose.yml`
file located in this directory.  Most services have relevant ports mapped to
the same ports on `localhost`
