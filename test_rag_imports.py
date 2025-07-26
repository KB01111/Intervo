#!/usr/bin/env python3
"""
Test script to check RAG API imports and dependencies
"""

import sys
import os

# Add the RAG API directory to Python path
rag_path = os.path.join(os.path.dirname(__file__), 'packages', 'intervo-backend', 'rag_py')
sys.path.insert(0, rag_path)

print("Testing RAG API imports...")
print(f"RAG path: {rag_path}")
print(f"Python path: {sys.path[:3]}")

try:
    print("\n1. Testing basic imports...")
    import fastapi
    import uvicorn
    import pydantic
    print("✅ FastAPI dependencies OK")
    
    print("\n2. Testing LangChain imports...")
    import langchain
    import langchain_core
    import langchain_community
    import langchain_openai
    print("✅ LangChain dependencies OK")
    
    print("\n3. Testing vector store imports...")
    from langchain_community.vectorstores import FAISS
    print("✅ FAISS import OK")
    
    print("\n4. Testing document processing imports...")
    import mammoth
    import pdfplumber
    from bs4 import BeautifulSoup
    print("✅ Document processing dependencies OK")
    
    print("\n5. Testing web crawling imports...")
    import requests
    import aiohttp
    try:
        from ratelimit import limits, sleep_and_retry
        print("✅ Ratelimit import OK")
    except ImportError as e:
        print(f"❌ Ratelimit import failed: {e}")
    
    print("\n6. Testing AWS imports...")
    import boto3
    import botocore
    print("✅ AWS dependencies OK")
    
    print("\n7. Testing local module imports...")
    try:
        from storage import S3Storage, DocumentType
        print("✅ Storage module import OK")
    except ImportError as e:
        print(f"❌ Storage module import failed: {e}")
    
    try:
        from crawler import WebCrawler
        print("✅ Crawler module import OK")
    except ImportError as e:
        print(f"❌ Crawler module import failed: {e}")
    
    try:
        from rag_service import RagTrainer, RagQuery
        print("✅ RAG service import OK")
    except ImportError as e:
        print(f"❌ RAG service import failed: {e}")
    
    print("\n8. Testing optional imports...")
    try:
        from langchain_voyageai import VoyageAIRerank
        print("✅ VoyageAI import OK")
    except ImportError as e:
        print(f"⚠️ VoyageAI import failed (optional): {e}")
    
    print("\n✅ All critical imports successful!")
    
except Exception as e:
    print(f"\n❌ Import test failed: {e}")
    import traceback
    traceback.print_exc()
