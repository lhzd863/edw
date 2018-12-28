#!/bin/bash
######################################################################
#  brief :get文件
#version :2018-12-19     create              liuhui
######################################################################

#load common
. ${BATCH_HOME}/lib/batch-common.sh

#variable

#
######################################################################
#  brief :main
#version :2018-12-19     create              liuhui
######################################################################
function main()
{
  #
  if [ ! -d /home/edw/stock/${cal_date} ];then
    mkdir -p /home/edw/stock/${cal_date}
  fi
  #
  scp -r osa@47.89.240.84:/home/stock/stockdata/${cal_date}/stockdata.txt /home/edw/stock/${cal_date}
  if [ $? -ne 0 ];then
   exit 1
  fi
  #
  mv /home/edw/stock/${cal_date}/stockdata.txt  /home/edw/stock/${cal_date}/stockdata_${cal_date}.txt
  if [ $? -ne 0 ];then
    exit 1
  fi
  #
  rmtlsinfo=`ssh osa@47.89.240.84 "ls -l --time-style '+%Y-%m-%d %H:%M:%S' /home/stock/stockdata/${cal_date}/stockdata.txt"`
  fsize=`echo "$rmtlsinfo"|awk -F ' ' '{print $5}'`
  fdate=`echo "$rmtlsinfo"|awk -F ' ' '{print $6}'`
  ftime=`echo "$rmtlsinfo"|awk -F ' ' '{print $7}'`
  tm=`date '+%Y-%m-%d %H:%M:%S'`
  flocalsize=`ls -l --time-style '+%Y-%m-%d %H:%M:%S' /home/edw/stock/${cal_date}/stockdata_${cal_date}.txt|awk -F ' ' '{print $5}'`
  frow=`wc -l /home/edw/stock/${cal_date}/stockdata_${cal_date}.txt|awk -F ' ' '{print $1}'`
  echo "${cal_date}|stockdata_${cal_date}.txt|$fsize|$fdate $ftime|$flocalsize|$frow|$tm"> /home/edw/stock/${cal_date}/stockdata_${cal_date}.ok

  errquit $?

  return 0
}
######################################################################
#entre
  if [ $# -ne 1 ];then
     echo "USAGE: job.yyyymmdd.HHMMSS"
     echo " e.g.: RDRPT_MSQL_R01_MATRIX_SUBJECT_SRC_EXP.20181130.000000"
     exit 1
  fi
  ctlf="$1"
  #1.spare ctl file
  splitctl "$ctlf"
  #2.cron expression
  isCronRunOk "* * * * * ? *" "${cal_date_0} ${cal_time_0}"
  succquit $? "cron express fail"
  #3.main
  main
