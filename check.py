#check if webite were built on weblogic

import requests
import sys

domain = sys.argv[1]
http = "http://" + sys.argv[1]
https = "https://" + sys.argv[1]
f_name = sys.argv[2] + ".txt"
path = "./results/"
vul = False
methods = []
key = "liferay"

try:
	r = requests.get(http, timeout=5, allow_redirects=True)
	if key in r.text:
		vul = True
		methods.append("http")
except :
	print "Error: Cant access %s" % http

try:
	r = requests.get(https, timeout=5, allow_redirects=True)
	if key in r.text:
		vul = True
		methods.append("https")
except :
	print "Error: Cant access %s" % https

if (vul):
	with open(path + f_name, "a") as fout:
		fout.write("%s %s - VUL\n" % (domain, methods))
else:
	print "NOT VUL"
