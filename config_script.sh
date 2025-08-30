#!/bin/bash

# for the restore: The variable called <OLD_TOML> is for
# the alacritty config you previously had in your directory.
# the previous .vimrc file is in the <OLD_VIM> variable.
# If you want to restore the old config just write <./config_script.sh restore>.
# The script will run just the restore, nothing else :).
VIM=$(which vim)

PACKAGE_MANAGER=""
get_package_manager() {
    
    local distro=$(lsb_release -i | cut -f 2-)
    if [ "$distro" == "Debian" || "$distro" == "Ubuntu" || "$distro" == "LinuxMint" ] then
        PACKAGE_MANAGER="apt install"
    elif [ "$distro" == "Arch" ] then
        PACKAGE_MANAGER="pacman -S"
    elif [ "$distro" == "Fedora" ] then
        PACKAGE_MANAGER="dnf install"
    elif [ "$distro" == "Manjaro" ] then
        PACKAGE_MANAGER="pacman -S"
    else
        echo "IM SO SRY IDK UR DISTRO">&2
        exit 1
    fi
}

if [ -z "$VIM" ] then
    sudo "$PACKAGE_MANAGER" vim
fi

CURL=$(which curl)
DUMMY_REPO="$HOME/repo"
ALACRITTY_TARGET="$HOME/.config/alacritty"
OLD_TOML="$ALACRITTY_TARGET/alacritty.toml"
OLD_VIM="$HOME/.vimrc"
BACKUP="$DUMMY_REPO/BACKUP"
cd "$DUMMY_REPO"
if [ ! -d "$BACKUP" ] then
    mkdir "$BACKUP" 
fi

if [ ! -f "$OLD_TOML" ] then
    touch "$OLD_TOML"
fi

if [ ! -f "$OLD_VIM" ] then
    touch "$OLD_VIM"
fi

cp "$OLD_TOML" "$BACKUP" 
cp "$OLD_VIM" "$BACKUP" 

cd "$HOME"

if [ -z "$CURL" ] then
    echo "YOU WILL BE REQUESTED TO ENTER SUDO MODE"
    sudo "$PACKAGE_MANAGER" curl
fi

restore() {
   mv -f "$BACKUP/.vimrc" "$HOME"
   mv -f "$BACKUP/alacritty.toml" "$ALACRITTY_TARGET"

   echo "CONFIG WAS RESTORED"
   exit 0;
}

# write <./config_script.sh font> for downloading IOSEVKA font.
# the script will run just the font function, nothing else :).

font() {
    echo "PLEASE BEFORE INSTALLATION QUIT EVERY TEXT EDITOR, YOU HAVE 5 SECONDS"
    sleep 5
    curl -s 'https://api.github.com/repos/be5invis/Iosevka/releases/latest' | jq -r ".assets[] | .browser_download_url" | grep PkgTTC-Iosevka | xargs -n 1 curl -L -O --fail --silent --show-error
    echo "MAKE SURE THAT YOU HAVE NOT MORE DOWNLOADS OF THE FONT IN THE CURRENT DIRECTORY"
    mkdir IOSEVKA
    cd IOSEVKA
    tar -xf Iosevka-*.tar.xz
    cd Iosevka-*
    echo "THIS IS ONLY USER SPECIFIC INSTALLATION KEEP IN MIND"
    mkdir -p ~/.local/share/fonts
    cp -r Iosevka-*/* ~/.local/share/fonts/
    sudo fc-cache -fv
    cd ..
    rm -rf IOSEVKA
    cd "$HOME"

    exit 0;

}

if [ $1 == "restore" ] then
    restore
elif [ $1 == "font" ] then
    font
elif [ $1 == "--help" ] then
    echo "ok so idk why u need help but basically skill issue"
fi

PLUGIN_EXISTS="vim-plug already installed"
GIT_EXISTS="git already installed"
GIT_LOADED="git successfully closed"
PLUGIN_LOADED="Vim-plug was successfully instaled"
LOAD="config loaded successfully"
PLUGIN_ERR="Vim-plug was not installed successfully"
GIT_ERR="Something went wrong while working with git"
IS_PLUG_INSTALLED=0
PLUG_LOCATION="~/.vim/autoload/plug.vim"
IS_GT_INSTALLED=$(which git)
WGET_EXISTS=$(which git)
LSB=$(which lsb_release)

if [ -z "$LSB" ] then
    echo "IM SRY IM TOO LAZY TO CHECK SOME OTHER WAY WHAT TYPE OF DISTRO U HAVE SO PLEASE INSTALL LSB_RELEASE TY <3">&2
    exit 1
fi

if [ ! -f $PLUG_LOCATION ]; then
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    IS_PLUG_INSTALLED=1
fi

if [ $IS_PLUG_INSTALLED -eq 1 ] then;
    if [ $? -eq 1 ] then;
        echo $PLUGIN_ERR >&2
        exit 1
    else
        echo $PLUGIN_LOADED
else
    echo "$PLUGIN_EXISTS"
fi


get_package_manager
if [ -z "$IS_GIT_INSTALLED" ] then
    echo "U WILL BE REQUESTED TO ENTER SUDO MODE *MAYBE* if not then idk maybe check if u are not already in sudo mode :D"
    sleep 2
    sudo "$PACKAGE_MANAGER" git
else
    echo "$GIT_EXISTS"
fi

if [ ! -d "$DUMMY_REPO" ] then
    mkdir "$DUMMY_REPO"
fi

echo "$GIT_LOADED"

git clone https://github.com/masef3/config.git "$DUMMY_REPO"
cd "$DUMMY_REPO"
if [ ! -d "$ALACRITTY_TARGET" ] then
    mkdir "$ALACRITTY_TARGET"
fi

mv -f alacritty.toml "$ALACRITTY_TARGET"
mv -f .vimrc "$HOME"

vim +PlugInstall +qall

echo "$LOAD"
exit 0;



     
    


