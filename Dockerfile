FROM archlinux

COPY makepkg.conf /etc/
RUN pacman -Sy --noconfirm --noprogressbar reflector && \
    reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist && \
    pacman -Syu --noconfirm --noprogressbar base-devel git && \
    useradd -m user && \
    echo "user ALL=NOPASSWD: ALL" >> /etc/sudoers

USER user
WORKDIR /home/user
RUN git clone https://aur.archlinux.org/yay-bin.git && \
    cd yay-bin && \
    makepkg -si --noconfirm --noprogressbar && \
    cd .. && \
    rm -rf yay-bin
