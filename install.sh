mkdir ~/bin # directory to help on installing language servers

# tailwind intellisense ... check for latest version
curl -L https://github.com/tailwindlabs/tailwindcss-intellisense/releases/download/v0.8.6/vscode-tailwindcss-0.8.6.vsix -o tailwindcss-intellisense.vsix

unzip -d ~/bin/ tailwindcss-intellisense.vsix
cd ~/bin
rm \[Content_Types\].xml extension.vsixmanifest
chmod +x extension/dist/server/index.js

cat <<EOF > tailwindcss-language-server
#!/usr/bin/env bash
 
DIR=\$(cd \$(dirname \$0); pwd)
node \$DIR/extension/dist/server/index.js \$*
EOF
 
chmod +x tailwindcss-language-server

# language servers
npm install -g typescript typescript-language-server
