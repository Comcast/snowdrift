
# TODO List: Items still needing help

- Add "-z" flag in to speed up tests, but it won't work with all versions of nc, so I need to see what versions I'm running up against and write tests.
   - I should change up the script that gets uploaded--have it uploaded to a temp file, executed, and have it determine if -z is supported or not.
- Come up with a way to test UDP port 123 for NTP
- Add support for testing that paths **do** time out, and mark them as "success"
   - Maybe change stats variables from success/fail to pass/fail

