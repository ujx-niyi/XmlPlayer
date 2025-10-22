import json
from pathlib import Path
import lxml.etree as ET
import pytest

# ──────────────────────────────────────────────
#  1️⃣  Load global config early
# ──────────────────────────────────────────────
try:
    from src import config as app_config
except Exception as e:
    app_config = None
    print(f"[WARN] Could not import src.config: {e}")

# ──────────────────────────────────────────────
#  2️⃣  Fixture: provide config to tests
# ──────────────────────────────────────────────
@pytest.fixture(scope="session")
def config():
    """Return application config (from src.config or dummy fallback)."""
    if app_config:
        return app_config
    else:
        class DummyConfig:
            app_id = "UJX"
        return DummyConfig()

# ──────────────────────────────────────────────
#  3️⃣  Parametrize tests from latest.json + XML
# ──────────────────────────────────────────────
def pytest_generate_tests(metafunc):
    import os
    from pathlib import Path
    import json
    import lxml.etree as ET

    # Determine which pointer file to use
    role_key = os.getenv("ROLE_KEY") or "UJX_PUBLIC_USER"  # fallback default
    pointer_pattern = f"latest_{role_key}.json"
    pointer_file = Path("data/output") / pointer_pattern

    if not pointer_file.exists():
        pytest.skip(f"Pointer file '{pointer_pattern}' not found. Run the converter for {role_key} first.")

    # Load the pointer file
    with open(pointer_file, "r", encoding="utf-8") as f:
        meta = json.load(f)

    output_dir = meta.get("current_output")
    if not output_dir:
        pytest.skip(f"Invalid {pointer_pattern}: missing 'current_output' field.")

    xml_path = Path("data/output") / output_dir / "test_cases.xml"
    if not xml_path.exists():
        pytest.skip(f"Missing expected XML: {xml_path}")

    # Parse XML tests
    tree = ET.parse(str(xml_path))
    root = tree.getroot()
    tests = root.findall(".//test")

    # Inject config.app_id fallback
    from src import config as app_config
    app_id = getattr(app_config, "app_id", role_key)
    for t in tests:
        if not t.get("application"):
            t.set("application", app_id)

    metafunc.parametrize("testcase", tests)

# ──────────────────────────────────────────────
#  4️⃣  Playwright Page fixture
# ──────────────────────────────────────────────
@pytest.fixture
def page(playwright):
    """Provide a fresh Playwright page."""
    browser = playwright.chromium.launch(headless=True)
    context = browser.new_context()
    page = context.new_page()
    yield page
    context.close()
    browser.close()
