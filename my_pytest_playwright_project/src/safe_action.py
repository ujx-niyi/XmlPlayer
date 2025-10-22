# src/safe_action.py
import functools
import logging

def safe_action(default=None):
    """Decorator to make step actions resilient to exceptions."""
    def decorator(func):
        @functools.wraps(func)
        def wrapper(self, *args, **kwargs):
            try:
                result = func(self, *args, **kwargs)
                self.logger.info(f"✅ {func.__name__} succeeded")
                return result if result is not None else True
            except Exception as e:
                self.logger.error(f"❌ Exception in {func.__name__}: {e}", exc_info=True)
                return default
        return wrapper
    return decorator
