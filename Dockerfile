FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y \
    python2 \
    virtualenv \
    python2-setuptools-whl \
    python2-pip-whl \
    build-essential \
    python2-dev \
    git

RUN virtualenv -p python2 /opt/ldade-env
# Dependency version resolution is broken for Python 2.7
RUN bash -c "source /opt/ldade-env/bin/activate && pip install numpy~=1.16"
# Latest commit is broken for Python 2.7
RUN git clone https://github.com/amritbhanu/LDADE-package.git /tmp/LDADE-package && cd /tmp/LDADE-package && git checkout 72db70b6dd0e2be6f3d93a4fd70e7aaace02fabd
RUN bash -c "source /opt/ldade-env/bin/activate && cd /tmp/LDADE-package && python setup.py install"
# sklearn no longer exists
RUN bash -c "source /opt/ldade-env/bin/activate && pip install scikit-learn~=0.20"

ENTRYPOINT ["bash", "-c", "source /opt/ldade-env/bin/activate && python $@"]
