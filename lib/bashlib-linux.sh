# @name bashlib-linux
# @brief A library of linux functions
# @description
#     A library of linux functions
#
#

# @description Function to convert numeric permissions to symbolic notation (ie letter)
linux::mode_to_symbolic() {

    local num=$1
    if [[ ! $num =~ ^[0-7]{3,4}$ ]]; then
        echo "Error: Invalid numeric permission format. Use 3 or 4 digits (0-7)"
        exit 1
    fi

    # Remove leading digit if present (special permissions)
    num=${num: -3}

    local result=""

    # Convert each digit
    for ((i=0; i<${#num}; i++)); do
        digit=${num:$i:1}
        case $i in
            0) user="u=" ;;
            1) user="g=" ;;
            2) user="o=" ;;
        esac

        # Convert digit to rwx format
        permissions=""
        (( digit & 4 )) && permissions+="r"
        (( digit & 2 )) && permissions+="w"
        (( digit & 1 )) && permissions+="x"
        [[ -z "$permissions" ]] && permissions="-"

        result+="$user$permissions "
    done

    echo "$result"
}

# @description Function to convert symbolic notation to numeric permissions
linux::mode_to_numeric() {
    local sym=$1
    if [[ ! $sym =~ ^[rwx-]{9}$ ]]; then
        echo "Error: Invalid symbolic permission format. Use 9 characters (rwx-)"
        exit 1
    fi

    local result=""

    # Process permissions in groups of 3
    for ((i=0; i<9; i+=3)); do
        local value=0
        local group=${sym:$i:3}

        [[ ${group:0:1} == "r" ]] && ((value+=4))
        [[ ${group:1:1} == "w" ]] && ((value+=2))
        [[ ${group:2:1} == "x" ]] && ((value+=1))

        result+="$value"
    done

    echo $result
}