FROM node:20-alpine AS base
RUN mkdir -p /usr/app
WORKDIR /usr/app

# Prepare static files
FROM base AS build-front
COPY ./ ./
RUN npm ci
RUN npm run build

# en la stage de release es como si lo anterior ya no exista pero se puede recuperar
# por eso hacemos un COPY --from=build-front
# de esta manera el container pesa mucho menos

FROM base AS release
# aquí falta contenido
COPY --from=build-front /usr/app/dist ./public
# ... más contenido
# para no instalar las dependencias de dev
RUN npm ci --omit=dev

ENV PORT=8083
CMD npm start
