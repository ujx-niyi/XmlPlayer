# src/factory.py
from src.ujx_executor import UjxStepExecutor

def get_step_executor(application_id, driver=None, config=None):
    """Factory returning appropriate executor based on application ID."""
    app = (application_id or "UJX").upper()
    # Add conditional mapping later for real apps
    return UjxStepExecutor(driver, config)
