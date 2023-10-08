# Stage 1: Build the PDWA5 Rest API application using fukamachi/sbcl
FROM fukamachi/sbcl AS build

WORKDIR /app

# Install Git
RUN apt-get update && apt-get install -y git

# Clone the PDWA5 Rest API repository
RUN git clone https://github.com/felipebubu/pdwa5-rest-api.git

# Stage 2: Create a temporary image to compile the application
FROM fukamachi/sbcl AS compile

WORKDIR /app/pdwa5-rest-api

# Copy the source code
COPY --from=build /app/pdwa5-rest-api /app/pdwa5-rest-api

# Build the application (assuming the build process is inside /app/pdwa5-rest-api)
RUN sbcl --eval '(asdf:make :rest-api)'

# Stage 3: Create the final runtime image using Arch Linux
FROM archlinux

WORKDIR /app/pdwa5-rest-api

# Copy the built application from the compile stage
COPY --from=compile /app/pdwa5-rest-api/bin/rest-api /app/pdwa5-rest-api/bin/rest-api

# Copy libsqlite3.so.0.8.6 from the repository's bin folder
COPY --from=compile /app/pdwa5-rest-api/bin/libsqlite3.so.0.8.6 /app/pdwa5-rest-api/bin/libsqlite3.so.0.8.6

# Copy libcrypto.so.3 and libssl.so.3 from the repository's bin folder
COPY --from=compile /app/pdwa5-rest-api/bin/libcrypto.so.3 /app/pdwa5-rest-api/bin/libcrypto.so.3
COPY --from=compile /app/pdwa5-rest-api/bin/libssl.so.3 /app/pdwa5-rest-api/bin/libssl.so.3

# Expose port 5000
EXPOSE 5000

# Define the command to execute the application
CMD ["/app/pdwa5-rest-api/bin/rest-api"]
