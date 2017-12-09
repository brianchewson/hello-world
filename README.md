# markov-bash- 

## use a bash script to

1. take an input file
1. analyze the length of each line
1. analyze the frequency of letters
1. analyze the positional frequency of letters
1. generate new line based on the above criteria

## inputs
* filename - should contain a number of lines to analyze
* number - number of lines to generate after running the analysis

## outputs
1. a number of lines with content randomized content following the frequency and length limits based on the input file

## tests
* 0 length input file
** expected result: a message to the effect that there is no input
* 1 extremely long line
** expected result: a message that the file cannot be used
* binary file
** expected result: a message that the file cannot be used
* all other files
** expected result: correct number of lines generated
