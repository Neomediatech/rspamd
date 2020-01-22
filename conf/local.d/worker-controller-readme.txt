# This file is only an example on what you have to do to enable Rspamd web interface.
# Replace "secure_ip" line with an IP address that can connect to the interface without enter the password.
# Repeat "secure_ip" lines as many IP addresses you want to enable the access without password.
# For any other IP replace ${PASSWORD} with an encrypted password generate by the command
#    docker run --rm -it neomediatech/rspamd rspamadm pw
# After you can rename this file as worker-controller.inc
#
bind_socket = "0.0.0.0:11334";
secure_ip = "127.0.0.1";
password = "${PASSWORD}";
#enable_password = "${PASSWORD}";
