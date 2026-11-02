<img width="1600" height="900" alt="2026-10-08-162933_1600x900_scrot" src="https://github.com/user-attachments/assets/27399160-2210-402a-8a8c-441df2d3262b" />

```
sudo tar -xzf ~/reactionary-clean.tar.gz -C /usr/share/sddm/themes
sudo chown -R root:root /usr/share/sddm/themes/reactionary-clean
sudo chmod -R go-w /usr/share/sddm/themes/reactionary-clean

sudo mkdir -p /etc/sddm.conf.d
sudo tee /etc/sddm.conf.d/theme.conf >/dev/null <<'EOF'
[Theme]
Current=reactionary-clean
EOF
```
