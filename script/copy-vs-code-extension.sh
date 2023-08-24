CODE_SERVER_PATH=$HOME_DIR/.local/share/code-server

if [ ! -f "${CODE_SERVER_PATH}/User/settings.json" ]; then
mkdir -p $CODE_SERVER_PATH/User
echo "Initializing vscode ..."
cat << EOF >> ${CODE_SERVER_PATH}/User/settings.json
{
    "terminal.integrated.shell.linux": "/bin/bash",
    "python.pythonPath": "/usr/bin/python3",
    "update.channel": "none",
    "workbench.colorTheme": "Default Dark+",
    "go.formatTool": "goimports"
}
EOF
sudo mv -f /root/.local/share/code-server/extensions $CODE_SERVER_PATH
sudo chown -R $USER_NAME:$GROUP_NAME $HOME_DIR
sudo chmod 750 $HOME_DIR
fi