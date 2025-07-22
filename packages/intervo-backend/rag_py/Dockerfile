# RAG API Dockerfile for production
FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY packages/intervo-backend/rag_py/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire RAG API directory structure
COPY packages/intervo-backend/rag_py/ ./

# Create non-root user
RUN adduser --disabled-password --gecos '' ragapi
RUN chown -R ragapi:ragapi /app
USER ragapi

EXPOSE 4003

CMD ["python", "start_api.py"]
