#!/usr/bin/env bash
true=0
false=0
checkBashVersion() {
    local version="${BASHVERSINFO}"
    printf "%s\n" "${version}"
}
<<EOF
checkNumberOfArgs() {
    declare -i numArgs="$((${1} - 1))"
    declare -i requiredNumArgs="${2}"
    
    (( numArgs > requiredNumArgs )) && \
	printf "%s\n" "Error: requires ${requiredNumArgs} args, but passed ${numArgs} args" && return $false
}

String() {
    local stringFunction=${1}
    case ${stringFunction} in
	repeatString)
	    checkNumberOfArgs ${#@} 2
	    repeatString "${2}" "${3}" ;;
	endsWidth)
	;;
	charAt)
	    checkNumberOfArgs ${#@} 2
	    charAt "${2}" "${3}"
	    ;;
	startsWidth) ;;
	includes) ;;
	*) printf "%s\n" "${stringFunction} is not a valid string operation" && return $false;;
    esac
}
EOF

repeatString() {
    local stringToRepeat="${1}"
    declare -i depth="${2}"
    
    if [[ -z "${stringToRepeat}" ]];then
	printf "%s\n" "Usage: String ${FUNCNAME} string ?depth"
	return $false
    fi
    
    (( depth == 0 )) && depth=1
    
    (
	# depthIndex will loose it value after been executed in this subshell
	
	for ((depthIndex=0;depthIndex<${depth};depthIndex+=1)) {
		
		printf "%s" "${stringToRepeat}"
		
	    }
	    
	    printf "\n"				
    )
    
}

charAt() {
    local  char="${1}"
    declare -i charPosition=${2}
    
    [[ -z "${char}" ]] && \
	printf "%s\n" "Usage: String ${FUNCNAME} string (position to extract string)" && return $false
    
    {
	[[ ${charPosition} -eq 0 ]] && printf "%c\n" "${char}" && return $true
    } || {
	# if the position specified is greater than the length of the string print out an empty string
	[[ ${charPosition} -gt ${#char} ]] && printf "%s\n" "" && return $true
    }
    
    
    
    (
	# All the variables delcared here will get lost after this subshell finsih executing
	
	local temp=${char}
	local cutFirstString
	declare -i i=0
	while [[ -n "${temp}" ]];do
	    #if [[ $charPosition == $i ]];then
	    #	printf "%c" 
	    #fi
	    : $((i++))
	    cutFirstString=$(printf "%c" "${temp}")
	    temp=${temp#*$cutFirstString}
	    (( i == charPosition )) && printf "%s\n" "${cutFirstString}"
	    
	done
    )
}

endsWidth() {
    #FIX:It does not work with range of characters
    local char="${1}"
    local endswith="${2}"
    declare -i depth="${3}"

    {
	[[ -z "$char" ]] || [[ -z "$endswith" ]]
    } && printf "%s\n" "Usage: String ${FUNCNAME} string endToCheck ?depth" && return $false
    
    (( depth == 0 )) && depth=${#char}


    (
	local character="${char}"
	for ((i=1;i<=$depth;i++)) {
		
		while [ -n "$character" ];do
		    
		    printOne=$(printf "%c" "$character")
		    character=${character#*"${printOne}"}
		    
		    (( i == depth )) && {
			
			[[ "${printOne}" == "${endswith}" ]] && {
			    printf "%s\n" "true" && return $true\
							   
			} || {
			    printf "%s\n" "false"
			    return $false
			}
			
			
		    } || {
			
			continue 2;
		    }
		    
		done
		
	    }
    )
    
}

offset() {
    
    # Bug: It does not deal with negative numbers
    local string=${1}
    local position=${2}
    local length=${3}

    [[ -z "${string}" ]] && printf "%s\n" "Error: String to work with was not specified" && \
	
	printf "%s\n" "Usage: ${FUNCNAME} string ?postion ?length" && return $false
    

    if [[ -z "${position}" ]] && [[ -z "${length}" ]];then
	
	printf "%s\n" "${string}"
	return $true
	
    fi

    [[ "${position}" =~ [A-Za-z] ]] && \
	printf "%s\n" "Error: Required an integer for postion but got a string"  && return $false
    [[ "${length}"  =~ [A-Za-z] ]] && \
	printf "%s\n" "Error: Required an integer for length but got a string" && return $false

    if [[ ${position} -gt ${#string} ]] || [[ ${length} -gt ${#string} ]] ;then
	
	printf "%s\n" "Error: index is greater than string length"
	return $false
    fi
    
    (
	# Kill all the variables declared inside this subshell when done
	# Using index++ inside the for (()) introduced an unwanted feature
	# i had  to take it to the body of the while loop
	for ((index=0;index<=${#string};)) {	
		while [ -n "${string}" ];do

		    (( index == position )) && {
			# If the value of index equals to the position specified run this block of code
			# if length is null print the string and return from this function ${FUNCNAME}
			[[ -z "${length}" ]] && printf "%s\n" "${string}" && return $true

			# if length is not null get the offset specified by the user
			for ((ind=0;ind<=${#string};)) {
				
				while [ -n "${string}" ];do
				    
				    (( ${#string} == length )) && {
					echo "$string" && return $true;
				    }
				    # rev revserses the string
				    # TODO: Implement your on rev function , incase rev is not installed on the users box
				    string=${string%$(printf "%c" "$(rev <<<${string})")*}
				    # : >> don't run the result of $(( ind++ ))
				    # better still ind=$(( ind++ ))
				    : $(( ind++ ))
				done
			    }

			
			
			
		    }
		    
		    printOneChar=$(printf "%c" "${string}" )
		    string=${string#*$printOneChar}
		    : $((index++))
		done
	    }
    )

}

isNumber() {
    :
}

isString() {
    :
}

int() {
    :
}

raw() {
    :
}

destructure() {
    :
}
