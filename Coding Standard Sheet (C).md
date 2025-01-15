# Do's:
- Be consistent
- Make it readable
- Use Header File Guards
```C
#ifndef sys_socket_h
  #define sys_socket_h  /* NOT _sys_socket_h_ */
  #endif
```
- Ensure Exceptions are setup where Errors will be most present due to external issues
- Comments should be enough to explain the code to anyone
- Ask for help/consensus (this format is just a quick lookup guide and should grow with us as we run into issues)
# Do not's
- Magic numbers
- Undescriptive names
- Too little commenting 
- Deep nesting
- Long lines (~80 characters long)
- Long functions
- 
# Naming
## Variable Names
 - Snake Case
 - Include units if possible for clarity
 - They can be funny as long as they are descriptive 
```C
uint32 weight_lbs;
string main_menu_title;
```
### Global Variables
- Preface these with "g_" in order to not confuse them with normal variables
```C
uint32 g_buffer;
```
### Constants/Defines
- All uppercase
- '\_' separating words
```C
#define MAX 10

const int BALL_RADIUS = 5; 
```
### Enum Names
- Camel Caps for the enum type
- All caps and '\_' spaces for the labels
```C
enum PinStateType {
	PIN_OFF,
	PIN_ON
};
```
## Function Names 
- Descriptive names
- Snake Case
- Whatever you feel is a good length
```C
void make_chopped_cheese () {
	choppedCheese++;
	return;
}
```
# Statement Structures
## Switch/Case Statement
```C
switch (num)  // Brackets start on next line
{
	case 1: 
		do_logic(num);
		break;
	default: 
		smooth_balls();
		break;
}
```
## If-else
- One line form for if statements are okay
```C
if (bool) {  // Brackets start on same line
	do_logic(num);
} /* Add comment here of what the condition does */
else if (true) {
	smooth_balls();
} /* Add comment here of what the condition does */
else {
	continue;
} /* Add comment here of what the condition does */

// One liners
if (bool) { do_logic(num); }
```
## Loops
```C
for (int i=0; i < 5; i++) {
	rotate(i);
} /* Add comment here of what the condition does */

while (1) {
	boom_boom("help");
} /* Add comment here of what the condition does */
```

# Parentheses ()
- Add a space between keywords & the Parentheses
- No need for a space when it comes to functions 
- This is how we will subtly differentiate the two
```C
while (isFalling) {  // Space between keyword "while" and condition
	decrease_altitude(-1);  // No space 
}
```
# Header Comments
## File Headers
```C
/************************************************************
* Module Name 
* Date of Creation
* Name of Creator(s)
* History of Modification
* Summary of Module
************************************************************/
```
## Function Headers
```C
/************************************************************
* Function Name 
* Summary of Function
************************************************************/
```
# Indenting
- Indenting will be 4 spaces (should be able to change this in your editor if needed)
- Indent further in every code block { }
---
# Sources for Deeper Dives
[BrowserStack](https://www.browserstack.com/guide/coding-standards-best-practices)
[Carnegie Mellon University C Coding Standard](https://users.ece.cmu.edu/~eno/coding/CCodingStandard.html#initvar)
[Texas A&M](https://people.engr.tamu.edu/j-welch/teaching/cstyle.html)