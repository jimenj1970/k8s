FROM ubuntu:latest

# - then it should use alpine package manager to install tini: 'apk add --update tini'
RUN apt-get update && \
    apt-get install -y apt-utils && \
    apt-get install -y python && \
    apt-get install -y iproute2 && \
    apt-get install -y ssh

RUN echo PermitRootLogin yes >> /etc/ssh/sshd_config
RUN mkdir /root/.ssh
RUN echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8hUHuE6cfHZyr9niB5M0QnjGbikx7Nm8ldvPNEdLzSebApaKfJ4lJpr3MmH8goYG5OnJGvOYHZMhDSl3IHjsrYNOSrcxnEXVbmx0Hoc8pKFS+q58uXGlNS8pUc/cHr+97uLMLndwKePU8ek2UVQUWOEvjvVNsreaLIWzngoghE/ysRvSGGk7SzgBR5KmbjDo1/7i8Qz+QHOOxgLVlANjwUm4o7PtXYKRm9epr1l8DtsBrqnLRgm7oVtVSx3f/2qrpH8SXdgAZgLJNlJ0pfXf1KLULdnEJeQwhp+SEkRt146rm/u2Byo/P3VAwjxWzbWwS/GoGjLvl5ODVekltmiTevHmEu3IgqkXe9wyF3EChxlLKbBfXryW04cOu6OyLwJasJbGAYrhxWqv+DaShY5LpUwMpS0F3pDvHom+2BcG4O6ppzeJpQHq6Dvdvg+fdDb53H06LW1G8YDLDnCjABidZVnFfzPCUgWyte8XixSMYGACQGvj6PTQ1Wmb8ddLt2Ck= root@8c4e7ce78e0e  >> /root/.ssh/authorized_keys                                                                                                                                     
RUN update-rc.d ssh enable

ENTRYPOINT service ssh start && tail -f /var/log/bootstrap.log