FROM ubuntu

RUN apt update
RUN apt install python3-pip -y
RUN pip3 install flask

WORKDIR /application

COPY . /application/

ENTRYPOINT ["python3"]
CMD ["app.py"]
