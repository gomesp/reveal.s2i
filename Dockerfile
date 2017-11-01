FROM openshift/base-centos7

MAINTAINER Pablo Gomes Ludermir <pablog@datacom.co.nz>

# TODO: Rename the builder environment variable to inform users about application you provide them
# ENV BUILDER_VERSION 1.0

LABEL io.k8s.description="Platform for building reveal.js" \
      io.k8s.display-name="builder reveal.js" \
      io.openshift.expose-services="9000:http" \
      io.openshift.tags="builder,reveal.js, revealjs"

# RUN yum install -y ... && yum clean all -y
RUN yum install -y epel-release openssl
RUN yum install -y nodejs npm git && yum clean all -y
RUN yum update -y
RUN npm rebuild
RUN npm install -g grunt-cli bower

WORKDIR /opt

RUN git clone https://github.com/hakimel/reveal.js.git

WORKDIR reveal.js

RUN npm install && bower install --allow-root

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
# RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 9000

WORKDIR /opt/reveal.js

ENTRYPOINT ["npm", "start"]

#CMD ["npm", "start"]
# /usr/libexec/s2i/usage

