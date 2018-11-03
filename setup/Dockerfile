# This image is used to test Ubuntu setup script.

FROM ubuntu:18.04

RUN apt update \
  && apt install -y curl sudo \
  && apt clean \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -m -s /bin/bash user \
  && echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER user
WORKDIR /home/user

ADD ubuntu /init.sh
RUN sh /init.sh

CMD ["zsh"]