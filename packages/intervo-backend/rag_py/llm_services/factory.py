from typing import Dict, Any, Optional
from enum import Enum

from .base import BaseLLMService
from .openai_service import OpenAIService
from .gemini_service import GeminiService
from .groq_service import GroqService
from .deepseek_service import DeepSeekService

class LLMServiceType(Enum):
    """Supported LLM service types."""
    OPENAI = "openai"
    GEMINI = "gemini"
    GROQ = "groq"
    DEEPSEEK = "deepseek"
    
class LLMServiceFactory:
    """Factory for creating LLM service instances."""
    
    _services: Dict[str, BaseLLMService] = {}
    
    @classmethod
    async def get_service(
        cls,
        service_type: str,
        config: Optional[Dict[str, Any]] = None
    ) -> BaseLLMService:
        """
        Get or create an LLM service instance.
        
        Args:
            service_type: Type of LLM service to use
            config: Optional configuration for the service
            
        Returns:
            An initialized LLM service instance
        """
        service_type = service_type.lower()
        
        # Return existing service if already initialized
        if service_type in cls._services:
            return cls._services[service_type]
            
        # Create new service instance
        service: BaseLLMService
        if service_type == LLMServiceType.OPENAI.value:
            service = OpenAIService(config)
        elif service_type == LLMServiceType.GEMINI.value:
            service = GeminiService(config)
        elif service_type == LLMServiceType.GROQ.value:
            service = GroqService(config)
        elif service_type == LLMServiceType.DEEPSEEK.value:
            service = DeepSeekService(config)
        else:
            raise ValueError(f"Unsupported LLM service type: {service_type}")
            
        # Initialize the service
        await service.initialize()
        
        # Cache the service instance
        cls._services[service_type] = service
        
        return service 