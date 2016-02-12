<h2 id="linux-technologies">Linux Technologies</h2>
<p>This unit will get you started with shell programming, general Linux command usage (specifically text parsing), and will help cultivate a good understanding of files and pipes.</p>
<h4 id="bashthe-shell">Bash/The Shell</h4>
<ul>
<li>Create a string varaible in Bash, and print it out.</li>
<li>Append another string to that same variable, and print out the appended result.</li>
<li>Print out that same variable in UPPER CASE without re-typing it capitalized (find out how to uppercase a string). Do this without using a <code>|</code> pipe or a second command; this should be pure Bash.</li>
<li>Store the output of a command in a variable, and then print that variable.</li>
<li>Given a list of words, e.g. <code>apple banana monkey douchebag</code>, write a Bash command <em>on a single line</em> that prints out each of those words on its own line. Don’t print out any trailing newlines.
<ul>
<li>XC: If you used a <code>|</code> pipe for the above, write another program that does the same thing, but using <code>for</code>. If you used <code>for</code> for the above, write a version that uses a pipe.</li>
</ul>
</li>
<li>Write a shell script in a single file that does the following:
<ul>
<li>Accepts arguments on the commandline (one or more; we only care about the first), e.g. <code>./my_script.sh argument1</code>.</li>
<li>If there is <em>no</em> argument passed to the script, print out <code>Try again!</code>.</li>
<li>If the first argument to the script starts <em>and ends</em> with the letter <code>a</code>, case insensitive, print out <code>Success!</code>.</li>
<li>Otherwise (if there is an argument but it doesn’t start and end with <code>a</code>), print out a failure message of your choice.</li>
<li>XC: explain the difference between <code>[</code> and <code>[[</code> when used in <code>if</code> checks.</li>
</ul>
</li>
<li>On almost all Unixish systems, there is a massive dictionary of words in the user’s language of choice contained in <code>/usr/share/dict/words</code>. Let’s play with it.
<ul>
<li>Print out the first 10 words in the dictionary.</li>
<li>Print out the last 10 words in the dictionary.</li>
<li>Print out the first five characters of each of the first 10 words in the dictionary. Words shorter than 5 characters should be left alone. E.g. if the dictionary contained <code>adorable apple apples at</code>, your program should print (probably each on its own line, but you can format it however you like) <code>adora apple apple at</code>.</li>
<li>Print out all words starting with <code>Q</code> (capitalized) in the dictionary.</li>
<li>Print out all words starting with <code>Q</code> or <code>X</code> in the dictionary.</li>
<li>Print out the first 10 words starting with <code>Q</code> in the dictionary.</li>
<li>On the console, view the entire dictionary in such a way that you can scroll through it (i.e. it should be opened starting at <code>a</code>, and you should be able to navigate around, rather than printing out the whole thing and scrolling for 10 years to get back to the top).</li>
<li>Sort the entire dictionary in reverse (it’s already sorted forwards).
<ul>
<li>XC: if you accomplished the above by reversing the file, do it using <code>sort</code>. If you accomplished the above using <code>sort</code>, try reversing the file.
<ul>
<li>Hint: Stack Overflow and other online forums have a little problem when it comes to Bash commands: they like to post incredibly elaborate, over-the-top examples/multiline, complex programs, when there are <em>already dedicated tools to get the job done</em>. When trying to do something simple in Bash/Linux, always read more than one answer, and try to find a solution that emphasizes brevity. This solution may not be any better or worse functionally, but it will save you from having to wrangle long strings of code in the long run.</li>
</ul>
</li>
</ul>
</li>
</ul>
</li>
</ul>
<h4 id="minifinal">Minifinal</h4>
<ul>
<li>This one is kind of silly/contrived, but is useful at testing the above skills. Given the dictionary in <code>/usr/share/dict/words</code>, do the following:
<ul>
<li>Make a command that prints out the first letter of every word. This will generate a lot of output. Try using the pagination/navigation technique you learned in the previous excercise to manage the output more easily.</li>
<li>Now make that command deduplicate its output: it should only print one of each letter (case sensitive).</li>
<li>Now, it’ll be printing out the alphabet in upper and lower case, e.g. <code>A a B b</code> or similar. Make it case insensitive, so it’s only printing out one of each letter. They can all be uppercase or all lowercase; it doesn’t matter.</li>
<li>At this point, it should just be printing out the alphabet. If there are non-letter characters in there, remove them from its output.</li>
<li>Make it print out the alphabet, generated using the above steps, <em>backwards</em>.</li>
<li>Put your command in a shell script, and run your command using the script.</li>
<li>Allow your command to operate on any file of text, not just <code>/usr/share/dict/words</code>. I should be able to give it a path to an <em>unsorted</em> file of words, and it should case-insensitively print out the reverse-sorted list of all of their first letters.</li>
<li>Make it possible to invoke your command from anywhere on your computer without writing out the full path to the script. You can use a shell script and modify <code>PATH</code> for this, move the script into a particular location, or use an alias; it’s up to you.</li>
</ul>
</li>
</ul>
<h4 id="customization">Customization</h4>
<ul>
<li>At the beginning of each line in your terminal, in the area before you can type, there is some information; usually the name of the computer, your username, and the directory you’re in, e.g. <code>reid@laz /home/reid&gt;</code> followed by your cursor. 	- Change the prompt of your terminal to <em>not</em> display the username, and to end with a double-hash sign, e.g. <code>laz /home/reid##</code>, followed by your cursor.
<ul>
<li>Change the prompt of your terminal as outlined above, and do it such that it is still changed after you restart your computer.</li>
<li>Hint: this may not take effect immediately. You may need to start another shell to see the fruits of your labors.</li>
</ul>
</li>
<li>Create a single file “Hello world” program in Python. It should just print out a single, static line of text. Run it on the commandline. For example, you could have a Python script, <code>my_program.py</code>, and you could run it by saying <code>python /path/to/my_program.py</code>.
<ul>
<li>Make your script executable <em>without</em> having to type <code>python</code> at the beginning, and just be able to type <code>/path/to/my_program.py</code> and have it run.
<ul>
<li>Hint: you may have to modify the program slightly in addition to other steps to get this working.</li>
</ul>
</li>
<li>Execute your script from within the directory in which it is stored, without typing the whole path. In the above examples, this would involve navigating into the <code>/path/to</code> directory, and invoking your script there <em>without</em> typing <code>python</code> or <code>/path/to</code> before its name.
<ul>
<li>Hint: there might have to be something <em>else</em> before the name, but it wont be a full path.</li>
</ul>
</li>
<li>Customize your shell so that you can run your script from <em>anywhere</em> without the full path. In any directory, you should be able to type <code>my_program.py</code>, with no extra prefixes or other characters, and run your program.</li>
<li>Make the above customization permanent: if you start a new shell, or restart your computer, you should still be able to type <code>my_program.py</code> in any terminal anywhere and have it run.</li>
</ul>
</li>
</ul>
<h4 id="virtualization-and-os-installation">Virtualization and OS Installation</h4>
<ul>
<li>Research and be able to succinctly define and explain the following terms <em>in a useful way</em>. I am not interested in the wiki definitions; I want you to explain them to me as if I were going to use them, not just memorize them:
<ul>
<li>Hypervisor.</li>
<li>VirtualBox.</li>
<li>VMWare.</li>
<li>Parallels.</li>
<li>Bootloader.</li>
<li>ISO Image.</li>
<li>“Thin provisioned” or “Dynamically provisioned” virtual hard disks.</li>
<li>Virtual Machine snapshot.</li>
</ul>
</li>
<li>Using VirtualBox, create a new, empty virtual machine on your laptop, that satisfies the following:
<ul>
<li>The machine should not have an operating system yet.</li>
<li>It should be built to support 64-bit Ubuntu.</li>
<li>It should have 1GB of RAM provisioned for its use.</li>
<li>It should have a 20GB “thin provisioned” virtual hard disk.</li>
<li>It should have all available accelleration enabled: nested paging (if it’s an option) and VT-X/AMD-V.</li>
<li>Hint: there will be lots of configurable things that aren’t listed here. The above bullets are requirements, not a guide. You’ll have to figure out the rest yourself.</li>
</ul>
</li>
<li>Start the virtual machine such that it advances to a screen that says something like “No bootable medium found!” with white text on a black background, or similar.</li>
<li>Practice switching mouse control to and from your VM. There will be no mouse inside the VM at this time. Get used to switching back and forth.
<ul>
<li>Hint: before you give the VM control of your mouse, it might be a good idea to learn how to get control <em>back</em> when you want it.</li>
</ul>
</li>
<li>Power your virtual machine off and on again a couple of times. Get comfortable controlling it from within VirtualBox.</li>
<li>Locate and make note of the current <em>actual</em> size of the virtual hard disk of your new VM. This is how many bytes of your laptop’s hard drive are <em>currently</em> taken up by your VM, not how many <em>could</em> be taken up.
<ul>
<li>There are a few parts to this. You’ll have to learn where VirtualBox keeps its files, go to that location, figure out which one is the virtual hard disk, and obtain the size of that file somehow.</li>
<li>XC: get the current size of the virtual hard disk using the terminal, and not the GUI.</li>
</ul>
</li>
<li>Download an ISO image of the Ubuntu-based Linux distribution of your choice (can be any of the Ubuntu family, or Mint, or whatever).</li>
<li>Use the ISO image you downloaded to boot your VM into Linux.
<ul>
<li>Hint: this does <em>not</em> involve installing Linux on the VM, nor does it involve burning a CD.</li>
</ul>
</li>
<li>With the VM still running and booted from the ISO, make a note of the current actual size ofits virtual hard disk.</li>
<li>Explain why that size is what it is compared to your previous measurement.</li>
<li>With the VM still running and booted from the ISO, ensure that the VM can connect to the internet.
<ul>
<li>This might be a little bit complicated, because networking is evil. There’s no harm in trying lots of random stuff here, though, so give a few stabs at it before seeking help.</li>
</ul>
</li>
<li>Install Linux onto your VM, and then shut it down.
<ul>
<li>You can configure Linux however you want on your VM. What user accounts you use, software you install, or other configuration choices you make are totally up to you. Please use a password you’re comfortable telling me, though.</li>
</ul>
</li>
<li>Delete the ISO image you downloaded, and start your VM into Linux.</li>
<li>From inside your VM, shut it down.</li>
<li>Make a snapshot of your VM, and then start it up again.</li>
<li>Inside your VM, in a terminal, do <code>sudo rm -rf /</code>, and then reboot your VM. Explain what happens after the reboot, and why.
<ul>
<li>Make sure you are certain that you’re running this command <em>inside</em> your VM, not on your laptop/host OS.</li>
</ul>
</li>
<li>Roll your VM back to the snapshot you have taken, and start your VM. Explain why its behavior is different from your previous attempt to start it.</li>
</ul>
<h4 id="network-usage">Network Usage</h4>
<p>This one isn’t called “networking” because you’re not, well, doing any networking for it. But you are using various features of the network, so “network usage” it is!</p>
<ul>
<li>Find out, write down, and give me the IP and MAC address of your laptop, so I can give it a hostname.</li>
<li>Find out, write down, and give me the IP and MAC address of your VM, so I can give it a hostname.</li>
<li>SSH into your new VM.</li>
<li>SSH into your new VM from another computer in the house.
<ul>
<li>Networking is kind of hard, in that failures don’t give you any information. It’s either “everything works”, or “nothing works, and it could be due to any one of a hundred issues”. Always check the basics first: Linux doesn’t give you everything for free, and SSH is just like any other network service (like Apache, for example): it needs to be started and running. Is your virtual machine networked to your laptop? Virtual networking is weird, but there are easy graphical ways to configure it and lots of guides.</li>
<li>XC: SSH into your new VM <em>from your phone</em>.</li>
</ul>
</li>
<li>SSH into your new VM <em>without a password</em>.</li>
<li>Explain to me how the files you created in the above step are used, and what they’re for.
<ul>
<li>XC: explain to me what the commands you used to create/move/adjust those files are for/what they do.</li>
</ul>
</li>
</ul>