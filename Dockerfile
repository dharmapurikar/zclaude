# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Update package lists and install basic dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gnupg \
    ca-certificates \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and npm (for Claude CLI installation)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Verify installations
RUN node --version && npm --version

# Create a working directory
WORKDIR /app

# Copy the setup script into the container
COPY setup_zclaude.sh /app/setup_zclaude.sh

# Make the setup script executable
RUN chmod +x /app/setup_zclaude.sh

# Set up a default shell (bash)
SHELL ["/bin/bash", "-c"]

# Add message for users in a location that won't be overwritten
RUN echo "=========================================" > /etc/motd && \
    echo "Z.AI Claude Test Environment" >> /etc/motd && \
    echo "=========================================" >> /etc/motd && \
    echo "To run the setup script:" >> /etc/motd && \
    echo "  ./setup_zclaude.sh" >> /etc/motd && \
    echo "" >> /etc/motd && \
    echo "After setup, you can use:" >> /etc/motd && \
    echo "  zclaude --help" >> /etc/motd && \
    echo "=========================================" >> /etc/motd

# Display the message when container starts
CMD ["/bin/bash", "-c", "cat /etc/motd && echo '' && echo 'Setup script available at: /app/setup_zclaude.sh' && echo '' && exec /bin/bash"]