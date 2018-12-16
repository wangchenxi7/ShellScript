#!/usr/bin/env python
# -*- coding:utf-8 -*-  

import requests  
import getpass  
name = "yanxiaochao-by"  
passwd = "123456" 
payload = {'action': 'login', 'ac_id': '1','username': name,'password': passwd,'save_me':'0'}  
r = requests.post('http://159.226.39.22/srun_portal_pc.php?url=&ac_id=1', data=payload)  
res = r.text  
  
if res.find(u'网络已连接'):  
  print 'You are connected.'  
else:
  print 'Unknown error'
