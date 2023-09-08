FROM python:3.10 as builder

ENV VIRTUAL_ENV=/home/ubuntu/merge-sqlite/docker_test_env

RUN python3 -m venv $VIRTUAL_ENV

ENV PATH="$VIRTUAL_ENV/bin:$PATH"
COPY ./ /opt

WORKDIR /opt

RUN pip install tox && tox -p

FROM python:3.10

COPY --from=builder /opt/dist/*.tar.gz /opt
COPY requirements.txt /opt

WORKDIR /opt

RUN pip install -r requirements.txt *.tar.gz \
	&& rm -f *.tar.gz requirements.txt

ENTRYPOINT ["bam_readgroup_to_json"]

CMD ["--help"]
