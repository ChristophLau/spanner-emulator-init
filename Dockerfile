FROM gcr.io/google.com/cloudsdktool/cloud-sdk:436.0.0-emulators

WORKDIR /usr/bin

COPY bootstrap.sh .

ENTRYPOINT [ "/bin/bash", "bootstrap.sh" ]
