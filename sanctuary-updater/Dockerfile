ARG BUILD_FROM
FROM $BUILD_FROM

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

RUN apk add --no-cache busctl
#RUN apk add --no-cache rauc --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/

CMD [ "/run.sh" ]