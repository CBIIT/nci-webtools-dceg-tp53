FROM public.ecr.aws/amazonlinux/amazonlinux:2023

RUN dnf -y update && \
    dnf -y install \
    gcc \
    pkgconf \
    pkgconf-pkg-config \
    python3.12 \
    python3.12-devel \
    python3.12-pip \
    python3.12-setuptools \
    python3.12-wheel \
    shadow-utils \
    && dnf clean all

RUN useradd --uid 1001 --user-group --no-create-home --shell /sbin/nologin app

RUN mkdir /app

WORKDIR /app

COPY requirements.txt .

RUN python3.12 -m pip install --no-cache-dir -r requirements.txt

COPY . .

ENV PYTHONUNBUFFERED=1

ENV TZ=America/New_York

ENV PORT=8080

USER app

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD python3.12 -c "import http.client, os, sys; c = http.client.HTTPConnection('127.0.0.1', int(os.environ.get('PORT', '8080')), timeout=4); c.request('GET', '/_ah/warmup'); sys.exit(0 if c.getresponse().status < 500 else 1)"

CMD python3.12 -m gunicorn -t 120 -b :$PORT main:app
