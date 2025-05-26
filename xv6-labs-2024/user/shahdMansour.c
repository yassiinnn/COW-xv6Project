//communication between two processes
#include "kernel/types.h"
#include "user/user.h"

int main () {
  int n, pid;
  int fds[2];
  int fds2[2];
  char buf[100];
  
  pipe(fds);
  pipe(fds2);
  pid = fork();
  
  if (pid == 0) {
    write(fds[1], "i am a child, and i will send this string to parent.\n", 52);
    
    n = read(fds2[0], buf, sizeof(buf));
    write(1, buf, n);
  }
  
  else {
    n = read(fds[0], buf, sizeof(buf));
    write(1, buf, n);

    write(fds2[1], "i am a parent, and i received this string from child.\n", 55);
    wait(0);
  }
  
  exit(0);
}
