# NGINX Error Pages

Error Pages generator for NGINX

## Installation

```bash
git clone https://github.com/bbielewicz/nginx-error-pages.git
cd nginx-error-pages
make
sudo mkdir -p /var/www/default
sudo cp -R error-pages /var/www/default/
sudo chmod o-rwx -R /var/www/default
sudo chown <OAM-USER>:<NGINX-USER> -R /var/www/default
sudo cp error-pages.conf /etc/nginx/snippets/
```

## Example

```nginx
# /etc/nginx/sites-available/example.com
server {
  listen 80;
  server_name example.com www.example.com;

  location / {
    return 301 https://example.com$request_uri;
  }
  include /etc/nginx/snippets/error-pages.conf;
}
```
