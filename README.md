# rpi-hdmi-cec-rest

# start docker

    docker run -p 5000:5000 -v /etc/localtime:/etc/localtime:ro -e TZ=Europe/Zurich --device=/dev/vchiq pavandoo/hdmi-cec-rest

# install as a systemd service

create a systemd service file: 

    sudo nano /etc/systemd/system/hdmi-cec-rest.service

    [Unit]
    Description=HDMI CEC Rest Container
    Requires=docker.service
    After=docker.service

    [Service]
    Restart=always

    ExecStartPre=-/usr/bin/docker stop -t 10 hdmi-cec-rest
    ExecStartPre=-/usr/bin/docker container rm hdmi-cec-rest
    ExecStartPre=-/usr/bin/docker container prune -f

    ExecStart=/usr/bin/docker run -p 5000:5000 -v /etc/localtime:/etc/localtime:ro -e TZ=Europe/Zurich --device=/dev/vchiq --log-opt max-size=10m --log-opt max-file=5 --name=hdmi-cec-rest pavandoo/hdmi-cec-rest

    ExecStop=/usr/bin/docker stop -t 10 hdmi-cec-rest

    [Install]
    WantedBy=multi-user.target
 
 reload systemd daemon:
 
    sudo systemctl daemon-reload
  
  start service:
  
    sudo systemctl start hdmi-cec-rest.service 
