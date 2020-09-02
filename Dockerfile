FROM infracost/infracost
RUN apk add --no-cache git jq bash curl util-linux
WORKDIR /modulecost
COPY . .
RUN chmod +x bargs.sh entrypoint.sh
ENTRYPOINT [ "/modulecost/entrypoint.sh" ]
# CMD [ "--help" ]
