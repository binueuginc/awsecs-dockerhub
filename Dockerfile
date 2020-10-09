FROM tomcat:8.0-alpine

LABEL maintainer="binu.eugin@sonetel.com"

EXPOSE 80

CMD ["catalina.sh", "run"]
