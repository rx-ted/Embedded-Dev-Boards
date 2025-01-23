#!/bin/bash

source ../add_path.sh

REPOSITORY_YAML_FILE=$(find "$Embedded_Dev_Boards_PATH" -name "repository.yaml" -print -quit)
if [ -z "$REPOSITORY_YAML_FILE" ]; then
    echo 'repository.txt file is not found!'
    exit 1
fi

show_all_boars() {
    echo "Please select a board:"
    for board in $(cat "$REPOSITORY_YAML_FILE" | yq -e '.boards[]' -r); do
        echo "$board:"
        filter=.$board.driver_names\[\]
        for driver in $(cat "$REPOSITORY_YAML_FILE" | yq -e $filter -r); do
            echo "  - $driver"
        done
    done
    exit 1
}

check_board() {
    for board in $(cat "$REPOSITORY_YAML_FILE" | yq -e '.boards[]' -r); do
        filter=.$board.driver_names\[\]
        for driver in $(cat "$REPOSITORY_YAML_FILE" | yq -e $filter -r); do
            if [ "$1" = "$driver" ]; then
                local company=$(cat $REPOSITORY_YAML_FILE | yq -e .$board.company_name)
                echo "$board $driver $company"
                break
            fi
        done
    done
}

get_str_diff() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        exit 1
    fi
    local len1=${#1}
    local len2=${#2}
    if [ "$len1" -gt "$len2" ]; then
        local longer="$1"
        local shorter="$2"
    else
        local longer="$2"
        local shorter="$1"
    fi

    if [[ "$longer" == "$shorter"* ]]; then
        local suffix="${longer#$shorter}"
    fi
    if [ -z "$suffix" ]; then
        exit 1
    fi
    echo "$suffix"

}

download_repo() {
    url_prefix="https://dgithub.xyz"
    url_stuffix=$1"xx-hal-driver"
    url=$(echo $url_prefix/$2/$url_stuffix.git | tr -d '"')
    echo "Clone $url to $Embedded_Dev_Boards_PATH/Drivers/$url_stuffix"
    $(git clone $url $Embedded_Dev_Boards_PATH/Drivers/$url_stuffix)
    url_suffix1="cmsis-device-"$(get_str_diff "$3" $1)
    url1=$(echo $url_prefix/$2/$url_suffix1.git | tr -d '"')
    echo "Clone $url1 to $Embedded_Dev_Boards_PATH/Drivers/CMSIS/Device/$url_suffix1"
    $(git clone $url1 $Embedded_Dev_Boards_PATH/Drivers/CMSIS/Device/$url_suffix1)
}

user_input=${1:-""}
user_input_lower=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')

main() {
    if [ -z "$user_input" ]; then
        show_all_boars
    else
        result=$(check_board "$user_input_lower")
        if [ -z "$result" ]; then
            echo "Not found!"
            exit 1
        fi
        IFS=' ' read -r board_name driver_name company_name <<<"$result"
        download_repo $driver_name $company_name $board_name
    fi
}

main
