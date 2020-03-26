FROM java:latest

#RUN useradd -m rootless
#USER rootless:rootless
#WORKDIR /home/rootless

RUN mkdir /data
WORKDIR /data

COPY Boxcryptor*.tar.gz /data
RUN tar xzf Boxcryptor*.tar.gz
RUN rm Boxcryptor*.tar.gz
RUN mv Boxcryptor* /usr/bin

CMD 'Boxcryptor_Portable.sh'

