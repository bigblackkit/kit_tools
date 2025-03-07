FROM ununtu:6.04
RUN apt-get update && apt-get upgrade && apt-get install apache2
COPY . ./var/www/html/
CMD [ "/usr/sbin/apache2ctl", "-DFOREGROUND" ]
EXPOSE 80