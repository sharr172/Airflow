from apache/airflow:2.1.0

###install oracle client#


USER root

RUN sudo mkdir -p /opt/oracle/instantclient_12_1/network/admin \
   && sudo mkdir -p /usr/local/airflow \
   && sudo ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime \
   && sudo apt-get update && apt-get install -y apt-utils build-essential unzip python-dev libaio-dev

#### Download the oracle client basic and sdk from oracle site
#ADD https://download.oracle.com/otn_software/linux/instantclient/211000/oracle-instantclient-basic-21.1.0.0.0-1.x86_64.rpm /opt/oracle/
#ADD https://download.oracle.com/otn_software/linux/instantclient/211000/oracle-instantclient-devel-21.1.0.0.0-1.x86_64.rpmi /opt/oacle/
#ADD https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html#license-lightbox  /opt/oracle/
#ADD oracle/instantclient-basic-linux.x64-12.1.0.2.0.zip /opt/oracle/
#ADD oracle/instantclient-sdk-linux.x64-12.1.0.2.0.zip /opt/oracle/


ADD https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-basic-linux.x64-21.1.0.0.0.zip /opt/oracle/
ADD https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-sdk-linux.x64-21.1.0.0.0.zip /opt/oracle/ 
ADD https://download.oracle.com/otn_software/linux/instantclient/1911000/instantclient-sqlplus-linux-19.11.0.0.0dbru.zip /opt/oracle/




RUN cd /opt/oracle && unzip instantclient-basic-linux.x64-21.1.0.0.0.zip \
   && unzip instantclient-sdk-linux.x64-21.1.0.0.0.zip \
   && unzip instantclient-sqlplus-linux-19.11.0.0.0dbru.zip \
   && cd /opt/oracle/instantclient_21_1 


ENV ORACLE_HOME /opt/oracle/instantclient_21_1
#ENV LD_LIBRARY_PATH $ORACLE_HOME:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH $ORACLE_HOME
ENV PATH=$ORACLE_HOME:$PATH
ENV ORACLE_BASE /opt/oracle
ENV TNS_ADMIN $ORACLE_HOME/network/admin
#PATH=/usr/lib/oracle/12.2/client/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


RUN echo "/opt/oracle/instantclient_21_1" > /etc/ld.so.conf.d/oracle.conf
RUN ldconfig 

RUN pip install requests && pip install retrying
RUN pip install cx_Oracle
RUN pip install apache-airflow-providers-oracle

RUN echo "airflow:airflow" | chpasswd \
&& adduser airflow sudo 


#RUN apt-get update && apt-get install libaio
#RUN apt-get update && apt-get install lbsnl
#RUN apt-get update
#RUN apt-get install vim

#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME #since all binaries are in $ORACLE_HOME - no bin or lib are present  
# sudo apt-get update && apt-get install 
#sudo yum install oracle-instantclient-basic-21.1.0.0.0-1.x86_64.rpm
#sudo apt-get install oracle-instantclient-basic-21.1.0.0.0-1.x86_64.rpm
##manually, you need to run the pip install steps on every server
##you also need ot maybe run the ldconfig manually
