#!/usr/bin/python3
import time
import os
import subprocess
from simple_term_menu import TerminalMenu

# main menu
def main():
    main_menu_title = "  Main Menu.\n  Press Q or Esc to quit. \n"
    main_menu_items = ["[1] Install ansible", "[2] Edit hosts file", "[3] Edit variables file", "[4] Install swarm cluster (Production)", "[5] Deploy Kubernetes", "Quit"]
    main_menu_cursor = ">> "
    main_menu_cursor_style = ("fg_blue", "bold")
    main_menu_style = ("bg_red", "fg_yellow")
    main_menu_exit = False

    main_menu = TerminalMenu(
        menu_entries=main_menu_items,
        title=main_menu_title,
        menu_cursor=main_menu_cursor,
        menu_cursor_style=main_menu_cursor_style,
        menu_highlight_style=main_menu_style,
        cycle_cursor=True,
        clear_screen=False,
    )
# submenu 1
    install_swarm_title = "  Install cluster.\n  Press Q or Esc to back to main menu. \n"
    install_swarm_items = ["[1] Install multi-manage multi-worker cluster *", "[2] Install manager reachable", "[3] Install worker","[4] Install swarm cluster only one node (Test)", "Back to Main Menu"]
    install_swarm_back = False
    install_swarm = TerminalMenu(
        install_swarm_items,
        title=install_swarm_title,
        menu_cursor=main_menu_cursor,
        menu_cursor_style=main_menu_cursor_style,
        menu_highlight_style=main_menu_style,
        cycle_cursor=True,
        clear_screen=False,
    )
# submenu 2
    deploy_kubernetes_title = "  Install cluster.\n  Press Q or Esc to back to main menu. \n"
    deploy_kubernetes_items = ["[1] Deploy kubernester cluster *", "[2] Setup nfs-volumes", "[3] Deploy metalLB, Ingress", "[4] Portainer", "[5] Infratructure service", "[6] Base service", "Back to Main Menu"]
    deploy_kubernetes_back = False
    deploy_kubernetes = TerminalMenu(
        deploy_kubernetes_items,
        title=deploy_kubernetes_title,
        menu_cursor=main_menu_cursor,
        menu_cursor_style=main_menu_cursor_style,
        menu_highlight_style=main_menu_style,
        cycle_cursor=True,
        clear_screen=False,
    )
# main menu seletor    
    while not main_menu_exit:
        main_sel = main_menu.show()

        if main_sel == 0:
            print("install ansible")
            os.system("apt install python3-pip -y; pip3 install ansible; mkdir -p /etc/ansible/")
            subprocess.run('ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N "" 0>&-', shell=True)
        if main_sel == 1:
            print("Cập nhật file hosts")
            time.sleep(1)
            subprocess.run("nano hosts; cp -f ./hosts /etc/ansible/hosts", shell=True)
            print("Copy keygen ssh: write Yes and import Password")
            time.sleep(2)
            os.system("grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' hosts > server.txt")
            os.system("chmod a+x playbook/copykeygen.sh; playbook/copykeygen.sh")           
        elif main_sel == 2:
            print("Cập nhật file variables.yml")
            subprocess.run("nano playbook/variables.yml", shell=True)
            time.sleep(3)
# submenu 1 seletor    
        elif main_sel == 3:
            while not install_swarm_back:
                edit_sel = install_swarm.show()
                if edit_sel == 0:
                    print("install multi-manage multi-worker cluster")
                    subprocess.run("ansible-playbook playbook/umanager.yml; ansible-playbook playbook/managerjoin.yml; ansible-playbook playbook/workerjoin.yml; ansible-playbook playbook/replaceManagerToWorker.yml; ansible-playbook playbook/portainerinstall.yml; ansible-playbook playbook/traefikinstall.yml; ansible-playbook playbook/infrainstall.yml; ansible-playbook playbook/Log4jSecurityVulnerability.yml", shell=True)
                elif edit_sel == 1:
                    print("Install manager reachable")
                    subprocess.run("ansible-playbook playbook/umanager.yml --tags token; ansible-playbook playbook/managerjoin.yml", shell=True)
                elif edit_sel == 2:
                    print("install worker")
                    subprocess.run("ansible-playbook playbook/umanager.yml --tags token; ansible-playbook playbook/workerjoin.yml", shell=True)
                elif edit_sel == 3:
                    print("install swarm cluster only one node")
                    subprocess.run("ansible-playbook playbook/umanager.yml; ansible-playbook playbook/portainerinstall.yml --skip-tags git; ansible-playbook playbook/traefikinstall.yml --skip-tags git; ansible-playbook playbook/infrainstall.yml --skip-tags git", shell=True)
                    time.sleep(3)
                elif edit_sel == 4 or edit_sel == None:
                    install_swarm_back = True
                    print("Back Selected")
            install_swarm_back = False
# submenu 2 seletor 
        elif main_sel == 4:
            while not deploy_kubernetes_back:
                edit_sel = deploy_kubernetes.show()
                if edit_sel == 0:
                    print("Deploy kubernester cluster *")
                    subprocess.run("ansible-playbook kubernetes/dependent-components.yaml; ansible-playbook kubernetes/master.yaml; ansible-playbook kubernetes/worker.yaml", shell=True)
                    time.sleep(3)
                elif edit_sel == 1:
                    print("Setup nfs-volumes")
                    subprocess.run("ansible-playbook kubernetes/replace.yaml --tags nfs; ansible-playbook kubernetes/nfs-volumes/setupnfs.yaml", shell=True)
                elif edit_sel == 2:
                    print("Deploy metalLB, Ingress")
                    subprocess.run("ansible-playbook kubernetes/replace.yaml --tags metallb; ansible-playbook kubernetes/metallb/setupmetallb.yaml", shell=True)
                elif edit_sel == 3:
                    print("Deploy Portainer")
                    subprocess.run("ansible-playbook kubernetes/infra/setupportainer.yaml", shell=True)
                    time.sleep(3)
                elif edit_sel == 4:
                    print("Infratructure service")
                    subprocess.run("ansible-playbook kubernetes/infra/setupinfra.yaml", shell=True)
                    time.sleep(3)
                elif edit_sel == 5:
                    print("Base service")
                    subprocess.run("ansible-playbook kubernetes/basesvc/setupbasesvc.yaml", shell=True)
                    time.sleep(3)
                elif edit_sel == 6 or edit_sel == None:
                    deploy_kubernetes_back = True
                    print("Back Selected")
            deploy_kubernetes_back = False

        elif main_sel == 5 or main_sel == None:
            main_menu_exit = True
            print("Quit Selected")


if __name__ == "__main__":
    main()
