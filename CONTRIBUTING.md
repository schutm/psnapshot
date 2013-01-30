Contributing to psnapshot
=========================
Want to get involved? Thanks! Read on to see how you can help...


Bugs
----
A bug is a reproducable, demonstrable problem caused by the software.
Good bug reports are very important. Therefor some guidelines are
provided:

1. Check if the issue has already been reported using the **GitHub
   issue search**.

2. Check if the issue has not already been fixed by getting the latest
   `master` branch and try to reproduce the problem.

3. Create a minimal setup/example whcih reproduces the problem.

Please try to be as detailed as possible in the bug report. Add what OS
you're using, what version of rsync you're using. What does your
configuration look like, what arguments did you use to invoke
`psnapshot`. Did you invoke `psnapshot` from the commandline or from
crontab? What happened and what did you expect to happen?

**[File a bug report](https://github.com/schutm/psnapshot/)**


Pull requests
-------------
Good pull request - patches, improvements, new features - are even
better than good bug reports. Pull requests should remain focused in
scope and unrelated commits should be moved to separate pull requests.
Please open an issue to discuss a significant amount of work.

Allthough there are no coding guidelines, try to stay within the coding
conventions of the source files. Please update any documentation that
is relevant to the change you're making.

For pull requests follow this process:

1. [Fork](http://help.github.com/fork-a-repo/) the project, clone your
   fork, and configure the remotes:

   ```bash
   # Clone your fork of the repo into the current directory
   git clone https://github.com/<your-username>/psnapshot.git
   # Navigate to the newly cloned directory
   cd psnapshot
   # Assigns the original repo to a remote called "upstream"
   git remote add upstream https://github.com/schutm/psnapshot.git
   ```

2. If you cloned a while ago, get the latest changes from upstream:

   ```bash
   git checkout master
   git pull upstream master
   ```

3. Create a new topic branch to contain your feature, change, or fix:

   ```bash
   git checkout -b <topic-branch-name>
   ```

4. Commit your changes in logical chunks. Please adhere to these [git
   commit message guidelines] (http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
   or your pull request is unlikely be merged into the main project.
   Use git's [interactive rebase](https://help.github.com/articles/interactive-rebase)
   feature to tidy up your commits before making them public.

5. Locally merge (or rebase) the upstream development branch into your
   topic branch:

   ```bash
   git pull [--rebase] upstream master
   ```

6. Push your topic branch up to your fork:

   ```bash
   git push origin <topic-branch-name>
   ```

7. [Open a Pull Request](https://help.github.com/articles/using-pull-requests)
   with a clear title and description.
