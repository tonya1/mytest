#comment
FROM busybox

RUN git rev-parse --abbrev-ref HEAD

ADD this.py /
