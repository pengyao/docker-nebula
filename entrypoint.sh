# Create the tun device path if required
test -d /dev/net || mkdir -p /dev/net
test -f /dev/net/tun || mknod /dev/net/tun c 10 200
/nebula "$@"