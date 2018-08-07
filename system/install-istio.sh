#! /bin/sh
OS="$(uname)"
if [ "x${OS}" = "xDarwin" ] ; then
  OSEXT="osx"
else
  # TODO we should check more/complain if not likely to work, etc...
  OSEXT="linux"
fi

ISTIO_VERSION="1.0.0"

NAME="istio-$ISTIO_VERSION"
URL="https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-${OSEXT}.tar.gz"
echo "Downloading $NAME from $URL ..."
curl -L "$URL" | tar xz
# TODO: change this so the version is in the tgz/directory name (users trying multiple versions)
echo "Downloaded into $NAME:"
BINDIR="$(cd $NAME/bin; pwd)"

\cp -f $BINDIR/istioctl /usr/local/bin/

# fix helm chart template bug
cd $NAME/install/kubernetes/helm/istio/templates/
ls sidecar-injector-configmap.yaml.sectest.backup > /dev/null 2>&1
if [ $? != 0 ]; then
  cp sidecar-injector-configmap.yaml sidecar-injector-configmap.yaml.sectest.backup
  sed -i '1,1d' sidecar-injector-configmap.yaml
  sed -i '$d' sidecar-injector-configmap.yaml
fi
cd -

kubectl create namespace istio-system
helm template $NAME/install/kubernetes/helm/istio --name istio -f helm_values.yaml --namespace istio-system > istio-install.yaml
kubectl apply -f istio-install.yaml
rm -f istio-install.yaml
