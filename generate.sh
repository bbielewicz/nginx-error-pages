#!/bin/bash
set -e

declare -A errors
errors[300]="Multiple Choices"
errors[301]="Moved Permanently"
errors[302]="Found"
errors[303]="See Other"
errors[304]="Not Modified"
errors[307]="Temporary Redirect"
errors[308]="Permanent Redirect"
errors[400]="Bad Request"
errors[401]="Unauthorized"
errors[402]="Payment Required"
errors[403]="Forbidden"
errors[404]="Not Found"
errors[405]="Method Not Allowed"
errors[406]="Not Acceptable"
errors[407]="Proxy Authentication Required"
errors[408]="Request Timeout"
errors[409]="Conflict"
errors[410]="Gone"
errors[411]="Length Required"
errors[412]="Precondition Failed"
errors[413]="Content Too Large"
errors[414]="URI Too Long"
errors[415]="Unsupported Media Type"
errors[416]="Range Not Satisfiable"
errors[417]="Expectation Failed"
errors[421]="Misdirected Request"
errors[422]="Unprocessable Content"
errors[423]="Locked"
errors[424]="Failed Dependency"
errors[425]="Too Early"
errors[426]="Upgrade Required"
errors[428]="Precondition Required"
errors[429]="Too Many Requests"
errors[431]="Request Header Fields Too Large"
errors[451]="Unavailable For Legal Reasons"
#errors[494]="Request Header Too Large"
#errors[495]="SSL Certificate Error"
#errors[496]="SSL Certificate Required"
#errors[497]="HTTP Request Sent To HTTPS Port"
#errors[499]="Client Closed Request"
errors[500]="Internal Server Error"
errors[501]="Not Implemented"
errors[502]="Bad Gateway"
errors[503]="Service Unavailable"
errors[504]="Gateway Timeout"
errors[505]="HTTP Version Not Supported"
errors[506]="Variant Also Negotiates"
errors[507]="Insufficient Storage"
errors[508]="Loop Detected"
errors[510]="Not Extended"
errors[511]="Network Authentication Required"

codes=($(echo ${!errors[@]} | tr ' ' $'\n' | sort))

regex="30[0123478]|40[0-9]|41[0-7]|42[12345689]|431|451|50[0-8]|51[01]"

config_file="error-pages.conf"
if [ -f $config_file ]; then
  echo "ERROR: $config_file already exists"
  exit
fi

directory="error-pages"
if [ -d $directory ]; then
  echo "ERROR: $directory directory already exists"
  exit
fi;

touch $config_file
mkdir $directory

echo "Generating error pages..."

for code in ${codes[@]}; do
cat > $directory/$code.html << EOF
<!DOCTYPE html>
<html>
  <head>
    <title>$code ${errors[$code]}</title>
  </head>
  <body>
    <h1>$code ${errors[$code]}</h1>
  </body>
</html>
EOF
cat >> $config_file << EOF
error_page $code /error-pages/$code.html;
EOF
done

cat >> $config_file << EOF
location ~ ^/error-pages/(?:$regex)\.html$ {
  root /var/www/default;
  auth_basic off;
  internal;
}
EOF
