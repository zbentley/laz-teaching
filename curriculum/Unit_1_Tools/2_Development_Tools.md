<h2 id="development-tools">Development Tools</h2>
<p>The goal of this unit is to teach server technologies, development tools and workflows. The code is a very small part of this one; the configuration is much larger.</p>
<h3 id="langaugesruntimes">Langauges/Runtimes</h3>
<ul>
<li>
<p>Somewhere on your laptop, create a file that contains a single line of static text, followed by <em>two</em> newlines. The text can be anything and the file can be called whatever you like. An example of content of the file is:</p>
<pre><code>&lt;invisible start of file&gt;
this is some static text, and it's very boring


&lt;invisible end of file&gt;
</code></pre>
<ul>
<li>All of the below programs must read this file to get that string; they may not write it out themselves. I should be able to change the file, and re-run all 4 programs and have them print out the updated information without changing anything else.</li>
</ul>
</li>
<li>
<p>On your laptop, make a program in Java. That program should print three things, on the same line:</p>
<ul>
<li>First, it should print out the time and date.</li>
<li>Second, it should print out some static string.</li>
<li>Third, it should print out the string you wrote into the file.</li>
<li>An example output, given <code>hi, world!</code> as the second part, would be: <code>2012-08-10 10:45PM EST hi, world! this is some static text, and it's very boring</code>.</li>
<li>The date/time can be in any format.</li>
<li>The program must print to the console.</li>
<li>The program must not print any empty lines. When I run it, it should only print the one line, like so:</li>
</ul>
</li>
</ul>
<pre><code>        #~&gt; java MyProgram.class
		2012-08-10 10:45PM EST hi, world! this is some static text, and it's very boring
		#~&gt;
</code></pre>
<ul>
<li>On your laptop, make a program in Python that prints out the exact same information <em>in the exact same format</em>.
<ul>
<li>You can change the date format as you go through these different languages, but whatever format you pick needs to be exactly the same between the programs the same.</li>
</ul>
</li>
<li>On your laptop, make a terminal command (or shell script file) that prints out the exact same information <em>in the exact same format</em>.
<ul>
<li>You might want to make this one print out whatever date format you can make it do the first time, and then fix all of the other programs so they use that same format. That’s not necessary, but Bash can be finnicky.</li>
<li>This can either be one long one-line command, or a shell script file.</li>
<li>XC: vica versa: if it’s a one-liner, make it a shell-script file (with multiple lines and comments). If it’s a shell-script file, make it a one-liner (no comments are necessary).</li>
</ul>
</li>
</ul>
<h3 id="minifinal">Minifinal</h3>
<ul>
<li>On your laptop, write a program in PHP that prints out the exact same information as the exercises above <em>in the exact same format</em>.
<ul>
<li>Two things are likely to trip you up here: a possible lack of PHP, and the fact that the program must write <em>to the console</em>, not a web page.</li>
<li>Hint: Neither Apache, MySQL, nor any sort of server are necessary for this.</li>
</ul>
</li>
</ul>
<h3 id="ides">IDEs</h3>
<ul>
<li>Install the IDE of your choice for Java. I suggest IntelliJ IDEA, Eclipse, or NetBeans, but you can use any IDE you wish.</li>
<li>Create a new, empty project in the IDE, and copy the code from the java date-printing-from-file section of this exercise into that project.</li>
<li>The IDE will probably present you with a lot of confusing options when you go to create a project. Figure out which one you need, and be able to explain why it is appropriate, and what at least two of the other project alternatives are for (I don’t mean “is it a java project or a C++ project”; those are obvious. I’m referring to the specific <em>kinds</em> of java project, or different configuration settings for the project and what they do).</li>
<li>Use the IDE to edit run your code directly; no terminal or other text editor should be open, and you should be able to make changes and test your program.</li>
<li>Most IDEs have some sort of “redline” engine, like Microsoft Word. Red lines usually mean that a portion of code will not work; other indicators suggest that a piece of code will work, but could be improved. Now that your code is working, use one of those other indicators (lightbulbs or non-red lines, usually) to make a change to the code in your application. Be able to explain what the change did, and why it is an improvement (if it is an improvement).</li>
<li>Do the above steps in the “IDEs” section for either the Python or PHP version of your date-printing program. You can use whatever IDE/language combination you wish; the IDEs that work for Java usually have plugin-based support for other languages, or you could google for and install a new IDE of your choice. You should still be able to edit, run, debug, and receive suggestions for your code in whatever IDE you choose.</li>
<li>For either your Python, PHP, or Bash version of the date printer, do the following:
<ul>
<li>Learn about a command-line text editor. There are many. The most popular are Vim and Emacs.</li>
<li>Open a single terminal window.</li>
<li><em>Without leaving that terminal window</em>, change the static (hardcoded) string that your program prints to be something else, and run your program to make sure that your changes are reflected.</li>
<li>XC: whatever command-line text editor you used, repeat the above steps using a different one.</li>
<li>XC: <em>without leaving the command-line editor</em>, run your code and ensure that its behavior reflects your changes.</li>
</ul>
</li>
<li>Be able to discuss some perceived strengths and/or weaknesses of any of the IDEs (graphical or command-line) that you used above. This is opinion only; I’m not going to argue with you (well, I might, but the point of this isn’t to have a specific opinion, just to have one at all).</li>
</ul>
<h3 id="remote-development">Remote Development</h3>
<ul>
<li>Figure out some way <em>that does not involve copy-and-paste</em> to get the code you wrote for any <em>one</em> of the above multilanguage exercises onto your VM.
<ul>
<li>You can use any one of the excercises <em>other</em> than the shell command (it’s too easy).</li>
<li>There are countless ways to do this (move code). Specific ones will be discussed later; for this excercise, be free-form. You may have to try more than one thing, and you are welcome to use some feature of an IDE to accomplish this.</li>
<li>If you have to run a command to move the code, that’s fine. Whatever you come up with doesn’t have to be automatic.</li>
<li>XC: figure out a way to move your code from one location to the other that does not require entering your password at any point.</li>
</ul>
</li>
<li>Run your code on your virtual machine, inside the VirtualBox window. Ensure it works as expected on both your laptop and your virtual machine.
<ul>
<li>You might have to make some changes to your virtual machine (or your code) to make things work in both environments. Be prepared to spend some time on this step.</li>
</ul>
</li>
<li>Run your code on your virtual machine, via SSH.</li>
<li>If you haven’t already, configure your laptop to automatically update the code on your VM whenever you save a file.
<ul>
<li>This can be done however you like: you can maintain two copies of code and have an IDE synchronize the two on save; you can have one central storage location and have either your laptop or VM connect remotely to that location so there’s only ever one version of the files, or you can use an external service to keep the two locations in snyc. It is very open ended and there are lots of ways to do it.</li>
<li>At the end of the day, you should be able to hit “save” in your editor of choice running on your laptop, and have those changes be available on your VM either immediately or within seconds, with no extra steps needed.</li>
</ul>
</li>
</ul>