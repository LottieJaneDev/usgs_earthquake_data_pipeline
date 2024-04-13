from mage_ai.orchestration.triggers.api import trigger_pipeline
if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter


@data_exporter
def trigger(*args, **kwargs):
    """
    Trigger's the DBT pipeline to run

    Documentation: https://docs.mage.ai/orchestration/triggers/trigger-pipeline
    """

    trigger_pipeline(
        'dbt_pipeline',        # Required: enter the UUID of the pipeline to trigger
        variables={},           # Optional: runtime variables for the pipeline
        check_status=False,     # Optional: poll and check the status of the triggered pipeline
        error_on_failure=False, # Optional: if triggered pipeline fails, raise an exception
        poll_interval=60,       # Optional: check the status of triggered pipeline every N seconds
        poll_timeout=None,      # Optional: raise an exception after N seconds
        verbose=True,           # Optional: print status of triggered pipeline run
    )
