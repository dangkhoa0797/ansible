tar xzvf k9s_Linux_x86_64.tar.gz
mv k9s /usr/local/bin/
k9s

printf '
alias k=kubectl
alias ka='kubectl apply -f '
alias kg='kubectl get'
' >>~/.bashrc