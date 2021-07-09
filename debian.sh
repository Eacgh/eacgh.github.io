#!/data/data/com.termux/files/usr/bin/sh
termux-setup-storage
apt update ; apt install debootstrap -y
debootstrap --no-check-gpg --include=fish,locales stable ~/.proot/debian https://mirrors.tuna.tsinghua.edu.cn/debian

if [ -e ~/.proot/debian/etc/locale.gen ];then
        echo 'zh_CN.UTF-8 UTF-8' > ~/.proot/debian/etc/locale.gen
        echo 'LANG=zh_CN.UTF-8' > ~/.proot/debian/etc/locale.conf
        unset LD_PRELOAD
        proot -0 -l -r ~/.proot/debian/ -w / /usr/bin/env -i PATH=/bin:/usr/bin:/sbin:/usr/sbin /sbin/locale-gen
else
        exit
fi

cat <<PROOT > /data/data/com.termux/files/usr/bin/start-debian
#!/data/data/com.termux/files/usr/bin/sh
unset LD_PRELOAD
proot \\
  -0 \\
  --link2symlink \\
  -r ~/.proot/debian \\
  -b /dev/ \\
  -b /sys/ \\
  -b /proc/ \\
  -b /data/data/com.termux \\
  -b /sdcard \\
  -w /root \\
  /usr/bin/env \\
    -i \\
    HOME=/root \\
    TERM="\${TERM}" \\
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \\
    LANG=zh_CN.UTF-8 \\
    /bin/fish --login
PROOT

chmod +x /data/data/com.termux/files/usr/bin/start-debian