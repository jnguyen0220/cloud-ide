ARCH=$(dpkg --print-architecture)
FILE="go${GO_VERSION}.linux-${ARCH}.tar.gz"
URL="https://dl.google.com/go/${FILE}"
curl -o /tmp/$FILE $URL
tar -xvzf /tmp/$FILE -C /usr/local
rm -f /tmp/$FILE
export PATH="/usr/local/go/bin:${PATH}"
echo "export PATH=/usr/local/go/bin:${PATH}" >> /etc/bash.bashrc