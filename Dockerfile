FROM ubuntu:latest

# Disable interactive
ENV DEBIAN_FRONTEND=noninteractive

# Set root user as default user
ENV USER root

# Install necessary packages
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    wget \
    net-tools \
    iputils-ping \
    dbus-x11 \
    nano \
    curl

# Create directory for VNC server
RUN mkdir /.vnc

# Create startup script for VNC server
RUN echo "#!/bin/sh\n\nunset SESSION_MANAGER\n\n" > /.vnc/xstartup \
    && echo "unset DBUS_SESSION_BUS_ADDRESS\n\n" >> /.vnc/xstartup \
    && echo "startxfce4 &\n\n" >> /.vnc/xstartup \
    && echo "[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup\n" >> /.vnc/xstartup \
    && echo "[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources\n\n" >> /.vnc/xstartup \
    && echo "xsetroot -solid grey\n\n" >> /.vnc/xstartup \
    && echo "vncconfig -iconic &\n\n" >> /.vnc/xstartup

# Set execute permission for the startup script
RUN chmod 755 /.vnc/xstartup

# Create VNC password file
RUN mkdir /root/.vnc && touch /root/.vnc/passwd && chmod 600 /root/.vnc/passwd

# Set VNC password
RUN echo "password" | vncpasswd -f >> /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Install Firefox
RUN apt-get install firefox -y


# Start VNC server
CMD ["vncserver", ":1", "-geometry", "1280x800", "-depth", "24"]
