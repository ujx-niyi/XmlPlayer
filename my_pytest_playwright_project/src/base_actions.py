# src/base_actions.py
import logging
from pathlib import Path

class BaseActions:
    def __init__(self, driver=None, logger=None):
        self.driver = driver or MockDriver()
        self.logger = logger or logging.getLogger(__name__)

    def click(self, element):
        self.logger.info(f"[MOCK] Click on element: {element}")


class MockDriver:
    """A dummy driver simulating Playwright or Selenium."""
    def click(self, element):
        print(f"[MockDriver] Click: {element}")

