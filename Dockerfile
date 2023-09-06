FROM python:3 as builder

COPY ./ /opt

WORKDIR /opt

RUN pip install tox && tox -p

FROM python:3

COPY --from=builder /opt/dist/*.tar.gz /opt
COPY requirements.txt /opt

WORKDIR /opt

RUN pip install -r requirements.txt *.tar.gz \
	&& rm -f *.tar.gz requirements.txt

ENTRYPOINT ["bam_readgroup_to_json"]

CMD ["--help"]
