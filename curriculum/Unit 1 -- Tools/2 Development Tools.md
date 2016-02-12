## Development Tools

The goal of this unit is to teach server technologies, development tools and workflows. The code is a very small part of this one; the configuration is much larger.

### Langauges/Runtimes
- Somewhere on your laptop, create a file that contains a single line of static text, followed by *two* newlines. The text can be anything and the file can be called whatever you like. An example of content of the file is:

	  <invisible start of file>
      this is some static text, and it's very boring
      
      
      <invisible end of file>
 
	- All of the below programs must read this file to get that string; they may not write it out themselves. I should be able to change the file, and re-run all 4 programs and have them print out the updated information without changing anything else.
- On your laptop, make a program in Java. That program should print three things, on the same line:
	- First, it should print out the time and date. 
	- Second, it should print out some static string.
	- Third, it should print out the string you wrote into the file.
	- An example output, given `hi, world!` as the second part, would be: `2012-08-10 10:45PM EST hi, world! this is some static text, and it's very boring`.
	- The date/time can be in any format.
	- The program must print to the console.
	- The program must not print any empty lines. When I run it, it should only print the one line, like so:
	
	
	        #~> java MyProgram.class
			2012-08-10 10:45PM EST hi, world! this is some static text, and it's very boring
			#~>
	
- On your laptop, make a program in Python that prints out the exact same information _in the exact same format_.
	- You can change the date format as you go through these different languages, but whatever format you pick needs to be exactly the same between the programs the same.
- On your laptop, make a terminal command (or shell script file) that prints out the exact same information _in the exact same format_.
	- You might want to make this one print out whatever date format you can make it do the first time, and then fix all of the other programs so they use that same format. That's not necessary, but Bash can be finnicky.
	- This can either be one long one-line command, or a shell script file.
	- XC: vica versa: if it's a one-liner, make it a shell-script file (with multiple lines and comments). If it's a shell-script file, make it a one-liner (no comments are necessary).
	
##### Minifinal:
- On your laptop, write a program in PHP that prints out the exact same information as the excercises above _in the exact same format_.
	- Two things are likely to trip you up here: a possible lack of PHP, and the fact that the program must write _to the console_, not a web page.
	- Hint: Neither Apache, MySQL, nor any sort of server are necessary for this.

### IDEs
- Install the IDE of your choice for Java. I suggest IntelliJ IDEA, Eclipse, or NetBeans, but you can use any IDE you wish.
- Create a new, empty project in the IDE, and copy the code from the java date-printing-from-file section of this excercise into that project.
- The IDE will probably present you with a lot of confusing options when you go to create a project. Figure out which one you need, and be able to explain why it is appropriate, and what at least two of the other project alternatives are for (I don't mean "is it a java project or a C++ project"; those are obvious. I'm referring to the specific *kinds* of java project, or different configuration settings for the project and what they do).
- Use the IDE to edit run your code directly; no terminal or other text editor should be open, and you should be able to make changes and test your program.
- Most IDEs have some sort of "redline" engine, like Microsoft Word. Red lines usually mean that a portion of code will not work; other indicators suggest that a piece of code will work, but could be improved. Now that your code is working, use one of those other indicators (lightbulbs or non-red lines, usually) to make a change to the code in your application. Be able to explain what the change did, and why it is an improvement (if it is an improvement).
- Do the above steps in the "IDEs" section for either the Python or PHP version of your date-printing program. You can use whatever IDE/language combination you wish; the IDEs that work for Java usually have plugin-based support for other languages, or you could google for and install a new IDE of your choice. You should still be able to edit, run, debug, and receive suggestions for your code in whatever IDE you choose.
- For either your Python, PHP, or Bash version of the date printer, do the following:
	- Learn about a command-line text editor. There are many. The most popular are Vim and Emacs.
	- Open a single terminal window.
	- *Without leaving that terminal window*, change the static (hardcoded) string that your program prints to be something else, and run your program to make sure that your changes are reflected.
	- XC: whatever command-line text editor you used, repeat the above steps using a different one.
	- XC: *without leaving the command-line editor*, run your code and ensure that its behavior reflects your changes.
- Be able to discuss some perceived strengths and/or weaknesses of any of the IDEs (graphical or command-line) that you used above. This is opinion only; I'm not going to argue with you (well, I might, but the point of this isn't to have a specific opinion, just to have one at all).

### Remote Development
- Figure out some way _that does not involve copy-and-paste_ to get the code you wrote for any *one* of the above multilanguage excercises onto your VM.
	- You can use any one of the excercises _other_ than the shell command (it's too easy).
	- There are countless ways to do this (move code). Specific ones will be discussed later; for this excercise, be free-form. You may have to try more than one thing, and you are welcome to use some feature of an IDE to accomplish this.
	- If you have to run a command to move the code, that's fine. Whatever you come up with doesn't have to be automatic.
	- XC: figure out a way to move your code from one location to the other that does not require entering your password at any point.
- Run your code on your virtual machine, inside the VirtualBox window. Ensure it works as expected on both your laptop and your virtual machine.
	- You might have to make some changes to your virtual machine (or your code) to make things work in both environments. Be prepared to spend some time on this step.
- Run your code on your virtual machine, via SSH.
- If you haven't already, configure your laptop to automatically update the code on your VM whenever you save a file.
	- This can be done however you like: you can maintain two copies of code and have an IDE synchronize the two on save; you can have one central storage location and have either your laptop or VM connect remotely to that location so there's only ever one version of the files, or you can use an external service to keep the two locations in snyc. It is very open ended and there are lots of ways to do it.
	- At the end of the day, you should be able to hit "save" in your editor of choice running on your laptop, and have those changes be available on your VM either immediately or within seconds, with no extra steps needed.