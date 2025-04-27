import os

errors = [
  "300 Multiple Choices",
  "301 Moved Permanently",
  "302 Found",
  "303 See Other",
  "304 Not Modified",
  "307 Temporary Redirect",
  "308 Permanent Redirect",
  "400 Bad Request",
  "401 Unauthorized",
  "402 Payment Required",
  "403 Forbidden",
  "404 Not Found",
  "405 Method Not Allowed",
  "406 Not Acceptable",
  "407 Proxy Authentication Required",
  "408 Request Timeout",
  "409 Conflict",
  "410 Gone",
  "411 Length Required",
  "412 Precondition Failed",
  "413 Content Too Large",
  "414 URI Too Long",
  "415 Unsupported Media Type",
  "416 Range Not Satisfiable",
  "417 Expectation Failed",
  "421 Misdirected Request",
  "422 Unprocessable Content",
  "423 Locked",
  "424 Failed Dependency",
  "425 Too Early",
  "426 Upgrade Required",
  "428 Precondition Required",
  "429 Too Many Requests",
  "431 Request Header Fields Too Large",
  "451 Unavailable For Legal Reasons",
#  "494 Request Header Too Large",
#  "495 SSL Certificate Error",
#  "496 SSL Certificate Required",
#  "497 HTTP Request Sent To HTTPS Port",
#  "499 Client Closed Request",
  "500 Internal Server Error",
  "501 Not Implemented",
  "502 Bad Gateway",
  "503 Service Unavailable",
  "504 Gateway Timeout",
  "505 HTTP Version Not Supported",
  "506 Variant Also Negotiates",
  "507 Insufficient Storage",
  "508 Loop Detected",
  "510 Not Extended",
  "511 Network Authentication Required",
]
regex = "30[0123478]|40[0-9]|41[0-7]|42[12345689]|431|451|50[0-8]|51[01]"

configfile = "error-pages.conf"
if os.path.exists(configfile):
  print("ERROR: " + configfile + " already exists")
  exit()

directory = "error-pages"
if os.path.exists(directory):
  print("ERROR: " + directory + " directory already exists")
  exit()

os.mkdir(directory)

print("Generating error pages...")

for error in errors:
  with open("template.html") as template:
    template = template.read()
    template = template.replace("$ERROR", error)
    code = error[0:3]
    with open(directory + '/' + code + ".html", 'w') as output:
      output.write(template)
    with open(configfile, 'a') as config:
      line = "error_page " + code + " /" + directory + '/' + code + ".html;\n"
      config.write(line)

with open(configfile, 'a') as config:
  data  = "\n"
  data += "location ~ ^/error-pages/(?:" + regex + ")\\.html$ {\n"
  data += "  root /var/www/default;\n"
  data += "  auth_basic off;\n"
  data += "  internal;\n"
  data += "}\n"
  config.write(data)
