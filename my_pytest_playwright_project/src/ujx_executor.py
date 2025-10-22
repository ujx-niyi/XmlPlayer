# src/ujx_executor.py
import logging
import os
from datetime import datetime
from src.safe_action import safe_action
from src.base_actions import BaseActions

class UjxStepExecutor:
    def __init__(self, driver=None, config=None):
        self.driver = driver or BaseActions()
        self.config = config or {}
        os.makedirs(self.config.get("output_dir", "data/logs"), exist_ok=True)
        log_path = os.path.join(self.config.get("output_dir", "data/logs"), "execution.log")

        logging.basicConfig(filename=log_path, format="%(asctime)s %(message)s", filemode="a")
        self.logger = logging.getLogger(__name__)
        self.logger.setLevel(logging.INFO)

    def process_step(self, test, action, data_to_enter, verb, element, outcome):
        method = getattr(self, action.lower(), None)
        if not method:
            self.logger.warning(f"⚠️ No method for action '{action}'")
            return False
        try:
            return method(test, data_to_enter, verb, element, outcome, datetime.now())
        except Exception as e:
            self.logger.error(f"❌ Error executing {action}: {e}")
            return False

    @safe_action(default=False)
    def click(self, test, data_to_enter, verb, element, outcome, start):
        self.logger.info(f"Clicking {element}")
        print(f"Clicking {element}", flush=True)
        #self.driver.click(element)
        return True

