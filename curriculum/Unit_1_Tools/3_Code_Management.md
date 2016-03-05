<h2 id="code-management">Code Management</h2>
<h4 id="organization">Organization</h4>
<ul>
<li>Take the program from the final of the “Development Tools” unit, and give it two entry points: one for the console, and one for the web. The code to actually print out the “hostname :: time :: static string” should only be written in one place.
<ul>
<li>If this is Java, you can have two <code>.class</code>/<code>.jar</code> files for each entry point, if you like.</li>
</ul>
</li>
</ul>
<h4 id="packaging">Packaging</h4>
<ul>
<li>Given your Java program from the “Development Tools” unit’s source code <em>and nothing else</em>, write a <em>single terminal command</em> that causes the program to display its output. Explain how the command works.</li>
<li>Compile your Java program into a JAR file such that you can run it by doing <code>java -jar my_program.jar</code> on the terminal.
<ul>
<li>XC: reduce the command needed to run your program to <em>one word</em>, with no spaces, e.g. <code>./my_java_program</code>. Hint: you can change your source code if you like, and at the end of this step your program may not be all in one language. <strong>Note:</strong> this is perhaps the most difficult extra-credit problem in this unit.</li>
</ul>
</li>
</ul>
<h4 id="version-control-introduction">Version Control: Introduction</h4>
<p>Distributed version control systems are notoriously complicated. Unlike most super-complicated computing tools, though, the “cliff notes” version tends to be incredibly harmful. A lot of the cleanup work I do when helping new developers work on shared projects is un-breaking things that stop everyone’s work that were broken due to the new dev’s misunderstanding of source control. <a href="http://explainxkcd.com/wiki/index.php/1597:_Git">This article</a> sums up the situation pretty well.</p>
<p>Save the commands used to do the below steps. After each step, a status check in whatever source control you use should not indicate any outstanding changes in the repository.<br>
	- Create an empty Git repository (or Mercurial, if you want, but Git is more ubiquitous).<br>
	- Add one file, called <code>file1.txt</code> containing some random text to that repository, and commit it.<br>
	- Change <code>file1.txt</code> (in any way), and commit the changes.<br>
	- Revert to the original (first) version of <code>file1.txt</code>, removing the second set of changes.<br>
	- Switch back to the latest version of <code>file1.txt</code>. Ensure its content is as expected.<br>
	- Change <code>file1.txt</code> again in any way, and then add another file, <code>file2.txt</code> containing some random text to the repository. Commit both the change and the addition in one commit.<br>
	- Revert/rollback the entire commit from the above step. Ensure <code>file1.txt</code> does not have its most recent changes, and that <code>file2.txt</code> does not exist.<br>
	- Sync back to the latest version of all files.<br>
	- Revert only the latest changes to <code>file1.txt</code> from the most recent commit. <code>file2.txt</code> should still exist and should not be detected as changed.<br>
	- View the commit history of your repository.</p>
<h4 id="version-control-conceptual-stuff">Version Control: Conceptual Stuff</h4>
<p>Be prepared to answer the below questions:</p>
<ul>
<li>When is it a good idea to include multiple files in a single commit? When is it a good idea to break it up as much as possible?</li>
<li>How would you guess the mechanic of <code>git status</code> (or <code>hg status</code>) works? In very general terms, what do you suppose that command does? What are some limitations that might happen with that approach?</li>
<li>Have any of the source control operations you have done in this section before this point required the internet? Why or why not?</li>
<li>When using Git or Mercurial, why is it not recommended to change the commit history (e.g. “I committed a file last week with <code>foo</code> in it; let me update that old commit so it reads <code>bar</code>, rather than adding changes onto the latest version of the file”)? What are some alternatives to changing the history?</li>
<li>How often should you commit and/or push changes? Why? This is subjective.</li>
<li>What are some advantages to keeping all of your code/notes in as few files as possible in source control? What are some disadvantages?
<ul>
<li>Be able to speak comprehensively on these distinctions: one of the most important skills in software engineering is a detailed understanding not just of how to organize things, but of <em>why</em> a particular organization scheme is chosen.</li>
</ul>
</li>
<li>XC: Be able to explain the key differences between distributed version control systems like those used in this section, and centralized ones, like SVN, CVS, or Perforce.</li>
</ul>
<h4 id="version-control-git-github">Version Control: Git: GitHub</h4>
<p>Keep a record of the steps and practices used to accomplish the below:<br>
	- Create a new repository on GitHub (not GitLab). GitHub has good documentation if you get stuck.<br>
	- <code>pull</code> that repository onto your workstation.<br>
	- Add a file to the repo on your workstation and commit your changes.<br>
	- Navigate to that repository on the GitHub website (remember to refresh). Is the file you added present? Why or why not?<br>
	- Do whatever is necessary to make the file you added appear on the GitHub website.<br>
	- Be able to explain in detail the differences between changing a file on disk, <code>add</code>ing a file to source control for the first time, <code>add</code>ing a file to source control when it is changed (and was already in source control before), committing changes, and pushing commits.<br>
		- This is the most important part of this section. Commands can be written down or memorized/copy-pasted, but without a good understanding of the above concepts, you will <em>definitely</em> cause problems for yourself and others during your first couple of days working on a truly shared codebase.</p>
<h4 id="version-control-git-merging">Version Control: Git: Merging</h4>
<ul>
<li>If you don’t already have one, create a file called <code>README.md</code> in the root of your GitHub repository, and ensure that it is available on the GitHub website. Add <em>at least</em> five lines of content to the file; the content can be anything, but having multiple lines will make the rest of this section somewhat easier to understand.
<ul>
<li>Check out the documentation on <a href="https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet">markdown</a> if you’re not familiar with it and are interested; it’s an invaluable tool for programmers.</li>
</ul>
</li>
<li>Ensure you have your GitHub repository, with the <code>README.md</code> file in it, on your workstation.</li>
<li>While you are logged into the GitHub website, you should be able to open the <code>README.md</code> file in an in-browser editor and make changes. Do so: add or change some content in the file (add, remove, and change a few lines of text) and make sure the changes get saved in your repository.</li>
<li>Without running any other commands on your workstation, make some <em>different</em> changes to the <code>README.md</code> file in your desktop editor of choice (add, remove, and change a few lines of text), and commit those changes. Try to get your changes onto the web version of the repo the same way you have pushed changes before. Why didn’t that work? What is different this time?</li>
<li>Merge both sets of changes such that the web and local versions of the repository have the same content in <code>README.md</code>.
<ul>
<li>This is one of the harder parts of this section, but it’s not optional, since understanding how simple merge operations happen is an essential skill.</li>
<li>There are many guides on how to do this; some of them really suck, so don’t assume that if you find a guide that is confusing you are missing something–the guide might just be terrible.</li>
<li>On the bright side, I don’t care how you accomplish the merge, so long as a combination of both sets of changes to the file are available once you’re done.</li>
</ul>
</li>
<li>When finished, be able to explain why merging was necessary, what you did, and why it worked.</li>
</ul>
<h4 id="minifinal">Minifinal</h4>
<ul>
<li>Upload the code, solutions, and materials used for all of your work in this unit to this GitHub repository. If you have trouble getting commit access, check with me. The <code>README.md</code> file in the top level of this repo contains general instructions on where to store these materials; other than that, your organization scheme is up to you. Just make sure I can find a specific part of the lesson without having to dig too much.
<ul>
<li>Make sure you don’t upload any private/password information. Scraper robots around the world ensure that it will be captured within a seconds of being uploaded.</li>
</ul>
</li>
<li>Be familiar with excluding common non-text files (e.g. VM images or <code>.jar</code> files); from <code>git add</code>/source control additions. Why is it a bad idea to upload large created/compiled non-text files to source control (there are many reasons; I’m looking for the most obvious).</li>
<li>Switch to using Git and GitHub as the sole code storage location for all of your work on these tutorials. Adjust your IDEs, project locations, and workflows such that you are never copying files from a place where you edit/test them into a Git repository; whenever you save a file, you should be able to go to the exact path at which you saved it and tell Git about it.
<ul>
<li>Keep in mind you can have (and commit to/push from) multiple copies of the same Git repository on the same computer.</li>
</ul>
</li>
<li>Consider integrating Git into your editor or IDE. Most IDEs contain plugins that integrate with various source control mechanisms, and allow you to do things like push/pull/merge from a GUI, or add/commit files when they are saved (so there isn’t an extra step).</li>
</ul>