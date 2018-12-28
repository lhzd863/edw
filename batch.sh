txdate="$1"
bash /home/edw/ETL/APP/XXESD/XXESD_OSCT_S01_STOCK/bin/xxesd_osct_s01_stock0010.sh XXESD_OSCT_S01_STOCK.${txdate}.000000
ret=$?
if [ $? -ne 0 ];then
  python /home/edw/ETL/mail/sendm.py -a lhzd863 -s "Batch:$txdate XXESD_OSCT_S01_STOCK fail" -c "XXESD_OSCT_S01_STOCK fail $ret !"
  exit 1
fi
#
bash /home/edw/ETL/images/images_sdl_file_check_exists0010.sh NSSDL_HIVE_S01_STOCK.${txdate}.000000
ret=$?
if [ $ret -ne 0 ];then
  python /home/edw/ETL/mail/sendm.py -a lhzd863 -s "Batch:$txdate NSSDL_HIVE_S01_STOCK check fail" -c "NSSDL_HIVE_S01_STOCK check fail $ret !"
  exit 1
fi
#
bash /home/edw/ETL/images/images_sdl_file_load0100.sh NSSDL_HIVE_S01_STOCK.${txdate}.000000
ret=$?
if [ $ret -ne 0 ];then
  python /home/edw/ETL/mail/sendm.py -a lhzd863 -s "Batch:$txdate NSSDL_HIVE_S01_STOCK load fail" -c "NSSDL_HIVE_S01_STOCK load faili,$ret !"
  exit 1
fi
bash /home/edw/ETL/APP/NSPDM/NSPDM_HIVE_T00_STOCK_CDE/bin/nspdm_hive_t00_stock_cde0200.sh NSPDM_HIVE_T00_STOCK_CDE.${txdate}.000000
ret=$?
if [ $ret -ne 0 ];then
  python /home/edw/ETL/mail/sendm.py -a lhzd863 -s "Batch:$txdate NSPDM_HIVE_T00_STOCK_CDE fail" -c "NSPDM_HIVE_T00_STOCK_CDE fail,$ret !"
  exit 1
fi

python /home/edw/ETL/mail/sendm.py -a lhzd863 -s "Batch:$txdate success" -c "batch has finished,success!"
