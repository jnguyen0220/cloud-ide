nohup code-server --host 0.0.0.0 --port 8080 &
nohup jupyter lab --LabApp.base_url=jl --ip 0.0.0.0 --allow-root --LabApp.token=${PASSWORD} &
nginx -g 'daemon off;'