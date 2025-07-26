#!/usr/bin/env python3
"""
Startup script for RAG API with error handling and dependency checking
"""

import sys
import os
import logging
import traceback

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

def check_dependencies():
    """Check if all required dependencies are available"""
    logger.info("Checking dependencies...")
    
    missing_deps = []
    
    # Check core dependencies
    try:
        import fastapi
        import uvicorn
        import pydantic
        logger.info("✅ FastAPI dependencies OK")
    except ImportError as e:
        missing_deps.append(f"FastAPI: {e}")
    
    try:
        import langchain
        import langchain_core
        import langchain_community
        import langchain_openai
        logger.info("✅ LangChain dependencies OK")
    except ImportError as e:
        missing_deps.append(f"LangChain: {e}")
    
    try:
        from langchain_community.vectorstores import FAISS
        logger.info("✅ FAISS import OK")
    except ImportError as e:
        missing_deps.append(f"FAISS: {e}")
    
    try:
        import boto3
        import botocore
        logger.info("✅ AWS dependencies OK")
    except ImportError as e:
        missing_deps.append(f"AWS: {e}")
    
    try:
        from ratelimit import limits, sleep_and_retry
        logger.info("✅ Ratelimit dependency OK")
    except ImportError as e:
        missing_deps.append(f"Ratelimit: {e}")
    
    if missing_deps:
        logger.error("Missing dependencies:")
        for dep in missing_deps:
            logger.error(f"  - {dep}")
        return False
    
    logger.info("✅ All dependencies available")
    return True

def setup_paths():
    """Setup Python paths for local imports"""
    current_dir = os.path.dirname(os.path.abspath(__file__))
    parent_dir = os.path.dirname(current_dir)
    
    # Add current directory for local imports
    if current_dir not in sys.path:
        sys.path.insert(0, current_dir)
    
    # Add parent directory for backend imports
    if parent_dir not in sys.path:
        sys.path.insert(0, parent_dir)
    
    logger.info(f"Python path configured: {current_dir}")

def check_local_modules():
    """Check if local modules can be imported"""
    logger.info("Checking local modules...")
    
    try:
        from storage import S3Storage, DocumentType
        logger.info("✅ Storage module OK")
    except ImportError as e:
        logger.error(f"❌ Storage module failed: {e}")
        return False
    
    try:
        from crawler import WebCrawler
        logger.info("✅ Crawler module OK")
    except ImportError as e:
        logger.error(f"❌ Crawler module failed: {e}")
        return False
    
    try:
        from rag_service import RagTrainer, RagQuery
        logger.info("✅ RAG service module OK")
    except ImportError as e:
        logger.error(f"❌ RAG service module failed: {e}")
        return False
    
    return True

def main():
    """Main startup function"""
    logger.info("🚀 Starting RAG API...")
    
    # Setup paths
    setup_paths()
    
    # Check dependencies
    if not check_dependencies():
        logger.error("❌ Dependency check failed")
        sys.exit(1)
    
    # Check local modules
    if not check_local_modules():
        logger.error("❌ Local module check failed")
        sys.exit(1)
    
    # Import and start the API
    try:
        logger.info("Starting FastAPI application...")
        from api import app
        import uvicorn
        
        # Start the server
        uvicorn.run(
            app,
            host="0.0.0.0",
            port=4003,
            log_level="info",
            access_log=True
        )
        
    except Exception as e:
        logger.error(f"❌ Failed to start API: {e}")
        traceback.print_exc()
        sys.exit(1)

if __name__ == "__main__":
    main()
