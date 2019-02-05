FROM busybox

RUN git branch -a | grep '\*'

ADD this.py /
