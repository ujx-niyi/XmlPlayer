# src/ujx_base.py
import logging

class ujxBase:
    def __init__(self, driver=None):
        self.driver = driver
        self.logger = logging.getLogger(__name__)

    def clickElement(self, element, item):
        self.logger.info(f"[PAGE] Click '{item}' on {element}")
        return True

