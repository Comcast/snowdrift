
# TODO List: Items still needing help

- Write a script that will audit all Netcat versions:
   - docker-compose exec source nc --help |head
   - Add a blurb into the README saying what Netcat versions (and OSes they are in, where appropriate) Snowdrift is guaranteed to work on.
- Add ranges into test
- Come up with a way to test UDP port 123 for NTP
- Add support for testing that paths **do** time out, and mark them as "success"
   - Maybe change stats variables from success/fail to pass/fail

