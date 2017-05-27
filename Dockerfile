FROM factual/docker-base

MAINTAINER Nicholas Digati <nicholas@factual.com>

WORKDIR /home/

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

RUN apt-get install -y build-essential
RUN apt-get install -y nodejs
RUN apt-get install -y python-pip
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /etc/service/sinopia/ \
             /etc/my_init.d/ \
             /home/bucket

ADD variable_check.sh /home/variable_check.sh
ADD service_start.sh /etc/my_init.d/99_service_start.sh
ADD sinopia.sh /etc/service/sinopia/run

ADD package.json /home/package.json
ADD requirement.txt /home/requirement.txt

RUN npm install --no-optional --no-shrinkwrap
RUN pip install -r requirement.txt

RUN perl -pi -e 's|encodeURIComponent|function (thing) { return encodeURIComponent(thing).replace(/^%40/, '@'); }|' node_modules/sinopia/lib/up-storage.js

EXPOSE 4873

CMD [ "/sbin/my_init" ]
