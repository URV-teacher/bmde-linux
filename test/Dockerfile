# Use a lightweight base image
FROM aleixmt/bmde-linux:latest

# Copy entrypoint ans test materials into image container
COPY ./entrypoint.sh  /app/
COPY ./test.zip /app/

RUN apt-get install update && \
    apt-get install -y unzip

RUN unzip test.zip

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]