FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    wget \
    net-tools \
    iputils-ping \
    dbus-x11

RUN mkdir /.vnc

RUN echo "#!/bin/sh\n\nunset SESSION_MANAGER\n\n" > /.vnc/xstartup \
    && echo "unset DBUS_SESSION_BUS_ADDRESS\n\n" >> /.vnc/xstartup \
    && echo "startxfce4 &\n\n" >> /.vnc/xstartup \
    && echo "[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup\n" >> /.vnc/xstartup \
    && echo "[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources\n\n" >> /.vnc/xstartup \
    && echo "xsetroot -solid grey\n\n" >> /.vnc/xstartup \
    && echo "vncconfig -iconic &\n\n" >> /.vnc/xstartup

RUN chmod 755 /.vnc/xstartup

RUN mkdir /root/.vnc

CMD ["vncserver"]