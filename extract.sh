#!/bin/bash

LOG_FILE="/tmp/extracted_7z_list.txt"
touch "$LOG_FILE"

while true; do
clear

cat <<EOF
┌──────────────────────────────┐
│        MENU GIAI NEN         │
├──────────────────────────────┤
│ 1) Giai nen tat ca           │
│ 2) Giai nen file chi dinh    │
│ 0) Thoat                     │
└──────────────────────────────┘
EOF

echo
read -p "Chon: " choice
echo

case $choice in

1)
    echo "Dang giai nen tat ca file..."
    echo

    for file in *.zip *.rar *.7z *.tar *.tar.gz *.tgz *.tar.xz *.gz; do
        [ -e "$file" ] || continue

        if grep -Fxq "$file" "$LOG_FILE"; then
            echo "Bo qua (da giai nen): $file"
            continue
        fi

        echo "Dang giai nen: $file"
        7z x "$file"

        echo "$file" >> "$LOG_FILE"
        echo
    done

    echo "Hoan tat!"
    read -p "Nhan Enter de quay lai menu..."
    ;;

2)
    read -p "Nhap ten file can giai nen: " file
    echo

    if [ ! -f "$file" ]; then
        echo "File khong ton tai!"
    else
        echo "Dang giai nen: $file"
        7z x "$file"
    fi

    echo
    read -p "Nhan Enter de quay lai menu..."
    ;;

0)
    echo "Thoat chuong trinh!"
    exit 0
    ;;

*)
    echo "Lua chon khong hop le!"
    read -p "Nhan Enter de thu lai..."
    ;;

esac

done
