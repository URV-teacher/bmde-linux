# Use a lightweight base image
FROM debian:latest

# Set environment variables for devkitPro
ENV DEVKITPRO=/bmde/devkitPro
ENV DEVKITARM=$DEVKITPRO/devkitARM
ENV PATH=$DEVKITARM/bin:$PATH

# Install required dependencies
RUN apt-get update && apt-get install -y \
    make \
    wget \
    bzip2

# Create directories for devkitPro
RUN mkdir -p $DEVKITPRO $DEVKITARM

# Install devkitARM directory
RUN wget https://wii.leseratte10.de/devkitPro/devkitARM/r46%20%282017%29/devkitARM_r46-x86_64-linux.tar.bz2 \
    && tar -xvjf devkitARM_r46-x86_64-linux.tar.bz2 -C /bmde/devkitPro/ \
    && rm devkitARM_r46-x86_64-linux.tar.bz2

# Copy and extract libnds.tar.bz2
COPY data/libnds.tar.bz2 /bmde/devkitPro/
RUN tar -xvjf /bmde/devkitPro/libnds.tar.bz2 -C /bmde/devkitPro/ \
    && rm /bmde/devkitPro/libnds.tar.bz2

# Remove used packages to make it lighter
RUN apt-get purge -y wget bzip2 \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Create directory for mount volumes
RUN mkdir -p /input /output

# Create directory for workspace directory
RUN mkdir -p /workspace

# Copy entrypoint script into container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]