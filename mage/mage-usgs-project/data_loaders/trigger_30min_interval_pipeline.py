from mage_ai.orchestration import trigger_pipeline
import logging

@data_loader
def trigger(*args, **kwargs):
    """
    Trigger another pipeline to run.

    Documentation: https://docs.mage.ai/orchestration/triggers/trigger-pipeline
    """

    max_retries = 3
    retry_count = 0

    while retry_count < max_retries:
        try:
            trigger_pipeline(
                'usgs_earthquake_data_30min_intervals',
                variables={},           # Optional: runtime variables for the pipeline
                check_status=True,      # Poll and check the status of the triggered pipeline
                error_on_failure=False, # Do not raise an exception on failure
                poll_interval=60,       # Check the status every 60 seconds
                poll_timeout=None,      # No timeout
                verbose=True            # Print status
            )
            break  # Break out of the loop if successful
        except Exception as e:
            logging.error(f"Error occurred while triggering pipeline: {e}")
            retry_count += 1
            if retry_count == max_retries:
                raise  # If max retries reached, raise the exception
            logging.info(f"Retrying trigger. Attempt {retry_count}/{max_retries}")

    logging.info("Trigger completed successfully.")
