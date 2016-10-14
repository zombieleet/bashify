# bashify
List of helper functions

#repeatString
repeats a string 

`repeatString string ?depth`

`depth >> how many times to repeat the string`

`repeatString "bash" 5`

`>>> bashbashbash `

#charAt
get the character position of a string

`charAt string positionToSearch`

`charAt "bash" 2`

`>>> a`

#includes
check if a word is in a string

`includes string stringToSearch ?depth`

`depth >> where to start search from`

`includes "bash" sh 2`

`returns 1 for false or 0 for true`

#endsWith
check if a word is the end in a string

`endsWith string endToCheck ?depth`

`depth >>> where to start the search from`

`endsWith "bash" a 2`

`returns 1 for false or 0 for true`

#isInteger
check if a value is an integer

`isInteger number`

`return 1 for non integers or 0 for integers`

#int
get all the integers before the decimal point
non integers values will cause an error

`int number`

`int 25.8`

`25`

#destructure
set the content of an array into different variables
gotchas:- do not quote the array argument ( first agument )
          it is important you quote the second argument to this function
          associative arrays work in alphabetical order
          use "," to separate the variables to assign each array element to
          
`destrucutre array values`

`array=( bash ksh zsh )`

`destructre ${array[@]} "shell1,,shell2"`

`echo $shell1  > bash`

`echo $shell2 > zsh `

`destructure ${array[@]} "shell1,shell2,shell3"`

`echo $shell1 > bash`

`echo $shell2 > ksh`

`echo $shell3 > zsh`

#...
Spread a bunch of string inside an array

`... string`

`str=bash`

`array=( $(... $str) )`

`echo ${str[@]}`

`>> b a s h`

#foreach
foreach element of an array execute a function 
gotchas: dont'quote the array arugment ( i.e the first agument )
         If you pass in a function as the callback using the function command you should wrap it in single quotes
         
`s() { echo $(( $1 * $1 )) ;}`

`array=( 1 2 3 4 5 6 )`

`foreach ${array[@]} s`

`>>> 2 4 6 8 10 12`

`foreach ${array[@]} 'function s() { echo $(( $1 + $1 )) ;}' >> always end the function with a (
;} )  `

`>>> 2 4 6 8 10 12`


#copyWithin
copy an array index into another index
quote the first argument use ${array[\*]} instead of ${array[@]}

`copyWithin arrayArgument indexToCopyfrom indexToCopyTo`

`array=( "bash" "ksh" "zsh" "csh" )`

`copyWithin "${array[*]}" 1 3`

`bash ksh zsh ksh`

