set fish_greeting ""
alias python=python3
alias py=python3
alias gdb="gdb -quiet"

function fish_prompt --description 'Write out the prompt'
    echo -n -s (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) '> '
end

function vm
    switch (count $argv)
        case 0
            set name dev
            set username admin
        case 1
            set name $argv[1]
            set username admin
        case 2
            set name $argv[1]
            set username $argv[2]
    end
    if not VBoxManage list runningvms | cut -d '"' -f 2 | grep -q "$name"
        VBoxManage startvm --type headless "$name"
        echo "Waiting for SSH connection..."
    end
    set port (VBoxManage showvminfo "$name" --machinereadable | \
                 grep '^Forwarding(.*,22"' | cut -d, -f4)
    ssh -p $port -o ConnectionAttempts=60 $username@localhost
end
