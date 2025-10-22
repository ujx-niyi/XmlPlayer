# src/config.py
import json
import os
from pathlib import Path
import yaml

# Default fallbacks
app_id = "UJX"
project = "PUBLIC"
role = "USER"
section_key = None
excel_source = None
output_dir = "data/output"

def _load_latest_context():
    """Try to detect the latest converter run and infer the context."""
    global app_id, project, role, section_key, excel_source, output_dir

    latest_pointer = Path("data/output/latest.json")
    if not latest_pointer.exists():
        print("[config] ⚠️ No latest.json found — using defaults.")
        return

    try:
        with open(latest_pointer, "r", encoding="utf-8") as f:
            meta = json.load(f)

        current_output = meta.get("current_output")
        if not current_output:
            print("[config] ⚠️ Missing 'current_output' in latest.json.")
            return

        output_dir = str(Path("data/output") / current_output)

        # Infer section key from the output folder name (e.g. UJX_PUBLIC_USER_20251021_121200)
        parts = current_output.split("_")
        if len(parts) >= 3:
            app_id, project, role = parts[:3]
            section_key = f"{app_id}_{project}_{role}"
        else:
            section_key = "UNKNOWN_SECTION"

        # Load YAML for extra context (e.g., Excel source)
        yaml_path = Path("config.yml")
        if yaml_path.exists():
            with open(yaml_path, "r", encoding="utf-8") as f:
                cfg = yaml.safe_load(f)
            if section_key in cfg:
                excel_source = cfg[section_key].get("excel_source")
        else:
            print("[config] ⚠️ config.yml not found.")

    except Exception as e:
        print(f"[config] ⚠️ Failed to load runtime context: {e}")


# Initialize on import
_load_latest_context()
