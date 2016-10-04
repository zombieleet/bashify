#!/usr/bin/env bash

true=0
false=1
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

endsWith() {
    local char="${1}"
    local endswith="${2}"
    declare -i depth="${3}"

    {
	[[ -z "$char" ]] || [[ -z "$endswith" ]]
    } && printf "%s\n" "Usage: String ${FUNCNAME} string endToCheck ?depth" && return $false
    
    (( depth == 0 )) && depth=${#char}


    (
	character="${char}"
	for ((i=1;i<=$depth;i++)) {
		echo ${#character}
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
    # better still use ${var:position:length} to get the offset of a value
    
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

isInteger() {
    
    local number="${1}"
    
    [[ -z "${number}" ]] && {
	printf "%s\n" "Usage: ${FUNCNAME} number"
	return $false
    }
    
    # check if the content of $number is an alphabet or any punctuation mark

    (
	for ((i=0;i<=${#number};)) {
		while [ -n "$number" ];do
		    printNumber=$(printf "%c" "$number")
		    [[ ! $printNumber == [0-9] ]] && return $false
		    number=${number#*?}
		    : $(( i++ ))
		done
	    }
    )

    [[ $? == 1 ]] && return $false
    
    #if egrep -q "([[:alpha:]])|([[:punct:]])" <<<"${number}";then
    #return $false
    #fi
    
    return $true
}

int() {
    # get all the integers before the decimal point
    # non integers values will cause an error
    local integer="${1}"

    [[ -z "${integer}" ]] && {
	printf "%s\n" "Usage: ${FUNCNAME} number"
	return $false
    }

    isInteger $integer

    # if the exit status of "isInteger $integer" greater than 0 enter the below block of code
    [[ $? != 0 ]] && {
	# setting integer to another variable
	local privInteger=$integer
	local ind;
	for ((ind=0;ind<=${#privInteger};)) {
		
		# while privInteger is non-zero i.e if there is still information in privInteger
		
		while [ -n "$privInteger" ];do
		    # save the first character of privInteger in printchar variable
		    local printchar=$(printf "%c" "${privInteger}" )
		    # cut the first character in privInteger until there is nothing in privInteger
		    privInteger=${privInteger#*$printchar}
		    # incase printchar variable does not contain 0-9 or .
		    [[ ! $printchar =~ ([0-9\.]) ]] && {
			# declare a variable space
			local space=""
			# save integer again on another variable
			local int=$integer
			local err;
			for ((err=0;err<=${#int};)) {
				# this block of code , will add a single space to the space variable
				# aslong as int is non-zero and $pchar(see the next while loop ) does not equal printchar
				# Note:- $printchar is the single value that does not equal 0-9 or .
				# if a match is find return from this function with return code of 1
				while [ -n "${int}" ];do
				    local pchar=$(printf "%c" "${int}")
				    [[ $pchar == $printchar ]] && {
					printf "%s\n" "${integer}"
					printf "%s\n" "$space^Invalid character"	    
					return $false
				    }
				    space+=" "
				    : $(( err++ ))
				    # cut a single value from int until there is nothing inside
				    int=${int#*$pchar}
				done
				
			    } ; #end of $err
				
			    
		    } ; # End of $printchar
		    
		    #for ((period=0;period<=${#integer};period++)) {
		    #	echo $printchar
		    #   }
		    
		    : $(( ind++ ))
		done
		# printchar does not equal any punct value
		# cut any leading . forward
		printf "%s\n" "${integer%%.*}"
		return $true
	    }
    }
    printf "%s\n" "${integer}"
    return $true
    
    
}

raw() {
    # you might not need this
    local str="${1}"
    [[ -z "${@}" ]] && {
	printf "%s\n" "Usage: raw string"
    }
    sed 's|\\|\\\\|g' <<<"${str}"
}
destructure() {
    
    # do not quote the array argument ( first agument )
    # it is important you quote the second argument to this function
    # associative arrays work in alphabetical order
    # use "," to separate the variables to assign each array element to
    
    [[ -z "${@}" ]] && {
	
	printf "%s\n" "Usage: ${FUNCNAME}  array values"
	printf "%s\n" "destructure \${array[@]} \"var1,var2,,var3\""
	printf "%s\n" "The array should not be quoted but the variables to assign the array element should be quoted"
	return $false
    }
    
    # Substract 1 from the total number of arguments
    local arrayLength=$(( ${#@} - 1))
    # get the location of the last argument
    local str=$(( arrayLength + 1 ))
    # get the value of the last argument using indirect reference ( ! )
    local strToDestruct="${!str},"
    declare -i y=0;
    local varList;
    # loop through the length of arrayLength
    for ((i=0;i<=$arrayLength;)) {
	    # for j in the total number of arguments
	    for j ; do
		# if the value of i equals the length of our arrayLength variable, break from the 2 loops
		(( i == arrayLength )) && break 2;
		while [ -n "$strToDestruct" ] ;do
		    (( y == arrayLength )) && break 3;
		    local destruct=${strToDestruct%%,*}
		    strToDestruct=${strToDestruct#*,}
		    [[ -z "${destruct}" ]] && {
			declare -x null="null"
			varList+=$null, # ${!destruct} >> ignore this comment
			: $(( y++ ))
			continue
		    }
		    declare -g $destruct=$j
		    varList+=${!destruct},
		    : $(( y++ ))
		    continue 2;
		    
		done
		: $(( i++ ))
	    done
	}
	varList=${varList%,*}
	echo {$varList}
}

...() {
    # Spread a bunch of string inside an array
    # for example:-
    # str=bash
    # array=( $(... $str) )
    # echo ${str[@]}
    # b a s h
    
    local stringToSpread="$@"

    [[ -z "${stringToSpread}" ]] && {

	printf "%s\n" "Usage: ${FUNCNAME} string"
	return $false
    }
    [[ ${#@} -eq 1 ]] && {
	for ((i=0;i<=${#stringToSpread};i++)) {
		while [[ -n "${stringToSpread}" ]];do
		    printf "%c\n" "${stringToSpread}"		    
		    stringToSpread=${stringToSpread#*?}
		done
	    }
    }
    
    
    
}

map() {
    # dont'quote the array arugment ( i.e the first agument )
    echo ${#@}
    local array=$(( ${#@} - 1 ))
    local callback=$(( array + 1 ))
    declare -ga mapArray
    [[ -z ${#@} ]] && {
	printf "%s\n" "Usage: ${FUNCNAME} array callback"
	return $false
    }
    # stupid hack to test if argument 1 is an array
    [[ ${array} -le 1 ]] && {
	printf "%s\n" "Error: ${!array} is not an Array"
	return $false
    }

    [[ -z "${callback}" ]] && {
	printf "%s\n" "Error: No Callback argument was provided"
	return $false
    }
    declare -F ${!callback} >/dev/null
    [[ $? -ge 1 ]] && {
	eval ${!callback} &>/dev/null
	[[ $? -ge 1 ]] && {   
	    printf "%s\n" "Error: bad ${!callback} "
	    return $false
	} || {
	    echo "hi"
	    return $true
	}
    }
   
    for ((i=0;i<=${#array};)) {
	    for j;do
		(( i == array )) && break 2;
		mapArray+=( $(${!callback} $j) )

		: $(( i++ ))
	    done

	}
	echo ${mapArray[@]}
	
}
a=( 1 2 3 4 )
s() {
    echo $(( $1**$1))
}
map ${a[@]} "s"
