FROM python:3.12-alpine
# fetching cheat sheets
## installing dependencies
RUN apk add --update --no-cache git libstdc++ sed bash gawk \
								py3-six py3-pygments py3-yaml py3-gevent py3-colorama py3-requests py3-icu py3-redis py3-jinja2 py3-flask
## copying
WORKDIR /app
COPY . /app
## building missing python packages
RUN apk add --no-cache --virtual build-deps py3-pip g++ python3-dev libffi-dev pkgconf icu-dev icu-data-full

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip3 install --no-cache-dir --upgrade pygments \
    && pip3 install --no-cache-dir -r requirements.txt

RUN apk del build-deps
# fetching dependencies
RUN mkdir -p /root/.cheat.sh/log/ \
    && python3 lib/fetch.py fetch-all

ENTRYPOINT ["python3", "-u", "bin/srv.py"]
EXPOSE 8002
CMD [""]
