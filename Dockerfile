FROM ubuntu

ARG UNITY_DOWNLOAD_URL=https://beta.unity3d.com/download/fcee59332301/UnitySetup-2018.2.2f1
ARG COMPONENTS=Unity,Windows-Mono

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install tzdata
RUN echo "Europe/Dublin" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update -qq; \
  apt-get install -qq -y \
  gconf-service \
  lib32gcc1 \
  lib32stdc++6 \
  libasound2 \
  libarchive13 \
  libc6 \
  libc6-i386 \
  libcairo2 \
  libcap2 \
  libcups2 \
  libdbus-1-3 \
  libexpat1 \
  libfontconfig1 \
  libfreetype6 \
  libgcc1 \
  libgconf-2-4 \
  libgdk-pixbuf2.0-0 \
  libgl1-mesa-glx \
  libglib2.0-0 \
  libglu1-mesa \
  libgtk2.0-0 \
  libgtk3.0 \
  libnspr4 \
  libnss3 \
  libpango1.0-0 \
  libsoup2.4-1 \
  libstdc++6 \
  libx11-6 \
  libxcomposite1 \
  libxcursor1 \
  libxdamage1 \
  libxext6 \
  libxfixes3 \
  libxi6 \
  libxrandr2 \
  libxrender1 \
  libxtst6 \
  zlib1g \
  debconf \
  npm \
  xdg-utils \
  lsb-release \
  libpq5 \
  xvfb \
  wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN wget -nv ${UNITY_DOWNLOAD_URL} -O UnitySetup && \
    # make executable
    chmod +x UnitySetup && \
    # agree with license
    echo y | \
    # install unity with required components
    ./UnitySetup --unattended \
    --install-location=/opt/Unity \
    --verbose \
    --download-location=/tmp/unity \
    --components=$COMPONENTS && \
    # remove setup
    rm UnitySetup && \
    # make a directory for the certificate Unity needs to run
    mkdir -p $HOME/.local/share/unity3d/Certificates/

ADD CACerts.pem $HOME/.local/share/unity3d/Certificates/

# Clean up
RUN rm -rf /tmp/* /var/tmp/*

RUN /opt/Unity/Editor/Unity xvfb-run --auto-servernum --server-args='-screen 0 640x480x24' -batchmode -projectPath /