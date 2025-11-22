# Docker Setup for zclaude Testing

This Docker environment allows you to test the `setup_zclaude.sh` script in a fresh Ubuntu container.

## Quick Start

### Option 1: Using Docker Compose (Recommended)

1. Build and run the container:
   ```bash
   docker-compose up --build
   ```

2. This will start an interactive bash session where you can run:
   ```bash
   ./setup_zclaude.sh
   ```

### Option 2: Using Docker directly

1. Build the Docker image:
   ```bash
   docker build -t zclaude-test .
   ```

2. Run the container interactively:
   ```bash
   docker run -it --rm -v $(pwd):/app zclaude-test
   ```

3. Inside the container, run:
   ```bash
   ./setup_zclaude.sh
   ```

## What's Included in the Container

- Ubuntu 22.04 base image
- Node.js 18.x and npm (for Claude CLI installation)
- curl, wget, git, and other basic utilities
- The setup_zclaude.sh script copied to /app
- Non-interactive environment to avoid prompts during package installation

## Testing Workflow

1. Start the container using one of the methods above
2. Run the setup script: `./setup_zclaude.sh`
3. Follow the prompts to enter your Anthropic Auth Token
4. Test the installation:
   ```bash
   # Load the new shell configuration
   source ~/.bashrc

   # Test the zclaude command
   zclaude --help

   # Check MCP servers
   claude mcp list
   ```

## Persistence

- The current directory is mounted as `/app`, so any changes to files on your host will be reflected in the container
- Shell history is preserved using a Docker volume

## Cleanup

To remove the container and volumes:
```bash
docker-compose down -v
```

Or if using Docker directly:
```bash
docker system prune -f
```

## Troubleshooting

If you encounter issues:

1. **Network connectivity**: Ensure you have internet access for downloading packages
2. **Permissions**: The script runs as root inside the container, which is fine for testing
3. **Token issues**: Make sure your Anthropic Auth Token is valid and has the necessary permissions
4. **Clean restart**: Remove the container and start fresh to test the setup from the beginning

## Notes

- This is a testing environment only
- The zclaude command will be configured to use Z.AI's API endpoints
- All MCP servers will be set up with your provided token
- The configuration is temporary and exists only within the container