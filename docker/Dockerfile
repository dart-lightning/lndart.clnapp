FROM dart:stable-sdk
LABEL mantainer="Vincenzo Palazzo vincenzopalazzodev@gmail.com"

# Ubuntu utils
RUN apt-get update && apt-get install -y \
    software-properties-common make bash wget  && \
    git clone https://github.com/flutter/flutter.git /usr/local/flutter

ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

RUN flutter doctor && flutter channel master && flutter upgrade

COPY . .

CMD ["./docker/entrypoint.sh"]