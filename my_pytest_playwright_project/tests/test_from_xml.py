import pytest
import allure
from src.factory import get_step_executor

# ──────────────────────────────────────────────
#  XML-driven Test Execution
# ──────────────────────────────────────────────
@pytest.mark.usefixtures("page")
def test_from_xml(testcase, page, config):
    """
    Executes test cases defined in XML (via data/output/latest.json).
    Each <test> element may contain multiple <step> elements with
    attributes like action, input, verb, element, outcome, automated, etc.
    """

    # Extract basic attributes from XML node
    test_name = testcase.get("name", "Unnamed")
    app_id = testcase.get("application", getattr(config, "app_id", "UJX"))

    # Register title in Allure
    allure.dynamic.title(f"{app_id}: {test_name}")

    # Instantiate appropriate StepExecutor for this app
    driver = page  # Playwright Page acts as our driver
    executor = get_step_executor(app_id, driver, {"output_dir": "data/output"})

    # Collect <step> elements
    steps = testcase.findall(".//step")
    if not steps:
        pytest.skip(f"No steps defined for {test_name}")

    # ──────────────────────────────────────────────
    #  Step-by-step execution
    # ──────────────────────────────────────────────
    for step in steps:
        action = step.get("action", "").strip()
        data_to_enter = step.get("input", "").strip()
        verb = step.get("verb", "").strip()
        element = step.get("element", "").strip()
        outcome = step.get("outcome", "").strip()

        step_desc = " ".join(filter(None, [action, verb, element, data_to_enter]))

        with allure.step(step_desc or "Unnamed step"):
            result = executor.process_step(
                test_name,
                action,
                data_to_enter,
                verb,
                element,
                outcome,
            )
            # If result is explicitly False, fail the test
            assert result is not False, f"Step failed: {step_desc}"
