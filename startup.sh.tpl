#!/bin/bash -xe

apt-get update
apt-get install -y apache2 libapache2-mod-php

rm /var/www/html/index.html

cat > /var/www/html/index.php <<'EOF'
<?php
echo $_SERVER["SERVER_ADDR"];
EOF

