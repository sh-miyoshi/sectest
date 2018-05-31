#! /bin/sh
OS="$(uname)"
if [ "x${OS}" = "xDarwin" ] ; then
  OSEXT="osx"
else
  # TODO we should check more/complain if not likely to work, etc...
  OSEXT="linux"
fi

if [ "x${ISTIO_VERSION}" = "x" ] ; then
  ISTIO_VERSION=$(curl -L -s https://api.github.com/repos/istio/istio/releases/latest | \
                  grep tag_name | sed "s/ *\"tag_name\": *\"\(.*\)\",*/\1/")
fi

NAME="istio-$ISTIO_VERSION"
URL="https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-${OSEXT}.tar.gz"
echo "Downloading $NAME from $URL ..."
curl -L "$URL" | tar xz
# TODO: change this so the version is in the tgz/directory name (users trying multiple versions)
echo "Downloaded into $NAME:"
ls $NAME
BINDIR="$(cd $NAME/bin; pwd)"

sudo \cp -f $BINDIR/istioctl /usr/local/bin/

cd $NAME/install/kubernetes
sed -i -e 's/type: LoadBalancer/type: NodePort/g' istio-auth.yaml
sed -i -e 's/#   nodePort: 32000/    nodePort: 32000/' istio-auth.yaml

cd addons
sed -i -e "/name: http/a\    nodePort: 32010" grafana.yaml
sed -i -e "/selector:/i\  type: NodePort" grafana.yaml
sed -i -e "/name: http/a\    nodePort: 32011" zipkin.yaml
sed -i -e "/selector:/i\  type: NodePort" zipkin.yaml

