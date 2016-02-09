FROM node:latest

RUN echo 'prefix = ~/.node' >> ~/.npmrc
ENV PATH $HOME/.node/bin:$PATH
RUN npm install -g yo generator-hubot
RUN yo hubot --owner="<Bot Wrangler <bw@example.com>" --name="Hubot" \
    --description="Delightfully aware robutt" --adapter=slack --defaults
