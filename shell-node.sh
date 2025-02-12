#!/bin/bash

cd /opt

wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz

tar -xf node_exporter-1.8.2.linux-amd64.tar.gz

mv node_exporter-1.8.2.linux-amd64 node_exporter

cd node_exporter

cp /etc/systemd/system/node_exporter.service


systemctl start node_exporter

systemctl enable node_exporter

systemctl status node_exporter