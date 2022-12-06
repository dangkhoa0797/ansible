tar xzvf k9s_Linux_x86_64.tar.gz
mv k9s /usr/local/bin/
k9s

echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc