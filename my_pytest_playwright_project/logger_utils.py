# logger_utils.py
import os
from datetime import datetime

class Logger:
    """
    Simple timestamped logger that writes to both console and file.
    Prints with flush=True and timestamps every line.
    """

    def __init__(self, log_dir: str, log_prefix: str = "run"):
        os.makedirs(log_dir, exist_ok=True)
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        self.log_path = os.path.join(log_dir, f"{log_prefix}_{timestamp}.log")
        self._log("=== Logger initialized ===")

    def _timestamp(self) -> str:
        return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    def _log(self, message: str):
        line = f"[{self._timestamp()}] {message}"
        print(line, flush=True)
        with open(self.log_path, "a", encoding="utf-8") as lf:
            lf.write(line + "\n")

    # Common levels
    def info(self, msg): self._log(f"ℹ️  {msg}")
    def success(self, msg): self._log(f"✅ {msg}")
    def warning(self, msg): self._log(f"⚠️  {msg}")
    def error(self, msg): self._log(f"❌ {msg}")
    def section(self, title): self._log(f"\n=== {title} ===")

    def path(self): return self.log_path
