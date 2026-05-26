FROM apache/airflow:2.10.5-python3.11

USER root

RUN python -m venv /opt/airflow/finflow_venv \
    && chown -R airflow:0 /opt/airflow/finflow_venv

USER airflow

COPY requirements.txt /tmp/finflow-requirements.txt

RUN /opt/airflow/finflow_venv/bin/pip install --no-cache-dir --upgrade pip \
    && /opt/airflow/finflow_venv/bin/pip install --no-cache-dir -r /tmp/finflow-requirements.txt
