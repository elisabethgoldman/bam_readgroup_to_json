FROM python:3.8 as builder

RUN python3

COPY ./ /opt

WORKDIR /opt

RUN pip install tox && tox -p

# Remove tar.gz built from 'testenv:check_dist' step in tox.ini
RUN rm ./dist/*+dirty.tar.gz

FROM python:3.8

COPY --from=builder /opt/dist/*.tar.gz /opt
COPY requirements.txt /opt

WORKDIR /opt

RUN pip install -r requirements.txt \
	&& rm -f requirements.txt

ENTRYPOINT ["bam_readgroup_to_json"]

CMD ["--help"]
