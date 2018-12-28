#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import datetime
import time
import getopt
sys.path.append('/home/edw/ETL/mail')
from sendmailetl import SendEmail

vmailaddress = 'lhzd863'

def sendmsg(vmailaddress,vsubject,vcontext):
    try:
        mail = SendEmail(vmailaddress, vsubject, vcontext)
        mail.send_email()
    except Exception, e:
        print e

if __name__ == '__main__':
    global subject_mail, context_mail,mailaddress_mail
    opts, args = getopt.getopt(sys.argv[1:], "a:s:c:")
    for op, val in opts:
        if op == "-a":
            mailaddress_mail = val
        if op == "-s":
            subject_mail = val
        if op == "-c":
            context_mail = val
    sendmsg(mailaddress_mail,subject_mail,context_mail)
    
