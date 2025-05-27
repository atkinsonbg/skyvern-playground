# Skyvern/Ollama Playground
This repository demonstrates the integration of Skyvern, an AI-powered web automation platform, with Ollama for local LLM inference. The setup uses Docker Compose to orchestrate several services:

- **Skyvern**: The main automation engine that can navigate websites and perform tasks
- **Ollama**: A local LLM server running TinyLlama for AI-powered decision making
- **PostgreSQL**: Database for storing workflow states and configurations
- **Skyvern UI**: Web interface for managing and monitoring automation workflows

The configuration is optimized for CPU-only operation with reduced resource usage and disabled CSS parsing for better performance. This setup is ideal for testing and development of web automation workflows using local LLM capabilities.

## How To Run
This Compose Stack requires a little care and feeding to get started:
1. Perform a `make start` to start the stack. If this is the first time running the stack, you need to give the Ollama container time to download the model before running any queries in Skyern.
2. Once the Postgres container is ready to accept connections and **after** the Skyvern container is ready (this creates all the DB tables), you need to run the `init-db.sh`. This will populate the DB with an organization and API key for use when running tasks from the UI.

## Docker Compose Settings

### Dozzle Container
- **Purpose**: Real-time log viewer for all containers
- **Ports**: 8888:8080 (Web interface)
- **Volumes**: Mounts Docker socket for container access

### Ollama Container
- **Purpose**: Local LLM server running TinyLlama
- **Ports**: 11434:11434 (API endpoint)
- **Environment Variables**:
  - `OLLAMA_HOST=0.0.0.0`: Allows external connections
  - `OLLAMA_ORIGINS=*`: Allows CORS from any origin
  - `OLLAMA_TIMEOUT=900s`: Maximum time for model inference (15 minutes)
  - `OLLAMA_KEEP_ALIVE=15m`: Connection keep-alive duration
  - `OLLAMA_NUM_THREAD=2`: Number of CPU threads for inference
  - `OLLAMA_CONTEXT_LENGTH=2048`: Maximum context window size
  - `OLLAMA_BATCH_SIZE=256`: Batch size for processing
  - `OLLAMA_DEBUG=1`: Enables verbose logging
  - `OLLAMA_GPU_LAYERS=0`: Forces CPU-only operation
- **Resource Limits**: 6GB memory limit
- **Volumes**: Persistent storage for model files

### PostgreSQL Container
- **Purpose**: Database for Skyvern state and configuration
- **Ports**: 5432:5432 (Database access)
- **Environment Variables**:
  - `PGDATA=/var/lib/postgresql/data/pgdata`: Data directory
  - `POSTGRES_USER=skyvern`: Database username
  - `POSTGRES_PASSWORD=skyvern`: Database password
  - `POSTGRES_DB=skyvern`: Database name
- **Healthcheck**: Verifies database readiness
- **Volumes**: Persistent storage for database files

### Skyvern Container
- **Purpose**: Main automation engine
- **Ports**: 
  - 8000:8000 (API endpoint)
  - 9222:9222 (Browser debugging)
- **Volumes**: 
  - `./.artifacts`: Task artifacts
  - `./.videos`: Recordings
  - `./.har`: Network logs
  - `./.log`: Application logs
  - `./.streamlit`: UI configuration
- **Environment Variables**:
  - `DATABASE_STRING`: PostgreSQL connection string
  - `BROWSER_TYPE=chromium-headful`: Browser for automation
  - `ENABLE_CODE_BLOCK=true`: Enables code block support
  - `API_HOST=0.0.0.0`: Allows external connections
  - `API_PORT=8000`: API port
  - `LOG_LEVEL=debug`: Verbose logging
  - `ENABLE_CSS_SHAPE_CONVERT=false`: Disables CSS parsing
  - `LLM_KEY=OLLAMA`: Uses Ollama for LLM
  - `ENABLE_OLLAMA=true`: Enables Ollama integration
  - `OLLAMA_MODEL=tinyllama`: LLM model to use
  - `OLLAMA_SERVER_URL`: Ollama server address
  - `OLLAMA_FORMAT=json`: Forces JSON responses
  - `OLLAMA_TEMPERATURE=0.1`: Low randomness in responses

### Skyvern UI Container
- **Purpose**: Web interface for Skyvern
- **Ports**: 
  - 8080:8080 (Main UI)
  - 9090:9090 (Additional services)
- **Volumes**: Same as Skyvern container
- **Environment Variables**:
  - `VITE_ENABLE_CODE_BLOCK=true`: Enables code block support
  - `VITE_WSS_BASE_URL`: WebSocket connection
  - `VITE_API_BASE_URL`: API endpoint
  - `VITE_SKYVERN_API_KEY`: Authentication token

## Test Commands
```
Navigate to https://www.caresource.com/about-us/caresource-board-of-directors/.

Once on the Board of Directors page:
- Validate that there are exactly 10 board members listed on the page.
- Confirm that "Linda Willett" is one of the listed members.

Report the results of both validations, including any errors if the count is incorrect or if Linda Willett is not found.
```

```
Navigate to https://finder.porsche.com/us/en-US/search/911?model=911

Once on this page, you will be presented with a modal dialog asking for a Zip code, enter "23236", and select the first result in the drop down that appears.

Click the button to Show the results.

On the following page, ensure that:
- All the cars displayed are model 911
- There is at least one car shown on the page

Report the results of both validations.
```