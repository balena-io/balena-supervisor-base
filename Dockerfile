FROM scratch
ADD ./out/rootfs.tar.gz /

CMD [ "/sbin/init" ]
