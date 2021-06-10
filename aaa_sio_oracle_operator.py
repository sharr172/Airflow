from datetime import datetime,timedelta

import airflow
from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.operators.bash_operator import BashOperator
from airflow.operators.oracle_operator import OracleOperator

default_args = {
        'owner': 'Airflow',
        'depends_on_past': False,
        'email': ['airflow@example.com'],
        'email_on_failure': False,
        'email_on_retry': False,
        'retries': 0,
        'retry_delay': timedelta(minutes=5)
        }

with DAG(
    dag_id='aaa_sio_oracle_operator',
    default_args=default_args,
    schedule_interval='0 0 * * *',
    start_date=days_ago(2),
    dagrun_timeout=timedelta(minutes=10),
     ) as dag:

    opr_sql = OracleOperator(
         task_id='task_sql',
         oracle_conn_id='Production',
         sql= 'insert into table1 (a,b,c) values (1,2,3)',
         autocommit ='True')
