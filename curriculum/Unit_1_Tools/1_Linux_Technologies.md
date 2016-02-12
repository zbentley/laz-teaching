## Linux Technologies

This unit will get you started with shell programming, general Linux command usage (specifically text parsing), and will help cultivate a good understanding of files and pipes.

#### Bash/The Shell
- Create a string varaible in Bash, and print it out.
- Append another string to that same variable, and print out the appended result. 
- Print out that same variable in UPPER CASE without re-typing it capitalized (find out how to uppercase a string). Do this without using a `|` pipe or a second command; this should be pure Bash.
- Store the output of a command in a variable, and then print that variable.
- Given a list of words, e.g. `apple banana monkey douchebag`, write a Bash command _on a single line_ that prints out each of those words on its own line. Don't print out any trailing newlines.
	- XC: If you used a `|` pipe for the above, write another program that does the same thing, but using `for`. If you used `for` for the above, write a version that uses a pipe.
- Write a shell script in a single file that does the following:
	- Accepts arguments on the commandline (one or more; we only care about the first), e.g. `./my_script.sh argument1`.
	- If there is _no_ argument passed to the script, print out `Try again!`.
	- If the first argument to the script starts _and ends_ with the letter `a`, case insensitive, print out `Success!`.
	- Otherwise (if there is an argument but it doesn't start and end with `a`), print out a failure message of your choice.
	- XC: explain the difference between `[` and `[[` when used in `if` checks.
- On almost all Unixish systems, there is a massive dictionary of words in the user's language of choice contained in `/usr/share/dict/words`. Let's play with it.
	- Print out the first 10 words in the dictionary.
	- Print out the last 10 words in the dictionary.
	- Print out the first five characters of each of the first 10 words in the dictionary. Words shorter than 5 characters should be left alone. E.g. if the dictionary contained `adorable apple apples at`, your program should print (probably each on its own line, but you can format it however you like) `adora apple apple at`.
	- Print out all words starting with `Q` (capitalized) in the dictionary.
	- Print out all words starting with `Q` or `X` in the dictionary.
	- Print out the first 10 words starting with `Q` in the dictionary.
	- On the console, view the entire dictionary in such a way that you can scroll through it (i.e. it should be opened starting at `a`, and you should be able to navigate around, rather than printing out the whole thing and scrolling for 10 years to get back to the top).
	- Sort the entire dictionary in reverse (it's already sorted forwards).
		- XC: if you accomplished the above by reversing the file, do it using `sort`. If you accomplished the above using `sort`, try reversing the file.
			- Hint: Stack Overflow and other online forums have a little problem when it comes to Bash commands: they like to post incredibly elaborate, over-the-top examples/multiline, complex programs, when there are _already dedicated tools to get the job done_. When trying to do something simple in Bash/Linux, always read more than one answer, and try to find a solution that emphasizes brevity. This solution may not be any better or worse functionally, but it will save you from having to wrangle long strings of code in the long run.
			
#### Minifinal
- This one is kind of silly/contrived, but is useful at testing the above skills. Given the dictionary in `/usr/share/dict/words`, do the following:
	- Make a command that prints out the first letter of every word. This will generate a lot of output. Try using the pagination/navigation technique you learned in the previous excercise to manage the output more easily.
	- Now make that command deduplicate its output: it should only print one of each letter (case sensitive).
	- Now, it'll be printing out the alphabet in upper and lower case, e.g. `A a B b` or similar. Make it case insensitive, so it's only printing out one of each letter. They can all be uppercase or all lowercase; it doesn't matter.
	- At this point, it should just be printing out the alphabet. If there are non-letter characters in there, remove them from its output.
	- Make it print out the alphabet, generated using the above steps, *backwards*.
	- Put your command in a shell script, and run your command using the script.
	- Allow your command to operate on any file of text, not just `/usr/share/dict/words`. I should be able to give it a path to an *unsorted* file of words, and it should case-insensitively print out the reverse-sorted list of all of their first letters.
	- Make it possible to invoke your command from anywhere on your computer without writing out the full path to the script. You can use a shell script and modify `PATH` for this, move the script into a particular location, or use an alias; it's up to you.

#### Customization
- At the beginning of each line in your terminal, in the area before you can type, there is some information; usually the name of the computer, your username, and the directory you're in, e.g. `reid@laz /home/reid>` followed by your cursor. 	- Change the prompt of your terminal to _not_ display the username, and to end with a double-hash sign, e.g. `laz /home/reid##`, followed by your cursor.
	- Change the prompt of your terminal as outlined above, and do it such that it is still changed after you restart your computer.
	- Hint: this may not take effect immediately. You may need to start another shell to see the fruits of your labors.
- Create a single file "Hello world" program in Python. It should just print out a single, static line of text. Run it on the commandline. For example, you could have a Python script, `my_program.py`, and you could run it by saying `python /path/to/my_program.py`.
	- Make your script executable *without* having to type `python` at the beginning, and just be able to type `/path/to/my_program.py` and have it run.
		- Hint: you may have to modify the program slightly in addition to other steps to get this working.
	- Execute your script from within the directory in which it is stored, without typing the whole path. In the above examples, this would involve navigating into the `/path/to` directory, and invoking your script there *without* typing `python` or `/path/to` before its name.
		- Hint: there might have to be something *else* before the name, but it wont be a full path.
	- Customize your shell so that you can run your script from *anywhere* without the full path. In any directory, you should be able to type `my_program.py`, with no extra prefixes or other characters, and run your program.
	- Make the above customization permanent: if you start a new shell, or restart your computer, you should still be able to type `my_program.py` in any terminal anywhere and have it run.

#### Virtualization and OS Installation
- Research and be able to succinctly define and explain the following terms *in a useful way*. I am not interested in the wiki definitions; I want you to explain them to me as if I were going to use them, not just memorize them:
	- Hypervisor.
	- VirtualBox.
	- VMWare.
	- Parallels.
	- Bootloader.
	- ISO Image.
	- "Thin provisioned" or "Dynamically provisioned" virtual hard disks.
	- Virtual Machine snapshot.
- Using VirtualBox, create a new, empty virtual machine on your laptop, that satisfies the following:
	- The machine should not have an operating system yet.
	- It should be built to support 64-bit Ubuntu.
	- It should have 1GB of RAM provisioned for its use.
	- It should have a 20GB "thin provisioned" virtual hard disk.
	- It should have all available accelleration enabled: nested paging (if it's an option) and VT-X/AMD-V.
	- Hint: there will be lots of configurable things that aren't listed here. The above bullets are requirements, not a guide. You'll have to figure out the rest yourself.
- Start the virtual machine such that it advances to a screen that says something like "No bootable medium found!" with white text on a black background, or similar.
- Practice switching mouse control to and from your VM. There will be no mouse inside the VM at this time. Get used to switching back and forth.
	- Hint: before you give the VM control of your mouse, it might be a good idea to learn how to get control *back* when you want it.
- Power your virtual machine off and on again a couple of times. Get comfortable controlling it from within VirtualBox.
- Locate and make note of the current *actual* size of the virtual hard disk of your new VM. This is how many bytes of your laptop's hard drive are *currently* taken up by your VM, not how many *could* be taken up.
	- There are a few parts to this. You'll have to learn where VirtualBox keeps its files, go to that location, figure out which one is the virtual hard disk, and obtain the size of that file somehow.
	- XC: get the current size of the virtual hard disk using the terminal, and not the GUI.
- Download an ISO image of the Ubuntu-based Linux distribution of your choice (can be any of the Ubuntu family, or Mint, or whatever).
- Use the ISO image you downloaded to boot your VM into Linux.
	- Hint: this does _not_ involve installing Linux on the VM, nor does it involve burning a CD.
- With the VM still running and booted from the ISO, make a note of the current actual size ofits virtual hard disk.
- Explain why that size is what it is compared to your previous measurement.
- With the VM still running and booted from the ISO, ensure that the VM can connect to the internet.
	- This might be a little bit complicated, because networking is evil. There's no harm in trying lots of random stuff here, though, so give a few stabs at it before seeking help.
- Install Linux onto your VM, and then shut it down.
	- You can configure Linux however you want on your VM. What user accounts you use, software you install, or other configuration choices you make are totally up to you. Please use a password you're comfortable telling me, though.
- Delete the ISO image you downloaded, and start your VM into Linux.
- From inside your VM, shut it down.
- Make a snapshot of your VM, and then start it up again. 
- Inside your VM, in a terminal, do `sudo rm -rf /`, and then reboot your VM. Explain what happens after the reboot, and why.
	- Make sure you are certain that you're running this command *inside* your VM, not on your laptop/host OS.
- Roll your VM back to the snapshot you have taken, and start your VM. Explain why its behavior is different from your previous attempt to start it.

#### Network Usage
This one isn't called "networking" because you're not, well, doing any networking for it. But you are using various features of the network, so "network usage" it is!

- Find out, write down, and give me the IP and MAC address of your laptop, so I can give it a hostname.
- Find out, write down, and give me the IP and MAC address of your VM, so I can give it a hostname.
- SSH into your new VM.
- SSH into your new VM from another computer in the house.
	- Networking is kind of hard, in that failures don't give you any information. It's either "everything works", or "nothing works, and it could be due to any one of a hundred issues". Always check the basics first: Linux doesn't give you everything for free, and SSH is just like any other network service (like Apache, for example): it needs to be started and running. Is your virtual machine networked to your laptop? Virtual networking is weird, but there are easy graphical ways to configure it and lots of guides.
	- XC: SSH into your new VM *from your phone*.
- SSH into your new VM _without a password_.
- Explain to me how the files you created in the above step are used, and what they're for.
	- XC: explain to me what the commands you used to create/move/adjust those files are for/what they do.
