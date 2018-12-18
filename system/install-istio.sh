#! /bin/sh
OS="$(uname)"
if [ "x${OS}" = "xDarwin" ] ; then
  OSEXT="osx"
else
  # TODO we should check more/complain if not likely to work, etc...
  OSEXT="linux"
fi

ISTIO_VERSION="1.0.1"

NAME="istio-$ISTIO_VERSION"

ls $NAME > /dev/null 2>&1
# if istio data is not download yet
if [ $? != 0 ]; then
  URL="https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-${OSEXT}.tar.gz"
  echo "Downloading $NAME from $URL ..."
  curl -L "$URL" | tar xz
  # TODO: change this so the version is in the tgz/directory name (users trying multiple versions)
  echo "Downloaded into $NAME:"
  BINDIR="$(cd $NAME/bin; pwd)"

  \cp -f $BINDIR/istioctl /usr/local/bin/
fi

# set nodePort setting to access tracing UI
mkdir -p $NAME/tmp
ls $NAME/tmp/tracing-service.yaml > /dev/null 2>&1
if [ $? != 0 ]; then
  TRACING_DIR=$NAME/install/kubernetes/helm/istio/charts/tracing/templates
  cp $TRACING_DIR/service.yaml $NAME/tmp/tracing-service.yaml
  sed -i -e "/targetPort: {{ .Values.jaeger.ui.port }}/a\        nodePort: 31070\n    type: {{ .Values.jaeger.service.type }}" $TRACING_DIR/service.yaml
fi

# install helm command
which helm > /dev/null 2>&1
if [ $? != 0 ]; then
  curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
fi

kubectl create namespace istio-system
helm template $NAME/install/kubernetes/helm/istio --name istio -f helm_values.yaml --namespace istio-system > istio-install.yaml
kubectl apply -f istio-install.yaml
#rm -f istio-install.yaml
