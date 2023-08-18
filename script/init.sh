#!/usr/bin/env bash
set -e
nohup code-server --host 0.0.0.0 --auth none --port 8080 &
nohup jupyter lab --LabApp.base_url=jl --ip 0.0.0.0 --allow-root --LabApp.token="" --LabApp.password="" &
sudo nginx
wait -n