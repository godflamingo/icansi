mkdir /xraybin
mkdir /nzqc
unzip /one.zip -d /xraybin
unzip /nzqc1.zip -d /nzqc
COPY nzqc/default.conf.template /etc/nginx/conf.d/default.conf.template
COPY nzqc/nginx.conf /etc/nginx/nginx.conf
COPY nzqc/static-html /usr/share/nginx/html/index
rm -f /one.zip
rm -f /nzqc1.zip
cd /xraybin
chmod +x ./xray
ls -al
cat << EOF > /config.json
{
    "log": {
        "loglevel": "warning"
    },
    "routing": {
        "domainStrategy": "AsIs",
        "rules": [
            {
                "type": "field",
                "ip": [
                    "geoip:private"
                ],
                "outboundTag": "block"
            }
        ]
    },
    "inbounds": [
        {
            "listen": "0.0.0.0",
            "port": 23323,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                    "id": "$UUID",
                    "level": 0,
                    "alterId": 0,
                    "email": "love@xray.com"
                    }
                ],
                "disableInsecureEncryption": false
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "acceptProxyProtocol": false,
                    "path": "$WS_PATH"
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom",
            "tag": "direct"
        },
        {
            "protocol": "blackhole",
            "tag": "block"
        }
    ]
}
EOF
envsubst '\$UUID,\$WS_PATH' < /config.json > /xraybin/config.json
cd /xraybin
./xray run -c ./config.json &
/bin/bash -c "envsubst '\$PORT,\$WS_PATH' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf" && nginx -g 'daemon off;'
