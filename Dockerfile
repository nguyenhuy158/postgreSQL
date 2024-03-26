FROM docker/whalesay:latest
LABEL Name=postgresql Version=0.0.1
RUN apt-get -y update && apt-get install -y fortunes
CMD ["sh", "-c", "/usr/games/fortune -a | cowsay"]

# Install PostgreSQL
RUN apt-get -y install postgresql
RUN apt-get -y install mysql

# Switch to postgres user
USER postgres

# Define environment variables for username, password, and database
# ENV POSTGRES_USER=docker
# ENV POSTGRES_PASSWORD=docker
# ENV POSTGRES_DB=docker

# Start PostgreSQL, create user, and create database
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER ${POSTGRES_USER} WITH SUPERUSER PASSWORD '${POSTGRES_PASSWORD}';" &&\
    createdb -O ${POSTGRES_USER} ${POSTGRES_DB}

# Add VOLUMEs to allow backup of config, logs, and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Set the default command to run when starting the container
CMD ["/usr/lib/postgresql/9.3/bin/postgres", "-D", "/var/lib/postgresql/9.3/main", "-c", "config_file=/etc/postgresql/9.3/main/postgresql.conf"]

# Expose the PostgreSQL port
EXPOSE 5432
