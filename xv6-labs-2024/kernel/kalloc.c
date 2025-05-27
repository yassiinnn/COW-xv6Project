// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

#define PHYPAGES (PHYSTOP / PGSIZE)

struct {
  struct spinlock lock;
  int refcnt[PHYPAGES];
  struct run *freelist;
} kmem;

void
kinit()
{
  initlock(&kmem.lock, "kmem");

  // Zero the reference counts
  for (int i = 0; i < PHYPAGES; i++) {
    kmem.refcnt[i] = 0;
  }

  freerange(end, (void*)PHYSTOP);
}

void freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    kfree(p);
  }
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  acquire(&kmem.lock);
  int index = (uint64)pa >> PGSHIFT;
  if (--kmem.refcnt[index] > 0) {
    // Still in use, do not free
    release(&kmem.lock);
    return;
  }
  release(&kmem.lock);

#ifndef LAB_SYSCALL
  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
#endif

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r) {
    kmem.freelist = r->next;
    kmem.refcnt[(uint64)r >> PGSHIFT] = 1;  // Set initial refcount
  }
  release(&kmem.lock);
#ifndef LAB_SYSCALL
  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
#endif
  return (void*)r;
}

void incref(uint64 pa) {
  acquire(&kmem.lock);
  kmem.refcnt[pa >> PGSHIFT]++;
  release(&kmem.lock);
}

void decref(uint64 pa) {
  kfree((void*)pa);  // kfree handles refcounting now
}

int refcount(uint64 pa) {
  acquire(&kmem.lock);
  int count = kmem.refcnt[pa >> PGSHIFT];
  release(&kmem.lock);
  return count;
}
