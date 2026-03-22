#!/bin/bash

LOG_FILE="/tmp/extracted_7z_list.txt"
MAX_JOBS=3  
touch "$LOG_FILE"

extract_file () {
    file="$1"

    echo "Bat dau: $file"

    7z x "$file" -bsp1 -bso0 | while read -r line; do
        if [[ "$line" =~ ([0-9]+)% ]]; then
            printf "\r%-40s %3s%%" "$file" "${BASH_REMATCH[1]}"
        fi
    done

    echo
    echo "$file" >> "$LOG_FILE"
    echo "Xong: $file"
}

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
    job_count=0

    for file in *.zip *.rar *.7z *.tar *.tar.gz *.tgz *.tar.xz *.gz; do
        [ -e "$file" ] || continue

        if grep -Fxq "$file" "$LOG_FILE"; then
            echo "Bo qua (da giai nen): $file"
            continue
        fi

        extract_file "$file" &

        ((job_count++))

        if (( job_count >= MAX_JOBS )); then
            wait -n
            ((job_count--))
        fi
    done

    wait
    echo
    echo "Hoan tat!"
    read -p "Nhan Enter de quay lai menu..."
    ;;

2)
    read -p "Nhap ten file can giai nen: " file

    if [ ! -f "$file" ]; then
        echo "File khong ton tai!"
    else
        extract_file "$file"
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
