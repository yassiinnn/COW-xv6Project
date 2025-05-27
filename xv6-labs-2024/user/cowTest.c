#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main() {
  printf("COW test starting\n");

  char *p = sbrk(0);     // get current break
  sbrk(1);               // allocate a page
  p[0] = 'A';            // write something

  int pid = fork();
  if(pid == 0) {
    // Child
    printf("Child reads: %c\n", p[0]);
    p[0] = 'B';          // Trigger COW
    printf("Child writes and reads: %c\n", p[0]);
    exit(0);
  } else {
    wait(0);
    printf("Parent reads again: %c\n", p[0]);  // should still be 'A'
  }

  printf("COW test done\n");
  exit(0);
}
