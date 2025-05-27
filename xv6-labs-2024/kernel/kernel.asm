
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0023b117          	auipc	sp,0x23b
    80000004:	5f010113          	addi	sp,sp,1520 # 8023b5f0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	6c7040ef          	jal	80004edc <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000026:	03451793          	slli	a5,a0,0x34
    8000002a:	efbd                	bnez	a5,800000a8 <kfree+0x8c>
    8000002c:	84aa                	mv	s1,a0
    8000002e:	00243797          	auipc	a5,0x243
    80000032:	6c278793          	addi	a5,a5,1730 # 802436f0 <end>
    80000036:	06f56963          	bltu	a0,a5,800000a8 <kfree+0x8c>
    8000003a:	47c5                	li	a5,17
    8000003c:	07ee                	slli	a5,a5,0x1b
    8000003e:	06f57563          	bgeu	a0,a5,800000a8 <kfree+0x8c>
    panic("kfree");

  acquire(&kmem.lock);
    80000042:	0000a517          	auipc	a0,0xa
    80000046:	37e50513          	addi	a0,a0,894 # 8000a3c0 <kmem>
    8000004a:	0fb050ef          	jal	80005944 <acquire>
  int index = (uint64)pa >> PGSHIFT;
    8000004e:	00c4d793          	srli	a5,s1,0xc
    80000052:	2781                	sext.w	a5,a5
  if (--kmem.refcnt[index] > 0) {
    80000054:	0791                	addi	a5,a5,4
    80000056:	078a                	slli	a5,a5,0x2
    80000058:	0000a717          	auipc	a4,0xa
    8000005c:	36870713          	addi	a4,a4,872 # 8000a3c0 <kmem>
    80000060:	973e                	add	a4,a4,a5
    80000062:	471c                	lw	a5,8(a4)
    80000064:	37fd                	addiw	a5,a5,-1
    80000066:	c71c                	sw	a5,8(a4)
    80000068:	04f04663          	bgtz	a5,800000b4 <kfree+0x98>
    // Still in use, do not free
    release(&kmem.lock);
    return;
  }
  release(&kmem.lock);
    8000006c:	0000a517          	auipc	a0,0xa
    80000070:	35450513          	addi	a0,a0,852 # 8000a3c0 <kmem>
    80000074:	165050ef          	jal	800059d8 <release>
  memset(pa, 1, PGSIZE);
#endif

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000078:	0000a517          	auipc	a0,0xa
    8000007c:	34850513          	addi	a0,a0,840 # 8000a3c0 <kmem>
    80000080:	0c5050ef          	jal	80005944 <acquire>
  r->next = kmem.freelist;
    80000084:	0022a797          	auipc	a5,0x22a
    80000088:	33c78793          	addi	a5,a5,828 # 8022a3c0 <kmem+0x220000>
    8000008c:	6f98                	ld	a4,24(a5)
    8000008e:	e098                	sd	a4,0(s1)
  kmem.freelist = r;
    80000090:	ef84                	sd	s1,24(a5)
  release(&kmem.lock);
    80000092:	0000a517          	auipc	a0,0xa
    80000096:	32e50513          	addi	a0,a0,814 # 8000a3c0 <kmem>
    8000009a:	13f050ef          	jal	800059d8 <release>
}
    8000009e:	60e2                	ld	ra,24(sp)
    800000a0:	6442                	ld	s0,16(sp)
    800000a2:	64a2                	ld	s1,8(sp)
    800000a4:	6105                	addi	sp,sp,32
    800000a6:	8082                	ret
    panic("kfree");
    800000a8:	00007517          	auipc	a0,0x7
    800000ac:	f5850513          	addi	a0,a0,-168 # 80007000 <etext>
    800000b0:	566050ef          	jal	80005616 <panic>
    release(&kmem.lock);
    800000b4:	0000a517          	auipc	a0,0xa
    800000b8:	30c50513          	addi	a0,a0,780 # 8000a3c0 <kmem>
    800000bc:	11d050ef          	jal	800059d8 <release>
    return;
    800000c0:	bff9                	j	8000009e <kfree+0x82>

00000000800000c2 <freerange>:
{
    800000c2:	7179                	addi	sp,sp,-48
    800000c4:	f406                	sd	ra,40(sp)
    800000c6:	f022                	sd	s0,32(sp)
    800000c8:	ec26                	sd	s1,24(sp)
    800000ca:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000cc:	6785                	lui	a5,0x1
    800000ce:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000d2:	00e504b3          	add	s1,a0,a4
    800000d6:	777d                	lui	a4,0xfffff
    800000d8:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000da:	94be                	add	s1,s1,a5
    800000dc:	0295e263          	bltu	a1,s1,80000100 <freerange+0x3e>
    800000e0:	e84a                	sd	s2,16(sp)
    800000e2:	e44e                	sd	s3,8(sp)
    800000e4:	e052                	sd	s4,0(sp)
    800000e6:	892e                	mv	s2,a1
    kfree(p);
    800000e8:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000ea:	89be                	mv	s3,a5
    kfree(p);
    800000ec:	01448533          	add	a0,s1,s4
    800000f0:	f2dff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000f4:	94ce                	add	s1,s1,s3
    800000f6:	fe997be3          	bgeu	s2,s1,800000ec <freerange+0x2a>
    800000fa:	6942                	ld	s2,16(sp)
    800000fc:	69a2                	ld	s3,8(sp)
    800000fe:	6a02                	ld	s4,0(sp)
}
    80000100:	70a2                	ld	ra,40(sp)
    80000102:	7402                	ld	s0,32(sp)
    80000104:	64e2                	ld	s1,24(sp)
    80000106:	6145                	addi	sp,sp,48
    80000108:	8082                	ret

000000008000010a <kinit>:
{
    8000010a:	1141                	addi	sp,sp,-16
    8000010c:	e406                	sd	ra,8(sp)
    8000010e:	e022                	sd	s0,0(sp)
    80000110:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000112:	00007597          	auipc	a1,0x7
    80000116:	efe58593          	addi	a1,a1,-258 # 80007010 <etext+0x10>
    8000011a:	0000a517          	auipc	a0,0xa
    8000011e:	2a650513          	addi	a0,a0,678 # 8000a3c0 <kmem>
    80000122:	79e050ef          	jal	800058c0 <initlock>
  for (int i = 0; i < PHYPAGES; i++) {
    80000126:	0000a797          	auipc	a5,0xa
    8000012a:	2b278793          	addi	a5,a5,690 # 8000a3d8 <kmem+0x18>
    8000012e:	0022a717          	auipc	a4,0x22a
    80000132:	2aa70713          	addi	a4,a4,682 # 8022a3d8 <kmem+0x220018>
    kmem.refcnt[i] = 0;
    80000136:	0007a023          	sw	zero,0(a5)
  for (int i = 0; i < PHYPAGES; i++) {
    8000013a:	0791                	addi	a5,a5,4
    8000013c:	fee79de3          	bne	a5,a4,80000136 <kinit+0x2c>
  freerange(end, (void*)PHYSTOP);
    80000140:	45c5                	li	a1,17
    80000142:	05ee                	slli	a1,a1,0x1b
    80000144:	00243517          	auipc	a0,0x243
    80000148:	5ac50513          	addi	a0,a0,1452 # 802436f0 <end>
    8000014c:	f77ff0ef          	jal	800000c2 <freerange>
}
    80000150:	60a2                	ld	ra,8(sp)
    80000152:	6402                	ld	s0,0(sp)
    80000154:	0141                	addi	sp,sp,16
    80000156:	8082                	ret

0000000080000158 <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void)
{
    80000158:	1101                	addi	sp,sp,-32
    8000015a:	ec06                	sd	ra,24(sp)
    8000015c:	e822                	sd	s0,16(sp)
    8000015e:	e426                	sd	s1,8(sp)
    80000160:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000162:	0000a517          	auipc	a0,0xa
    80000166:	25e50513          	addi	a0,a0,606 # 8000a3c0 <kmem>
    8000016a:	7da050ef          	jal	80005944 <acquire>
  r = kmem.freelist;
    8000016e:	0022a497          	auipc	s1,0x22a
    80000172:	26a4b483          	ld	s1,618(s1) # 8022a3d8 <kmem+0x220018>
  if(r) {
    80000176:	c08d                	beqz	s1,80000198 <kalloc+0x40>
    kmem.freelist = r->next;
    80000178:	609c                	ld	a5,0(s1)
    8000017a:	0022a717          	auipc	a4,0x22a
    8000017e:	24f73f23          	sd	a5,606(a4) # 8022a3d8 <kmem+0x220018>
    kmem.refcnt[(uint64)r >> PGSHIFT] = 1;  // Set initial refcount
    80000182:	00c4d793          	srli	a5,s1,0xc
    80000186:	0791                	addi	a5,a5,4
    80000188:	078a                	slli	a5,a5,0x2
    8000018a:	0000a717          	auipc	a4,0xa
    8000018e:	23670713          	addi	a4,a4,566 # 8000a3c0 <kmem>
    80000192:	97ba                	add	a5,a5,a4
    80000194:	4705                	li	a4,1
    80000196:	c798                	sw	a4,8(a5)
  }
  release(&kmem.lock);
    80000198:	0000a517          	auipc	a0,0xa
    8000019c:	22850513          	addi	a0,a0,552 # 8000a3c0 <kmem>
    800001a0:	039050ef          	jal	800059d8 <release>
#ifndef LAB_SYSCALL
  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
#endif
  return (void*)r;
}
    800001a4:	8526                	mv	a0,s1
    800001a6:	60e2                	ld	ra,24(sp)
    800001a8:	6442                	ld	s0,16(sp)
    800001aa:	64a2                	ld	s1,8(sp)
    800001ac:	6105                	addi	sp,sp,32
    800001ae:	8082                	ret

00000000800001b0 <incref>:

void incref(uint64 pa) {
    800001b0:	1101                	addi	sp,sp,-32
    800001b2:	ec06                	sd	ra,24(sp)
    800001b4:	e822                	sd	s0,16(sp)
    800001b6:	e426                	sd	s1,8(sp)
    800001b8:	1000                	addi	s0,sp,32
    800001ba:	84aa                	mv	s1,a0
  acquire(&kmem.lock);
    800001bc:	0000a517          	auipc	a0,0xa
    800001c0:	20450513          	addi	a0,a0,516 # 8000a3c0 <kmem>
    800001c4:	780050ef          	jal	80005944 <acquire>
  kmem.refcnt[pa >> PGSHIFT]++;
    800001c8:	00c4d793          	srli	a5,s1,0xc
    800001cc:	0000a517          	auipc	a0,0xa
    800001d0:	1f450513          	addi	a0,a0,500 # 8000a3c0 <kmem>
    800001d4:	0791                	addi	a5,a5,4
    800001d6:	078a                	slli	a5,a5,0x2
    800001d8:	97aa                	add	a5,a5,a0
    800001da:	4798                	lw	a4,8(a5)
    800001dc:	2705                	addiw	a4,a4,1
    800001de:	c798                	sw	a4,8(a5)
  release(&kmem.lock);
    800001e0:	7f8050ef          	jal	800059d8 <release>
}
    800001e4:	60e2                	ld	ra,24(sp)
    800001e6:	6442                	ld	s0,16(sp)
    800001e8:	64a2                	ld	s1,8(sp)
    800001ea:	6105                	addi	sp,sp,32
    800001ec:	8082                	ret

00000000800001ee <decref>:

void decref(uint64 pa) {
    800001ee:	1141                	addi	sp,sp,-16
    800001f0:	e406                	sd	ra,8(sp)
    800001f2:	e022                	sd	s0,0(sp)
    800001f4:	0800                	addi	s0,sp,16
  kfree((void*)pa);  // kfree handles refcounting now
    800001f6:	e27ff0ef          	jal	8000001c <kfree>
}
    800001fa:	60a2                	ld	ra,8(sp)
    800001fc:	6402                	ld	s0,0(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret

0000000080000202 <refcount>:

int refcount(uint64 pa) {
    80000202:	1101                	addi	sp,sp,-32
    80000204:	ec06                	sd	ra,24(sp)
    80000206:	e822                	sd	s0,16(sp)
    80000208:	e426                	sd	s1,8(sp)
    8000020a:	1000                	addi	s0,sp,32
    8000020c:	84aa                	mv	s1,a0
  acquire(&kmem.lock);
    8000020e:	0000a517          	auipc	a0,0xa
    80000212:	1b250513          	addi	a0,a0,434 # 8000a3c0 <kmem>
    80000216:	72e050ef          	jal	80005944 <acquire>
  int count = kmem.refcnt[pa >> PGSHIFT];
    8000021a:	0000a517          	auipc	a0,0xa
    8000021e:	1a650513          	addi	a0,a0,422 # 8000a3c0 <kmem>
    80000222:	80b1                	srli	s1,s1,0xc
    80000224:	0491                	addi	s1,s1,4
    80000226:	048a                	slli	s1,s1,0x2
    80000228:	94aa                	add	s1,s1,a0
    8000022a:	4484                	lw	s1,8(s1)
  release(&kmem.lock);
    8000022c:	7ac050ef          	jal	800059d8 <release>
  return count;
}
    80000230:	8526                	mv	a0,s1
    80000232:	60e2                	ld	ra,24(sp)
    80000234:	6442                	ld	s0,16(sp)
    80000236:	64a2                	ld	s1,8(sp)
    80000238:	6105                	addi	sp,sp,32
    8000023a:	8082                	ret

000000008000023c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000023c:	1141                	addi	sp,sp,-16
    8000023e:	e406                	sd	ra,8(sp)
    80000240:	e022                	sd	s0,0(sp)
    80000242:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000244:	ca19                	beqz	a2,8000025a <memset+0x1e>
    80000246:	87aa                	mv	a5,a0
    80000248:	1602                	slli	a2,a2,0x20
    8000024a:	9201                	srli	a2,a2,0x20
    8000024c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000250:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000254:	0785                	addi	a5,a5,1
    80000256:	fee79de3          	bne	a5,a4,80000250 <memset+0x14>
  }
  return dst;
}
    8000025a:	60a2                	ld	ra,8(sp)
    8000025c:	6402                	ld	s0,0(sp)
    8000025e:	0141                	addi	sp,sp,16
    80000260:	8082                	ret

0000000080000262 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000262:	1141                	addi	sp,sp,-16
    80000264:	e406                	sd	ra,8(sp)
    80000266:	e022                	sd	s0,0(sp)
    80000268:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000026a:	ca0d                	beqz	a2,8000029c <memcmp+0x3a>
    8000026c:	fff6069b          	addiw	a3,a2,-1
    80000270:	1682                	slli	a3,a3,0x20
    80000272:	9281                	srli	a3,a3,0x20
    80000274:	0685                	addi	a3,a3,1
    80000276:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000278:	00054783          	lbu	a5,0(a0)
    8000027c:	0005c703          	lbu	a4,0(a1)
    80000280:	00e79863          	bne	a5,a4,80000290 <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    80000284:	0505                	addi	a0,a0,1
    80000286:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000288:	fed518e3          	bne	a0,a3,80000278 <memcmp+0x16>
  }

  return 0;
    8000028c:	4501                	li	a0,0
    8000028e:	a019                	j	80000294 <memcmp+0x32>
      return *s1 - *s2;
    80000290:	40e7853b          	subw	a0,a5,a4
}
    80000294:	60a2                	ld	ra,8(sp)
    80000296:	6402                	ld	s0,0(sp)
    80000298:	0141                	addi	sp,sp,16
    8000029a:	8082                	ret
  return 0;
    8000029c:	4501                	li	a0,0
    8000029e:	bfdd                	j	80000294 <memcmp+0x32>

00000000800002a0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800002a0:	1141                	addi	sp,sp,-16
    800002a2:	e406                	sd	ra,8(sp)
    800002a4:	e022                	sd	s0,0(sp)
    800002a6:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800002a8:	c205                	beqz	a2,800002c8 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800002aa:	02a5e363          	bltu	a1,a0,800002d0 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800002ae:	1602                	slli	a2,a2,0x20
    800002b0:	9201                	srli	a2,a2,0x20
    800002b2:	00c587b3          	add	a5,a1,a2
{
    800002b6:	872a                	mv	a4,a0
      *d++ = *s++;
    800002b8:	0585                	addi	a1,a1,1
    800002ba:	0705                	addi	a4,a4,1
    800002bc:	fff5c683          	lbu	a3,-1(a1)
    800002c0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800002c4:	feb79ae3          	bne	a5,a1,800002b8 <memmove+0x18>

  return dst;
}
    800002c8:	60a2                	ld	ra,8(sp)
    800002ca:	6402                	ld	s0,0(sp)
    800002cc:	0141                	addi	sp,sp,16
    800002ce:	8082                	ret
  if(s < d && s + n > d){
    800002d0:	02061693          	slli	a3,a2,0x20
    800002d4:	9281                	srli	a3,a3,0x20
    800002d6:	00d58733          	add	a4,a1,a3
    800002da:	fce57ae3          	bgeu	a0,a4,800002ae <memmove+0xe>
    d += n;
    800002de:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800002e0:	fff6079b          	addiw	a5,a2,-1
    800002e4:	1782                	slli	a5,a5,0x20
    800002e6:	9381                	srli	a5,a5,0x20
    800002e8:	fff7c793          	not	a5,a5
    800002ec:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800002ee:	177d                	addi	a4,a4,-1
    800002f0:	16fd                	addi	a3,a3,-1
    800002f2:	00074603          	lbu	a2,0(a4)
    800002f6:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800002fa:	fee79ae3          	bne	a5,a4,800002ee <memmove+0x4e>
    800002fe:	b7e9                	j	800002c8 <memmove+0x28>

0000000080000300 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000300:	1141                	addi	sp,sp,-16
    80000302:	e406                	sd	ra,8(sp)
    80000304:	e022                	sd	s0,0(sp)
    80000306:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000308:	f99ff0ef          	jal	800002a0 <memmove>
}
    8000030c:	60a2                	ld	ra,8(sp)
    8000030e:	6402                	ld	s0,0(sp)
    80000310:	0141                	addi	sp,sp,16
    80000312:	8082                	ret

0000000080000314 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000314:	1141                	addi	sp,sp,-16
    80000316:	e406                	sd	ra,8(sp)
    80000318:	e022                	sd	s0,0(sp)
    8000031a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000031c:	ce11                	beqz	a2,80000338 <strncmp+0x24>
    8000031e:	00054783          	lbu	a5,0(a0)
    80000322:	cf89                	beqz	a5,8000033c <strncmp+0x28>
    80000324:	0005c703          	lbu	a4,0(a1)
    80000328:	00f71a63          	bne	a4,a5,8000033c <strncmp+0x28>
    n--, p++, q++;
    8000032c:	367d                	addiw	a2,a2,-1
    8000032e:	0505                	addi	a0,a0,1
    80000330:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000332:	f675                	bnez	a2,8000031e <strncmp+0xa>
  if(n == 0)
    return 0;
    80000334:	4501                	li	a0,0
    80000336:	a801                	j	80000346 <strncmp+0x32>
    80000338:	4501                	li	a0,0
    8000033a:	a031                	j	80000346 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    8000033c:	00054503          	lbu	a0,0(a0)
    80000340:	0005c783          	lbu	a5,0(a1)
    80000344:	9d1d                	subw	a0,a0,a5
}
    80000346:	60a2                	ld	ra,8(sp)
    80000348:	6402                	ld	s0,0(sp)
    8000034a:	0141                	addi	sp,sp,16
    8000034c:	8082                	ret

000000008000034e <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000034e:	1141                	addi	sp,sp,-16
    80000350:	e406                	sd	ra,8(sp)
    80000352:	e022                	sd	s0,0(sp)
    80000354:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000356:	87aa                	mv	a5,a0
    80000358:	86b2                	mv	a3,a2
    8000035a:	367d                	addiw	a2,a2,-1
    8000035c:	02d05563          	blez	a3,80000386 <strncpy+0x38>
    80000360:	0785                	addi	a5,a5,1
    80000362:	0005c703          	lbu	a4,0(a1)
    80000366:	fee78fa3          	sb	a4,-1(a5)
    8000036a:	0585                	addi	a1,a1,1
    8000036c:	f775                	bnez	a4,80000358 <strncpy+0xa>
    ;
  while(n-- > 0)
    8000036e:	873e                	mv	a4,a5
    80000370:	00c05b63          	blez	a2,80000386 <strncpy+0x38>
    80000374:	9fb5                	addw	a5,a5,a3
    80000376:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000378:	0705                	addi	a4,a4,1
    8000037a:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    8000037e:	40e786bb          	subw	a3,a5,a4
    80000382:	fed04be3          	bgtz	a3,80000378 <strncpy+0x2a>
  return os;
}
    80000386:	60a2                	ld	ra,8(sp)
    80000388:	6402                	ld	s0,0(sp)
    8000038a:	0141                	addi	sp,sp,16
    8000038c:	8082                	ret

000000008000038e <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000038e:	1141                	addi	sp,sp,-16
    80000390:	e406                	sd	ra,8(sp)
    80000392:	e022                	sd	s0,0(sp)
    80000394:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000396:	02c05363          	blez	a2,800003bc <safestrcpy+0x2e>
    8000039a:	fff6069b          	addiw	a3,a2,-1
    8000039e:	1682                	slli	a3,a3,0x20
    800003a0:	9281                	srli	a3,a3,0x20
    800003a2:	96ae                	add	a3,a3,a1
    800003a4:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800003a6:	00d58963          	beq	a1,a3,800003b8 <safestrcpy+0x2a>
    800003aa:	0585                	addi	a1,a1,1
    800003ac:	0785                	addi	a5,a5,1
    800003ae:	fff5c703          	lbu	a4,-1(a1)
    800003b2:	fee78fa3          	sb	a4,-1(a5)
    800003b6:	fb65                	bnez	a4,800003a6 <safestrcpy+0x18>
    ;
  *s = 0;
    800003b8:	00078023          	sb	zero,0(a5)
  return os;
}
    800003bc:	60a2                	ld	ra,8(sp)
    800003be:	6402                	ld	s0,0(sp)
    800003c0:	0141                	addi	sp,sp,16
    800003c2:	8082                	ret

00000000800003c4 <strlen>:

int
strlen(const char *s)
{
    800003c4:	1141                	addi	sp,sp,-16
    800003c6:	e406                	sd	ra,8(sp)
    800003c8:	e022                	sd	s0,0(sp)
    800003ca:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800003cc:	00054783          	lbu	a5,0(a0)
    800003d0:	cf99                	beqz	a5,800003ee <strlen+0x2a>
    800003d2:	0505                	addi	a0,a0,1
    800003d4:	87aa                	mv	a5,a0
    800003d6:	86be                	mv	a3,a5
    800003d8:	0785                	addi	a5,a5,1
    800003da:	fff7c703          	lbu	a4,-1(a5)
    800003de:	ff65                	bnez	a4,800003d6 <strlen+0x12>
    800003e0:	40a6853b          	subw	a0,a3,a0
    800003e4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800003e6:	60a2                	ld	ra,8(sp)
    800003e8:	6402                	ld	s0,0(sp)
    800003ea:	0141                	addi	sp,sp,16
    800003ec:	8082                	ret
  for(n = 0; s[n]; n++)
    800003ee:	4501                	li	a0,0
    800003f0:	bfdd                	j	800003e6 <strlen+0x22>

00000000800003f2 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800003f2:	1141                	addi	sp,sp,-16
    800003f4:	e406                	sd	ra,8(sp)
    800003f6:	e022                	sd	s0,0(sp)
    800003f8:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800003fa:	329000ef          	jal	80000f22 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800003fe:	0000a717          	auipc	a4,0xa
    80000402:	f9270713          	addi	a4,a4,-110 # 8000a390 <started>
  if(cpuid() == 0){
    80000406:	c51d                	beqz	a0,80000434 <main+0x42>
    while(started == 0)
    80000408:	431c                	lw	a5,0(a4)
    8000040a:	2781                	sext.w	a5,a5
    8000040c:	dff5                	beqz	a5,80000408 <main+0x16>
      ;
    __sync_synchronize();
    8000040e:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000412:	311000ef          	jal	80000f22 <cpuid>
    80000416:	85aa                	mv	a1,a0
    80000418:	00007517          	auipc	a0,0x7
    8000041c:	c2050513          	addi	a0,a0,-992 # 80007038 <etext+0x38>
    80000420:	727040ef          	jal	80005346 <printf>
    kvminithart();    // turn on paging
    80000424:	080000ef          	jal	800004a4 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000428:	618010ef          	jal	80001a40 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000042c:	4fc040ef          	jal	80004928 <plicinithart>
  }

  scheduler();        
    80000430:	75b000ef          	jal	8000138a <scheduler>
    consoleinit();
    80000434:	645040ef          	jal	80005278 <consoleinit>
    printfinit();
    80000438:	218050ef          	jal	80005650 <printfinit>
    printf("\n");
    8000043c:	00007517          	auipc	a0,0x7
    80000440:	bdc50513          	addi	a0,a0,-1060 # 80007018 <etext+0x18>
    80000444:	703040ef          	jal	80005346 <printf>
    printf("xv6 kernel is booting\n");
    80000448:	00007517          	auipc	a0,0x7
    8000044c:	bd850513          	addi	a0,a0,-1064 # 80007020 <etext+0x20>
    80000450:	6f7040ef          	jal	80005346 <printf>
    printf("\n");
    80000454:	00007517          	auipc	a0,0x7
    80000458:	bc450513          	addi	a0,a0,-1084 # 80007018 <etext+0x18>
    8000045c:	6eb040ef          	jal	80005346 <printf>
    kinit();         // physical page allocator
    80000460:	cabff0ef          	jal	8000010a <kinit>
    kvminit();       // create kernel page table
    80000464:	2ce000ef          	jal	80000732 <kvminit>
    kvminithart();   // turn on paging
    80000468:	03c000ef          	jal	800004a4 <kvminithart>
    procinit();      // process table
    8000046c:	207000ef          	jal	80000e72 <procinit>
    trapinit();      // trap vectors
    80000470:	5ac010ef          	jal	80001a1c <trapinit>
    trapinithart();  // install kernel trap vector
    80000474:	5cc010ef          	jal	80001a40 <trapinithart>
    plicinit();      // set up interrupt controller
    80000478:	496040ef          	jal	8000490e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000047c:	4ac040ef          	jal	80004928 <plicinithart>
    binit();         // buffer cache
    80000480:	40f010ef          	jal	8000208e <binit>
    iinit();         // inode table
    80000484:	1da020ef          	jal	8000265e <iinit>
    fileinit();      // file table
    80000488:	7a9020ef          	jal	80003430 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000048c:	58c040ef          	jal	80004a18 <virtio_disk_init>
    userinit();      // first user process
    80000490:	52f000ef          	jal	800011be <userinit>
    __sync_synchronize();
    80000494:	0330000f          	fence	rw,rw
    started = 1;
    80000498:	4785                	li	a5,1
    8000049a:	0000a717          	auipc	a4,0xa
    8000049e:	eef72b23          	sw	a5,-266(a4) # 8000a390 <started>
    800004a2:	b779                	j	80000430 <main+0x3e>

00000000800004a4 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800004a4:	1141                	addi	sp,sp,-16
    800004a6:	e406                	sd	ra,8(sp)
    800004a8:	e022                	sd	s0,0(sp)
    800004aa:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800004ac:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800004b0:	0000a797          	auipc	a5,0xa
    800004b4:	ee87b783          	ld	a5,-280(a5) # 8000a398 <kernel_pagetable>
    800004b8:	83b1                	srli	a5,a5,0xc
    800004ba:	577d                	li	a4,-1
    800004bc:	177e                	slli	a4,a4,0x3f
    800004be:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800004c0:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800004c4:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800004c8:	60a2                	ld	ra,8(sp)
    800004ca:	6402                	ld	s0,0(sp)
    800004cc:	0141                	addi	sp,sp,16
    800004ce:	8082                	ret

00000000800004d0 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004d0:	7139                	addi	sp,sp,-64
    800004d2:	fc06                	sd	ra,56(sp)
    800004d4:	f822                	sd	s0,48(sp)
    800004d6:	f426                	sd	s1,40(sp)
    800004d8:	f04a                	sd	s2,32(sp)
    800004da:	ec4e                	sd	s3,24(sp)
    800004dc:	e852                	sd	s4,16(sp)
    800004de:	e456                	sd	s5,8(sp)
    800004e0:	e05a                	sd	s6,0(sp)
    800004e2:	0080                	addi	s0,sp,64
    800004e4:	84aa                	mv	s1,a0
    800004e6:	89ae                	mv	s3,a1
    800004e8:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004ea:	57fd                	li	a5,-1
    800004ec:	83e9                	srli	a5,a5,0x1a
    800004ee:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004f0:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004f2:	04b7e263          	bltu	a5,a1,80000536 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    800004f6:	0149d933          	srl	s2,s3,s4
    800004fa:	1ff97913          	andi	s2,s2,511
    800004fe:	090e                	slli	s2,s2,0x3
    80000500:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000502:	00093483          	ld	s1,0(s2)
    80000506:	0014f793          	andi	a5,s1,1
    8000050a:	cf85                	beqz	a5,80000542 <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000050c:	80a9                	srli	s1,s1,0xa
    8000050e:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000510:	3a5d                	addiw	s4,s4,-9
    80000512:	ff6a12e3          	bne	s4,s6,800004f6 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000516:	00c9d513          	srli	a0,s3,0xc
    8000051a:	1ff57513          	andi	a0,a0,511
    8000051e:	050e                	slli	a0,a0,0x3
    80000520:	9526                	add	a0,a0,s1
}
    80000522:	70e2                	ld	ra,56(sp)
    80000524:	7442                	ld	s0,48(sp)
    80000526:	74a2                	ld	s1,40(sp)
    80000528:	7902                	ld	s2,32(sp)
    8000052a:	69e2                	ld	s3,24(sp)
    8000052c:	6a42                	ld	s4,16(sp)
    8000052e:	6aa2                	ld	s5,8(sp)
    80000530:	6b02                	ld	s6,0(sp)
    80000532:	6121                	addi	sp,sp,64
    80000534:	8082                	ret
    panic("walk");
    80000536:	00007517          	auipc	a0,0x7
    8000053a:	b1a50513          	addi	a0,a0,-1254 # 80007050 <etext+0x50>
    8000053e:	0d8050ef          	jal	80005616 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000542:	020a8263          	beqz	s5,80000566 <walk+0x96>
    80000546:	c13ff0ef          	jal	80000158 <kalloc>
    8000054a:	84aa                	mv	s1,a0
    8000054c:	d979                	beqz	a0,80000522 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    8000054e:	6605                	lui	a2,0x1
    80000550:	4581                	li	a1,0
    80000552:	cebff0ef          	jal	8000023c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000556:	00c4d793          	srli	a5,s1,0xc
    8000055a:	07aa                	slli	a5,a5,0xa
    8000055c:	0017e793          	ori	a5,a5,1
    80000560:	00f93023          	sd	a5,0(s2)
    80000564:	b775                	j	80000510 <walk+0x40>
        return 0;
    80000566:	4501                	li	a0,0
    80000568:	bf6d                	j	80000522 <walk+0x52>

000000008000056a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000056a:	57fd                	li	a5,-1
    8000056c:	83e9                	srli	a5,a5,0x1a
    8000056e:	00b7f463          	bgeu	a5,a1,80000576 <walkaddr+0xc>
    return 0;
    80000572:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000574:	8082                	ret
{
    80000576:	1141                	addi	sp,sp,-16
    80000578:	e406                	sd	ra,8(sp)
    8000057a:	e022                	sd	s0,0(sp)
    8000057c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000057e:	4601                	li	a2,0
    80000580:	f51ff0ef          	jal	800004d0 <walk>
  if(pte == 0)
    80000584:	c105                	beqz	a0,800005a4 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000586:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000588:	0117f693          	andi	a3,a5,17
    8000058c:	4745                	li	a4,17
    return 0;
    8000058e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000590:	00e68663          	beq	a3,a4,8000059c <walkaddr+0x32>
}
    80000594:	60a2                	ld	ra,8(sp)
    80000596:	6402                	ld	s0,0(sp)
    80000598:	0141                	addi	sp,sp,16
    8000059a:	8082                	ret
  pa = PTE2PA(*pte);
    8000059c:	83a9                	srli	a5,a5,0xa
    8000059e:	00c79513          	slli	a0,a5,0xc
  return pa;
    800005a2:	bfcd                	j	80000594 <walkaddr+0x2a>
    return 0;
    800005a4:	4501                	li	a0,0
    800005a6:	b7fd                	j	80000594 <walkaddr+0x2a>

00000000800005a8 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800005a8:	715d                	addi	sp,sp,-80
    800005aa:	e486                	sd	ra,72(sp)
    800005ac:	e0a2                	sd	s0,64(sp)
    800005ae:	fc26                	sd	s1,56(sp)
    800005b0:	f84a                	sd	s2,48(sp)
    800005b2:	f44e                	sd	s3,40(sp)
    800005b4:	f052                	sd	s4,32(sp)
    800005b6:	ec56                	sd	s5,24(sp)
    800005b8:	e85a                	sd	s6,16(sp)
    800005ba:	e45e                	sd	s7,8(sp)
    800005bc:	e062                	sd	s8,0(sp)
    800005be:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800005c0:	03459793          	slli	a5,a1,0x34
    800005c4:	e7b1                	bnez	a5,80000610 <mappages+0x68>
    800005c6:	8aaa                	mv	s5,a0
    800005c8:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800005ca:	03461793          	slli	a5,a2,0x34
    800005ce:	e7b9                	bnez	a5,8000061c <mappages+0x74>
    panic("mappages: size not aligned");

  if(size == 0)
    800005d0:	ce21                	beqz	a2,80000628 <mappages+0x80>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800005d2:	77fd                	lui	a5,0xfffff
    800005d4:	963e                	add	a2,a2,a5
    800005d6:	00b609b3          	add	s3,a2,a1
  a = va;
    800005da:	892e                	mv	s2,a1
    800005dc:	40b68a33          	sub	s4,a3,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    800005e0:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005e2:	6c05                	lui	s8,0x1
    800005e4:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800005e8:	865e                	mv	a2,s7
    800005ea:	85ca                	mv	a1,s2
    800005ec:	8556                	mv	a0,s5
    800005ee:	ee3ff0ef          	jal	800004d0 <walk>
    800005f2:	c539                	beqz	a0,80000640 <mappages+0x98>
    if(*pte & PTE_V)
    800005f4:	611c                	ld	a5,0(a0)
    800005f6:	8b85                	andi	a5,a5,1
    800005f8:	ef95                	bnez	a5,80000634 <mappages+0x8c>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005fa:	80b1                	srli	s1,s1,0xc
    800005fc:	04aa                	slli	s1,s1,0xa
    800005fe:	0164e4b3          	or	s1,s1,s6
    80000602:	0014e493          	ori	s1,s1,1
    80000606:	e104                	sd	s1,0(a0)
    if(a == last)
    80000608:	05390963          	beq	s2,s3,8000065a <mappages+0xb2>
    a += PGSIZE;
    8000060c:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    8000060e:	bfd9                	j	800005e4 <mappages+0x3c>
    panic("mappages: va not aligned");
    80000610:	00007517          	auipc	a0,0x7
    80000614:	a4850513          	addi	a0,a0,-1464 # 80007058 <etext+0x58>
    80000618:	7ff040ef          	jal	80005616 <panic>
    panic("mappages: size not aligned");
    8000061c:	00007517          	auipc	a0,0x7
    80000620:	a5c50513          	addi	a0,a0,-1444 # 80007078 <etext+0x78>
    80000624:	7f3040ef          	jal	80005616 <panic>
    panic("mappages: size");
    80000628:	00007517          	auipc	a0,0x7
    8000062c:	a7050513          	addi	a0,a0,-1424 # 80007098 <etext+0x98>
    80000630:	7e7040ef          	jal	80005616 <panic>
      panic("mappages: remap");
    80000634:	00007517          	auipc	a0,0x7
    80000638:	a7450513          	addi	a0,a0,-1420 # 800070a8 <etext+0xa8>
    8000063c:	7db040ef          	jal	80005616 <panic>
      return -1;
    80000640:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000642:	60a6                	ld	ra,72(sp)
    80000644:	6406                	ld	s0,64(sp)
    80000646:	74e2                	ld	s1,56(sp)
    80000648:	7942                	ld	s2,48(sp)
    8000064a:	79a2                	ld	s3,40(sp)
    8000064c:	7a02                	ld	s4,32(sp)
    8000064e:	6ae2                	ld	s5,24(sp)
    80000650:	6b42                	ld	s6,16(sp)
    80000652:	6ba2                	ld	s7,8(sp)
    80000654:	6c02                	ld	s8,0(sp)
    80000656:	6161                	addi	sp,sp,80
    80000658:	8082                	ret
  return 0;
    8000065a:	4501                	li	a0,0
    8000065c:	b7dd                	j	80000642 <mappages+0x9a>

000000008000065e <kvmmap>:
{
    8000065e:	1141                	addi	sp,sp,-16
    80000660:	e406                	sd	ra,8(sp)
    80000662:	e022                	sd	s0,0(sp)
    80000664:	0800                	addi	s0,sp,16
    80000666:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000668:	86b2                	mv	a3,a2
    8000066a:	863e                	mv	a2,a5
    8000066c:	f3dff0ef          	jal	800005a8 <mappages>
    80000670:	e509                	bnez	a0,8000067a <kvmmap+0x1c>
}
    80000672:	60a2                	ld	ra,8(sp)
    80000674:	6402                	ld	s0,0(sp)
    80000676:	0141                	addi	sp,sp,16
    80000678:	8082                	ret
    panic("kvmmap");
    8000067a:	00007517          	auipc	a0,0x7
    8000067e:	a3e50513          	addi	a0,a0,-1474 # 800070b8 <etext+0xb8>
    80000682:	795040ef          	jal	80005616 <panic>

0000000080000686 <kvmmake>:
{
    80000686:	1101                	addi	sp,sp,-32
    80000688:	ec06                	sd	ra,24(sp)
    8000068a:	e822                	sd	s0,16(sp)
    8000068c:	e426                	sd	s1,8(sp)
    8000068e:	e04a                	sd	s2,0(sp)
    80000690:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000692:	ac7ff0ef          	jal	80000158 <kalloc>
    80000696:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000698:	6605                	lui	a2,0x1
    8000069a:	4581                	li	a1,0
    8000069c:	ba1ff0ef          	jal	8000023c <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800006a0:	4719                	li	a4,6
    800006a2:	6685                	lui	a3,0x1
    800006a4:	10000637          	lui	a2,0x10000
    800006a8:	85b2                	mv	a1,a2
    800006aa:	8526                	mv	a0,s1
    800006ac:	fb3ff0ef          	jal	8000065e <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800006b0:	4719                	li	a4,6
    800006b2:	6685                	lui	a3,0x1
    800006b4:	10001637          	lui	a2,0x10001
    800006b8:	85b2                	mv	a1,a2
    800006ba:	8526                	mv	a0,s1
    800006bc:	fa3ff0ef          	jal	8000065e <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800006c0:	4719                	li	a4,6
    800006c2:	040006b7          	lui	a3,0x4000
    800006c6:	0c000637          	lui	a2,0xc000
    800006ca:	85b2                	mv	a1,a2
    800006cc:	8526                	mv	a0,s1
    800006ce:	f91ff0ef          	jal	8000065e <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006d2:	00007917          	auipc	s2,0x7
    800006d6:	92e90913          	addi	s2,s2,-1746 # 80007000 <etext>
    800006da:	4729                	li	a4,10
    800006dc:	80007697          	auipc	a3,0x80007
    800006e0:	92468693          	addi	a3,a3,-1756 # 7000 <_entry-0x7fff9000>
    800006e4:	4605                	li	a2,1
    800006e6:	067e                	slli	a2,a2,0x1f
    800006e8:	85b2                	mv	a1,a2
    800006ea:	8526                	mv	a0,s1
    800006ec:	f73ff0ef          	jal	8000065e <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006f0:	4719                	li	a4,6
    800006f2:	46c5                	li	a3,17
    800006f4:	06ee                	slli	a3,a3,0x1b
    800006f6:	412686b3          	sub	a3,a3,s2
    800006fa:	864a                	mv	a2,s2
    800006fc:	85ca                	mv	a1,s2
    800006fe:	8526                	mv	a0,s1
    80000700:	f5fff0ef          	jal	8000065e <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000704:	4729                	li	a4,10
    80000706:	6685                	lui	a3,0x1
    80000708:	00006617          	auipc	a2,0x6
    8000070c:	8f860613          	addi	a2,a2,-1800 # 80006000 <_trampoline>
    80000710:	040005b7          	lui	a1,0x4000
    80000714:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000716:	05b2                	slli	a1,a1,0xc
    80000718:	8526                	mv	a0,s1
    8000071a:	f45ff0ef          	jal	8000065e <kvmmap>
  proc_mapstacks(kpgtbl);
    8000071e:	8526                	mv	a0,s1
    80000720:	6b4000ef          	jal	80000dd4 <proc_mapstacks>
}
    80000724:	8526                	mv	a0,s1
    80000726:	60e2                	ld	ra,24(sp)
    80000728:	6442                	ld	s0,16(sp)
    8000072a:	64a2                	ld	s1,8(sp)
    8000072c:	6902                	ld	s2,0(sp)
    8000072e:	6105                	addi	sp,sp,32
    80000730:	8082                	ret

0000000080000732 <kvminit>:
{
    80000732:	1141                	addi	sp,sp,-16
    80000734:	e406                	sd	ra,8(sp)
    80000736:	e022                	sd	s0,0(sp)
    80000738:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000073a:	f4dff0ef          	jal	80000686 <kvmmake>
    8000073e:	0000a797          	auipc	a5,0xa
    80000742:	c4a7bd23          	sd	a0,-934(a5) # 8000a398 <kernel_pagetable>
}
    80000746:	60a2                	ld	ra,8(sp)
    80000748:	6402                	ld	s0,0(sp)
    8000074a:	0141                	addi	sp,sp,16
    8000074c:	8082                	ret

000000008000074e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000074e:	715d                	addi	sp,sp,-80
    80000750:	e486                	sd	ra,72(sp)
    80000752:	e0a2                	sd	s0,64(sp)
    80000754:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;
  int sz;

  if((va % PGSIZE) != 0)
    80000756:	03459793          	slli	a5,a1,0x34
    8000075a:	e39d                	bnez	a5,80000780 <uvmunmap+0x32>
    8000075c:	f84a                	sd	s2,48(sp)
    8000075e:	f44e                	sd	s3,40(sp)
    80000760:	f052                	sd	s4,32(sp)
    80000762:	ec56                	sd	s5,24(sp)
    80000764:	e85a                	sd	s6,16(sp)
    80000766:	e45e                	sd	s7,8(sp)
    80000768:	8a2a                	mv	s4,a0
    8000076a:	892e                	mv	s2,a1
    8000076c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += sz){
    8000076e:	0632                	slli	a2,a2,0xc
    80000770:	00b609b3          	add	s3,a2,a1
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0) {
      printf("va=%ld pte=%ld\n", a, *pte);
      panic("uvmunmap: not mapped");
    }
    if(PTE_FLAGS(*pte) == PTE_V)
    80000774:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000776:	6b05                	lui	s6,0x1
    80000778:	0935f763          	bgeu	a1,s3,80000806 <uvmunmap+0xb8>
    8000077c:	fc26                	sd	s1,56(sp)
    8000077e:	a8a1                	j	800007d6 <uvmunmap+0x88>
    80000780:	fc26                	sd	s1,56(sp)
    80000782:	f84a                	sd	s2,48(sp)
    80000784:	f44e                	sd	s3,40(sp)
    80000786:	f052                	sd	s4,32(sp)
    80000788:	ec56                	sd	s5,24(sp)
    8000078a:	e85a                	sd	s6,16(sp)
    8000078c:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000078e:	00007517          	auipc	a0,0x7
    80000792:	93250513          	addi	a0,a0,-1742 # 800070c0 <etext+0xc0>
    80000796:	681040ef          	jal	80005616 <panic>
      panic("uvmunmap: walk");
    8000079a:	00007517          	auipc	a0,0x7
    8000079e:	93e50513          	addi	a0,a0,-1730 # 800070d8 <etext+0xd8>
    800007a2:	675040ef          	jal	80005616 <panic>
      printf("va=%ld pte=%ld\n", a, *pte);
    800007a6:	85ca                	mv	a1,s2
    800007a8:	00007517          	auipc	a0,0x7
    800007ac:	94050513          	addi	a0,a0,-1728 # 800070e8 <etext+0xe8>
    800007b0:	397040ef          	jal	80005346 <printf>
      panic("uvmunmap: not mapped");
    800007b4:	00007517          	auipc	a0,0x7
    800007b8:	94450513          	addi	a0,a0,-1724 # 800070f8 <etext+0xf8>
    800007bc:	65b040ef          	jal	80005616 <panic>
      panic("uvmunmap: not a leaf");
    800007c0:	00007517          	auipc	a0,0x7
    800007c4:	95050513          	addi	a0,a0,-1712 # 80007110 <etext+0x110>
    800007c8:	64f040ef          	jal	80005616 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800007cc:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += sz){
    800007d0:	995a                	add	s2,s2,s6
    800007d2:	03397963          	bgeu	s2,s3,80000804 <uvmunmap+0xb6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007d6:	4601                	li	a2,0
    800007d8:	85ca                	mv	a1,s2
    800007da:	8552                	mv	a0,s4
    800007dc:	cf5ff0ef          	jal	800004d0 <walk>
    800007e0:	84aa                	mv	s1,a0
    800007e2:	dd45                	beqz	a0,8000079a <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0) {
    800007e4:	6110                	ld	a2,0(a0)
    800007e6:	00167793          	andi	a5,a2,1
    800007ea:	dfd5                	beqz	a5,800007a6 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007ec:	3ff67793          	andi	a5,a2,1023
    800007f0:	fd7788e3          	beq	a5,s7,800007c0 <uvmunmap+0x72>
    if(do_free){
    800007f4:	fc0a8ce3          	beqz	s5,800007cc <uvmunmap+0x7e>
      uint64 pa = PTE2PA(*pte);
    800007f8:	8229                	srli	a2,a2,0xa
      kfree((void*)pa);
    800007fa:	00c61513          	slli	a0,a2,0xc
    800007fe:	81fff0ef          	jal	8000001c <kfree>
    80000802:	b7e9                	j	800007cc <uvmunmap+0x7e>
    80000804:	74e2                	ld	s1,56(sp)
    80000806:	7942                	ld	s2,48(sp)
    80000808:	79a2                	ld	s3,40(sp)
    8000080a:	7a02                	ld	s4,32(sp)
    8000080c:	6ae2                	ld	s5,24(sp)
    8000080e:	6b42                	ld	s6,16(sp)
    80000810:	6ba2                	ld	s7,8(sp)
  }
}
    80000812:	60a6                	ld	ra,72(sp)
    80000814:	6406                	ld	s0,64(sp)
    80000816:	6161                	addi	sp,sp,80
    80000818:	8082                	ret

000000008000081a <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000081a:	1101                	addi	sp,sp,-32
    8000081c:	ec06                	sd	ra,24(sp)
    8000081e:	e822                	sd	s0,16(sp)
    80000820:	e426                	sd	s1,8(sp)
    80000822:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000824:	935ff0ef          	jal	80000158 <kalloc>
    80000828:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000082a:	c509                	beqz	a0,80000834 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000082c:	6605                	lui	a2,0x1
    8000082e:	4581                	li	a1,0
    80000830:	a0dff0ef          	jal	8000023c <memset>
  return pagetable;
}
    80000834:	8526                	mv	a0,s1
    80000836:	60e2                	ld	ra,24(sp)
    80000838:	6442                	ld	s0,16(sp)
    8000083a:	64a2                	ld	s1,8(sp)
    8000083c:	6105                	addi	sp,sp,32
    8000083e:	8082                	ret

0000000080000840 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000840:	7179                	addi	sp,sp,-48
    80000842:	f406                	sd	ra,40(sp)
    80000844:	f022                	sd	s0,32(sp)
    80000846:	ec26                	sd	s1,24(sp)
    80000848:	e84a                	sd	s2,16(sp)
    8000084a:	e44e                	sd	s3,8(sp)
    8000084c:	e052                	sd	s4,0(sp)
    8000084e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000850:	6785                	lui	a5,0x1
    80000852:	04f67063          	bgeu	a2,a5,80000892 <uvmfirst+0x52>
    80000856:	8a2a                	mv	s4,a0
    80000858:	89ae                	mv	s3,a1
    8000085a:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000085c:	8fdff0ef          	jal	80000158 <kalloc>
    80000860:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000862:	6605                	lui	a2,0x1
    80000864:	4581                	li	a1,0
    80000866:	9d7ff0ef          	jal	8000023c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000086a:	4779                	li	a4,30
    8000086c:	86ca                	mv	a3,s2
    8000086e:	6605                	lui	a2,0x1
    80000870:	4581                	li	a1,0
    80000872:	8552                	mv	a0,s4
    80000874:	d35ff0ef          	jal	800005a8 <mappages>
  memmove(mem, src, sz);
    80000878:	8626                	mv	a2,s1
    8000087a:	85ce                	mv	a1,s3
    8000087c:	854a                	mv	a0,s2
    8000087e:	a23ff0ef          	jal	800002a0 <memmove>
}
    80000882:	70a2                	ld	ra,40(sp)
    80000884:	7402                	ld	s0,32(sp)
    80000886:	64e2                	ld	s1,24(sp)
    80000888:	6942                	ld	s2,16(sp)
    8000088a:	69a2                	ld	s3,8(sp)
    8000088c:	6a02                	ld	s4,0(sp)
    8000088e:	6145                	addi	sp,sp,48
    80000890:	8082                	ret
    panic("uvmfirst: more than a page");
    80000892:	00007517          	auipc	a0,0x7
    80000896:	89650513          	addi	a0,a0,-1898 # 80007128 <etext+0x128>
    8000089a:	57d040ef          	jal	80005616 <panic>

000000008000089e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000089e:	1101                	addi	sp,sp,-32
    800008a0:	ec06                	sd	ra,24(sp)
    800008a2:	e822                	sd	s0,16(sp)
    800008a4:	e426                	sd	s1,8(sp)
    800008a6:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008a8:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008aa:	00b67d63          	bgeu	a2,a1,800008c4 <uvmdealloc+0x26>
    800008ae:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008b0:	6785                	lui	a5,0x1
    800008b2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008b4:	00f60733          	add	a4,a2,a5
    800008b8:	76fd                	lui	a3,0xfffff
    800008ba:	8f75                	and	a4,a4,a3
    800008bc:	97ae                	add	a5,a5,a1
    800008be:	8ff5                	and	a5,a5,a3
    800008c0:	00f76863          	bltu	a4,a5,800008d0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008c4:	8526                	mv	a0,s1
    800008c6:	60e2                	ld	ra,24(sp)
    800008c8:	6442                	ld	s0,16(sp)
    800008ca:	64a2                	ld	s1,8(sp)
    800008cc:	6105                	addi	sp,sp,32
    800008ce:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008d0:	8f99                	sub	a5,a5,a4
    800008d2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008d4:	4685                	li	a3,1
    800008d6:	0007861b          	sext.w	a2,a5
    800008da:	85ba                	mv	a1,a4
    800008dc:	e73ff0ef          	jal	8000074e <uvmunmap>
    800008e0:	b7d5                	j	800008c4 <uvmdealloc+0x26>

00000000800008e2 <uvmalloc>:
  if(newsz < oldsz)
    800008e2:	08b66f63          	bltu	a2,a1,80000980 <uvmalloc+0x9e>
{
    800008e6:	715d                	addi	sp,sp,-80
    800008e8:	e486                	sd	ra,72(sp)
    800008ea:	e0a2                	sd	s0,64(sp)
    800008ec:	f052                	sd	s4,32(sp)
    800008ee:	ec56                	sd	s5,24(sp)
    800008f0:	e85a                	sd	s6,16(sp)
    800008f2:	0880                	addi	s0,sp,80
    800008f4:	8b2a                	mv	s6,a0
    800008f6:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    800008f8:	6785                	lui	a5,0x1
    800008fa:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008fc:	95be                	add	a1,a1,a5
    800008fe:	77fd                	lui	a5,0xfffff
    80000900:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += sz){
    80000904:	08ca7063          	bgeu	s4,a2,80000984 <uvmalloc+0xa2>
    80000908:	fc26                	sd	s1,56(sp)
    8000090a:	f84a                	sd	s2,48(sp)
    8000090c:	f44e                	sd	s3,40(sp)
    8000090e:	e45e                	sd	s7,8(sp)
    80000910:	8952                	mv	s2,s4
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000912:	0126eb93          	ori	s7,a3,18
    80000916:	6985                	lui	s3,0x1
    mem = kalloc();
    80000918:	841ff0ef          	jal	80000158 <kalloc>
    8000091c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000091e:	c115                	beqz	a0,80000942 <uvmalloc+0x60>
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000920:	875e                	mv	a4,s7
    80000922:	86aa                	mv	a3,a0
    80000924:	864e                	mv	a2,s3
    80000926:	85ca                	mv	a1,s2
    80000928:	855a                	mv	a0,s6
    8000092a:	c7fff0ef          	jal	800005a8 <mappages>
    8000092e:	e91d                	bnez	a0,80000964 <uvmalloc+0x82>
  for(a = oldsz; a < newsz; a += sz){
    80000930:	994e                	add	s2,s2,s3
    80000932:	ff5963e3          	bltu	s2,s5,80000918 <uvmalloc+0x36>
  return newsz;
    80000936:	8556                	mv	a0,s5
    80000938:	74e2                	ld	s1,56(sp)
    8000093a:	7942                	ld	s2,48(sp)
    8000093c:	79a2                	ld	s3,40(sp)
    8000093e:	6ba2                	ld	s7,8(sp)
    80000940:	a819                	j	80000956 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000942:	8652                	mv	a2,s4
    80000944:	85ca                	mv	a1,s2
    80000946:	855a                	mv	a0,s6
    80000948:	f57ff0ef          	jal	8000089e <uvmdealloc>
      return 0;
    8000094c:	4501                	li	a0,0
    8000094e:	74e2                	ld	s1,56(sp)
    80000950:	7942                	ld	s2,48(sp)
    80000952:	79a2                	ld	s3,40(sp)
    80000954:	6ba2                	ld	s7,8(sp)
}
    80000956:	60a6                	ld	ra,72(sp)
    80000958:	6406                	ld	s0,64(sp)
    8000095a:	7a02                	ld	s4,32(sp)
    8000095c:	6ae2                	ld	s5,24(sp)
    8000095e:	6b42                	ld	s6,16(sp)
    80000960:	6161                	addi	sp,sp,80
    80000962:	8082                	ret
      kfree(mem);
    80000964:	8526                	mv	a0,s1
    80000966:	eb6ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000096a:	8652                	mv	a2,s4
    8000096c:	85ca                	mv	a1,s2
    8000096e:	855a                	mv	a0,s6
    80000970:	f2fff0ef          	jal	8000089e <uvmdealloc>
      return 0;
    80000974:	4501                	li	a0,0
    80000976:	74e2                	ld	s1,56(sp)
    80000978:	7942                	ld	s2,48(sp)
    8000097a:	79a2                	ld	s3,40(sp)
    8000097c:	6ba2                	ld	s7,8(sp)
    8000097e:	bfe1                	j	80000956 <uvmalloc+0x74>
    return oldsz;
    80000980:	852e                	mv	a0,a1
}
    80000982:	8082                	ret
  return newsz;
    80000984:	8532                	mv	a0,a2
    80000986:	bfc1                	j	80000956 <uvmalloc+0x74>

0000000080000988 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000988:	7179                	addi	sp,sp,-48
    8000098a:	f406                	sd	ra,40(sp)
    8000098c:	f022                	sd	s0,32(sp)
    8000098e:	ec26                	sd	s1,24(sp)
    80000990:	e84a                	sd	s2,16(sp)
    80000992:	e44e                	sd	s3,8(sp)
    80000994:	e052                	sd	s4,0(sp)
    80000996:	1800                	addi	s0,sp,48
    80000998:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000099a:	84aa                	mv	s1,a0
    8000099c:	6905                	lui	s2,0x1
    8000099e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a0:	4985                	li	s3,1
    800009a2:	a819                	j	800009b8 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009a4:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009a6:	00c79513          	slli	a0,a5,0xc
    800009aa:	fdfff0ef          	jal	80000988 <freewalk>
      pagetable[i] = 0;
    800009ae:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009b2:	04a1                	addi	s1,s1,8
    800009b4:	01248f63          	beq	s1,s2,800009d2 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800009b8:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ba:	00f7f713          	andi	a4,a5,15
    800009be:	ff3703e3          	beq	a4,s3,800009a4 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009c2:	8b85                	andi	a5,a5,1
    800009c4:	d7fd                	beqz	a5,800009b2 <freewalk+0x2a>
      panic("freewalk: leaf");
    800009c6:	00006517          	auipc	a0,0x6
    800009ca:	78250513          	addi	a0,a0,1922 # 80007148 <etext+0x148>
    800009ce:	449040ef          	jal	80005616 <panic>
    }
  }
  kfree((void*)pagetable);
    800009d2:	8552                	mv	a0,s4
    800009d4:	e48ff0ef          	jal	8000001c <kfree>
}
    800009d8:	70a2                	ld	ra,40(sp)
    800009da:	7402                	ld	s0,32(sp)
    800009dc:	64e2                	ld	s1,24(sp)
    800009de:	6942                	ld	s2,16(sp)
    800009e0:	69a2                	ld	s3,8(sp)
    800009e2:	6a02                	ld	s4,0(sp)
    800009e4:	6145                	addi	sp,sp,48
    800009e6:	8082                	ret

00000000800009e8 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009e8:	1101                	addi	sp,sp,-32
    800009ea:	ec06                	sd	ra,24(sp)
    800009ec:	e822                	sd	s0,16(sp)
    800009ee:	e426                	sd	s1,8(sp)
    800009f0:	1000                	addi	s0,sp,32
    800009f2:	84aa                	mv	s1,a0
  if(sz > 0)
    800009f4:	e989                	bnez	a1,80000a06 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009f6:	8526                	mv	a0,s1
    800009f8:	f91ff0ef          	jal	80000988 <freewalk>
}
    800009fc:	60e2                	ld	ra,24(sp)
    800009fe:	6442                	ld	s0,16(sp)
    80000a00:	64a2                	ld	s1,8(sp)
    80000a02:	6105                	addi	sp,sp,32
    80000a04:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a06:	6785                	lui	a5,0x1
    80000a08:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a0a:	95be                	add	a1,a1,a5
    80000a0c:	4685                	li	a3,1
    80000a0e:	00c5d613          	srli	a2,a1,0xc
    80000a12:	4581                	li	a1,0
    80000a14:	d3bff0ef          	jal	8000074e <uvmunmap>
    80000a18:	bff9                	j	800009f6 <uvmfree+0xe>

0000000080000a1a <uvmcopy>:
// Copies both the page table and the
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80000a1a:	715d                	addi	sp,sp,-80
    80000a1c:	e486                	sd	ra,72(sp)
    80000a1e:	e0a2                	sd	s0,64(sp)
    80000a20:	e062                	sd	s8,0(sp)
    80000a22:	0880                	addi	s0,sp,80
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; i += PGSIZE){
    80000a24:	c245                	beqz	a2,80000ac4 <uvmcopy+0xaa>
    80000a26:	fc26                	sd	s1,56(sp)
    80000a28:	f84a                	sd	s2,48(sp)
    80000a2a:	f44e                	sd	s3,40(sp)
    80000a2c:	f052                	sd	s4,32(sp)
    80000a2e:	ec56                	sd	s5,24(sp)
    80000a30:	e85a                	sd	s6,16(sp)
    80000a32:	e45e                	sd	s7,8(sp)
    80000a34:	8a2a                	mv	s4,a0
    80000a36:	8aae                	mv	s5,a1
    80000a38:	89b2                	mv	s3,a2
    80000a3a:	4481                	li	s1,0
    flags = PTE_FLAGS(*pte);

    if(flags & PTE_W){
      flags &= ~PTE_W;
      flags |= PTE_COW;
      *pte = PA2PTE(pa) | flags;
    80000a3c:	7b7d                	lui	s6,0xfffff
    80000a3e:	002b5b13          	srli	s6,s6,0x2
    }

    if(mappages(new, i, PGSIZE, pa, flags) != 0){
    80000a42:	6905                	lui	s2,0x1
    80000a44:	a099                	j	80000a8a <uvmcopy+0x70>
      panic("uvmcopy: pte should exist");
    80000a46:	00006517          	auipc	a0,0x6
    80000a4a:	71250513          	addi	a0,a0,1810 # 80007158 <etext+0x158>
    80000a4e:	3c9040ef          	jal	80005616 <panic>
      panic("uvmcopy: page not present");
    80000a52:	00006517          	auipc	a0,0x6
    80000a56:	72650513          	addi	a0,a0,1830 # 80007178 <etext+0x178>
    80000a5a:	3bd040ef          	jal	80005616 <panic>
      flags &= ~PTE_W;
    80000a5e:	3fb77693          	andi	a3,a4,1019
      flags |= PTE_COW;
    80000a62:	1006e713          	ori	a4,a3,256
      *pte = PA2PTE(pa) | flags;
    80000a66:	0167f7b3          	and	a5,a5,s6
    80000a6a:	8fd9                	or	a5,a5,a4
    80000a6c:	e11c                	sd	a5,0(a0)
    if(mappages(new, i, PGSIZE, pa, flags) != 0){
    80000a6e:	86de                	mv	a3,s7
    80000a70:	864a                	mv	a2,s2
    80000a72:	85a6                	mv	a1,s1
    80000a74:	8556                	mv	a0,s5
    80000a76:	b33ff0ef          	jal	800005a8 <mappages>
    80000a7a:	8c2a                	mv	s8,a0
    80000a7c:	e531                	bnez	a0,80000ac8 <uvmcopy+0xae>
      return -1;
    }

    incref(pa); // refcounting
    80000a7e:	855e                	mv	a0,s7
    80000a80:	f30ff0ef          	jal	800001b0 <incref>
  for(i = 0; i < sz; i += PGSIZE){
    80000a84:	94ca                	add	s1,s1,s2
    80000a86:	0334f763          	bgeu	s1,s3,80000ab4 <uvmcopy+0x9a>
    if((pte = walk(old, i, 0)) == 0)
    80000a8a:	4601                	li	a2,0
    80000a8c:	85a6                	mv	a1,s1
    80000a8e:	8552                	mv	a0,s4
    80000a90:	a41ff0ef          	jal	800004d0 <walk>
    80000a94:	d94d                	beqz	a0,80000a46 <uvmcopy+0x2c>
    if((*pte & PTE_V) == 0)
    80000a96:	611c                	ld	a5,0(a0)
    80000a98:	0017f713          	andi	a4,a5,1
    80000a9c:	db5d                	beqz	a4,80000a52 <uvmcopy+0x38>
    pa = PTE2PA(*pte);
    80000a9e:	00a7db93          	srli	s7,a5,0xa
    80000aa2:	0bb2                	slli	s7,s7,0xc
    flags = PTE_FLAGS(*pte);
    80000aa4:	0007871b          	sext.w	a4,a5
    if(flags & PTE_W){
    80000aa8:	0047f693          	andi	a3,a5,4
    80000aac:	facd                	bnez	a3,80000a5e <uvmcopy+0x44>
    flags = PTE_FLAGS(*pte);
    80000aae:	3ff77713          	andi	a4,a4,1023
    80000ab2:	bf75                	j	80000a6e <uvmcopy+0x54>
    80000ab4:	74e2                	ld	s1,56(sp)
    80000ab6:	7942                	ld	s2,48(sp)
    80000ab8:	79a2                	ld	s3,40(sp)
    80000aba:	7a02                	ld	s4,32(sp)
    80000abc:	6ae2                	ld	s5,24(sp)
    80000abe:	6b42                	ld	s6,16(sp)
    80000ac0:	6ba2                	ld	s7,8(sp)
    80000ac2:	a819                	j	80000ad8 <uvmcopy+0xbe>
  }
  return 0;
    80000ac4:	4c01                	li	s8,0
    80000ac6:	a809                	j	80000ad8 <uvmcopy+0xbe>
      return -1;
    80000ac8:	5c7d                	li	s8,-1
    80000aca:	74e2                	ld	s1,56(sp)
    80000acc:	7942                	ld	s2,48(sp)
    80000ace:	79a2                	ld	s3,40(sp)
    80000ad0:	7a02                	ld	s4,32(sp)
    80000ad2:	6ae2                	ld	s5,24(sp)
    80000ad4:	6b42                	ld	s6,16(sp)
    80000ad6:	6ba2                	ld	s7,8(sp)
}
    80000ad8:	8562                	mv	a0,s8
    80000ada:	60a6                	ld	ra,72(sp)
    80000adc:	6406                	ld	s0,64(sp)
    80000ade:	6c02                	ld	s8,0(sp)
    80000ae0:	6161                	addi	sp,sp,80
    80000ae2:	8082                	ret

0000000080000ae4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;
  
  while(len > 0){
    80000ae4:	c6a5                	beqz	a3,80000b4c <copyin+0x68>
{
    80000ae6:	715d                	addi	sp,sp,-80
    80000ae8:	e486                	sd	ra,72(sp)
    80000aea:	e0a2                	sd	s0,64(sp)
    80000aec:	fc26                	sd	s1,56(sp)
    80000aee:	f84a                	sd	s2,48(sp)
    80000af0:	f44e                	sd	s3,40(sp)
    80000af2:	f052                	sd	s4,32(sp)
    80000af4:	ec56                	sd	s5,24(sp)
    80000af6:	e85a                	sd	s6,16(sp)
    80000af8:	e45e                	sd	s7,8(sp)
    80000afa:	e062                	sd	s8,0(sp)
    80000afc:	0880                	addi	s0,sp,80
    80000afe:	8b2a                	mv	s6,a0
    80000b00:	8a2e                	mv	s4,a1
    80000b02:	8c32                	mv	s8,a2
    80000b04:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000b06:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b08:	6a85                	lui	s5,0x1
    80000b0a:	a00d                	j	80000b2c <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000b0c:	018505b3          	add	a1,a0,s8
    80000b10:	0004861b          	sext.w	a2,s1
    80000b14:	412585b3          	sub	a1,a1,s2
    80000b18:	8552                	mv	a0,s4
    80000b1a:	f86ff0ef          	jal	800002a0 <memmove>

    len -= n;
    80000b1e:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000b22:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000b24:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b28:	02098063          	beqz	s3,80000b48 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000b2c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b30:	85ca                	mv	a1,s2
    80000b32:	855a                	mv	a0,s6
    80000b34:	a37ff0ef          	jal	8000056a <walkaddr>
    if(pa0 == 0)
    80000b38:	cd01                	beqz	a0,80000b50 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000b3a:	418904b3          	sub	s1,s2,s8
    80000b3e:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b40:	fc99f6e3          	bgeu	s3,s1,80000b0c <copyin+0x28>
    80000b44:	84ce                	mv	s1,s3
    80000b46:	b7d9                	j	80000b0c <copyin+0x28>
  }
  return 0;
    80000b48:	4501                	li	a0,0
    80000b4a:	a021                	j	80000b52 <copyin+0x6e>
    80000b4c:	4501                	li	a0,0
}
    80000b4e:	8082                	ret
      return -1;
    80000b50:	557d                	li	a0,-1
}
    80000b52:	60a6                	ld	ra,72(sp)
    80000b54:	6406                	ld	s0,64(sp)
    80000b56:	74e2                	ld	s1,56(sp)
    80000b58:	7942                	ld	s2,48(sp)
    80000b5a:	79a2                	ld	s3,40(sp)
    80000b5c:	7a02                	ld	s4,32(sp)
    80000b5e:	6ae2                	ld	s5,24(sp)
    80000b60:	6b42                	ld	s6,16(sp)
    80000b62:	6ba2                	ld	s7,8(sp)
    80000b64:	6c02                	ld	s8,0(sp)
    80000b66:	6161                	addi	sp,sp,80
    80000b68:	8082                	ret

0000000080000b6a <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80000b6a:	715d                	addi	sp,sp,-80
    80000b6c:	e486                	sd	ra,72(sp)
    80000b6e:	e0a2                	sd	s0,64(sp)
    80000b70:	fc26                	sd	s1,56(sp)
    80000b72:	f84a                	sd	s2,48(sp)
    80000b74:	f44e                	sd	s3,40(sp)
    80000b76:	f052                	sd	s4,32(sp)
    80000b78:	ec56                	sd	s5,24(sp)
    80000b7a:	e85a                	sd	s6,16(sp)
    80000b7c:	e45e                	sd	s7,8(sp)
    80000b7e:	0880                	addi	s0,sp,80
    80000b80:	8aaa                	mv	s5,a0
    80000b82:	89ae                	mv	s3,a1
    80000b84:	8bb2                	mv	s7,a2
    80000b86:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    80000b88:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b8a:	6a05                	lui	s4,0x1
    80000b8c:	a02d                	j	80000bb6 <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b8e:	00078023          	sb	zero,0(a5)
    80000b92:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b94:	0017c793          	xori	a5,a5,1
    80000b98:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b9c:	60a6                	ld	ra,72(sp)
    80000b9e:	6406                	ld	s0,64(sp)
    80000ba0:	74e2                	ld	s1,56(sp)
    80000ba2:	7942                	ld	s2,48(sp)
    80000ba4:	79a2                	ld	s3,40(sp)
    80000ba6:	7a02                	ld	s4,32(sp)
    80000ba8:	6ae2                	ld	s5,24(sp)
    80000baa:	6b42                	ld	s6,16(sp)
    80000bac:	6ba2                	ld	s7,8(sp)
    80000bae:	6161                	addi	sp,sp,80
    80000bb0:	8082                	ret
    srcva = va0 + PGSIZE;
    80000bb2:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80000bb6:	c4b1                	beqz	s1,80000c02 <copyinstr+0x98>
    va0 = PGROUNDDOWN(srcva);
    80000bb8:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80000bbc:	85ca                	mv	a1,s2
    80000bbe:	8556                	mv	a0,s5
    80000bc0:	9abff0ef          	jal	8000056a <walkaddr>
    if(pa0 == 0)
    80000bc4:	c129                	beqz	a0,80000c06 <copyinstr+0x9c>
    n = PGSIZE - (srcva - va0);
    80000bc6:	41790633          	sub	a2,s2,s7
    80000bca:	9652                	add	a2,a2,s4
    if(n > max)
    80000bcc:	00c4f363          	bgeu	s1,a2,80000bd2 <copyinstr+0x68>
    80000bd0:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000bd2:	412b8bb3          	sub	s7,s7,s2
    80000bd6:	9baa                	add	s7,s7,a0
    while(n > 0){
    80000bd8:	de69                	beqz	a2,80000bb2 <copyinstr+0x48>
    80000bda:	87ce                	mv	a5,s3
      if(*p == '\0'){
    80000bdc:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    80000be0:	964e                	add	a2,a2,s3
    80000be2:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000be4:	00f68733          	add	a4,a3,a5
    80000be8:	00074703          	lbu	a4,0(a4)
    80000bec:	d34d                	beqz	a4,80000b8e <copyinstr+0x24>
        *dst = *p;
    80000bee:	00e78023          	sb	a4,0(a5)
      dst++;
    80000bf2:	0785                	addi	a5,a5,1
    while(n > 0){
    80000bf4:	fec797e3          	bne	a5,a2,80000be2 <copyinstr+0x78>
    80000bf8:	14fd                	addi	s1,s1,-1
    80000bfa:	94ce                	add	s1,s1,s3
      --max;
    80000bfc:	8c8d                	sub	s1,s1,a1
    80000bfe:	89be                	mv	s3,a5
    80000c00:	bf4d                	j	80000bb2 <copyinstr+0x48>
    80000c02:	4781                	li	a5,0
    80000c04:	bf41                	j	80000b94 <copyinstr+0x2a>
      return -1;
    80000c06:	557d                	li	a0,-1
    80000c08:	bf51                	j	80000b9c <copyinstr+0x32>

0000000080000c0a <handle_cow_fault>:
  return walk(pagetable, va, 0);
}
#endif

// Handle a page fault caused by a write to a COW page
int handle_cow_fault(uint64 va) {
    80000c0a:	7179                	addi	sp,sp,-48
    80000c0c:	f406                	sd	ra,40(sp)
    80000c0e:	f022                	sd	s0,32(sp)
    80000c10:	ec26                	sd	s1,24(sp)
    80000c12:	1800                	addi	s0,sp,48
    80000c14:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80000c16:	340000ef          	jal	80000f56 <myproc>
  if(p == 0)
    80000c1a:	c949                	beqz	a0,80000cac <handle_cow_fault+0xa2>
    return -1;

  // Check if address is valid
  if(va >= MAXVA)
    80000c1c:	57fd                	li	a5,-1
    80000c1e:	83e9                	srli	a5,a5,0x1a
    80000c20:	0897e863          	bltu	a5,s1,80000cb0 <handle_cow_fault+0xa6>
    80000c24:	e44e                	sd	s3,8(sp)

  // Round down to page boundary
  va = PGROUNDDOWN(va);

  // Walk the page table to get PTE
  pte_t *pte = walk(p->pagetable, va, 0);
    80000c26:	4601                	li	a2,0
    80000c28:	75fd                	lui	a1,0xfffff
    80000c2a:	8de5                	and	a1,a1,s1
    80000c2c:	6928                	ld	a0,80(a0)
    80000c2e:	8a3ff0ef          	jal	800004d0 <walk>
    80000c32:	89aa                	mv	s3,a0
  if(pte == 0)
    80000c34:	c141                	beqz	a0,80000cb4 <handle_cow_fault+0xaa>
    return -1;

  // Check if this is actually a COW page
  if((*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 || (*pte & PTE_COW) == 0)
    80000c36:	6104                	ld	s1,0(a0)
    80000c38:	1114f713          	andi	a4,s1,273
    80000c3c:	11100793          	li	a5,273
    80000c40:	06f71d63          	bne	a4,a5,80000cba <handle_cow_fault+0xb0>
    return -1;

  // Get the physical address
  uint64 pa = PTE2PA(*pte);
    80000c44:	80a9                	srli	s1,s1,0xa
    80000c46:	04b2                	slli	s1,s1,0xc
  
  // If reference count is 1, just make the page writable
  if(refcount(pa) == 1) {
    80000c48:	8526                	mv	a0,s1
    80000c4a:	db8ff0ef          	jal	80000202 <refcount>
    80000c4e:	4785                	li	a5,1
    80000c50:	04f50363          	beq	a0,a5,80000c96 <handle_cow_fault+0x8c>
    80000c54:	e84a                	sd	s2,16(sp)
    *pte &= ~PTE_COW;
    return 0;
  }

  // Allocate new page
  char *mem = kalloc();
    80000c56:	d02ff0ef          	jal	80000158 <kalloc>
    80000c5a:	892a                	mv	s2,a0
  if(mem == 0)
    80000c5c:	c135                	beqz	a0,80000cc0 <handle_cow_fault+0xb6>
    return -1;

  // Copy the old page contents
  memmove(mem, (char*)pa, PGSIZE);
    80000c5e:	6605                	lui	a2,0x1
    80000c60:	85a6                	mv	a1,s1
    80000c62:	e3eff0ef          	jal	800002a0 <memmove>

  // Map the new page with write permissions
  uint64 flags = (PTE_FLAGS(*pte) | PTE_W) & ~PTE_COW;
    80000c66:	0009b783          	ld	a5,0(s3) # 1000 <_entry-0x7ffff000>
    80000c6a:	2fb7f793          	andi	a5,a5,763
  *pte = PA2PTE((uint64)mem) | flags;
    80000c6e:	00c95913          	srli	s2,s2,0xc
    80000c72:	092a                	slli	s2,s2,0xa
    80000c74:	0127e7b3          	or	a5,a5,s2
    80000c78:	0047e793          	ori	a5,a5,4
    80000c7c:	00f9b023          	sd	a5,0(s3)

  // Decrease reference count of old page
  decref(pa);
    80000c80:	8526                	mv	a0,s1
    80000c82:	d6cff0ef          	jal	800001ee <decref>

  return 0;
    80000c86:	4501                	li	a0,0
    80000c88:	6942                	ld	s2,16(sp)
    80000c8a:	69a2                	ld	s3,8(sp)
}
    80000c8c:	70a2                	ld	ra,40(sp)
    80000c8e:	7402                	ld	s0,32(sp)
    80000c90:	64e2                	ld	s1,24(sp)
    80000c92:	6145                	addi	sp,sp,48
    80000c94:	8082                	ret
    *pte &= ~PTE_COW;
    80000c96:	0009b783          	ld	a5,0(s3)
    80000c9a:	eff7f793          	andi	a5,a5,-257
    80000c9e:	0047e793          	ori	a5,a5,4
    80000ca2:	00f9b023          	sd	a5,0(s3)
    return 0;
    80000ca6:	4501                	li	a0,0
    80000ca8:	69a2                	ld	s3,8(sp)
    80000caa:	b7cd                	j	80000c8c <handle_cow_fault+0x82>
    return -1;
    80000cac:	557d                	li	a0,-1
    80000cae:	bff9                	j	80000c8c <handle_cow_fault+0x82>
    return -1;
    80000cb0:	557d                	li	a0,-1
    80000cb2:	bfe9                	j	80000c8c <handle_cow_fault+0x82>
    return -1;
    80000cb4:	557d                	li	a0,-1
    80000cb6:	69a2                	ld	s3,8(sp)
    80000cb8:	bfd1                	j	80000c8c <handle_cow_fault+0x82>
    return -1;
    80000cba:	557d                	li	a0,-1
    80000cbc:	69a2                	ld	s3,8(sp)
    80000cbe:	b7f9                	j	80000c8c <handle_cow_fault+0x82>
    return -1;
    80000cc0:	557d                	li	a0,-1
    80000cc2:	6942                	ld	s2,16(sp)
    80000cc4:	69a2                	ld	s3,8(sp)
    80000cc6:	b7d9                	j	80000c8c <handle_cow_fault+0x82>

0000000080000cc8 <copyout>:
  while(len > 0){
    80000cc8:	c6dd                	beqz	a3,80000d76 <copyout+0xae>
{
    80000cca:	7159                	addi	sp,sp,-112
    80000ccc:	f486                	sd	ra,104(sp)
    80000cce:	f0a2                	sd	s0,96(sp)
    80000cd0:	eca6                	sd	s1,88(sp)
    80000cd2:	e8ca                	sd	s2,80(sp)
    80000cd4:	e4ce                	sd	s3,72(sp)
    80000cd6:	e0d2                	sd	s4,64(sp)
    80000cd8:	fc56                	sd	s5,56(sp)
    80000cda:	f85a                	sd	s6,48(sp)
    80000cdc:	f45e                	sd	s7,40(sp)
    80000cde:	f062                	sd	s8,32(sp)
    80000ce0:	ec66                	sd	s9,24(sp)
    80000ce2:	e86a                	sd	s10,16(sp)
    80000ce4:	e46e                	sd	s11,8(sp)
    80000ce6:	1880                	addi	s0,sp,112
    80000ce8:	8b2a                	mv	s6,a0
    80000cea:	892e                	mv	s2,a1
    80000cec:	8a32                	mv	s4,a2
    80000cee:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000cf0:	7c7d                	lui	s8,0xfffff
    if(va0 >= MAXVA)
    80000cf2:	5bfd                	li	s7,-1
    80000cf4:	01abdb93          	srli	s7,s7,0x1a
    if((*pte & PTE_V) && (*pte & PTE_COW)) {
    80000cf8:	10100c93          	li	s9,257
    if((*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 || (*pte & PTE_W) == 0)
    80000cfc:	4d55                	li	s10,21
    n = PGSIZE - (dstva - va0);
    80000cfe:	6a85                	lui	s5,0x1
    80000d00:	a81d                	j	80000d36 <copyout+0x6e>
      if(handle_cow_fault(va0) < 0)
    80000d02:	8526                	mv	a0,s1
    80000d04:	f07ff0ef          	jal	80000c0a <handle_cow_fault>
    80000d08:	08054b63          	bltz	a0,80000d9e <copyout+0xd6>
      pte = walk(pagetable, va0, 0);  // Re-walk since PTE might have changed
    80000d0c:	4601                	li	a2,0
    80000d0e:	85a6                	mv	a1,s1
    80000d10:	855a                	mv	a0,s6
    80000d12:	fbeff0ef          	jal	800004d0 <walk>
    80000d16:	a83d                	j	80000d54 <copyout+0x8c>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000d18:	40990533          	sub	a0,s2,s1
    80000d1c:	000d861b          	sext.w	a2,s11
    80000d20:	85d2                	mv	a1,s4
    80000d22:	953e                	add	a0,a0,a5
    80000d24:	d7cff0ef          	jal	800002a0 <memmove>
    len -= n;
    80000d28:	41b989b3          	sub	s3,s3,s11
    src += n;
    80000d2c:	9a6e                	add	s4,s4,s11
    dstva = va0 + PGSIZE;
    80000d2e:	01548933          	add	s2,s1,s5
  while(len > 0){
    80000d32:	04098063          	beqz	s3,80000d72 <copyout+0xaa>
    va0 = PGROUNDDOWN(dstva);
    80000d36:	018974b3          	and	s1,s2,s8
    if(va0 >= MAXVA)
    80000d3a:	049be063          	bltu	s7,s1,80000d7a <copyout+0xb2>
    pte = walk(pagetable, va0, 0);
    80000d3e:	4601                	li	a2,0
    80000d40:	85a6                	mv	a1,s1
    80000d42:	855a                	mv	a0,s6
    80000d44:	f8cff0ef          	jal	800004d0 <walk>
    if(pte == 0)
    80000d48:	c929                	beqz	a0,80000d9a <copyout+0xd2>
    if((*pte & PTE_V) && (*pte & PTE_COW)) {
    80000d4a:	611c                	ld	a5,0(a0)
    80000d4c:	1017f793          	andi	a5,a5,257
    80000d50:	fb9789e3          	beq	a5,s9,80000d02 <copyout+0x3a>
    if((*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 || (*pte & PTE_W) == 0)
    80000d54:	611c                	ld	a5,0(a0)
    80000d56:	0157f713          	andi	a4,a5,21
    80000d5a:	05a71463          	bne	a4,s10,80000da2 <copyout+0xda>
    pa0 = PTE2PA(*pte);
    80000d5e:	83a9                	srli	a5,a5,0xa
    80000d60:	07b2                	slli	a5,a5,0xc
    if(pa0 == 0)
    80000d62:	c3b1                	beqz	a5,80000da6 <copyout+0xde>
    n = PGSIZE - (dstva - va0);
    80000d64:	41248db3          	sub	s11,s1,s2
    80000d68:	9dd6                	add	s11,s11,s5
    if(n > len)
    80000d6a:	fbb9f7e3          	bgeu	s3,s11,80000d18 <copyout+0x50>
    80000d6e:	8dce                	mv	s11,s3
    80000d70:	b765                	j	80000d18 <copyout+0x50>
  return 0;
    80000d72:	4501                	li	a0,0
    80000d74:	a021                	j	80000d7c <copyout+0xb4>
    80000d76:	4501                	li	a0,0
}
    80000d78:	8082                	ret
      return -1;
    80000d7a:	557d                	li	a0,-1
}
    80000d7c:	70a6                	ld	ra,104(sp)
    80000d7e:	7406                	ld	s0,96(sp)
    80000d80:	64e6                	ld	s1,88(sp)
    80000d82:	6946                	ld	s2,80(sp)
    80000d84:	69a6                	ld	s3,72(sp)
    80000d86:	6a06                	ld	s4,64(sp)
    80000d88:	7ae2                	ld	s5,56(sp)
    80000d8a:	7b42                	ld	s6,48(sp)
    80000d8c:	7ba2                	ld	s7,40(sp)
    80000d8e:	7c02                	ld	s8,32(sp)
    80000d90:	6ce2                	ld	s9,24(sp)
    80000d92:	6d42                	ld	s10,16(sp)
    80000d94:	6da2                	ld	s11,8(sp)
    80000d96:	6165                	addi	sp,sp,112
    80000d98:	8082                	ret
      return -1;
    80000d9a:	557d                	li	a0,-1
    80000d9c:	b7c5                	j	80000d7c <copyout+0xb4>
        return -1;
    80000d9e:	557d                	li	a0,-1
    80000da0:	bff1                	j	80000d7c <copyout+0xb4>
      return -1;
    80000da2:	557d                	li	a0,-1
    80000da4:	bfe1                	j	80000d7c <copyout+0xb4>
      return -1;
    80000da6:	557d                	li	a0,-1
    80000da8:	bfd1                	j	80000d7c <copyout+0xb4>

0000000080000daa <uvmclear>:

// Clear PTE_U bit in a PTE, used to make a page inaccessible to user code.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000daa:	1141                	addi	sp,sp,-16
    80000dac:	e406                	sd	ra,8(sp)
    80000dae:	e022                	sd	s0,0(sp)
    80000db0:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000db2:	4601                	li	a2,0
    80000db4:	f1cff0ef          	jal	800004d0 <walk>
  if(pte == 0)
    80000db8:	c901                	beqz	a0,80000dc8 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000dba:	611c                	ld	a5,0(a0)
    80000dbc:	9bbd                	andi	a5,a5,-17
    80000dbe:	e11c                	sd	a5,0(a0)
}
    80000dc0:	60a2                	ld	ra,8(sp)
    80000dc2:	6402                	ld	s0,0(sp)
    80000dc4:	0141                	addi	sp,sp,16
    80000dc6:	8082                	ret
    panic("uvmclear");
    80000dc8:	00006517          	auipc	a0,0x6
    80000dcc:	3d050513          	addi	a0,a0,976 # 80007198 <etext+0x198>
    80000dd0:	047040ef          	jal	80005616 <panic>

0000000080000dd4 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000dd4:	715d                	addi	sp,sp,-80
    80000dd6:	e486                	sd	ra,72(sp)
    80000dd8:	e0a2                	sd	s0,64(sp)
    80000dda:	fc26                	sd	s1,56(sp)
    80000ddc:	f84a                	sd	s2,48(sp)
    80000dde:	f44e                	sd	s3,40(sp)
    80000de0:	f052                	sd	s4,32(sp)
    80000de2:	ec56                	sd	s5,24(sp)
    80000de4:	e85a                	sd	s6,16(sp)
    80000de6:	e45e                	sd	s7,8(sp)
    80000de8:	e062                	sd	s8,0(sp)
    80000dea:	0880                	addi	s0,sp,80
    80000dec:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dee:	0022a497          	auipc	s1,0x22a
    80000df2:	a2248493          	addi	s1,s1,-1502 # 8022a810 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000df6:	8c26                	mv	s8,s1
    80000df8:	a4fa57b7          	lui	a5,0xa4fa5
    80000dfc:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24d618b5>
    80000e00:	4fa50937          	lui	s2,0x4fa50
    80000e04:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000e08:	1902                	slli	s2,s2,0x20
    80000e0a:	993e                	add	s2,s2,a5
    80000e0c:	040009b7          	lui	s3,0x4000
    80000e10:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e12:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e14:	4b99                	li	s7,6
    80000e16:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e18:	0022fa97          	auipc	s5,0x22f
    80000e1c:	3f8a8a93          	addi	s5,s5,1016 # 80230210 <tickslock>
    char *pa = kalloc();
    80000e20:	b38ff0ef          	jal	80000158 <kalloc>
    80000e24:	862a                	mv	a2,a0
    if(pa == 0)
    80000e26:	c121                	beqz	a0,80000e66 <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    80000e28:	418485b3          	sub	a1,s1,s8
    80000e2c:	858d                	srai	a1,a1,0x3
    80000e2e:	032585b3          	mul	a1,a1,s2
    80000e32:	2585                	addiw	a1,a1,1 # fffffffffffff001 <end+0xffffffff7fdbb911>
    80000e34:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e38:	875e                	mv	a4,s7
    80000e3a:	86da                	mv	a3,s6
    80000e3c:	40b985b3          	sub	a1,s3,a1
    80000e40:	8552                	mv	a0,s4
    80000e42:	81dff0ef          	jal	8000065e <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e46:	16848493          	addi	s1,s1,360
    80000e4a:	fd549be3          	bne	s1,s5,80000e20 <proc_mapstacks+0x4c>
  }
}
    80000e4e:	60a6                	ld	ra,72(sp)
    80000e50:	6406                	ld	s0,64(sp)
    80000e52:	74e2                	ld	s1,56(sp)
    80000e54:	7942                	ld	s2,48(sp)
    80000e56:	79a2                	ld	s3,40(sp)
    80000e58:	7a02                	ld	s4,32(sp)
    80000e5a:	6ae2                	ld	s5,24(sp)
    80000e5c:	6b42                	ld	s6,16(sp)
    80000e5e:	6ba2                	ld	s7,8(sp)
    80000e60:	6c02                	ld	s8,0(sp)
    80000e62:	6161                	addi	sp,sp,80
    80000e64:	8082                	ret
      panic("kalloc");
    80000e66:	00006517          	auipc	a0,0x6
    80000e6a:	34250513          	addi	a0,a0,834 # 800071a8 <etext+0x1a8>
    80000e6e:	7a8040ef          	jal	80005616 <panic>

0000000080000e72 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000e72:	7139                	addi	sp,sp,-64
    80000e74:	fc06                	sd	ra,56(sp)
    80000e76:	f822                	sd	s0,48(sp)
    80000e78:	f426                	sd	s1,40(sp)
    80000e7a:	f04a                	sd	s2,32(sp)
    80000e7c:	ec4e                	sd	s3,24(sp)
    80000e7e:	e852                	sd	s4,16(sp)
    80000e80:	e456                	sd	s5,8(sp)
    80000e82:	e05a                	sd	s6,0(sp)
    80000e84:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e86:	00006597          	auipc	a1,0x6
    80000e8a:	32a58593          	addi	a1,a1,810 # 800071b0 <etext+0x1b0>
    80000e8e:	00229517          	auipc	a0,0x229
    80000e92:	55250513          	addi	a0,a0,1362 # 8022a3e0 <pid_lock>
    80000e96:	22b040ef          	jal	800058c0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e9a:	00006597          	auipc	a1,0x6
    80000e9e:	31e58593          	addi	a1,a1,798 # 800071b8 <etext+0x1b8>
    80000ea2:	00229517          	auipc	a0,0x229
    80000ea6:	55650513          	addi	a0,a0,1366 # 8022a3f8 <wait_lock>
    80000eaa:	217040ef          	jal	800058c0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eae:	0022a497          	auipc	s1,0x22a
    80000eb2:	96248493          	addi	s1,s1,-1694 # 8022a810 <proc>
      initlock(&p->lock, "proc");
    80000eb6:	00006b17          	auipc	s6,0x6
    80000eba:	312b0b13          	addi	s6,s6,786 # 800071c8 <etext+0x1c8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000ebe:	8aa6                	mv	s5,s1
    80000ec0:	a4fa57b7          	lui	a5,0xa4fa5
    80000ec4:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24d618b5>
    80000ec8:	4fa50937          	lui	s2,0x4fa50
    80000ecc:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000ed0:	1902                	slli	s2,s2,0x20
    80000ed2:	993e                	add	s2,s2,a5
    80000ed4:	040009b7          	lui	s3,0x4000
    80000ed8:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000eda:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000edc:	0022fa17          	auipc	s4,0x22f
    80000ee0:	334a0a13          	addi	s4,s4,820 # 80230210 <tickslock>
      initlock(&p->lock, "proc");
    80000ee4:	85da                	mv	a1,s6
    80000ee6:	8526                	mv	a0,s1
    80000ee8:	1d9040ef          	jal	800058c0 <initlock>
      p->state = UNUSED;
    80000eec:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000ef0:	415487b3          	sub	a5,s1,s5
    80000ef4:	878d                	srai	a5,a5,0x3
    80000ef6:	032787b3          	mul	a5,a5,s2
    80000efa:	2785                	addiw	a5,a5,1
    80000efc:	00d7979b          	slliw	a5,a5,0xd
    80000f00:	40f987b3          	sub	a5,s3,a5
    80000f04:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f06:	16848493          	addi	s1,s1,360
    80000f0a:	fd449de3          	bne	s1,s4,80000ee4 <procinit+0x72>
  }
}
    80000f0e:	70e2                	ld	ra,56(sp)
    80000f10:	7442                	ld	s0,48(sp)
    80000f12:	74a2                	ld	s1,40(sp)
    80000f14:	7902                	ld	s2,32(sp)
    80000f16:	69e2                	ld	s3,24(sp)
    80000f18:	6a42                	ld	s4,16(sp)
    80000f1a:	6aa2                	ld	s5,8(sp)
    80000f1c:	6b02                	ld	s6,0(sp)
    80000f1e:	6121                	addi	sp,sp,64
    80000f20:	8082                	ret

0000000080000f22 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f22:	1141                	addi	sp,sp,-16
    80000f24:	e406                	sd	ra,8(sp)
    80000f26:	e022                	sd	s0,0(sp)
    80000f28:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f2a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f2c:	2501                	sext.w	a0,a0
    80000f2e:	60a2                	ld	ra,8(sp)
    80000f30:	6402                	ld	s0,0(sp)
    80000f32:	0141                	addi	sp,sp,16
    80000f34:	8082                	ret

0000000080000f36 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000f36:	1141                	addi	sp,sp,-16
    80000f38:	e406                	sd	ra,8(sp)
    80000f3a:	e022                	sd	s0,0(sp)
    80000f3c:	0800                	addi	s0,sp,16
    80000f3e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f40:	2781                	sext.w	a5,a5
    80000f42:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f44:	00229517          	auipc	a0,0x229
    80000f48:	4cc50513          	addi	a0,a0,1228 # 8022a410 <cpus>
    80000f4c:	953e                	add	a0,a0,a5
    80000f4e:	60a2                	ld	ra,8(sp)
    80000f50:	6402                	ld	s0,0(sp)
    80000f52:	0141                	addi	sp,sp,16
    80000f54:	8082                	ret

0000000080000f56 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000f56:	1101                	addi	sp,sp,-32
    80000f58:	ec06                	sd	ra,24(sp)
    80000f5a:	e822                	sd	s0,16(sp)
    80000f5c:	e426                	sd	s1,8(sp)
    80000f5e:	1000                	addi	s0,sp,32
  push_off();
    80000f60:	1a5040ef          	jal	80005904 <push_off>
    80000f64:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f66:	2781                	sext.w	a5,a5
    80000f68:	079e                	slli	a5,a5,0x7
    80000f6a:	00229717          	auipc	a4,0x229
    80000f6e:	47670713          	addi	a4,a4,1142 # 8022a3e0 <pid_lock>
    80000f72:	97ba                	add	a5,a5,a4
    80000f74:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f76:	213040ef          	jal	80005988 <pop_off>
  return p;
}
    80000f7a:	8526                	mv	a0,s1
    80000f7c:	60e2                	ld	ra,24(sp)
    80000f7e:	6442                	ld	s0,16(sp)
    80000f80:	64a2                	ld	s1,8(sp)
    80000f82:	6105                	addi	sp,sp,32
    80000f84:	8082                	ret

0000000080000f86 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f86:	1141                	addi	sp,sp,-16
    80000f88:	e406                	sd	ra,8(sp)
    80000f8a:	e022                	sd	s0,0(sp)
    80000f8c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f8e:	fc9ff0ef          	jal	80000f56 <myproc>
    80000f92:	247040ef          	jal	800059d8 <release>

  if (first) {
    80000f96:	00009797          	auipc	a5,0x9
    80000f9a:	3aa7a783          	lw	a5,938(a5) # 8000a340 <first.1>
    80000f9e:	e799                	bnez	a5,80000fac <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000fa0:	2bd000ef          	jal	80001a5c <usertrapret>
}
    80000fa4:	60a2                	ld	ra,8(sp)
    80000fa6:	6402                	ld	s0,0(sp)
    80000fa8:	0141                	addi	sp,sp,16
    80000faa:	8082                	ret
    fsinit(ROOTDEV);
    80000fac:	4505                	li	a0,1
    80000fae:	644010ef          	jal	800025f2 <fsinit>
    first = 0;
    80000fb2:	00009797          	auipc	a5,0x9
    80000fb6:	3807a723          	sw	zero,910(a5) # 8000a340 <first.1>
    __sync_synchronize();
    80000fba:	0330000f          	fence	rw,rw
    80000fbe:	b7cd                	j	80000fa0 <forkret+0x1a>

0000000080000fc0 <allocpid>:
{
    80000fc0:	1101                	addi	sp,sp,-32
    80000fc2:	ec06                	sd	ra,24(sp)
    80000fc4:	e822                	sd	s0,16(sp)
    80000fc6:	e426                	sd	s1,8(sp)
    80000fc8:	e04a                	sd	s2,0(sp)
    80000fca:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fcc:	00229917          	auipc	s2,0x229
    80000fd0:	41490913          	addi	s2,s2,1044 # 8022a3e0 <pid_lock>
    80000fd4:	854a                	mv	a0,s2
    80000fd6:	16f040ef          	jal	80005944 <acquire>
  pid = nextpid;
    80000fda:	00009797          	auipc	a5,0x9
    80000fde:	36a78793          	addi	a5,a5,874 # 8000a344 <nextpid>
    80000fe2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000fe4:	0014871b          	addiw	a4,s1,1
    80000fe8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000fea:	854a                	mv	a0,s2
    80000fec:	1ed040ef          	jal	800059d8 <release>
}
    80000ff0:	8526                	mv	a0,s1
    80000ff2:	60e2                	ld	ra,24(sp)
    80000ff4:	6442                	ld	s0,16(sp)
    80000ff6:	64a2                	ld	s1,8(sp)
    80000ff8:	6902                	ld	s2,0(sp)
    80000ffa:	6105                	addi	sp,sp,32
    80000ffc:	8082                	ret

0000000080000ffe <proc_pagetable>:
{
    80000ffe:	1101                	addi	sp,sp,-32
    80001000:	ec06                	sd	ra,24(sp)
    80001002:	e822                	sd	s0,16(sp)
    80001004:	e426                	sd	s1,8(sp)
    80001006:	e04a                	sd	s2,0(sp)
    80001008:	1000                	addi	s0,sp,32
    8000100a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000100c:	80fff0ef          	jal	8000081a <uvmcreate>
    80001010:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001012:	cd05                	beqz	a0,8000104a <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001014:	4729                	li	a4,10
    80001016:	00005697          	auipc	a3,0x5
    8000101a:	fea68693          	addi	a3,a3,-22 # 80006000 <_trampoline>
    8000101e:	6605                	lui	a2,0x1
    80001020:	040005b7          	lui	a1,0x4000
    80001024:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001026:	05b2                	slli	a1,a1,0xc
    80001028:	d80ff0ef          	jal	800005a8 <mappages>
    8000102c:	02054663          	bltz	a0,80001058 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001030:	4719                	li	a4,6
    80001032:	05893683          	ld	a3,88(s2)
    80001036:	6605                	lui	a2,0x1
    80001038:	020005b7          	lui	a1,0x2000
    8000103c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000103e:	05b6                	slli	a1,a1,0xd
    80001040:	8526                	mv	a0,s1
    80001042:	d66ff0ef          	jal	800005a8 <mappages>
    80001046:	00054f63          	bltz	a0,80001064 <proc_pagetable+0x66>
}
    8000104a:	8526                	mv	a0,s1
    8000104c:	60e2                	ld	ra,24(sp)
    8000104e:	6442                	ld	s0,16(sp)
    80001050:	64a2                	ld	s1,8(sp)
    80001052:	6902                	ld	s2,0(sp)
    80001054:	6105                	addi	sp,sp,32
    80001056:	8082                	ret
    uvmfree(pagetable, 0);
    80001058:	4581                	li	a1,0
    8000105a:	8526                	mv	a0,s1
    8000105c:	98dff0ef          	jal	800009e8 <uvmfree>
    return 0;
    80001060:	4481                	li	s1,0
    80001062:	b7e5                	j	8000104a <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001064:	4681                	li	a3,0
    80001066:	4605                	li	a2,1
    80001068:	040005b7          	lui	a1,0x4000
    8000106c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000106e:	05b2                	slli	a1,a1,0xc
    80001070:	8526                	mv	a0,s1
    80001072:	edcff0ef          	jal	8000074e <uvmunmap>
    uvmfree(pagetable, 0);
    80001076:	4581                	li	a1,0
    80001078:	8526                	mv	a0,s1
    8000107a:	96fff0ef          	jal	800009e8 <uvmfree>
    return 0;
    8000107e:	4481                	li	s1,0
    80001080:	b7e9                	j	8000104a <proc_pagetable+0x4c>

0000000080001082 <proc_freepagetable>:
{
    80001082:	1101                	addi	sp,sp,-32
    80001084:	ec06                	sd	ra,24(sp)
    80001086:	e822                	sd	s0,16(sp)
    80001088:	e426                	sd	s1,8(sp)
    8000108a:	e04a                	sd	s2,0(sp)
    8000108c:	1000                	addi	s0,sp,32
    8000108e:	84aa                	mv	s1,a0
    80001090:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001092:	4681                	li	a3,0
    80001094:	4605                	li	a2,1
    80001096:	040005b7          	lui	a1,0x4000
    8000109a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000109c:	05b2                	slli	a1,a1,0xc
    8000109e:	eb0ff0ef          	jal	8000074e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010a2:	4681                	li	a3,0
    800010a4:	4605                	li	a2,1
    800010a6:	020005b7          	lui	a1,0x2000
    800010aa:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010ac:	05b6                	slli	a1,a1,0xd
    800010ae:	8526                	mv	a0,s1
    800010b0:	e9eff0ef          	jal	8000074e <uvmunmap>
  uvmfree(pagetable, sz);
    800010b4:	85ca                	mv	a1,s2
    800010b6:	8526                	mv	a0,s1
    800010b8:	931ff0ef          	jal	800009e8 <uvmfree>
}
    800010bc:	60e2                	ld	ra,24(sp)
    800010be:	6442                	ld	s0,16(sp)
    800010c0:	64a2                	ld	s1,8(sp)
    800010c2:	6902                	ld	s2,0(sp)
    800010c4:	6105                	addi	sp,sp,32
    800010c6:	8082                	ret

00000000800010c8 <freeproc>:
{
    800010c8:	1101                	addi	sp,sp,-32
    800010ca:	ec06                	sd	ra,24(sp)
    800010cc:	e822                	sd	s0,16(sp)
    800010ce:	e426                	sd	s1,8(sp)
    800010d0:	1000                	addi	s0,sp,32
    800010d2:	84aa                	mv	s1,a0
  if(p->trapframe)
    800010d4:	6d28                	ld	a0,88(a0)
    800010d6:	c119                	beqz	a0,800010dc <freeproc+0x14>
    kfree((void*)p->trapframe);
    800010d8:	f45fe0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    800010dc:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800010e0:	68a8                	ld	a0,80(s1)
    800010e2:	c501                	beqz	a0,800010ea <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    800010e4:	64ac                	ld	a1,72(s1)
    800010e6:	f9dff0ef          	jal	80001082 <proc_freepagetable>
  p->pagetable = 0;
    800010ea:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800010ee:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800010f2:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800010f6:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800010fa:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800010fe:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001102:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001106:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000110a:	0004ac23          	sw	zero,24(s1)
}
    8000110e:	60e2                	ld	ra,24(sp)
    80001110:	6442                	ld	s0,16(sp)
    80001112:	64a2                	ld	s1,8(sp)
    80001114:	6105                	addi	sp,sp,32
    80001116:	8082                	ret

0000000080001118 <allocproc>:
{
    80001118:	1101                	addi	sp,sp,-32
    8000111a:	ec06                	sd	ra,24(sp)
    8000111c:	e822                	sd	s0,16(sp)
    8000111e:	e426                	sd	s1,8(sp)
    80001120:	e04a                	sd	s2,0(sp)
    80001122:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001124:	00229497          	auipc	s1,0x229
    80001128:	6ec48493          	addi	s1,s1,1772 # 8022a810 <proc>
    8000112c:	0022f917          	auipc	s2,0x22f
    80001130:	0e490913          	addi	s2,s2,228 # 80230210 <tickslock>
    acquire(&p->lock);
    80001134:	8526                	mv	a0,s1
    80001136:	00f040ef          	jal	80005944 <acquire>
    if(p->state == UNUSED) {
    8000113a:	4c9c                	lw	a5,24(s1)
    8000113c:	cb91                	beqz	a5,80001150 <allocproc+0x38>
      release(&p->lock);
    8000113e:	8526                	mv	a0,s1
    80001140:	099040ef          	jal	800059d8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001144:	16848493          	addi	s1,s1,360
    80001148:	ff2496e3          	bne	s1,s2,80001134 <allocproc+0x1c>
  return 0;
    8000114c:	4481                	li	s1,0
    8000114e:	a089                	j	80001190 <allocproc+0x78>
  p->pid = allocpid();
    80001150:	e71ff0ef          	jal	80000fc0 <allocpid>
    80001154:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001156:	4785                	li	a5,1
    80001158:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000115a:	ffffe0ef          	jal	80000158 <kalloc>
    8000115e:	892a                	mv	s2,a0
    80001160:	eca8                	sd	a0,88(s1)
    80001162:	cd15                	beqz	a0,8000119e <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001164:	8526                	mv	a0,s1
    80001166:	e99ff0ef          	jal	80000ffe <proc_pagetable>
    8000116a:	892a                	mv	s2,a0
    8000116c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000116e:	c121                	beqz	a0,800011ae <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001170:	07000613          	li	a2,112
    80001174:	4581                	li	a1,0
    80001176:	06048513          	addi	a0,s1,96
    8000117a:	8c2ff0ef          	jal	8000023c <memset>
  p->context.ra = (uint64)forkret;
    8000117e:	00000797          	auipc	a5,0x0
    80001182:	e0878793          	addi	a5,a5,-504 # 80000f86 <forkret>
    80001186:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001188:	60bc                	ld	a5,64(s1)
    8000118a:	6705                	lui	a4,0x1
    8000118c:	97ba                	add	a5,a5,a4
    8000118e:	f4bc                	sd	a5,104(s1)
}
    80001190:	8526                	mv	a0,s1
    80001192:	60e2                	ld	ra,24(sp)
    80001194:	6442                	ld	s0,16(sp)
    80001196:	64a2                	ld	s1,8(sp)
    80001198:	6902                	ld	s2,0(sp)
    8000119a:	6105                	addi	sp,sp,32
    8000119c:	8082                	ret
    freeproc(p);
    8000119e:	8526                	mv	a0,s1
    800011a0:	f29ff0ef          	jal	800010c8 <freeproc>
    release(&p->lock);
    800011a4:	8526                	mv	a0,s1
    800011a6:	033040ef          	jal	800059d8 <release>
    return 0;
    800011aa:	84ca                	mv	s1,s2
    800011ac:	b7d5                	j	80001190 <allocproc+0x78>
    freeproc(p);
    800011ae:	8526                	mv	a0,s1
    800011b0:	f19ff0ef          	jal	800010c8 <freeproc>
    release(&p->lock);
    800011b4:	8526                	mv	a0,s1
    800011b6:	023040ef          	jal	800059d8 <release>
    return 0;
    800011ba:	84ca                	mv	s1,s2
    800011bc:	bfd1                	j	80001190 <allocproc+0x78>

00000000800011be <userinit>:
{
    800011be:	1101                	addi	sp,sp,-32
    800011c0:	ec06                	sd	ra,24(sp)
    800011c2:	e822                	sd	s0,16(sp)
    800011c4:	e426                	sd	s1,8(sp)
    800011c6:	1000                	addi	s0,sp,32
  p = allocproc();
    800011c8:	f51ff0ef          	jal	80001118 <allocproc>
    800011cc:	84aa                	mv	s1,a0
  initproc = p;
    800011ce:	00009797          	auipc	a5,0x9
    800011d2:	1ca7b923          	sd	a0,466(a5) # 8000a3a0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800011d6:	03400613          	li	a2,52
    800011da:	00009597          	auipc	a1,0x9
    800011de:	17658593          	addi	a1,a1,374 # 8000a350 <initcode>
    800011e2:	6928                	ld	a0,80(a0)
    800011e4:	e5cff0ef          	jal	80000840 <uvmfirst>
  p->sz = PGSIZE;
    800011e8:	6785                	lui	a5,0x1
    800011ea:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011ec:	6cb8                	ld	a4,88(s1)
    800011ee:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011f2:	6cb8                	ld	a4,88(s1)
    800011f4:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011f6:	4641                	li	a2,16
    800011f8:	00006597          	auipc	a1,0x6
    800011fc:	fd858593          	addi	a1,a1,-40 # 800071d0 <etext+0x1d0>
    80001200:	15848513          	addi	a0,s1,344
    80001204:	98aff0ef          	jal	8000038e <safestrcpy>
  p->cwd = namei("/");
    80001208:	00006517          	auipc	a0,0x6
    8000120c:	fd850513          	addi	a0,a0,-40 # 800071e0 <etext+0x1e0>
    80001210:	507010ef          	jal	80002f16 <namei>
    80001214:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001218:	478d                	li	a5,3
    8000121a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000121c:	8526                	mv	a0,s1
    8000121e:	7ba040ef          	jal	800059d8 <release>
}
    80001222:	60e2                	ld	ra,24(sp)
    80001224:	6442                	ld	s0,16(sp)
    80001226:	64a2                	ld	s1,8(sp)
    80001228:	6105                	addi	sp,sp,32
    8000122a:	8082                	ret

000000008000122c <growproc>:
{
    8000122c:	1101                	addi	sp,sp,-32
    8000122e:	ec06                	sd	ra,24(sp)
    80001230:	e822                	sd	s0,16(sp)
    80001232:	e426                	sd	s1,8(sp)
    80001234:	e04a                	sd	s2,0(sp)
    80001236:	1000                	addi	s0,sp,32
    80001238:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000123a:	d1dff0ef          	jal	80000f56 <myproc>
    8000123e:	84aa                	mv	s1,a0
  sz = p->sz;
    80001240:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001242:	01204c63          	bgtz	s2,8000125a <growproc+0x2e>
  } else if(n < 0){
    80001246:	02094463          	bltz	s2,8000126e <growproc+0x42>
  p->sz = sz;
    8000124a:	e4ac                	sd	a1,72(s1)
  return 0;
    8000124c:	4501                	li	a0,0
}
    8000124e:	60e2                	ld	ra,24(sp)
    80001250:	6442                	ld	s0,16(sp)
    80001252:	64a2                	ld	s1,8(sp)
    80001254:	6902                	ld	s2,0(sp)
    80001256:	6105                	addi	sp,sp,32
    80001258:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000125a:	4691                	li	a3,4
    8000125c:	00b90633          	add	a2,s2,a1
    80001260:	6928                	ld	a0,80(a0)
    80001262:	e80ff0ef          	jal	800008e2 <uvmalloc>
    80001266:	85aa                	mv	a1,a0
    80001268:	f16d                	bnez	a0,8000124a <growproc+0x1e>
      return -1;
    8000126a:	557d                	li	a0,-1
    8000126c:	b7cd                	j	8000124e <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000126e:	00b90633          	add	a2,s2,a1
    80001272:	6928                	ld	a0,80(a0)
    80001274:	e2aff0ef          	jal	8000089e <uvmdealloc>
    80001278:	85aa                	mv	a1,a0
    8000127a:	bfc1                	j	8000124a <growproc+0x1e>

000000008000127c <fork>:
{
    8000127c:	7139                	addi	sp,sp,-64
    8000127e:	fc06                	sd	ra,56(sp)
    80001280:	f822                	sd	s0,48(sp)
    80001282:	f04a                	sd	s2,32(sp)
    80001284:	e456                	sd	s5,8(sp)
    80001286:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001288:	ccfff0ef          	jal	80000f56 <myproc>
    8000128c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000128e:	e8bff0ef          	jal	80001118 <allocproc>
    80001292:	0e050a63          	beqz	a0,80001386 <fork+0x10a>
    80001296:	e852                	sd	s4,16(sp)
    80001298:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000129a:	048ab603          	ld	a2,72(s5)
    8000129e:	692c                	ld	a1,80(a0)
    800012a0:	050ab503          	ld	a0,80(s5)
    800012a4:	f76ff0ef          	jal	80000a1a <uvmcopy>
    800012a8:	04054a63          	bltz	a0,800012fc <fork+0x80>
    800012ac:	f426                	sd	s1,40(sp)
    800012ae:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800012b0:	048ab783          	ld	a5,72(s5)
    800012b4:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800012b8:	058ab683          	ld	a3,88(s5)
    800012bc:	87b6                	mv	a5,a3
    800012be:	058a3703          	ld	a4,88(s4)
    800012c2:	12068693          	addi	a3,a3,288
    800012c6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012ca:	6788                	ld	a0,8(a5)
    800012cc:	6b8c                	ld	a1,16(a5)
    800012ce:	6f90                	ld	a2,24(a5)
    800012d0:	01073023          	sd	a6,0(a4)
    800012d4:	e708                	sd	a0,8(a4)
    800012d6:	eb0c                	sd	a1,16(a4)
    800012d8:	ef10                	sd	a2,24(a4)
    800012da:	02078793          	addi	a5,a5,32
    800012de:	02070713          	addi	a4,a4,32
    800012e2:	fed792e3          	bne	a5,a3,800012c6 <fork+0x4a>
  np->trapframe->a0 = 0;
    800012e6:	058a3783          	ld	a5,88(s4)
    800012ea:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012ee:	0d0a8493          	addi	s1,s5,208
    800012f2:	0d0a0913          	addi	s2,s4,208
    800012f6:	150a8993          	addi	s3,s5,336
    800012fa:	a831                	j	80001316 <fork+0x9a>
    freeproc(np);
    800012fc:	8552                	mv	a0,s4
    800012fe:	dcbff0ef          	jal	800010c8 <freeproc>
    release(&np->lock);
    80001302:	8552                	mv	a0,s4
    80001304:	6d4040ef          	jal	800059d8 <release>
    return -1;
    80001308:	597d                	li	s2,-1
    8000130a:	6a42                	ld	s4,16(sp)
    8000130c:	a0b5                	j	80001378 <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    8000130e:	04a1                	addi	s1,s1,8
    80001310:	0921                	addi	s2,s2,8
    80001312:	01348963          	beq	s1,s3,80001324 <fork+0xa8>
    if(p->ofile[i])
    80001316:	6088                	ld	a0,0(s1)
    80001318:	d97d                	beqz	a0,8000130e <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    8000131a:	198020ef          	jal	800034b2 <filedup>
    8000131e:	00a93023          	sd	a0,0(s2)
    80001322:	b7f5                	j	8000130e <fork+0x92>
  np->cwd = idup(p->cwd);
    80001324:	150ab503          	ld	a0,336(s5)
    80001328:	4c8010ef          	jal	800027f0 <idup>
    8000132c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001330:	4641                	li	a2,16
    80001332:	158a8593          	addi	a1,s5,344
    80001336:	158a0513          	addi	a0,s4,344
    8000133a:	854ff0ef          	jal	8000038e <safestrcpy>
  pid = np->pid;
    8000133e:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001342:	8552                	mv	a0,s4
    80001344:	694040ef          	jal	800059d8 <release>
  acquire(&wait_lock);
    80001348:	00229497          	auipc	s1,0x229
    8000134c:	0b048493          	addi	s1,s1,176 # 8022a3f8 <wait_lock>
    80001350:	8526                	mv	a0,s1
    80001352:	5f2040ef          	jal	80005944 <acquire>
  np->parent = p;
    80001356:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000135a:	8526                	mv	a0,s1
    8000135c:	67c040ef          	jal	800059d8 <release>
  acquire(&np->lock);
    80001360:	8552                	mv	a0,s4
    80001362:	5e2040ef          	jal	80005944 <acquire>
  np->state = RUNNABLE;
    80001366:	478d                	li	a5,3
    80001368:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000136c:	8552                	mv	a0,s4
    8000136e:	66a040ef          	jal	800059d8 <release>
  return pid;
    80001372:	74a2                	ld	s1,40(sp)
    80001374:	69e2                	ld	s3,24(sp)
    80001376:	6a42                	ld	s4,16(sp)
}
    80001378:	854a                	mv	a0,s2
    8000137a:	70e2                	ld	ra,56(sp)
    8000137c:	7442                	ld	s0,48(sp)
    8000137e:	7902                	ld	s2,32(sp)
    80001380:	6aa2                	ld	s5,8(sp)
    80001382:	6121                	addi	sp,sp,64
    80001384:	8082                	ret
    return -1;
    80001386:	597d                	li	s2,-1
    80001388:	bfc5                	j	80001378 <fork+0xfc>

000000008000138a <scheduler>:
{
    8000138a:	715d                	addi	sp,sp,-80
    8000138c:	e486                	sd	ra,72(sp)
    8000138e:	e0a2                	sd	s0,64(sp)
    80001390:	fc26                	sd	s1,56(sp)
    80001392:	f84a                	sd	s2,48(sp)
    80001394:	f44e                	sd	s3,40(sp)
    80001396:	f052                	sd	s4,32(sp)
    80001398:	ec56                	sd	s5,24(sp)
    8000139a:	e85a                	sd	s6,16(sp)
    8000139c:	e45e                	sd	s7,8(sp)
    8000139e:	e062                	sd	s8,0(sp)
    800013a0:	0880                	addi	s0,sp,80
    800013a2:	8792                	mv	a5,tp
  int id = r_tp();
    800013a4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013a6:	00779b13          	slli	s6,a5,0x7
    800013aa:	00229717          	auipc	a4,0x229
    800013ae:	03670713          	addi	a4,a4,54 # 8022a3e0 <pid_lock>
    800013b2:	975a                	add	a4,a4,s6
    800013b4:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013b8:	00229717          	auipc	a4,0x229
    800013bc:	06070713          	addi	a4,a4,96 # 8022a418 <cpus+0x8>
    800013c0:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800013c2:	4c11                	li	s8,4
        c->proc = p;
    800013c4:	079e                	slli	a5,a5,0x7
    800013c6:	00229a17          	auipc	s4,0x229
    800013ca:	01aa0a13          	addi	s4,s4,26 # 8022a3e0 <pid_lock>
    800013ce:	9a3e                	add	s4,s4,a5
        found = 1;
    800013d0:	4b85                	li	s7,1
    800013d2:	a0a9                	j	8000141c <scheduler+0x92>
      release(&p->lock);
    800013d4:	8526                	mv	a0,s1
    800013d6:	602040ef          	jal	800059d8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013da:	16848493          	addi	s1,s1,360
    800013de:	03248563          	beq	s1,s2,80001408 <scheduler+0x7e>
      acquire(&p->lock);
    800013e2:	8526                	mv	a0,s1
    800013e4:	560040ef          	jal	80005944 <acquire>
      if(p->state == RUNNABLE) {
    800013e8:	4c9c                	lw	a5,24(s1)
    800013ea:	ff3795e3          	bne	a5,s3,800013d4 <scheduler+0x4a>
        p->state = RUNNING;
    800013ee:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    800013f2:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013f6:	06048593          	addi	a1,s1,96
    800013fa:	855a                	mv	a0,s6
    800013fc:	5b6000ef          	jal	800019b2 <swtch>
        c->proc = 0;
    80001400:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001404:	8ade                	mv	s5,s7
    80001406:	b7f9                	j	800013d4 <scheduler+0x4a>
    if(found == 0) {
    80001408:	000a9a63          	bnez	s5,8000141c <scheduler+0x92>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000140c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001410:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001414:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001418:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000141c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001420:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001424:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001428:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    8000142a:	00229497          	auipc	s1,0x229
    8000142e:	3e648493          	addi	s1,s1,998 # 8022a810 <proc>
      if(p->state == RUNNABLE) {
    80001432:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001434:	0022f917          	auipc	s2,0x22f
    80001438:	ddc90913          	addi	s2,s2,-548 # 80230210 <tickslock>
    8000143c:	b75d                	j	800013e2 <scheduler+0x58>

000000008000143e <sched>:
{
    8000143e:	7179                	addi	sp,sp,-48
    80001440:	f406                	sd	ra,40(sp)
    80001442:	f022                	sd	s0,32(sp)
    80001444:	ec26                	sd	s1,24(sp)
    80001446:	e84a                	sd	s2,16(sp)
    80001448:	e44e                	sd	s3,8(sp)
    8000144a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000144c:	b0bff0ef          	jal	80000f56 <myproc>
    80001450:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001452:	488040ef          	jal	800058da <holding>
    80001456:	c92d                	beqz	a0,800014c8 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001458:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000145a:	2781                	sext.w	a5,a5
    8000145c:	079e                	slli	a5,a5,0x7
    8000145e:	00229717          	auipc	a4,0x229
    80001462:	f8270713          	addi	a4,a4,-126 # 8022a3e0 <pid_lock>
    80001466:	97ba                	add	a5,a5,a4
    80001468:	0a87a703          	lw	a4,168(a5)
    8000146c:	4785                	li	a5,1
    8000146e:	06f71363          	bne	a4,a5,800014d4 <sched+0x96>
  if(p->state == RUNNING)
    80001472:	4c98                	lw	a4,24(s1)
    80001474:	4791                	li	a5,4
    80001476:	06f70563          	beq	a4,a5,800014e0 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000147a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000147e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001480:	e7b5                	bnez	a5,800014ec <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001482:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001484:	00229917          	auipc	s2,0x229
    80001488:	f5c90913          	addi	s2,s2,-164 # 8022a3e0 <pid_lock>
    8000148c:	2781                	sext.w	a5,a5
    8000148e:	079e                	slli	a5,a5,0x7
    80001490:	97ca                	add	a5,a5,s2
    80001492:	0ac7a983          	lw	s3,172(a5)
    80001496:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001498:	2781                	sext.w	a5,a5
    8000149a:	079e                	slli	a5,a5,0x7
    8000149c:	00229597          	auipc	a1,0x229
    800014a0:	f7c58593          	addi	a1,a1,-132 # 8022a418 <cpus+0x8>
    800014a4:	95be                	add	a1,a1,a5
    800014a6:	06048513          	addi	a0,s1,96
    800014aa:	508000ef          	jal	800019b2 <swtch>
    800014ae:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014b0:	2781                	sext.w	a5,a5
    800014b2:	079e                	slli	a5,a5,0x7
    800014b4:	993e                	add	s2,s2,a5
    800014b6:	0b392623          	sw	s3,172(s2)
}
    800014ba:	70a2                	ld	ra,40(sp)
    800014bc:	7402                	ld	s0,32(sp)
    800014be:	64e2                	ld	s1,24(sp)
    800014c0:	6942                	ld	s2,16(sp)
    800014c2:	69a2                	ld	s3,8(sp)
    800014c4:	6145                	addi	sp,sp,48
    800014c6:	8082                	ret
    panic("sched p->lock");
    800014c8:	00006517          	auipc	a0,0x6
    800014cc:	d2050513          	addi	a0,a0,-736 # 800071e8 <etext+0x1e8>
    800014d0:	146040ef          	jal	80005616 <panic>
    panic("sched locks");
    800014d4:	00006517          	auipc	a0,0x6
    800014d8:	d2450513          	addi	a0,a0,-732 # 800071f8 <etext+0x1f8>
    800014dc:	13a040ef          	jal	80005616 <panic>
    panic("sched running");
    800014e0:	00006517          	auipc	a0,0x6
    800014e4:	d2850513          	addi	a0,a0,-728 # 80007208 <etext+0x208>
    800014e8:	12e040ef          	jal	80005616 <panic>
    panic("sched interruptible");
    800014ec:	00006517          	auipc	a0,0x6
    800014f0:	d2c50513          	addi	a0,a0,-724 # 80007218 <etext+0x218>
    800014f4:	122040ef          	jal	80005616 <panic>

00000000800014f8 <yield>:
{
    800014f8:	1101                	addi	sp,sp,-32
    800014fa:	ec06                	sd	ra,24(sp)
    800014fc:	e822                	sd	s0,16(sp)
    800014fe:	e426                	sd	s1,8(sp)
    80001500:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001502:	a55ff0ef          	jal	80000f56 <myproc>
    80001506:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001508:	43c040ef          	jal	80005944 <acquire>
  p->state = RUNNABLE;
    8000150c:	478d                	li	a5,3
    8000150e:	cc9c                	sw	a5,24(s1)
  sched();
    80001510:	f2fff0ef          	jal	8000143e <sched>
  release(&p->lock);
    80001514:	8526                	mv	a0,s1
    80001516:	4c2040ef          	jal	800059d8 <release>
}
    8000151a:	60e2                	ld	ra,24(sp)
    8000151c:	6442                	ld	s0,16(sp)
    8000151e:	64a2                	ld	s1,8(sp)
    80001520:	6105                	addi	sp,sp,32
    80001522:	8082                	ret

0000000080001524 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001524:	7179                	addi	sp,sp,-48
    80001526:	f406                	sd	ra,40(sp)
    80001528:	f022                	sd	s0,32(sp)
    8000152a:	ec26                	sd	s1,24(sp)
    8000152c:	e84a                	sd	s2,16(sp)
    8000152e:	e44e                	sd	s3,8(sp)
    80001530:	1800                	addi	s0,sp,48
    80001532:	89aa                	mv	s3,a0
    80001534:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001536:	a21ff0ef          	jal	80000f56 <myproc>
    8000153a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000153c:	408040ef          	jal	80005944 <acquire>
  release(lk);
    80001540:	854a                	mv	a0,s2
    80001542:	496040ef          	jal	800059d8 <release>

  // Go to sleep.
  p->chan = chan;
    80001546:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000154a:	4789                	li	a5,2
    8000154c:	cc9c                	sw	a5,24(s1)

  sched();
    8000154e:	ef1ff0ef          	jal	8000143e <sched>

  // Tidy up.
  p->chan = 0;
    80001552:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001556:	8526                	mv	a0,s1
    80001558:	480040ef          	jal	800059d8 <release>
  acquire(lk);
    8000155c:	854a                	mv	a0,s2
    8000155e:	3e6040ef          	jal	80005944 <acquire>
}
    80001562:	70a2                	ld	ra,40(sp)
    80001564:	7402                	ld	s0,32(sp)
    80001566:	64e2                	ld	s1,24(sp)
    80001568:	6942                	ld	s2,16(sp)
    8000156a:	69a2                	ld	s3,8(sp)
    8000156c:	6145                	addi	sp,sp,48
    8000156e:	8082                	ret

0000000080001570 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001570:	7139                	addi	sp,sp,-64
    80001572:	fc06                	sd	ra,56(sp)
    80001574:	f822                	sd	s0,48(sp)
    80001576:	f426                	sd	s1,40(sp)
    80001578:	f04a                	sd	s2,32(sp)
    8000157a:	ec4e                	sd	s3,24(sp)
    8000157c:	e852                	sd	s4,16(sp)
    8000157e:	e456                	sd	s5,8(sp)
    80001580:	0080                	addi	s0,sp,64
    80001582:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001584:	00229497          	auipc	s1,0x229
    80001588:	28c48493          	addi	s1,s1,652 # 8022a810 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000158c:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000158e:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001590:	0022f917          	auipc	s2,0x22f
    80001594:	c8090913          	addi	s2,s2,-896 # 80230210 <tickslock>
    80001598:	a801                	j	800015a8 <wakeup+0x38>
      }
      release(&p->lock);
    8000159a:	8526                	mv	a0,s1
    8000159c:	43c040ef          	jal	800059d8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800015a0:	16848493          	addi	s1,s1,360
    800015a4:	03248263          	beq	s1,s2,800015c8 <wakeup+0x58>
    if(p != myproc()){
    800015a8:	9afff0ef          	jal	80000f56 <myproc>
    800015ac:	fea48ae3          	beq	s1,a0,800015a0 <wakeup+0x30>
      acquire(&p->lock);
    800015b0:	8526                	mv	a0,s1
    800015b2:	392040ef          	jal	80005944 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800015b6:	4c9c                	lw	a5,24(s1)
    800015b8:	ff3791e3          	bne	a5,s3,8000159a <wakeup+0x2a>
    800015bc:	709c                	ld	a5,32(s1)
    800015be:	fd479ee3          	bne	a5,s4,8000159a <wakeup+0x2a>
        p->state = RUNNABLE;
    800015c2:	0154ac23          	sw	s5,24(s1)
    800015c6:	bfd1                	j	8000159a <wakeup+0x2a>
    }
  }
}
    800015c8:	70e2                	ld	ra,56(sp)
    800015ca:	7442                	ld	s0,48(sp)
    800015cc:	74a2                	ld	s1,40(sp)
    800015ce:	7902                	ld	s2,32(sp)
    800015d0:	69e2                	ld	s3,24(sp)
    800015d2:	6a42                	ld	s4,16(sp)
    800015d4:	6aa2                	ld	s5,8(sp)
    800015d6:	6121                	addi	sp,sp,64
    800015d8:	8082                	ret

00000000800015da <reparent>:
{
    800015da:	7179                	addi	sp,sp,-48
    800015dc:	f406                	sd	ra,40(sp)
    800015de:	f022                	sd	s0,32(sp)
    800015e0:	ec26                	sd	s1,24(sp)
    800015e2:	e84a                	sd	s2,16(sp)
    800015e4:	e44e                	sd	s3,8(sp)
    800015e6:	e052                	sd	s4,0(sp)
    800015e8:	1800                	addi	s0,sp,48
    800015ea:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015ec:	00229497          	auipc	s1,0x229
    800015f0:	22448493          	addi	s1,s1,548 # 8022a810 <proc>
      pp->parent = initproc;
    800015f4:	00009a17          	auipc	s4,0x9
    800015f8:	daca0a13          	addi	s4,s4,-596 # 8000a3a0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015fc:	0022f997          	auipc	s3,0x22f
    80001600:	c1498993          	addi	s3,s3,-1004 # 80230210 <tickslock>
    80001604:	a029                	j	8000160e <reparent+0x34>
    80001606:	16848493          	addi	s1,s1,360
    8000160a:	01348b63          	beq	s1,s3,80001620 <reparent+0x46>
    if(pp->parent == p){
    8000160e:	7c9c                	ld	a5,56(s1)
    80001610:	ff279be3          	bne	a5,s2,80001606 <reparent+0x2c>
      pp->parent = initproc;
    80001614:	000a3503          	ld	a0,0(s4)
    80001618:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000161a:	f57ff0ef          	jal	80001570 <wakeup>
    8000161e:	b7e5                	j	80001606 <reparent+0x2c>
}
    80001620:	70a2                	ld	ra,40(sp)
    80001622:	7402                	ld	s0,32(sp)
    80001624:	64e2                	ld	s1,24(sp)
    80001626:	6942                	ld	s2,16(sp)
    80001628:	69a2                	ld	s3,8(sp)
    8000162a:	6a02                	ld	s4,0(sp)
    8000162c:	6145                	addi	sp,sp,48
    8000162e:	8082                	ret

0000000080001630 <exit>:
{
    80001630:	7179                	addi	sp,sp,-48
    80001632:	f406                	sd	ra,40(sp)
    80001634:	f022                	sd	s0,32(sp)
    80001636:	ec26                	sd	s1,24(sp)
    80001638:	e84a                	sd	s2,16(sp)
    8000163a:	e44e                	sd	s3,8(sp)
    8000163c:	e052                	sd	s4,0(sp)
    8000163e:	1800                	addi	s0,sp,48
    80001640:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001642:	915ff0ef          	jal	80000f56 <myproc>
    80001646:	89aa                	mv	s3,a0
  if(p == initproc)
    80001648:	00009797          	auipc	a5,0x9
    8000164c:	d587b783          	ld	a5,-680(a5) # 8000a3a0 <initproc>
    80001650:	0d050493          	addi	s1,a0,208
    80001654:	15050913          	addi	s2,a0,336
    80001658:	00a79b63          	bne	a5,a0,8000166e <exit+0x3e>
    panic("init exiting");
    8000165c:	00006517          	auipc	a0,0x6
    80001660:	bd450513          	addi	a0,a0,-1068 # 80007230 <etext+0x230>
    80001664:	7b3030ef          	jal	80005616 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80001668:	04a1                	addi	s1,s1,8
    8000166a:	01248963          	beq	s1,s2,8000167c <exit+0x4c>
    if(p->ofile[fd]){
    8000166e:	6088                	ld	a0,0(s1)
    80001670:	dd65                	beqz	a0,80001668 <exit+0x38>
      fileclose(f);
    80001672:	687010ef          	jal	800034f8 <fileclose>
      p->ofile[fd] = 0;
    80001676:	0004b023          	sd	zero,0(s1)
    8000167a:	b7fd                	j	80001668 <exit+0x38>
  begin_op();
    8000167c:	25d010ef          	jal	800030d8 <begin_op>
  iput(p->cwd);
    80001680:	1509b503          	ld	a0,336(s3)
    80001684:	324010ef          	jal	800029a8 <iput>
  end_op();
    80001688:	2bb010ef          	jal	80003142 <end_op>
  p->cwd = 0;
    8000168c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001690:	00229497          	auipc	s1,0x229
    80001694:	d6848493          	addi	s1,s1,-664 # 8022a3f8 <wait_lock>
    80001698:	8526                	mv	a0,s1
    8000169a:	2aa040ef          	jal	80005944 <acquire>
  reparent(p);
    8000169e:	854e                	mv	a0,s3
    800016a0:	f3bff0ef          	jal	800015da <reparent>
  wakeup(p->parent);
    800016a4:	0389b503          	ld	a0,56(s3)
    800016a8:	ec9ff0ef          	jal	80001570 <wakeup>
  acquire(&p->lock);
    800016ac:	854e                	mv	a0,s3
    800016ae:	296040ef          	jal	80005944 <acquire>
  p->xstate = status;
    800016b2:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800016b6:	4795                	li	a5,5
    800016b8:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800016bc:	8526                	mv	a0,s1
    800016be:	31a040ef          	jal	800059d8 <release>
  sched();
    800016c2:	d7dff0ef          	jal	8000143e <sched>
  panic("zombie exit");
    800016c6:	00006517          	auipc	a0,0x6
    800016ca:	b7a50513          	addi	a0,a0,-1158 # 80007240 <etext+0x240>
    800016ce:	749030ef          	jal	80005616 <panic>

00000000800016d2 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800016d2:	7179                	addi	sp,sp,-48
    800016d4:	f406                	sd	ra,40(sp)
    800016d6:	f022                	sd	s0,32(sp)
    800016d8:	ec26                	sd	s1,24(sp)
    800016da:	e84a                	sd	s2,16(sp)
    800016dc:	e44e                	sd	s3,8(sp)
    800016de:	1800                	addi	s0,sp,48
    800016e0:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800016e2:	00229497          	auipc	s1,0x229
    800016e6:	12e48493          	addi	s1,s1,302 # 8022a810 <proc>
    800016ea:	0022f997          	auipc	s3,0x22f
    800016ee:	b2698993          	addi	s3,s3,-1242 # 80230210 <tickslock>
    acquire(&p->lock);
    800016f2:	8526                	mv	a0,s1
    800016f4:	250040ef          	jal	80005944 <acquire>
    if(p->pid == pid){
    800016f8:	589c                	lw	a5,48(s1)
    800016fa:	01278b63          	beq	a5,s2,80001710 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800016fe:	8526                	mv	a0,s1
    80001700:	2d8040ef          	jal	800059d8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001704:	16848493          	addi	s1,s1,360
    80001708:	ff3495e3          	bne	s1,s3,800016f2 <kill+0x20>
  }
  return -1;
    8000170c:	557d                	li	a0,-1
    8000170e:	a819                	j	80001724 <kill+0x52>
      p->killed = 1;
    80001710:	4785                	li	a5,1
    80001712:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001714:	4c98                	lw	a4,24(s1)
    80001716:	4789                	li	a5,2
    80001718:	00f70d63          	beq	a4,a5,80001732 <kill+0x60>
      release(&p->lock);
    8000171c:	8526                	mv	a0,s1
    8000171e:	2ba040ef          	jal	800059d8 <release>
      return 0;
    80001722:	4501                	li	a0,0
}
    80001724:	70a2                	ld	ra,40(sp)
    80001726:	7402                	ld	s0,32(sp)
    80001728:	64e2                	ld	s1,24(sp)
    8000172a:	6942                	ld	s2,16(sp)
    8000172c:	69a2                	ld	s3,8(sp)
    8000172e:	6145                	addi	sp,sp,48
    80001730:	8082                	ret
        p->state = RUNNABLE;
    80001732:	478d                	li	a5,3
    80001734:	cc9c                	sw	a5,24(s1)
    80001736:	b7dd                	j	8000171c <kill+0x4a>

0000000080001738 <setkilled>:

void
setkilled(struct proc *p)
{
    80001738:	1101                	addi	sp,sp,-32
    8000173a:	ec06                	sd	ra,24(sp)
    8000173c:	e822                	sd	s0,16(sp)
    8000173e:	e426                	sd	s1,8(sp)
    80001740:	1000                	addi	s0,sp,32
    80001742:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001744:	200040ef          	jal	80005944 <acquire>
  p->killed = 1;
    80001748:	4785                	li	a5,1
    8000174a:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000174c:	8526                	mv	a0,s1
    8000174e:	28a040ef          	jal	800059d8 <release>
}
    80001752:	60e2                	ld	ra,24(sp)
    80001754:	6442                	ld	s0,16(sp)
    80001756:	64a2                	ld	s1,8(sp)
    80001758:	6105                	addi	sp,sp,32
    8000175a:	8082                	ret

000000008000175c <killed>:

int
killed(struct proc *p)
{
    8000175c:	1101                	addi	sp,sp,-32
    8000175e:	ec06                	sd	ra,24(sp)
    80001760:	e822                	sd	s0,16(sp)
    80001762:	e426                	sd	s1,8(sp)
    80001764:	e04a                	sd	s2,0(sp)
    80001766:	1000                	addi	s0,sp,32
    80001768:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000176a:	1da040ef          	jal	80005944 <acquire>
  k = p->killed;
    8000176e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001772:	8526                	mv	a0,s1
    80001774:	264040ef          	jal	800059d8 <release>
  return k;
}
    80001778:	854a                	mv	a0,s2
    8000177a:	60e2                	ld	ra,24(sp)
    8000177c:	6442                	ld	s0,16(sp)
    8000177e:	64a2                	ld	s1,8(sp)
    80001780:	6902                	ld	s2,0(sp)
    80001782:	6105                	addi	sp,sp,32
    80001784:	8082                	ret

0000000080001786 <wait>:
{
    80001786:	715d                	addi	sp,sp,-80
    80001788:	e486                	sd	ra,72(sp)
    8000178a:	e0a2                	sd	s0,64(sp)
    8000178c:	fc26                	sd	s1,56(sp)
    8000178e:	f84a                	sd	s2,48(sp)
    80001790:	f44e                	sd	s3,40(sp)
    80001792:	f052                	sd	s4,32(sp)
    80001794:	ec56                	sd	s5,24(sp)
    80001796:	e85a                	sd	s6,16(sp)
    80001798:	e45e                	sd	s7,8(sp)
    8000179a:	0880                	addi	s0,sp,80
    8000179c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000179e:	fb8ff0ef          	jal	80000f56 <myproc>
    800017a2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017a4:	00229517          	auipc	a0,0x229
    800017a8:	c5450513          	addi	a0,a0,-940 # 8022a3f8 <wait_lock>
    800017ac:	198040ef          	jal	80005944 <acquire>
        if(pp->state == ZOMBIE){
    800017b0:	4a15                	li	s4,5
        havekids = 1;
    800017b2:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800017b4:	0022f997          	auipc	s3,0x22f
    800017b8:	a5c98993          	addi	s3,s3,-1444 # 80230210 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017bc:	00229b97          	auipc	s7,0x229
    800017c0:	c3cb8b93          	addi	s7,s7,-964 # 8022a3f8 <wait_lock>
    800017c4:	a869                	j	8000185e <wait+0xd8>
          pid = pp->pid;
    800017c6:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800017ca:	000b0c63          	beqz	s6,800017e2 <wait+0x5c>
    800017ce:	4691                	li	a3,4
    800017d0:	02c48613          	addi	a2,s1,44
    800017d4:	85da                	mv	a1,s6
    800017d6:	05093503          	ld	a0,80(s2)
    800017da:	ceeff0ef          	jal	80000cc8 <copyout>
    800017de:	02054a63          	bltz	a0,80001812 <wait+0x8c>
          freeproc(pp);
    800017e2:	8526                	mv	a0,s1
    800017e4:	8e5ff0ef          	jal	800010c8 <freeproc>
          release(&pp->lock);
    800017e8:	8526                	mv	a0,s1
    800017ea:	1ee040ef          	jal	800059d8 <release>
          release(&wait_lock);
    800017ee:	00229517          	auipc	a0,0x229
    800017f2:	c0a50513          	addi	a0,a0,-1014 # 8022a3f8 <wait_lock>
    800017f6:	1e2040ef          	jal	800059d8 <release>
}
    800017fa:	854e                	mv	a0,s3
    800017fc:	60a6                	ld	ra,72(sp)
    800017fe:	6406                	ld	s0,64(sp)
    80001800:	74e2                	ld	s1,56(sp)
    80001802:	7942                	ld	s2,48(sp)
    80001804:	79a2                	ld	s3,40(sp)
    80001806:	7a02                	ld	s4,32(sp)
    80001808:	6ae2                	ld	s5,24(sp)
    8000180a:	6b42                	ld	s6,16(sp)
    8000180c:	6ba2                	ld	s7,8(sp)
    8000180e:	6161                	addi	sp,sp,80
    80001810:	8082                	ret
            release(&pp->lock);
    80001812:	8526                	mv	a0,s1
    80001814:	1c4040ef          	jal	800059d8 <release>
            release(&wait_lock);
    80001818:	00229517          	auipc	a0,0x229
    8000181c:	be050513          	addi	a0,a0,-1056 # 8022a3f8 <wait_lock>
    80001820:	1b8040ef          	jal	800059d8 <release>
            return -1;
    80001824:	59fd                	li	s3,-1
    80001826:	bfd1                	j	800017fa <wait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001828:	16848493          	addi	s1,s1,360
    8000182c:	03348063          	beq	s1,s3,8000184c <wait+0xc6>
      if(pp->parent == p){
    80001830:	7c9c                	ld	a5,56(s1)
    80001832:	ff279be3          	bne	a5,s2,80001828 <wait+0xa2>
        acquire(&pp->lock);
    80001836:	8526                	mv	a0,s1
    80001838:	10c040ef          	jal	80005944 <acquire>
        if(pp->state == ZOMBIE){
    8000183c:	4c9c                	lw	a5,24(s1)
    8000183e:	f94784e3          	beq	a5,s4,800017c6 <wait+0x40>
        release(&pp->lock);
    80001842:	8526                	mv	a0,s1
    80001844:	194040ef          	jal	800059d8 <release>
        havekids = 1;
    80001848:	8756                	mv	a4,s5
    8000184a:	bff9                	j	80001828 <wait+0xa2>
    if(!havekids || killed(p)){
    8000184c:	cf19                	beqz	a4,8000186a <wait+0xe4>
    8000184e:	854a                	mv	a0,s2
    80001850:	f0dff0ef          	jal	8000175c <killed>
    80001854:	e919                	bnez	a0,8000186a <wait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001856:	85de                	mv	a1,s7
    80001858:	854a                	mv	a0,s2
    8000185a:	ccbff0ef          	jal	80001524 <sleep>
    havekids = 0;
    8000185e:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001860:	00229497          	auipc	s1,0x229
    80001864:	fb048493          	addi	s1,s1,-80 # 8022a810 <proc>
    80001868:	b7e1                	j	80001830 <wait+0xaa>
      release(&wait_lock);
    8000186a:	00229517          	auipc	a0,0x229
    8000186e:	b8e50513          	addi	a0,a0,-1138 # 8022a3f8 <wait_lock>
    80001872:	166040ef          	jal	800059d8 <release>
      return -1;
    80001876:	59fd                	li	s3,-1
    80001878:	b749                	j	800017fa <wait+0x74>

000000008000187a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000187a:	7179                	addi	sp,sp,-48
    8000187c:	f406                	sd	ra,40(sp)
    8000187e:	f022                	sd	s0,32(sp)
    80001880:	ec26                	sd	s1,24(sp)
    80001882:	e84a                	sd	s2,16(sp)
    80001884:	e44e                	sd	s3,8(sp)
    80001886:	e052                	sd	s4,0(sp)
    80001888:	1800                	addi	s0,sp,48
    8000188a:	84aa                	mv	s1,a0
    8000188c:	892e                	mv	s2,a1
    8000188e:	89b2                	mv	s3,a2
    80001890:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001892:	ec4ff0ef          	jal	80000f56 <myproc>
  if(user_dst){
    80001896:	cc99                	beqz	s1,800018b4 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80001898:	86d2                	mv	a3,s4
    8000189a:	864e                	mv	a2,s3
    8000189c:	85ca                	mv	a1,s2
    8000189e:	6928                	ld	a0,80(a0)
    800018a0:	c28ff0ef          	jal	80000cc8 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018a4:	70a2                	ld	ra,40(sp)
    800018a6:	7402                	ld	s0,32(sp)
    800018a8:	64e2                	ld	s1,24(sp)
    800018aa:	6942                	ld	s2,16(sp)
    800018ac:	69a2                	ld	s3,8(sp)
    800018ae:	6a02                	ld	s4,0(sp)
    800018b0:	6145                	addi	sp,sp,48
    800018b2:	8082                	ret
    memmove((char *)dst, src, len);
    800018b4:	000a061b          	sext.w	a2,s4
    800018b8:	85ce                	mv	a1,s3
    800018ba:	854a                	mv	a0,s2
    800018bc:	9e5fe0ef          	jal	800002a0 <memmove>
    return 0;
    800018c0:	8526                	mv	a0,s1
    800018c2:	b7cd                	j	800018a4 <either_copyout+0x2a>

00000000800018c4 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800018c4:	7179                	addi	sp,sp,-48
    800018c6:	f406                	sd	ra,40(sp)
    800018c8:	f022                	sd	s0,32(sp)
    800018ca:	ec26                	sd	s1,24(sp)
    800018cc:	e84a                	sd	s2,16(sp)
    800018ce:	e44e                	sd	s3,8(sp)
    800018d0:	e052                	sd	s4,0(sp)
    800018d2:	1800                	addi	s0,sp,48
    800018d4:	892a                	mv	s2,a0
    800018d6:	84ae                	mv	s1,a1
    800018d8:	89b2                	mv	s3,a2
    800018da:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018dc:	e7aff0ef          	jal	80000f56 <myproc>
  if(user_src){
    800018e0:	cc99                	beqz	s1,800018fe <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800018e2:	86d2                	mv	a3,s4
    800018e4:	864e                	mv	a2,s3
    800018e6:	85ca                	mv	a1,s2
    800018e8:	6928                	ld	a0,80(a0)
    800018ea:	9faff0ef          	jal	80000ae4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800018ee:	70a2                	ld	ra,40(sp)
    800018f0:	7402                	ld	s0,32(sp)
    800018f2:	64e2                	ld	s1,24(sp)
    800018f4:	6942                	ld	s2,16(sp)
    800018f6:	69a2                	ld	s3,8(sp)
    800018f8:	6a02                	ld	s4,0(sp)
    800018fa:	6145                	addi	sp,sp,48
    800018fc:	8082                	ret
    memmove(dst, (char*)src, len);
    800018fe:	000a061b          	sext.w	a2,s4
    80001902:	85ce                	mv	a1,s3
    80001904:	854a                	mv	a0,s2
    80001906:	99bfe0ef          	jal	800002a0 <memmove>
    return 0;
    8000190a:	8526                	mv	a0,s1
    8000190c:	b7cd                	j	800018ee <either_copyin+0x2a>

000000008000190e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000190e:	715d                	addi	sp,sp,-80
    80001910:	e486                	sd	ra,72(sp)
    80001912:	e0a2                	sd	s0,64(sp)
    80001914:	fc26                	sd	s1,56(sp)
    80001916:	f84a                	sd	s2,48(sp)
    80001918:	f44e                	sd	s3,40(sp)
    8000191a:	f052                	sd	s4,32(sp)
    8000191c:	ec56                	sd	s5,24(sp)
    8000191e:	e85a                	sd	s6,16(sp)
    80001920:	e45e                	sd	s7,8(sp)
    80001922:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001924:	00005517          	auipc	a0,0x5
    80001928:	6f450513          	addi	a0,a0,1780 # 80007018 <etext+0x18>
    8000192c:	21b030ef          	jal	80005346 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001930:	00229497          	auipc	s1,0x229
    80001934:	03848493          	addi	s1,s1,56 # 8022a968 <proc+0x158>
    80001938:	0022f917          	auipc	s2,0x22f
    8000193c:	a3090913          	addi	s2,s2,-1488 # 80230368 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001940:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001942:	00006997          	auipc	s3,0x6
    80001946:	90e98993          	addi	s3,s3,-1778 # 80007250 <etext+0x250>
    printf("%d %s %s", p->pid, state, p->name);
    8000194a:	00006a97          	auipc	s5,0x6
    8000194e:	90ea8a93          	addi	s5,s5,-1778 # 80007258 <etext+0x258>
    printf("\n");
    80001952:	00005a17          	auipc	s4,0x5
    80001956:	6c6a0a13          	addi	s4,s4,1734 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000195a:	00006b97          	auipc	s7,0x6
    8000195e:	e4eb8b93          	addi	s7,s7,-434 # 800077a8 <states.0>
    80001962:	a829                	j	8000197c <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001964:	ed86a583          	lw	a1,-296(a3)
    80001968:	8556                	mv	a0,s5
    8000196a:	1dd030ef          	jal	80005346 <printf>
    printf("\n");
    8000196e:	8552                	mv	a0,s4
    80001970:	1d7030ef          	jal	80005346 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001974:	16848493          	addi	s1,s1,360
    80001978:	03248263          	beq	s1,s2,8000199c <procdump+0x8e>
    if(p->state == UNUSED)
    8000197c:	86a6                	mv	a3,s1
    8000197e:	ec04a783          	lw	a5,-320(s1)
    80001982:	dbed                	beqz	a5,80001974 <procdump+0x66>
      state = "???";
    80001984:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001986:	fcfb6fe3          	bltu	s6,a5,80001964 <procdump+0x56>
    8000198a:	02079713          	slli	a4,a5,0x20
    8000198e:	01d75793          	srli	a5,a4,0x1d
    80001992:	97de                	add	a5,a5,s7
    80001994:	6390                	ld	a2,0(a5)
    80001996:	f679                	bnez	a2,80001964 <procdump+0x56>
      state = "???";
    80001998:	864e                	mv	a2,s3
    8000199a:	b7e9                	j	80001964 <procdump+0x56>
  }
}
    8000199c:	60a6                	ld	ra,72(sp)
    8000199e:	6406                	ld	s0,64(sp)
    800019a0:	74e2                	ld	s1,56(sp)
    800019a2:	7942                	ld	s2,48(sp)
    800019a4:	79a2                	ld	s3,40(sp)
    800019a6:	7a02                	ld	s4,32(sp)
    800019a8:	6ae2                	ld	s5,24(sp)
    800019aa:	6b42                	ld	s6,16(sp)
    800019ac:	6ba2                	ld	s7,8(sp)
    800019ae:	6161                	addi	sp,sp,80
    800019b0:	8082                	ret

00000000800019b2 <swtch>:
    800019b2:	00153023          	sd	ra,0(a0)
    800019b6:	00253423          	sd	sp,8(a0)
    800019ba:	e900                	sd	s0,16(a0)
    800019bc:	ed04                	sd	s1,24(a0)
    800019be:	03253023          	sd	s2,32(a0)
    800019c2:	03353423          	sd	s3,40(a0)
    800019c6:	03453823          	sd	s4,48(a0)
    800019ca:	03553c23          	sd	s5,56(a0)
    800019ce:	05653023          	sd	s6,64(a0)
    800019d2:	05753423          	sd	s7,72(a0)
    800019d6:	05853823          	sd	s8,80(a0)
    800019da:	05953c23          	sd	s9,88(a0)
    800019de:	07a53023          	sd	s10,96(a0)
    800019e2:	07b53423          	sd	s11,104(a0)
    800019e6:	0005b083          	ld	ra,0(a1)
    800019ea:	0085b103          	ld	sp,8(a1)
    800019ee:	6980                	ld	s0,16(a1)
    800019f0:	6d84                	ld	s1,24(a1)
    800019f2:	0205b903          	ld	s2,32(a1)
    800019f6:	0285b983          	ld	s3,40(a1)
    800019fa:	0305ba03          	ld	s4,48(a1)
    800019fe:	0385ba83          	ld	s5,56(a1)
    80001a02:	0405bb03          	ld	s6,64(a1)
    80001a06:	0485bb83          	ld	s7,72(a1)
    80001a0a:	0505bc03          	ld	s8,80(a1)
    80001a0e:	0585bc83          	ld	s9,88(a1)
    80001a12:	0605bd03          	ld	s10,96(a1)
    80001a16:	0685bd83          	ld	s11,104(a1)
    80001a1a:	8082                	ret

0000000080001a1c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a1c:	1141                	addi	sp,sp,-16
    80001a1e:	e406                	sd	ra,8(sp)
    80001a20:	e022                	sd	s0,0(sp)
    80001a22:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a24:	00006597          	auipc	a1,0x6
    80001a28:	87458593          	addi	a1,a1,-1932 # 80007298 <etext+0x298>
    80001a2c:	0022e517          	auipc	a0,0x22e
    80001a30:	7e450513          	addi	a0,a0,2020 # 80230210 <tickslock>
    80001a34:	68d030ef          	jal	800058c0 <initlock>
}
    80001a38:	60a2                	ld	ra,8(sp)
    80001a3a:	6402                	ld	s0,0(sp)
    80001a3c:	0141                	addi	sp,sp,16
    80001a3e:	8082                	ret

0000000080001a40 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001a40:	1141                	addi	sp,sp,-16
    80001a42:	e406                	sd	ra,8(sp)
    80001a44:	e022                	sd	s0,0(sp)
    80001a46:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a48:	00003797          	auipc	a5,0x3
    80001a4c:	e6878793          	addi	a5,a5,-408 # 800048b0 <kernelvec>
    80001a50:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001a54:	60a2                	ld	ra,8(sp)
    80001a56:	6402                	ld	s0,0(sp)
    80001a58:	0141                	addi	sp,sp,16
    80001a5a:	8082                	ret

0000000080001a5c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001a5c:	1141                	addi	sp,sp,-16
    80001a5e:	e406                	sd	ra,8(sp)
    80001a60:	e022                	sd	s0,0(sp)
    80001a62:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001a64:	cf2ff0ef          	jal	80000f56 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a68:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001a6c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a6e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001a72:	00004697          	auipc	a3,0x4
    80001a76:	58e68693          	addi	a3,a3,1422 # 80006000 <_trampoline>
    80001a7a:	00004717          	auipc	a4,0x4
    80001a7e:	58670713          	addi	a4,a4,1414 # 80006000 <_trampoline>
    80001a82:	8f15                	sub	a4,a4,a3
    80001a84:	040007b7          	lui	a5,0x4000
    80001a88:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001a8a:	07b2                	slli	a5,a5,0xc
    80001a8c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a8e:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001a92:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001a94:	18002673          	csrr	a2,satp
    80001a98:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001a9a:	6d30                	ld	a2,88(a0)
    80001a9c:	6138                	ld	a4,64(a0)
    80001a9e:	6585                	lui	a1,0x1
    80001aa0:	972e                	add	a4,a4,a1
    80001aa2:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001aa4:	6d38                	ld	a4,88(a0)
    80001aa6:	00000617          	auipc	a2,0x0
    80001aaa:	11060613          	addi	a2,a2,272 # 80001bb6 <usertrap>
    80001aae:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001ab0:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ab2:	8612                	mv	a2,tp
    80001ab4:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ab6:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001aba:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001abe:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ac2:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001ac6:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ac8:	6f18                	ld	a4,24(a4)
    80001aca:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001ace:	6928                	ld	a0,80(a0)
    80001ad0:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001ad2:	00004717          	auipc	a4,0x4
    80001ad6:	5ca70713          	addi	a4,a4,1482 # 8000609c <userret>
    80001ada:	8f15                	sub	a4,a4,a3
    80001adc:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001ade:	577d                	li	a4,-1
    80001ae0:	177e                	slli	a4,a4,0x3f
    80001ae2:	8d59                	or	a0,a0,a4
    80001ae4:	9782                	jalr	a5
}
    80001ae6:	60a2                	ld	ra,8(sp)
    80001ae8:	6402                	ld	s0,0(sp)
    80001aea:	0141                	addi	sp,sp,16
    80001aec:	8082                	ret

0000000080001aee <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001aee:	1101                	addi	sp,sp,-32
    80001af0:	ec06                	sd	ra,24(sp)
    80001af2:	e822                	sd	s0,16(sp)
    80001af4:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80001af6:	c2cff0ef          	jal	80000f22 <cpuid>
    80001afa:	cd11                	beqz	a0,80001b16 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001afc:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001b00:	000f4737          	lui	a4,0xf4
    80001b04:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001b08:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001b0a:	14d79073          	csrw	stimecmp,a5
}
    80001b0e:	60e2                	ld	ra,24(sp)
    80001b10:	6442                	ld	s0,16(sp)
    80001b12:	6105                	addi	sp,sp,32
    80001b14:	8082                	ret
    80001b16:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80001b18:	0022e497          	auipc	s1,0x22e
    80001b1c:	6f848493          	addi	s1,s1,1784 # 80230210 <tickslock>
    80001b20:	8526                	mv	a0,s1
    80001b22:	623030ef          	jal	80005944 <acquire>
    ticks++;
    80001b26:	00009517          	auipc	a0,0x9
    80001b2a:	88250513          	addi	a0,a0,-1918 # 8000a3a8 <ticks>
    80001b2e:	411c                	lw	a5,0(a0)
    80001b30:	2785                	addiw	a5,a5,1
    80001b32:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001b34:	a3dff0ef          	jal	80001570 <wakeup>
    release(&tickslock);
    80001b38:	8526                	mv	a0,s1
    80001b3a:	69f030ef          	jal	800059d8 <release>
    80001b3e:	64a2                	ld	s1,8(sp)
    80001b40:	bf75                	j	80001afc <clockintr+0xe>

0000000080001b42 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001b42:	1101                	addi	sp,sp,-32
    80001b44:	ec06                	sd	ra,24(sp)
    80001b46:	e822                	sd	s0,16(sp)
    80001b48:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b4a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001b4e:	57fd                	li	a5,-1
    80001b50:	17fe                	slli	a5,a5,0x3f
    80001b52:	07a5                	addi	a5,a5,9
    80001b54:	00f70c63          	beq	a4,a5,80001b6c <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001b58:	57fd                	li	a5,-1
    80001b5a:	17fe                	slli	a5,a5,0x3f
    80001b5c:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001b5e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001b60:	04f70763          	beq	a4,a5,80001bae <devintr+0x6c>
  }
}
    80001b64:	60e2                	ld	ra,24(sp)
    80001b66:	6442                	ld	s0,16(sp)
    80001b68:	6105                	addi	sp,sp,32
    80001b6a:	8082                	ret
    80001b6c:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001b6e:	5ef020ef          	jal	8000495c <plic_claim>
    80001b72:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001b74:	47a9                	li	a5,10
    80001b76:	00f50963          	beq	a0,a5,80001b88 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80001b7a:	4785                	li	a5,1
    80001b7c:	00f50963          	beq	a0,a5,80001b8e <devintr+0x4c>
    return 1;
    80001b80:	4505                	li	a0,1
    } else if(irq){
    80001b82:	e889                	bnez	s1,80001b94 <devintr+0x52>
    80001b84:	64a2                	ld	s1,8(sp)
    80001b86:	bff9                	j	80001b64 <devintr+0x22>
      uartintr();
    80001b88:	4fd030ef          	jal	80005884 <uartintr>
    if(irq)
    80001b8c:	a819                	j	80001ba2 <devintr+0x60>
      virtio_disk_intr();
    80001b8e:	25e030ef          	jal	80004dec <virtio_disk_intr>
    if(irq)
    80001b92:	a801                	j	80001ba2 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80001b94:	85a6                	mv	a1,s1
    80001b96:	00005517          	auipc	a0,0x5
    80001b9a:	70a50513          	addi	a0,a0,1802 # 800072a0 <etext+0x2a0>
    80001b9e:	7a8030ef          	jal	80005346 <printf>
      plic_complete(irq);
    80001ba2:	8526                	mv	a0,s1
    80001ba4:	5d9020ef          	jal	8000497c <plic_complete>
    return 1;
    80001ba8:	4505                	li	a0,1
    80001baa:	64a2                	ld	s1,8(sp)
    80001bac:	bf65                	j	80001b64 <devintr+0x22>
    clockintr();
    80001bae:	f41ff0ef          	jal	80001aee <clockintr>
    return 2;
    80001bb2:	4509                	li	a0,2
    80001bb4:	bf45                	j	80001b64 <devintr+0x22>

0000000080001bb6 <usertrap>:
{
    80001bb6:	7179                	addi	sp,sp,-48
    80001bb8:	f406                	sd	ra,40(sp)
    80001bba:	f022                	sd	s0,32(sp)
    80001bbc:	ec26                	sd	s1,24(sp)
    80001bbe:	e84a                	sd	s2,16(sp)
    80001bc0:	e44e                	sd	s3,8(sp)
    80001bc2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bc4:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001bc8:	1007f793          	andi	a5,a5,256
    80001bcc:	efb9                	bnez	a5,80001c2a <usertrap+0x74>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bce:	00003797          	auipc	a5,0x3
    80001bd2:	ce278793          	addi	a5,a5,-798 # 800048b0 <kernelvec>
    80001bd6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001bda:	b7cff0ef          	jal	80000f56 <myproc>
    80001bde:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001be0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001be2:	14102773          	csrr	a4,sepc
    80001be6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001be8:	142029f3          	csrr	s3,scause
  if(scause == 8){
    80001bec:	47a1                	li	a5,8
    80001bee:	04f98463          	beq	s3,a5,80001c36 <usertrap+0x80>
  } else if((which_dev = devintr()) != 0){
    80001bf2:	f51ff0ef          	jal	80001b42 <devintr>
    80001bf6:	892a                	mv	s2,a0
    80001bf8:	ed41                	bnez	a0,80001c90 <usertrap+0xda>
  } else if(scause == 15) { // store/AMO page fault
    80001bfa:	47bd                	li	a5,15
    80001bfc:	06f98c63          	beq	s3,a5,80001c74 <usertrap+0xbe>
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", scause, p->pid);
    80001c00:	5890                	lw	a2,48(s1)
    80001c02:	85ce                	mv	a1,s3
    80001c04:	00005517          	auipc	a0,0x5
    80001c08:	70450513          	addi	a0,a0,1796 # 80007308 <etext+0x308>
    80001c0c:	73a030ef          	jal	80005346 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c10:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001c14:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001c18:	00005517          	auipc	a0,0x5
    80001c1c:	72050513          	addi	a0,a0,1824 # 80007338 <etext+0x338>
    80001c20:	726030ef          	jal	80005346 <printf>
    p->killed = 1;
    80001c24:	4785                	li	a5,1
    80001c26:	d49c                	sw	a5,40(s1)
    80001c28:	a02d                	j	80001c52 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001c2a:	00005517          	auipc	a0,0x5
    80001c2e:	69650513          	addi	a0,a0,1686 # 800072c0 <etext+0x2c0>
    80001c32:	1e5030ef          	jal	80005616 <panic>
    if(killed(p))
    80001c36:	b27ff0ef          	jal	8000175c <killed>
    80001c3a:	e90d                	bnez	a0,80001c6c <usertrap+0xb6>
    p->trapframe->epc += 4;
    80001c3c:	6cb8                	ld	a4,88(s1)
    80001c3e:	6f1c                	ld	a5,24(a4)
    80001c40:	0791                	addi	a5,a5,4
    80001c42:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c44:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c48:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c4a:	10079073          	csrw	sstatus,a5
    syscall();
    80001c4e:	23a000ef          	jal	80001e88 <syscall>
  if(killed(p))
    80001c52:	8526                	mv	a0,s1
    80001c54:	b09ff0ef          	jal	8000175c <killed>
    80001c58:	e129                	bnez	a0,80001c9a <usertrap+0xe4>
  usertrapret();
    80001c5a:	e03ff0ef          	jal	80001a5c <usertrapret>
}
    80001c5e:	70a2                	ld	ra,40(sp)
    80001c60:	7402                	ld	s0,32(sp)
    80001c62:	64e2                	ld	s1,24(sp)
    80001c64:	6942                	ld	s2,16(sp)
    80001c66:	69a2                	ld	s3,8(sp)
    80001c68:	6145                	addi	sp,sp,48
    80001c6a:	8082                	ret
      exit(-1);
    80001c6c:	557d                	li	a0,-1
    80001c6e:	9c3ff0ef          	jal	80001630 <exit>
    80001c72:	b7e9                	j	80001c3c <usertrap+0x86>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001c74:	14302573          	csrr	a0,stval
    if(handle_cow_fault(va) != 0) {
    80001c78:	f93fe0ef          	jal	80000c0a <handle_cow_fault>
    80001c7c:	d979                	beqz	a0,80001c52 <usertrap+0x9c>
      printf("usertrap(): cow page fault failed\n");
    80001c7e:	00005517          	auipc	a0,0x5
    80001c82:	66250513          	addi	a0,a0,1634 # 800072e0 <etext+0x2e0>
    80001c86:	6c0030ef          	jal	80005346 <printf>
      p->killed = 1;
    80001c8a:	4785                	li	a5,1
    80001c8c:	d49c                	sw	a5,40(s1)
    80001c8e:	b7d1                	j	80001c52 <usertrap+0x9c>
  if(killed(p))
    80001c90:	8526                	mv	a0,s1
    80001c92:	acbff0ef          	jal	8000175c <killed>
    80001c96:	c511                	beqz	a0,80001ca2 <usertrap+0xec>
    80001c98:	a011                	j	80001c9c <usertrap+0xe6>
    80001c9a:	4901                	li	s2,0
    exit(-1);
    80001c9c:	557d                	li	a0,-1
    80001c9e:	993ff0ef          	jal	80001630 <exit>
  if(which_dev == 2)
    80001ca2:	4789                	li	a5,2
    80001ca4:	faf91be3          	bne	s2,a5,80001c5a <usertrap+0xa4>
    yield();
    80001ca8:	851ff0ef          	jal	800014f8 <yield>
    80001cac:	b77d                	j	80001c5a <usertrap+0xa4>

0000000080001cae <kerneltrap>:
{
    80001cae:	7179                	addi	sp,sp,-48
    80001cb0:	f406                	sd	ra,40(sp)
    80001cb2:	f022                	sd	s0,32(sp)
    80001cb4:	ec26                	sd	s1,24(sp)
    80001cb6:	e84a                	sd	s2,16(sp)
    80001cb8:	e44e                	sd	s3,8(sp)
    80001cba:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cbc:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cc0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cc4:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001cc8:	1004f793          	andi	a5,s1,256
    80001ccc:	c795                	beqz	a5,80001cf8 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cce:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001cd2:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001cd4:	eb85                	bnez	a5,80001d04 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001cd6:	e6dff0ef          	jal	80001b42 <devintr>
    80001cda:	c91d                	beqz	a0,80001d10 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001cdc:	4789                	li	a5,2
    80001cde:	04f50a63          	beq	a0,a5,80001d32 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ce2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ce6:	10049073          	csrw	sstatus,s1
}
    80001cea:	70a2                	ld	ra,40(sp)
    80001cec:	7402                	ld	s0,32(sp)
    80001cee:	64e2                	ld	s1,24(sp)
    80001cf0:	6942                	ld	s2,16(sp)
    80001cf2:	69a2                	ld	s3,8(sp)
    80001cf4:	6145                	addi	sp,sp,48
    80001cf6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001cf8:	00005517          	auipc	a0,0x5
    80001cfc:	66850513          	addi	a0,a0,1640 # 80007360 <etext+0x360>
    80001d00:	117030ef          	jal	80005616 <panic>
    panic("kerneltrap: interrupts enabled");
    80001d04:	00005517          	auipc	a0,0x5
    80001d08:	68450513          	addi	a0,a0,1668 # 80007388 <etext+0x388>
    80001d0c:	10b030ef          	jal	80005616 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d10:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d14:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001d18:	85ce                	mv	a1,s3
    80001d1a:	00005517          	auipc	a0,0x5
    80001d1e:	68e50513          	addi	a0,a0,1678 # 800073a8 <etext+0x3a8>
    80001d22:	624030ef          	jal	80005346 <printf>
    panic("kerneltrap");
    80001d26:	00005517          	auipc	a0,0x5
    80001d2a:	6aa50513          	addi	a0,a0,1706 # 800073d0 <etext+0x3d0>
    80001d2e:	0e9030ef          	jal	80005616 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001d32:	a24ff0ef          	jal	80000f56 <myproc>
    80001d36:	d555                	beqz	a0,80001ce2 <kerneltrap+0x34>
    yield();
    80001d38:	fc0ff0ef          	jal	800014f8 <yield>
    80001d3c:	b75d                	j	80001ce2 <kerneltrap+0x34>

0000000080001d3e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001d3e:	1101                	addi	sp,sp,-32
    80001d40:	ec06                	sd	ra,24(sp)
    80001d42:	e822                	sd	s0,16(sp)
    80001d44:	e426                	sd	s1,8(sp)
    80001d46:	1000                	addi	s0,sp,32
    80001d48:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d4a:	a0cff0ef          	jal	80000f56 <myproc>
  switch (n) {
    80001d4e:	4795                	li	a5,5
    80001d50:	0497e163          	bltu	a5,s1,80001d92 <argraw+0x54>
    80001d54:	048a                	slli	s1,s1,0x2
    80001d56:	00006717          	auipc	a4,0x6
    80001d5a:	a8270713          	addi	a4,a4,-1406 # 800077d8 <states.0+0x30>
    80001d5e:	94ba                	add	s1,s1,a4
    80001d60:	409c                	lw	a5,0(s1)
    80001d62:	97ba                	add	a5,a5,a4
    80001d64:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001d66:	6d3c                	ld	a5,88(a0)
    80001d68:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001d6a:	60e2                	ld	ra,24(sp)
    80001d6c:	6442                	ld	s0,16(sp)
    80001d6e:	64a2                	ld	s1,8(sp)
    80001d70:	6105                	addi	sp,sp,32
    80001d72:	8082                	ret
    return p->trapframe->a1;
    80001d74:	6d3c                	ld	a5,88(a0)
    80001d76:	7fa8                	ld	a0,120(a5)
    80001d78:	bfcd                	j	80001d6a <argraw+0x2c>
    return p->trapframe->a2;
    80001d7a:	6d3c                	ld	a5,88(a0)
    80001d7c:	63c8                	ld	a0,128(a5)
    80001d7e:	b7f5                	j	80001d6a <argraw+0x2c>
    return p->trapframe->a3;
    80001d80:	6d3c                	ld	a5,88(a0)
    80001d82:	67c8                	ld	a0,136(a5)
    80001d84:	b7dd                	j	80001d6a <argraw+0x2c>
    return p->trapframe->a4;
    80001d86:	6d3c                	ld	a5,88(a0)
    80001d88:	6bc8                	ld	a0,144(a5)
    80001d8a:	b7c5                	j	80001d6a <argraw+0x2c>
    return p->trapframe->a5;
    80001d8c:	6d3c                	ld	a5,88(a0)
    80001d8e:	6fc8                	ld	a0,152(a5)
    80001d90:	bfe9                	j	80001d6a <argraw+0x2c>
  panic("argraw");
    80001d92:	00005517          	auipc	a0,0x5
    80001d96:	64e50513          	addi	a0,a0,1614 # 800073e0 <etext+0x3e0>
    80001d9a:	07d030ef          	jal	80005616 <panic>

0000000080001d9e <fetchaddr>:
{
    80001d9e:	1101                	addi	sp,sp,-32
    80001da0:	ec06                	sd	ra,24(sp)
    80001da2:	e822                	sd	s0,16(sp)
    80001da4:	e426                	sd	s1,8(sp)
    80001da6:	e04a                	sd	s2,0(sp)
    80001da8:	1000                	addi	s0,sp,32
    80001daa:	84aa                	mv	s1,a0
    80001dac:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001dae:	9a8ff0ef          	jal	80000f56 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001db2:	653c                	ld	a5,72(a0)
    80001db4:	02f4f663          	bgeu	s1,a5,80001de0 <fetchaddr+0x42>
    80001db8:	00848713          	addi	a4,s1,8
    80001dbc:	02e7e463          	bltu	a5,a4,80001de4 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001dc0:	46a1                	li	a3,8
    80001dc2:	8626                	mv	a2,s1
    80001dc4:	85ca                	mv	a1,s2
    80001dc6:	6928                	ld	a0,80(a0)
    80001dc8:	d1dfe0ef          	jal	80000ae4 <copyin>
    80001dcc:	00a03533          	snez	a0,a0
    80001dd0:	40a0053b          	negw	a0,a0
}
    80001dd4:	60e2                	ld	ra,24(sp)
    80001dd6:	6442                	ld	s0,16(sp)
    80001dd8:	64a2                	ld	s1,8(sp)
    80001dda:	6902                	ld	s2,0(sp)
    80001ddc:	6105                	addi	sp,sp,32
    80001dde:	8082                	ret
    return -1;
    80001de0:	557d                	li	a0,-1
    80001de2:	bfcd                	j	80001dd4 <fetchaddr+0x36>
    80001de4:	557d                	li	a0,-1
    80001de6:	b7fd                	j	80001dd4 <fetchaddr+0x36>

0000000080001de8 <fetchstr>:
{
    80001de8:	7179                	addi	sp,sp,-48
    80001dea:	f406                	sd	ra,40(sp)
    80001dec:	f022                	sd	s0,32(sp)
    80001dee:	ec26                	sd	s1,24(sp)
    80001df0:	e84a                	sd	s2,16(sp)
    80001df2:	e44e                	sd	s3,8(sp)
    80001df4:	1800                	addi	s0,sp,48
    80001df6:	892a                	mv	s2,a0
    80001df8:	84ae                	mv	s1,a1
    80001dfa:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001dfc:	95aff0ef          	jal	80000f56 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001e00:	86ce                	mv	a3,s3
    80001e02:	864a                	mv	a2,s2
    80001e04:	85a6                	mv	a1,s1
    80001e06:	6928                	ld	a0,80(a0)
    80001e08:	d63fe0ef          	jal	80000b6a <copyinstr>
    80001e0c:	00054c63          	bltz	a0,80001e24 <fetchstr+0x3c>
  return strlen(buf);
    80001e10:	8526                	mv	a0,s1
    80001e12:	db2fe0ef          	jal	800003c4 <strlen>
}
    80001e16:	70a2                	ld	ra,40(sp)
    80001e18:	7402                	ld	s0,32(sp)
    80001e1a:	64e2                	ld	s1,24(sp)
    80001e1c:	6942                	ld	s2,16(sp)
    80001e1e:	69a2                	ld	s3,8(sp)
    80001e20:	6145                	addi	sp,sp,48
    80001e22:	8082                	ret
    return -1;
    80001e24:	557d                	li	a0,-1
    80001e26:	bfc5                	j	80001e16 <fetchstr+0x2e>

0000000080001e28 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001e28:	1101                	addi	sp,sp,-32
    80001e2a:	ec06                	sd	ra,24(sp)
    80001e2c:	e822                	sd	s0,16(sp)
    80001e2e:	e426                	sd	s1,8(sp)
    80001e30:	1000                	addi	s0,sp,32
    80001e32:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001e34:	f0bff0ef          	jal	80001d3e <argraw>
    80001e38:	c088                	sw	a0,0(s1)
}
    80001e3a:	60e2                	ld	ra,24(sp)
    80001e3c:	6442                	ld	s0,16(sp)
    80001e3e:	64a2                	ld	s1,8(sp)
    80001e40:	6105                	addi	sp,sp,32
    80001e42:	8082                	ret

0000000080001e44 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001e44:	1101                	addi	sp,sp,-32
    80001e46:	ec06                	sd	ra,24(sp)
    80001e48:	e822                	sd	s0,16(sp)
    80001e4a:	e426                	sd	s1,8(sp)
    80001e4c:	1000                	addi	s0,sp,32
    80001e4e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001e50:	eefff0ef          	jal	80001d3e <argraw>
    80001e54:	e088                	sd	a0,0(s1)
}
    80001e56:	60e2                	ld	ra,24(sp)
    80001e58:	6442                	ld	s0,16(sp)
    80001e5a:	64a2                	ld	s1,8(sp)
    80001e5c:	6105                	addi	sp,sp,32
    80001e5e:	8082                	ret

0000000080001e60 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001e60:	1101                	addi	sp,sp,-32
    80001e62:	ec06                	sd	ra,24(sp)
    80001e64:	e822                	sd	s0,16(sp)
    80001e66:	e426                	sd	s1,8(sp)
    80001e68:	e04a                	sd	s2,0(sp)
    80001e6a:	1000                	addi	s0,sp,32
    80001e6c:	84ae                	mv	s1,a1
    80001e6e:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001e70:	ecfff0ef          	jal	80001d3e <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80001e74:	864a                	mv	a2,s2
    80001e76:	85a6                	mv	a1,s1
    80001e78:	f71ff0ef          	jal	80001de8 <fetchstr>
}
    80001e7c:	60e2                	ld	ra,24(sp)
    80001e7e:	6442                	ld	s0,16(sp)
    80001e80:	64a2                	ld	s1,8(sp)
    80001e82:	6902                	ld	s2,0(sp)
    80001e84:	6105                	addi	sp,sp,32
    80001e86:	8082                	ret

0000000080001e88 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001e88:	1101                	addi	sp,sp,-32
    80001e8a:	ec06                	sd	ra,24(sp)
    80001e8c:	e822                	sd	s0,16(sp)
    80001e8e:	e426                	sd	s1,8(sp)
    80001e90:	e04a                	sd	s2,0(sp)
    80001e92:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001e94:	8c2ff0ef          	jal	80000f56 <myproc>
    80001e98:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001e9a:	05853903          	ld	s2,88(a0)
    80001e9e:	0a893783          	ld	a5,168(s2)
    80001ea2:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001ea6:	37fd                	addiw	a5,a5,-1
    80001ea8:	4751                	li	a4,20
    80001eaa:	00f76f63          	bltu	a4,a5,80001ec8 <syscall+0x40>
    80001eae:	00369713          	slli	a4,a3,0x3
    80001eb2:	00006797          	auipc	a5,0x6
    80001eb6:	93e78793          	addi	a5,a5,-1730 # 800077f0 <syscalls>
    80001eba:	97ba                	add	a5,a5,a4
    80001ebc:	639c                	ld	a5,0(a5)
    80001ebe:	c789                	beqz	a5,80001ec8 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001ec0:	9782                	jalr	a5
    80001ec2:	06a93823          	sd	a0,112(s2)
    80001ec6:	a829                	j	80001ee0 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001ec8:	15848613          	addi	a2,s1,344
    80001ecc:	588c                	lw	a1,48(s1)
    80001ece:	00005517          	auipc	a0,0x5
    80001ed2:	51a50513          	addi	a0,a0,1306 # 800073e8 <etext+0x3e8>
    80001ed6:	470030ef          	jal	80005346 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001eda:	6cbc                	ld	a5,88(s1)
    80001edc:	577d                	li	a4,-1
    80001ede:	fbb8                	sd	a4,112(a5)
  }
}
    80001ee0:	60e2                	ld	ra,24(sp)
    80001ee2:	6442                	ld	s0,16(sp)
    80001ee4:	64a2                	ld	s1,8(sp)
    80001ee6:	6902                	ld	s2,0(sp)
    80001ee8:	6105                	addi	sp,sp,32
    80001eea:	8082                	ret

0000000080001eec <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001eec:	1101                	addi	sp,sp,-32
    80001eee:	ec06                	sd	ra,24(sp)
    80001ef0:	e822                	sd	s0,16(sp)
    80001ef2:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001ef4:	fec40593          	addi	a1,s0,-20
    80001ef8:	4501                	li	a0,0
    80001efa:	f2fff0ef          	jal	80001e28 <argint>
  exit(n);
    80001efe:	fec42503          	lw	a0,-20(s0)
    80001f02:	f2eff0ef          	jal	80001630 <exit>
  return 0;  // not reached
}
    80001f06:	4501                	li	a0,0
    80001f08:	60e2                	ld	ra,24(sp)
    80001f0a:	6442                	ld	s0,16(sp)
    80001f0c:	6105                	addi	sp,sp,32
    80001f0e:	8082                	ret

0000000080001f10 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001f10:	1141                	addi	sp,sp,-16
    80001f12:	e406                	sd	ra,8(sp)
    80001f14:	e022                	sd	s0,0(sp)
    80001f16:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001f18:	83eff0ef          	jal	80000f56 <myproc>
}
    80001f1c:	5908                	lw	a0,48(a0)
    80001f1e:	60a2                	ld	ra,8(sp)
    80001f20:	6402                	ld	s0,0(sp)
    80001f22:	0141                	addi	sp,sp,16
    80001f24:	8082                	ret

0000000080001f26 <sys_fork>:

uint64
sys_fork(void)
{
    80001f26:	1141                	addi	sp,sp,-16
    80001f28:	e406                	sd	ra,8(sp)
    80001f2a:	e022                	sd	s0,0(sp)
    80001f2c:	0800                	addi	s0,sp,16
  return fork();
    80001f2e:	b4eff0ef          	jal	8000127c <fork>
}
    80001f32:	60a2                	ld	ra,8(sp)
    80001f34:	6402                	ld	s0,0(sp)
    80001f36:	0141                	addi	sp,sp,16
    80001f38:	8082                	ret

0000000080001f3a <sys_wait>:

uint64
sys_wait(void)
{
    80001f3a:	1101                	addi	sp,sp,-32
    80001f3c:	ec06                	sd	ra,24(sp)
    80001f3e:	e822                	sd	s0,16(sp)
    80001f40:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001f42:	fe840593          	addi	a1,s0,-24
    80001f46:	4501                	li	a0,0
    80001f48:	efdff0ef          	jal	80001e44 <argaddr>
  return wait(p);
    80001f4c:	fe843503          	ld	a0,-24(s0)
    80001f50:	837ff0ef          	jal	80001786 <wait>
}
    80001f54:	60e2                	ld	ra,24(sp)
    80001f56:	6442                	ld	s0,16(sp)
    80001f58:	6105                	addi	sp,sp,32
    80001f5a:	8082                	ret

0000000080001f5c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001f5c:	7179                	addi	sp,sp,-48
    80001f5e:	f406                	sd	ra,40(sp)
    80001f60:	f022                	sd	s0,32(sp)
    80001f62:	ec26                	sd	s1,24(sp)
    80001f64:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001f66:	fdc40593          	addi	a1,s0,-36
    80001f6a:	4501                	li	a0,0
    80001f6c:	ebdff0ef          	jal	80001e28 <argint>
  addr = myproc()->sz;
    80001f70:	fe7fe0ef          	jal	80000f56 <myproc>
    80001f74:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001f76:	fdc42503          	lw	a0,-36(s0)
    80001f7a:	ab2ff0ef          	jal	8000122c <growproc>
    80001f7e:	00054863          	bltz	a0,80001f8e <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001f82:	8526                	mv	a0,s1
    80001f84:	70a2                	ld	ra,40(sp)
    80001f86:	7402                	ld	s0,32(sp)
    80001f88:	64e2                	ld	s1,24(sp)
    80001f8a:	6145                	addi	sp,sp,48
    80001f8c:	8082                	ret
    return -1;
    80001f8e:	54fd                	li	s1,-1
    80001f90:	bfcd                	j	80001f82 <sys_sbrk+0x26>

0000000080001f92 <sys_sleep>:

uint64
sys_sleep(void)
{
    80001f92:	7139                	addi	sp,sp,-64
    80001f94:	fc06                	sd	ra,56(sp)
    80001f96:	f822                	sd	s0,48(sp)
    80001f98:	f04a                	sd	s2,32(sp)
    80001f9a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001f9c:	fcc40593          	addi	a1,s0,-52
    80001fa0:	4501                	li	a0,0
    80001fa2:	e87ff0ef          	jal	80001e28 <argint>
  if(n < 0)
    80001fa6:	fcc42783          	lw	a5,-52(s0)
    80001faa:	0607c763          	bltz	a5,80002018 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001fae:	0022e517          	auipc	a0,0x22e
    80001fb2:	26250513          	addi	a0,a0,610 # 80230210 <tickslock>
    80001fb6:	18f030ef          	jal	80005944 <acquire>
  ticks0 = ticks;
    80001fba:	00008917          	auipc	s2,0x8
    80001fbe:	3ee92903          	lw	s2,1006(s2) # 8000a3a8 <ticks>
  while(ticks - ticks0 < n){
    80001fc2:	fcc42783          	lw	a5,-52(s0)
    80001fc6:	cf8d                	beqz	a5,80002000 <sys_sleep+0x6e>
    80001fc8:	f426                	sd	s1,40(sp)
    80001fca:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001fcc:	0022e997          	auipc	s3,0x22e
    80001fd0:	24498993          	addi	s3,s3,580 # 80230210 <tickslock>
    80001fd4:	00008497          	auipc	s1,0x8
    80001fd8:	3d448493          	addi	s1,s1,980 # 8000a3a8 <ticks>
    if(killed(myproc())){
    80001fdc:	f7bfe0ef          	jal	80000f56 <myproc>
    80001fe0:	f7cff0ef          	jal	8000175c <killed>
    80001fe4:	ed0d                	bnez	a0,8000201e <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001fe6:	85ce                	mv	a1,s3
    80001fe8:	8526                	mv	a0,s1
    80001fea:	d3aff0ef          	jal	80001524 <sleep>
  while(ticks - ticks0 < n){
    80001fee:	409c                	lw	a5,0(s1)
    80001ff0:	412787bb          	subw	a5,a5,s2
    80001ff4:	fcc42703          	lw	a4,-52(s0)
    80001ff8:	fee7e2e3          	bltu	a5,a4,80001fdc <sys_sleep+0x4a>
    80001ffc:	74a2                	ld	s1,40(sp)
    80001ffe:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002000:	0022e517          	auipc	a0,0x22e
    80002004:	21050513          	addi	a0,a0,528 # 80230210 <tickslock>
    80002008:	1d1030ef          	jal	800059d8 <release>
  return 0;
    8000200c:	4501                	li	a0,0
}
    8000200e:	70e2                	ld	ra,56(sp)
    80002010:	7442                	ld	s0,48(sp)
    80002012:	7902                	ld	s2,32(sp)
    80002014:	6121                	addi	sp,sp,64
    80002016:	8082                	ret
    n = 0;
    80002018:	fc042623          	sw	zero,-52(s0)
    8000201c:	bf49                	j	80001fae <sys_sleep+0x1c>
      release(&tickslock);
    8000201e:	0022e517          	auipc	a0,0x22e
    80002022:	1f250513          	addi	a0,a0,498 # 80230210 <tickslock>
    80002026:	1b3030ef          	jal	800059d8 <release>
      return -1;
    8000202a:	557d                	li	a0,-1
    8000202c:	74a2                	ld	s1,40(sp)
    8000202e:	69e2                	ld	s3,24(sp)
    80002030:	bff9                	j	8000200e <sys_sleep+0x7c>

0000000080002032 <sys_kill>:

uint64
sys_kill(void)
{
    80002032:	1101                	addi	sp,sp,-32
    80002034:	ec06                	sd	ra,24(sp)
    80002036:	e822                	sd	s0,16(sp)
    80002038:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000203a:	fec40593          	addi	a1,s0,-20
    8000203e:	4501                	li	a0,0
    80002040:	de9ff0ef          	jal	80001e28 <argint>
  return kill(pid);
    80002044:	fec42503          	lw	a0,-20(s0)
    80002048:	e8aff0ef          	jal	800016d2 <kill>
}
    8000204c:	60e2                	ld	ra,24(sp)
    8000204e:	6442                	ld	s0,16(sp)
    80002050:	6105                	addi	sp,sp,32
    80002052:	8082                	ret

0000000080002054 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002054:	1101                	addi	sp,sp,-32
    80002056:	ec06                	sd	ra,24(sp)
    80002058:	e822                	sd	s0,16(sp)
    8000205a:	e426                	sd	s1,8(sp)
    8000205c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000205e:	0022e517          	auipc	a0,0x22e
    80002062:	1b250513          	addi	a0,a0,434 # 80230210 <tickslock>
    80002066:	0df030ef          	jal	80005944 <acquire>
  xticks = ticks;
    8000206a:	00008497          	auipc	s1,0x8
    8000206e:	33e4a483          	lw	s1,830(s1) # 8000a3a8 <ticks>
  release(&tickslock);
    80002072:	0022e517          	auipc	a0,0x22e
    80002076:	19e50513          	addi	a0,a0,414 # 80230210 <tickslock>
    8000207a:	15f030ef          	jal	800059d8 <release>
  return xticks;
}
    8000207e:	02049513          	slli	a0,s1,0x20
    80002082:	9101                	srli	a0,a0,0x20
    80002084:	60e2                	ld	ra,24(sp)
    80002086:	6442                	ld	s0,16(sp)
    80002088:	64a2                	ld	s1,8(sp)
    8000208a:	6105                	addi	sp,sp,32
    8000208c:	8082                	ret

000000008000208e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000208e:	7179                	addi	sp,sp,-48
    80002090:	f406                	sd	ra,40(sp)
    80002092:	f022                	sd	s0,32(sp)
    80002094:	ec26                	sd	s1,24(sp)
    80002096:	e84a                	sd	s2,16(sp)
    80002098:	e44e                	sd	s3,8(sp)
    8000209a:	e052                	sd	s4,0(sp)
    8000209c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000209e:	00005597          	auipc	a1,0x5
    800020a2:	36a58593          	addi	a1,a1,874 # 80007408 <etext+0x408>
    800020a6:	0022e517          	auipc	a0,0x22e
    800020aa:	18250513          	addi	a0,a0,386 # 80230228 <bcache>
    800020ae:	013030ef          	jal	800058c0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800020b2:	00236797          	auipc	a5,0x236
    800020b6:	17678793          	addi	a5,a5,374 # 80238228 <bcache+0x8000>
    800020ba:	00236717          	auipc	a4,0x236
    800020be:	3d670713          	addi	a4,a4,982 # 80238490 <bcache+0x8268>
    800020c2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800020c6:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800020ca:	0022e497          	auipc	s1,0x22e
    800020ce:	17648493          	addi	s1,s1,374 # 80230240 <bcache+0x18>
    b->next = bcache.head.next;
    800020d2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800020d4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800020d6:	00005a17          	auipc	s4,0x5
    800020da:	33aa0a13          	addi	s4,s4,826 # 80007410 <etext+0x410>
    b->next = bcache.head.next;
    800020de:	2b893783          	ld	a5,696(s2)
    800020e2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800020e4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800020e8:	85d2                	mv	a1,s4
    800020ea:	01048513          	addi	a0,s1,16
    800020ee:	244010ef          	jal	80003332 <initsleeplock>
    bcache.head.next->prev = b;
    800020f2:	2b893783          	ld	a5,696(s2)
    800020f6:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800020f8:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800020fc:	45848493          	addi	s1,s1,1112
    80002100:	fd349fe3          	bne	s1,s3,800020de <binit+0x50>
  }
}
    80002104:	70a2                	ld	ra,40(sp)
    80002106:	7402                	ld	s0,32(sp)
    80002108:	64e2                	ld	s1,24(sp)
    8000210a:	6942                	ld	s2,16(sp)
    8000210c:	69a2                	ld	s3,8(sp)
    8000210e:	6a02                	ld	s4,0(sp)
    80002110:	6145                	addi	sp,sp,48
    80002112:	8082                	ret

0000000080002114 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002114:	7179                	addi	sp,sp,-48
    80002116:	f406                	sd	ra,40(sp)
    80002118:	f022                	sd	s0,32(sp)
    8000211a:	ec26                	sd	s1,24(sp)
    8000211c:	e84a                	sd	s2,16(sp)
    8000211e:	e44e                	sd	s3,8(sp)
    80002120:	1800                	addi	s0,sp,48
    80002122:	892a                	mv	s2,a0
    80002124:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002126:	0022e517          	auipc	a0,0x22e
    8000212a:	10250513          	addi	a0,a0,258 # 80230228 <bcache>
    8000212e:	017030ef          	jal	80005944 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002132:	00236497          	auipc	s1,0x236
    80002136:	3ae4b483          	ld	s1,942(s1) # 802384e0 <bcache+0x82b8>
    8000213a:	00236797          	auipc	a5,0x236
    8000213e:	35678793          	addi	a5,a5,854 # 80238490 <bcache+0x8268>
    80002142:	02f48b63          	beq	s1,a5,80002178 <bread+0x64>
    80002146:	873e                	mv	a4,a5
    80002148:	a021                	j	80002150 <bread+0x3c>
    8000214a:	68a4                	ld	s1,80(s1)
    8000214c:	02e48663          	beq	s1,a4,80002178 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002150:	449c                	lw	a5,8(s1)
    80002152:	ff279ce3          	bne	a5,s2,8000214a <bread+0x36>
    80002156:	44dc                	lw	a5,12(s1)
    80002158:	ff3799e3          	bne	a5,s3,8000214a <bread+0x36>
      b->refcnt++;
    8000215c:	40bc                	lw	a5,64(s1)
    8000215e:	2785                	addiw	a5,a5,1
    80002160:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002162:	0022e517          	auipc	a0,0x22e
    80002166:	0c650513          	addi	a0,a0,198 # 80230228 <bcache>
    8000216a:	06f030ef          	jal	800059d8 <release>
      acquiresleep(&b->lock);
    8000216e:	01048513          	addi	a0,s1,16
    80002172:	1f6010ef          	jal	80003368 <acquiresleep>
      return b;
    80002176:	a889                	j	800021c8 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002178:	00236497          	auipc	s1,0x236
    8000217c:	3604b483          	ld	s1,864(s1) # 802384d8 <bcache+0x82b0>
    80002180:	00236797          	auipc	a5,0x236
    80002184:	31078793          	addi	a5,a5,784 # 80238490 <bcache+0x8268>
    80002188:	00f48863          	beq	s1,a5,80002198 <bread+0x84>
    8000218c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000218e:	40bc                	lw	a5,64(s1)
    80002190:	cb91                	beqz	a5,800021a4 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002192:	64a4                	ld	s1,72(s1)
    80002194:	fee49de3          	bne	s1,a4,8000218e <bread+0x7a>
  panic("bget: no buffers");
    80002198:	00005517          	auipc	a0,0x5
    8000219c:	28050513          	addi	a0,a0,640 # 80007418 <etext+0x418>
    800021a0:	476030ef          	jal	80005616 <panic>
      b->dev = dev;
    800021a4:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800021a8:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800021ac:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800021b0:	4785                	li	a5,1
    800021b2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800021b4:	0022e517          	auipc	a0,0x22e
    800021b8:	07450513          	addi	a0,a0,116 # 80230228 <bcache>
    800021bc:	01d030ef          	jal	800059d8 <release>
      acquiresleep(&b->lock);
    800021c0:	01048513          	addi	a0,s1,16
    800021c4:	1a4010ef          	jal	80003368 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800021c8:	409c                	lw	a5,0(s1)
    800021ca:	cb89                	beqz	a5,800021dc <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800021cc:	8526                	mv	a0,s1
    800021ce:	70a2                	ld	ra,40(sp)
    800021d0:	7402                	ld	s0,32(sp)
    800021d2:	64e2                	ld	s1,24(sp)
    800021d4:	6942                	ld	s2,16(sp)
    800021d6:	69a2                	ld	s3,8(sp)
    800021d8:	6145                	addi	sp,sp,48
    800021da:	8082                	ret
    virtio_disk_rw(b, 0);
    800021dc:	4581                	li	a1,0
    800021de:	8526                	mv	a0,s1
    800021e0:	201020ef          	jal	80004be0 <virtio_disk_rw>
    b->valid = 1;
    800021e4:	4785                	li	a5,1
    800021e6:	c09c                	sw	a5,0(s1)
  return b;
    800021e8:	b7d5                	j	800021cc <bread+0xb8>

00000000800021ea <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800021ea:	1101                	addi	sp,sp,-32
    800021ec:	ec06                	sd	ra,24(sp)
    800021ee:	e822                	sd	s0,16(sp)
    800021f0:	e426                	sd	s1,8(sp)
    800021f2:	1000                	addi	s0,sp,32
    800021f4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800021f6:	0541                	addi	a0,a0,16
    800021f8:	1ee010ef          	jal	800033e6 <holdingsleep>
    800021fc:	c911                	beqz	a0,80002210 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800021fe:	4585                	li	a1,1
    80002200:	8526                	mv	a0,s1
    80002202:	1df020ef          	jal	80004be0 <virtio_disk_rw>
}
    80002206:	60e2                	ld	ra,24(sp)
    80002208:	6442                	ld	s0,16(sp)
    8000220a:	64a2                	ld	s1,8(sp)
    8000220c:	6105                	addi	sp,sp,32
    8000220e:	8082                	ret
    panic("bwrite");
    80002210:	00005517          	auipc	a0,0x5
    80002214:	22050513          	addi	a0,a0,544 # 80007430 <etext+0x430>
    80002218:	3fe030ef          	jal	80005616 <panic>

000000008000221c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000221c:	1101                	addi	sp,sp,-32
    8000221e:	ec06                	sd	ra,24(sp)
    80002220:	e822                	sd	s0,16(sp)
    80002222:	e426                	sd	s1,8(sp)
    80002224:	e04a                	sd	s2,0(sp)
    80002226:	1000                	addi	s0,sp,32
    80002228:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000222a:	01050913          	addi	s2,a0,16
    8000222e:	854a                	mv	a0,s2
    80002230:	1b6010ef          	jal	800033e6 <holdingsleep>
    80002234:	c125                	beqz	a0,80002294 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002236:	854a                	mv	a0,s2
    80002238:	176010ef          	jal	800033ae <releasesleep>

  acquire(&bcache.lock);
    8000223c:	0022e517          	auipc	a0,0x22e
    80002240:	fec50513          	addi	a0,a0,-20 # 80230228 <bcache>
    80002244:	700030ef          	jal	80005944 <acquire>
  b->refcnt--;
    80002248:	40bc                	lw	a5,64(s1)
    8000224a:	37fd                	addiw	a5,a5,-1
    8000224c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000224e:	e79d                	bnez	a5,8000227c <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002250:	68b8                	ld	a4,80(s1)
    80002252:	64bc                	ld	a5,72(s1)
    80002254:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002256:	68b8                	ld	a4,80(s1)
    80002258:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000225a:	00236797          	auipc	a5,0x236
    8000225e:	fce78793          	addi	a5,a5,-50 # 80238228 <bcache+0x8000>
    80002262:	2b87b703          	ld	a4,696(a5)
    80002266:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002268:	00236717          	auipc	a4,0x236
    8000226c:	22870713          	addi	a4,a4,552 # 80238490 <bcache+0x8268>
    80002270:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002272:	2b87b703          	ld	a4,696(a5)
    80002276:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002278:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000227c:	0022e517          	auipc	a0,0x22e
    80002280:	fac50513          	addi	a0,a0,-84 # 80230228 <bcache>
    80002284:	754030ef          	jal	800059d8 <release>
}
    80002288:	60e2                	ld	ra,24(sp)
    8000228a:	6442                	ld	s0,16(sp)
    8000228c:	64a2                	ld	s1,8(sp)
    8000228e:	6902                	ld	s2,0(sp)
    80002290:	6105                	addi	sp,sp,32
    80002292:	8082                	ret
    panic("brelse");
    80002294:	00005517          	auipc	a0,0x5
    80002298:	1a450513          	addi	a0,a0,420 # 80007438 <etext+0x438>
    8000229c:	37a030ef          	jal	80005616 <panic>

00000000800022a0 <bpin>:

void
bpin(struct buf *b) {
    800022a0:	1101                	addi	sp,sp,-32
    800022a2:	ec06                	sd	ra,24(sp)
    800022a4:	e822                	sd	s0,16(sp)
    800022a6:	e426                	sd	s1,8(sp)
    800022a8:	1000                	addi	s0,sp,32
    800022aa:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800022ac:	0022e517          	auipc	a0,0x22e
    800022b0:	f7c50513          	addi	a0,a0,-132 # 80230228 <bcache>
    800022b4:	690030ef          	jal	80005944 <acquire>
  b->refcnt++;
    800022b8:	40bc                	lw	a5,64(s1)
    800022ba:	2785                	addiw	a5,a5,1
    800022bc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800022be:	0022e517          	auipc	a0,0x22e
    800022c2:	f6a50513          	addi	a0,a0,-150 # 80230228 <bcache>
    800022c6:	712030ef          	jal	800059d8 <release>
}
    800022ca:	60e2                	ld	ra,24(sp)
    800022cc:	6442                	ld	s0,16(sp)
    800022ce:	64a2                	ld	s1,8(sp)
    800022d0:	6105                	addi	sp,sp,32
    800022d2:	8082                	ret

00000000800022d4 <bunpin>:

void
bunpin(struct buf *b) {
    800022d4:	1101                	addi	sp,sp,-32
    800022d6:	ec06                	sd	ra,24(sp)
    800022d8:	e822                	sd	s0,16(sp)
    800022da:	e426                	sd	s1,8(sp)
    800022dc:	1000                	addi	s0,sp,32
    800022de:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800022e0:	0022e517          	auipc	a0,0x22e
    800022e4:	f4850513          	addi	a0,a0,-184 # 80230228 <bcache>
    800022e8:	65c030ef          	jal	80005944 <acquire>
  b->refcnt--;
    800022ec:	40bc                	lw	a5,64(s1)
    800022ee:	37fd                	addiw	a5,a5,-1
    800022f0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800022f2:	0022e517          	auipc	a0,0x22e
    800022f6:	f3650513          	addi	a0,a0,-202 # 80230228 <bcache>
    800022fa:	6de030ef          	jal	800059d8 <release>
}
    800022fe:	60e2                	ld	ra,24(sp)
    80002300:	6442                	ld	s0,16(sp)
    80002302:	64a2                	ld	s1,8(sp)
    80002304:	6105                	addi	sp,sp,32
    80002306:	8082                	ret

0000000080002308 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002308:	1101                	addi	sp,sp,-32
    8000230a:	ec06                	sd	ra,24(sp)
    8000230c:	e822                	sd	s0,16(sp)
    8000230e:	e426                	sd	s1,8(sp)
    80002310:	e04a                	sd	s2,0(sp)
    80002312:	1000                	addi	s0,sp,32
    80002314:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002316:	00d5d79b          	srliw	a5,a1,0xd
    8000231a:	00236597          	auipc	a1,0x236
    8000231e:	5ea5a583          	lw	a1,1514(a1) # 80238904 <sb+0x1c>
    80002322:	9dbd                	addw	a1,a1,a5
    80002324:	df1ff0ef          	jal	80002114 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002328:	0074f713          	andi	a4,s1,7
    8000232c:	4785                	li	a5,1
    8000232e:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002332:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002334:	90d9                	srli	s1,s1,0x36
    80002336:	00950733          	add	a4,a0,s1
    8000233a:	05874703          	lbu	a4,88(a4)
    8000233e:	00e7f6b3          	and	a3,a5,a4
    80002342:	c29d                	beqz	a3,80002368 <bfree+0x60>
    80002344:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002346:	94aa                	add	s1,s1,a0
    80002348:	fff7c793          	not	a5,a5
    8000234c:	8f7d                	and	a4,a4,a5
    8000234e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002352:	711000ef          	jal	80003262 <log_write>
  brelse(bp);
    80002356:	854a                	mv	a0,s2
    80002358:	ec5ff0ef          	jal	8000221c <brelse>
}
    8000235c:	60e2                	ld	ra,24(sp)
    8000235e:	6442                	ld	s0,16(sp)
    80002360:	64a2                	ld	s1,8(sp)
    80002362:	6902                	ld	s2,0(sp)
    80002364:	6105                	addi	sp,sp,32
    80002366:	8082                	ret
    panic("freeing free block");
    80002368:	00005517          	auipc	a0,0x5
    8000236c:	0d850513          	addi	a0,a0,216 # 80007440 <etext+0x440>
    80002370:	2a6030ef          	jal	80005616 <panic>

0000000080002374 <balloc>:
{
    80002374:	715d                	addi	sp,sp,-80
    80002376:	e486                	sd	ra,72(sp)
    80002378:	e0a2                	sd	s0,64(sp)
    8000237a:	fc26                	sd	s1,56(sp)
    8000237c:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    8000237e:	00236797          	auipc	a5,0x236
    80002382:	56e7a783          	lw	a5,1390(a5) # 802388ec <sb+0x4>
    80002386:	0e078863          	beqz	a5,80002476 <balloc+0x102>
    8000238a:	f84a                	sd	s2,48(sp)
    8000238c:	f44e                	sd	s3,40(sp)
    8000238e:	f052                	sd	s4,32(sp)
    80002390:	ec56                	sd	s5,24(sp)
    80002392:	e85a                	sd	s6,16(sp)
    80002394:	e45e                	sd	s7,8(sp)
    80002396:	e062                	sd	s8,0(sp)
    80002398:	8baa                	mv	s7,a0
    8000239a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000239c:	00236b17          	auipc	s6,0x236
    800023a0:	54cb0b13          	addi	s6,s6,1356 # 802388e8 <sb>
      m = 1 << (bi % 8);
    800023a4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800023a6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800023a8:	6c09                	lui	s8,0x2
    800023aa:	a09d                	j	80002410 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    800023ac:	97ca                	add	a5,a5,s2
    800023ae:	8e55                	or	a2,a2,a3
    800023b0:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800023b4:	854a                	mv	a0,s2
    800023b6:	6ad000ef          	jal	80003262 <log_write>
        brelse(bp);
    800023ba:	854a                	mv	a0,s2
    800023bc:	e61ff0ef          	jal	8000221c <brelse>
  bp = bread(dev, bno);
    800023c0:	85a6                	mv	a1,s1
    800023c2:	855e                	mv	a0,s7
    800023c4:	d51ff0ef          	jal	80002114 <bread>
    800023c8:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800023ca:	40000613          	li	a2,1024
    800023ce:	4581                	li	a1,0
    800023d0:	05850513          	addi	a0,a0,88
    800023d4:	e69fd0ef          	jal	8000023c <memset>
  log_write(bp);
    800023d8:	854a                	mv	a0,s2
    800023da:	689000ef          	jal	80003262 <log_write>
  brelse(bp);
    800023de:	854a                	mv	a0,s2
    800023e0:	e3dff0ef          	jal	8000221c <brelse>
}
    800023e4:	7942                	ld	s2,48(sp)
    800023e6:	79a2                	ld	s3,40(sp)
    800023e8:	7a02                	ld	s4,32(sp)
    800023ea:	6ae2                	ld	s5,24(sp)
    800023ec:	6b42                	ld	s6,16(sp)
    800023ee:	6ba2                	ld	s7,8(sp)
    800023f0:	6c02                	ld	s8,0(sp)
}
    800023f2:	8526                	mv	a0,s1
    800023f4:	60a6                	ld	ra,72(sp)
    800023f6:	6406                	ld	s0,64(sp)
    800023f8:	74e2                	ld	s1,56(sp)
    800023fa:	6161                	addi	sp,sp,80
    800023fc:	8082                	ret
    brelse(bp);
    800023fe:	854a                	mv	a0,s2
    80002400:	e1dff0ef          	jal	8000221c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002404:	015c0abb          	addw	s5,s8,s5
    80002408:	004b2783          	lw	a5,4(s6)
    8000240c:	04fafe63          	bgeu	s5,a5,80002468 <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    80002410:	41fad79b          	sraiw	a5,s5,0x1f
    80002414:	0137d79b          	srliw	a5,a5,0x13
    80002418:	015787bb          	addw	a5,a5,s5
    8000241c:	40d7d79b          	sraiw	a5,a5,0xd
    80002420:	01cb2583          	lw	a1,28(s6)
    80002424:	9dbd                	addw	a1,a1,a5
    80002426:	855e                	mv	a0,s7
    80002428:	cedff0ef          	jal	80002114 <bread>
    8000242c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000242e:	004b2503          	lw	a0,4(s6)
    80002432:	84d6                	mv	s1,s5
    80002434:	4701                	li	a4,0
    80002436:	fca4f4e3          	bgeu	s1,a0,800023fe <balloc+0x8a>
      m = 1 << (bi % 8);
    8000243a:	00777693          	andi	a3,a4,7
    8000243e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002442:	41f7579b          	sraiw	a5,a4,0x1f
    80002446:	01d7d79b          	srliw	a5,a5,0x1d
    8000244a:	9fb9                	addw	a5,a5,a4
    8000244c:	4037d79b          	sraiw	a5,a5,0x3
    80002450:	00f90633          	add	a2,s2,a5
    80002454:	05864603          	lbu	a2,88(a2)
    80002458:	00c6f5b3          	and	a1,a3,a2
    8000245c:	d9a1                	beqz	a1,800023ac <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000245e:	2705                	addiw	a4,a4,1
    80002460:	2485                	addiw	s1,s1,1
    80002462:	fd471ae3          	bne	a4,s4,80002436 <balloc+0xc2>
    80002466:	bf61                	j	800023fe <balloc+0x8a>
    80002468:	7942                	ld	s2,48(sp)
    8000246a:	79a2                	ld	s3,40(sp)
    8000246c:	7a02                	ld	s4,32(sp)
    8000246e:	6ae2                	ld	s5,24(sp)
    80002470:	6b42                	ld	s6,16(sp)
    80002472:	6ba2                	ld	s7,8(sp)
    80002474:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80002476:	00005517          	auipc	a0,0x5
    8000247a:	fe250513          	addi	a0,a0,-30 # 80007458 <etext+0x458>
    8000247e:	6c9020ef          	jal	80005346 <printf>
  return 0;
    80002482:	4481                	li	s1,0
    80002484:	b7bd                	j	800023f2 <balloc+0x7e>

0000000080002486 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002486:	7179                	addi	sp,sp,-48
    80002488:	f406                	sd	ra,40(sp)
    8000248a:	f022                	sd	s0,32(sp)
    8000248c:	ec26                	sd	s1,24(sp)
    8000248e:	e84a                	sd	s2,16(sp)
    80002490:	e44e                	sd	s3,8(sp)
    80002492:	1800                	addi	s0,sp,48
    80002494:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002496:	47ad                	li	a5,11
    80002498:	02b7e363          	bltu	a5,a1,800024be <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    8000249c:	02059793          	slli	a5,a1,0x20
    800024a0:	01e7d593          	srli	a1,a5,0x1e
    800024a4:	00b504b3          	add	s1,a0,a1
    800024a8:	0504a903          	lw	s2,80(s1)
    800024ac:	06091363          	bnez	s2,80002512 <bmap+0x8c>
      addr = balloc(ip->dev);
    800024b0:	4108                	lw	a0,0(a0)
    800024b2:	ec3ff0ef          	jal	80002374 <balloc>
    800024b6:	892a                	mv	s2,a0
      if(addr == 0)
    800024b8:	cd29                	beqz	a0,80002512 <bmap+0x8c>
        return 0;
      ip->addrs[bn] = addr;
    800024ba:	c8a8                	sw	a0,80(s1)
    800024bc:	a899                	j	80002512 <bmap+0x8c>
    }
    return addr;
  }
  bn -= NDIRECT;
    800024be:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    800024c2:	0ff00793          	li	a5,255
    800024c6:	0697e963          	bltu	a5,s1,80002538 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800024ca:	08052903          	lw	s2,128(a0)
    800024ce:	00091b63          	bnez	s2,800024e4 <bmap+0x5e>
      addr = balloc(ip->dev);
    800024d2:	4108                	lw	a0,0(a0)
    800024d4:	ea1ff0ef          	jal	80002374 <balloc>
    800024d8:	892a                	mv	s2,a0
      if(addr == 0)
    800024da:	cd05                	beqz	a0,80002512 <bmap+0x8c>
    800024dc:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800024de:	08a9a023          	sw	a0,128(s3)
    800024e2:	a011                	j	800024e6 <bmap+0x60>
    800024e4:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800024e6:	85ca                	mv	a1,s2
    800024e8:	0009a503          	lw	a0,0(s3)
    800024ec:	c29ff0ef          	jal	80002114 <bread>
    800024f0:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800024f2:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800024f6:	02049713          	slli	a4,s1,0x20
    800024fa:	01e75593          	srli	a1,a4,0x1e
    800024fe:	00b784b3          	add	s1,a5,a1
    80002502:	0004a903          	lw	s2,0(s1)
    80002506:	00090e63          	beqz	s2,80002522 <bmap+0x9c>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000250a:	8552                	mv	a0,s4
    8000250c:	d11ff0ef          	jal	8000221c <brelse>
    return addr;
    80002510:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002512:	854a                	mv	a0,s2
    80002514:	70a2                	ld	ra,40(sp)
    80002516:	7402                	ld	s0,32(sp)
    80002518:	64e2                	ld	s1,24(sp)
    8000251a:	6942                	ld	s2,16(sp)
    8000251c:	69a2                	ld	s3,8(sp)
    8000251e:	6145                	addi	sp,sp,48
    80002520:	8082                	ret
      addr = balloc(ip->dev);
    80002522:	0009a503          	lw	a0,0(s3)
    80002526:	e4fff0ef          	jal	80002374 <balloc>
    8000252a:	892a                	mv	s2,a0
      if(addr){
    8000252c:	dd79                	beqz	a0,8000250a <bmap+0x84>
        a[bn] = addr;
    8000252e:	c088                	sw	a0,0(s1)
        log_write(bp);
    80002530:	8552                	mv	a0,s4
    80002532:	531000ef          	jal	80003262 <log_write>
    80002536:	bfd1                	j	8000250a <bmap+0x84>
    80002538:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000253a:	00005517          	auipc	a0,0x5
    8000253e:	f3650513          	addi	a0,a0,-202 # 80007470 <etext+0x470>
    80002542:	0d4030ef          	jal	80005616 <panic>

0000000080002546 <iget>:
{
    80002546:	7179                	addi	sp,sp,-48
    80002548:	f406                	sd	ra,40(sp)
    8000254a:	f022                	sd	s0,32(sp)
    8000254c:	ec26                	sd	s1,24(sp)
    8000254e:	e84a                	sd	s2,16(sp)
    80002550:	e44e                	sd	s3,8(sp)
    80002552:	e052                	sd	s4,0(sp)
    80002554:	1800                	addi	s0,sp,48
    80002556:	89aa                	mv	s3,a0
    80002558:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000255a:	00236517          	auipc	a0,0x236
    8000255e:	3ae50513          	addi	a0,a0,942 # 80238908 <itable>
    80002562:	3e2030ef          	jal	80005944 <acquire>
  empty = 0;
    80002566:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002568:	00236497          	auipc	s1,0x236
    8000256c:	3b848493          	addi	s1,s1,952 # 80238920 <itable+0x18>
    80002570:	00238697          	auipc	a3,0x238
    80002574:	e4068693          	addi	a3,a3,-448 # 8023a3b0 <log>
    80002578:	a039                	j	80002586 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000257a:	02090963          	beqz	s2,800025ac <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000257e:	08848493          	addi	s1,s1,136
    80002582:	02d48863          	beq	s1,a3,800025b2 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002586:	449c                	lw	a5,8(s1)
    80002588:	fef059e3          	blez	a5,8000257a <iget+0x34>
    8000258c:	4098                	lw	a4,0(s1)
    8000258e:	ff3716e3          	bne	a4,s3,8000257a <iget+0x34>
    80002592:	40d8                	lw	a4,4(s1)
    80002594:	ff4713e3          	bne	a4,s4,8000257a <iget+0x34>
      ip->ref++;
    80002598:	2785                	addiw	a5,a5,1
    8000259a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000259c:	00236517          	auipc	a0,0x236
    800025a0:	36c50513          	addi	a0,a0,876 # 80238908 <itable>
    800025a4:	434030ef          	jal	800059d8 <release>
      return ip;
    800025a8:	8926                	mv	s2,s1
    800025aa:	a02d                	j	800025d4 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800025ac:	fbe9                	bnez	a5,8000257e <iget+0x38>
      empty = ip;
    800025ae:	8926                	mv	s2,s1
    800025b0:	b7f9                	j	8000257e <iget+0x38>
  if(empty == 0)
    800025b2:	02090a63          	beqz	s2,800025e6 <iget+0xa0>
  ip->dev = dev;
    800025b6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800025ba:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800025be:	4785                	li	a5,1
    800025c0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800025c4:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800025c8:	00236517          	auipc	a0,0x236
    800025cc:	34050513          	addi	a0,a0,832 # 80238908 <itable>
    800025d0:	408030ef          	jal	800059d8 <release>
}
    800025d4:	854a                	mv	a0,s2
    800025d6:	70a2                	ld	ra,40(sp)
    800025d8:	7402                	ld	s0,32(sp)
    800025da:	64e2                	ld	s1,24(sp)
    800025dc:	6942                	ld	s2,16(sp)
    800025de:	69a2                	ld	s3,8(sp)
    800025e0:	6a02                	ld	s4,0(sp)
    800025e2:	6145                	addi	sp,sp,48
    800025e4:	8082                	ret
    panic("iget: no inodes");
    800025e6:	00005517          	auipc	a0,0x5
    800025ea:	ea250513          	addi	a0,a0,-350 # 80007488 <etext+0x488>
    800025ee:	028030ef          	jal	80005616 <panic>

00000000800025f2 <fsinit>:
fsinit(int dev) {
    800025f2:	7179                	addi	sp,sp,-48
    800025f4:	f406                	sd	ra,40(sp)
    800025f6:	f022                	sd	s0,32(sp)
    800025f8:	ec26                	sd	s1,24(sp)
    800025fa:	e84a                	sd	s2,16(sp)
    800025fc:	e44e                	sd	s3,8(sp)
    800025fe:	1800                	addi	s0,sp,48
    80002600:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002602:	4585                	li	a1,1
    80002604:	b11ff0ef          	jal	80002114 <bread>
    80002608:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000260a:	00236997          	auipc	s3,0x236
    8000260e:	2de98993          	addi	s3,s3,734 # 802388e8 <sb>
    80002612:	02000613          	li	a2,32
    80002616:	05850593          	addi	a1,a0,88
    8000261a:	854e                	mv	a0,s3
    8000261c:	c85fd0ef          	jal	800002a0 <memmove>
  brelse(bp);
    80002620:	8526                	mv	a0,s1
    80002622:	bfbff0ef          	jal	8000221c <brelse>
  if(sb.magic != FSMAGIC)
    80002626:	0009a703          	lw	a4,0(s3)
    8000262a:	102037b7          	lui	a5,0x10203
    8000262e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002632:	02f71063          	bne	a4,a5,80002652 <fsinit+0x60>
  initlog(dev, &sb);
    80002636:	00236597          	auipc	a1,0x236
    8000263a:	2b258593          	addi	a1,a1,690 # 802388e8 <sb>
    8000263e:	854a                	mv	a0,s2
    80002640:	215000ef          	jal	80003054 <initlog>
}
    80002644:	70a2                	ld	ra,40(sp)
    80002646:	7402                	ld	s0,32(sp)
    80002648:	64e2                	ld	s1,24(sp)
    8000264a:	6942                	ld	s2,16(sp)
    8000264c:	69a2                	ld	s3,8(sp)
    8000264e:	6145                	addi	sp,sp,48
    80002650:	8082                	ret
    panic("invalid file system");
    80002652:	00005517          	auipc	a0,0x5
    80002656:	e4650513          	addi	a0,a0,-442 # 80007498 <etext+0x498>
    8000265a:	7bd020ef          	jal	80005616 <panic>

000000008000265e <iinit>:
{
    8000265e:	7179                	addi	sp,sp,-48
    80002660:	f406                	sd	ra,40(sp)
    80002662:	f022                	sd	s0,32(sp)
    80002664:	ec26                	sd	s1,24(sp)
    80002666:	e84a                	sd	s2,16(sp)
    80002668:	e44e                	sd	s3,8(sp)
    8000266a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000266c:	00005597          	auipc	a1,0x5
    80002670:	e4458593          	addi	a1,a1,-444 # 800074b0 <etext+0x4b0>
    80002674:	00236517          	auipc	a0,0x236
    80002678:	29450513          	addi	a0,a0,660 # 80238908 <itable>
    8000267c:	244030ef          	jal	800058c0 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002680:	00236497          	auipc	s1,0x236
    80002684:	2b048493          	addi	s1,s1,688 # 80238930 <itable+0x28>
    80002688:	00238997          	auipc	s3,0x238
    8000268c:	d3898993          	addi	s3,s3,-712 # 8023a3c0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002690:	00005917          	auipc	s2,0x5
    80002694:	e2890913          	addi	s2,s2,-472 # 800074b8 <etext+0x4b8>
    80002698:	85ca                	mv	a1,s2
    8000269a:	8526                	mv	a0,s1
    8000269c:	497000ef          	jal	80003332 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800026a0:	08848493          	addi	s1,s1,136
    800026a4:	ff349ae3          	bne	s1,s3,80002698 <iinit+0x3a>
}
    800026a8:	70a2                	ld	ra,40(sp)
    800026aa:	7402                	ld	s0,32(sp)
    800026ac:	64e2                	ld	s1,24(sp)
    800026ae:	6942                	ld	s2,16(sp)
    800026b0:	69a2                	ld	s3,8(sp)
    800026b2:	6145                	addi	sp,sp,48
    800026b4:	8082                	ret

00000000800026b6 <ialloc>:
{
    800026b6:	7139                	addi	sp,sp,-64
    800026b8:	fc06                	sd	ra,56(sp)
    800026ba:	f822                	sd	s0,48(sp)
    800026bc:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800026be:	00236717          	auipc	a4,0x236
    800026c2:	23672703          	lw	a4,566(a4) # 802388f4 <sb+0xc>
    800026c6:	4785                	li	a5,1
    800026c8:	06e7f063          	bgeu	a5,a4,80002728 <ialloc+0x72>
    800026cc:	f426                	sd	s1,40(sp)
    800026ce:	f04a                	sd	s2,32(sp)
    800026d0:	ec4e                	sd	s3,24(sp)
    800026d2:	e852                	sd	s4,16(sp)
    800026d4:	e456                	sd	s5,8(sp)
    800026d6:	e05a                	sd	s6,0(sp)
    800026d8:	8aaa                	mv	s5,a0
    800026da:	8b2e                	mv	s6,a1
    800026dc:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800026de:	00236a17          	auipc	s4,0x236
    800026e2:	20aa0a13          	addi	s4,s4,522 # 802388e8 <sb>
    800026e6:	00495593          	srli	a1,s2,0x4
    800026ea:	018a2783          	lw	a5,24(s4)
    800026ee:	9dbd                	addw	a1,a1,a5
    800026f0:	8556                	mv	a0,s5
    800026f2:	a23ff0ef          	jal	80002114 <bread>
    800026f6:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800026f8:	05850993          	addi	s3,a0,88
    800026fc:	00f97793          	andi	a5,s2,15
    80002700:	079a                	slli	a5,a5,0x6
    80002702:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002704:	00099783          	lh	a5,0(s3)
    80002708:	cb9d                	beqz	a5,8000273e <ialloc+0x88>
    brelse(bp);
    8000270a:	b13ff0ef          	jal	8000221c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000270e:	0905                	addi	s2,s2,1
    80002710:	00ca2703          	lw	a4,12(s4)
    80002714:	0009079b          	sext.w	a5,s2
    80002718:	fce7e7e3          	bltu	a5,a4,800026e6 <ialloc+0x30>
    8000271c:	74a2                	ld	s1,40(sp)
    8000271e:	7902                	ld	s2,32(sp)
    80002720:	69e2                	ld	s3,24(sp)
    80002722:	6a42                	ld	s4,16(sp)
    80002724:	6aa2                	ld	s5,8(sp)
    80002726:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002728:	00005517          	auipc	a0,0x5
    8000272c:	d9850513          	addi	a0,a0,-616 # 800074c0 <etext+0x4c0>
    80002730:	417020ef          	jal	80005346 <printf>
  return 0;
    80002734:	4501                	li	a0,0
}
    80002736:	70e2                	ld	ra,56(sp)
    80002738:	7442                	ld	s0,48(sp)
    8000273a:	6121                	addi	sp,sp,64
    8000273c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000273e:	04000613          	li	a2,64
    80002742:	4581                	li	a1,0
    80002744:	854e                	mv	a0,s3
    80002746:	af7fd0ef          	jal	8000023c <memset>
      dip->type = type;
    8000274a:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000274e:	8526                	mv	a0,s1
    80002750:	313000ef          	jal	80003262 <log_write>
      brelse(bp);
    80002754:	8526                	mv	a0,s1
    80002756:	ac7ff0ef          	jal	8000221c <brelse>
      return iget(dev, inum);
    8000275a:	0009059b          	sext.w	a1,s2
    8000275e:	8556                	mv	a0,s5
    80002760:	de7ff0ef          	jal	80002546 <iget>
    80002764:	74a2                	ld	s1,40(sp)
    80002766:	7902                	ld	s2,32(sp)
    80002768:	69e2                	ld	s3,24(sp)
    8000276a:	6a42                	ld	s4,16(sp)
    8000276c:	6aa2                	ld	s5,8(sp)
    8000276e:	6b02                	ld	s6,0(sp)
    80002770:	b7d9                	j	80002736 <ialloc+0x80>

0000000080002772 <iupdate>:
{
    80002772:	1101                	addi	sp,sp,-32
    80002774:	ec06                	sd	ra,24(sp)
    80002776:	e822                	sd	s0,16(sp)
    80002778:	e426                	sd	s1,8(sp)
    8000277a:	e04a                	sd	s2,0(sp)
    8000277c:	1000                	addi	s0,sp,32
    8000277e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002780:	415c                	lw	a5,4(a0)
    80002782:	0047d79b          	srliw	a5,a5,0x4
    80002786:	00236597          	auipc	a1,0x236
    8000278a:	17a5a583          	lw	a1,378(a1) # 80238900 <sb+0x18>
    8000278e:	9dbd                	addw	a1,a1,a5
    80002790:	4108                	lw	a0,0(a0)
    80002792:	983ff0ef          	jal	80002114 <bread>
    80002796:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002798:	05850793          	addi	a5,a0,88
    8000279c:	40d8                	lw	a4,4(s1)
    8000279e:	8b3d                	andi	a4,a4,15
    800027a0:	071a                	slli	a4,a4,0x6
    800027a2:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800027a4:	04449703          	lh	a4,68(s1)
    800027a8:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800027ac:	04649703          	lh	a4,70(s1)
    800027b0:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800027b4:	04849703          	lh	a4,72(s1)
    800027b8:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800027bc:	04a49703          	lh	a4,74(s1)
    800027c0:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800027c4:	44f8                	lw	a4,76(s1)
    800027c6:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800027c8:	03400613          	li	a2,52
    800027cc:	05048593          	addi	a1,s1,80
    800027d0:	00c78513          	addi	a0,a5,12
    800027d4:	acdfd0ef          	jal	800002a0 <memmove>
  log_write(bp);
    800027d8:	854a                	mv	a0,s2
    800027da:	289000ef          	jal	80003262 <log_write>
  brelse(bp);
    800027de:	854a                	mv	a0,s2
    800027e0:	a3dff0ef          	jal	8000221c <brelse>
}
    800027e4:	60e2                	ld	ra,24(sp)
    800027e6:	6442                	ld	s0,16(sp)
    800027e8:	64a2                	ld	s1,8(sp)
    800027ea:	6902                	ld	s2,0(sp)
    800027ec:	6105                	addi	sp,sp,32
    800027ee:	8082                	ret

00000000800027f0 <idup>:
{
    800027f0:	1101                	addi	sp,sp,-32
    800027f2:	ec06                	sd	ra,24(sp)
    800027f4:	e822                	sd	s0,16(sp)
    800027f6:	e426                	sd	s1,8(sp)
    800027f8:	1000                	addi	s0,sp,32
    800027fa:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800027fc:	00236517          	auipc	a0,0x236
    80002800:	10c50513          	addi	a0,a0,268 # 80238908 <itable>
    80002804:	140030ef          	jal	80005944 <acquire>
  ip->ref++;
    80002808:	449c                	lw	a5,8(s1)
    8000280a:	2785                	addiw	a5,a5,1
    8000280c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000280e:	00236517          	auipc	a0,0x236
    80002812:	0fa50513          	addi	a0,a0,250 # 80238908 <itable>
    80002816:	1c2030ef          	jal	800059d8 <release>
}
    8000281a:	8526                	mv	a0,s1
    8000281c:	60e2                	ld	ra,24(sp)
    8000281e:	6442                	ld	s0,16(sp)
    80002820:	64a2                	ld	s1,8(sp)
    80002822:	6105                	addi	sp,sp,32
    80002824:	8082                	ret

0000000080002826 <ilock>:
{
    80002826:	1101                	addi	sp,sp,-32
    80002828:	ec06                	sd	ra,24(sp)
    8000282a:	e822                	sd	s0,16(sp)
    8000282c:	e426                	sd	s1,8(sp)
    8000282e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002830:	cd19                	beqz	a0,8000284e <ilock+0x28>
    80002832:	84aa                	mv	s1,a0
    80002834:	451c                	lw	a5,8(a0)
    80002836:	00f05c63          	blez	a5,8000284e <ilock+0x28>
  acquiresleep(&ip->lock);
    8000283a:	0541                	addi	a0,a0,16
    8000283c:	32d000ef          	jal	80003368 <acquiresleep>
  if(ip->valid == 0){
    80002840:	40bc                	lw	a5,64(s1)
    80002842:	cf89                	beqz	a5,8000285c <ilock+0x36>
}
    80002844:	60e2                	ld	ra,24(sp)
    80002846:	6442                	ld	s0,16(sp)
    80002848:	64a2                	ld	s1,8(sp)
    8000284a:	6105                	addi	sp,sp,32
    8000284c:	8082                	ret
    8000284e:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002850:	00005517          	auipc	a0,0x5
    80002854:	c8850513          	addi	a0,a0,-888 # 800074d8 <etext+0x4d8>
    80002858:	5bf020ef          	jal	80005616 <panic>
    8000285c:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000285e:	40dc                	lw	a5,4(s1)
    80002860:	0047d79b          	srliw	a5,a5,0x4
    80002864:	00236597          	auipc	a1,0x236
    80002868:	09c5a583          	lw	a1,156(a1) # 80238900 <sb+0x18>
    8000286c:	9dbd                	addw	a1,a1,a5
    8000286e:	4088                	lw	a0,0(s1)
    80002870:	8a5ff0ef          	jal	80002114 <bread>
    80002874:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002876:	05850593          	addi	a1,a0,88
    8000287a:	40dc                	lw	a5,4(s1)
    8000287c:	8bbd                	andi	a5,a5,15
    8000287e:	079a                	slli	a5,a5,0x6
    80002880:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002882:	00059783          	lh	a5,0(a1)
    80002886:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000288a:	00259783          	lh	a5,2(a1)
    8000288e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002892:	00459783          	lh	a5,4(a1)
    80002896:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000289a:	00659783          	lh	a5,6(a1)
    8000289e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800028a2:	459c                	lw	a5,8(a1)
    800028a4:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800028a6:	03400613          	li	a2,52
    800028aa:	05b1                	addi	a1,a1,12
    800028ac:	05048513          	addi	a0,s1,80
    800028b0:	9f1fd0ef          	jal	800002a0 <memmove>
    brelse(bp);
    800028b4:	854a                	mv	a0,s2
    800028b6:	967ff0ef          	jal	8000221c <brelse>
    ip->valid = 1;
    800028ba:	4785                	li	a5,1
    800028bc:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800028be:	04449783          	lh	a5,68(s1)
    800028c2:	c399                	beqz	a5,800028c8 <ilock+0xa2>
    800028c4:	6902                	ld	s2,0(sp)
    800028c6:	bfbd                	j	80002844 <ilock+0x1e>
      panic("ilock: no type");
    800028c8:	00005517          	auipc	a0,0x5
    800028cc:	c1850513          	addi	a0,a0,-1000 # 800074e0 <etext+0x4e0>
    800028d0:	547020ef          	jal	80005616 <panic>

00000000800028d4 <iunlock>:
{
    800028d4:	1101                	addi	sp,sp,-32
    800028d6:	ec06                	sd	ra,24(sp)
    800028d8:	e822                	sd	s0,16(sp)
    800028da:	e426                	sd	s1,8(sp)
    800028dc:	e04a                	sd	s2,0(sp)
    800028de:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800028e0:	c505                	beqz	a0,80002908 <iunlock+0x34>
    800028e2:	84aa                	mv	s1,a0
    800028e4:	01050913          	addi	s2,a0,16
    800028e8:	854a                	mv	a0,s2
    800028ea:	2fd000ef          	jal	800033e6 <holdingsleep>
    800028ee:	cd09                	beqz	a0,80002908 <iunlock+0x34>
    800028f0:	449c                	lw	a5,8(s1)
    800028f2:	00f05b63          	blez	a5,80002908 <iunlock+0x34>
  releasesleep(&ip->lock);
    800028f6:	854a                	mv	a0,s2
    800028f8:	2b7000ef          	jal	800033ae <releasesleep>
}
    800028fc:	60e2                	ld	ra,24(sp)
    800028fe:	6442                	ld	s0,16(sp)
    80002900:	64a2                	ld	s1,8(sp)
    80002902:	6902                	ld	s2,0(sp)
    80002904:	6105                	addi	sp,sp,32
    80002906:	8082                	ret
    panic("iunlock");
    80002908:	00005517          	auipc	a0,0x5
    8000290c:	be850513          	addi	a0,a0,-1048 # 800074f0 <etext+0x4f0>
    80002910:	507020ef          	jal	80005616 <panic>

0000000080002914 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002914:	7179                	addi	sp,sp,-48
    80002916:	f406                	sd	ra,40(sp)
    80002918:	f022                	sd	s0,32(sp)
    8000291a:	ec26                	sd	s1,24(sp)
    8000291c:	e84a                	sd	s2,16(sp)
    8000291e:	e44e                	sd	s3,8(sp)
    80002920:	1800                	addi	s0,sp,48
    80002922:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002924:	05050493          	addi	s1,a0,80
    80002928:	08050913          	addi	s2,a0,128
    8000292c:	a021                	j	80002934 <itrunc+0x20>
    8000292e:	0491                	addi	s1,s1,4
    80002930:	01248b63          	beq	s1,s2,80002946 <itrunc+0x32>
    if(ip->addrs[i]){
    80002934:	408c                	lw	a1,0(s1)
    80002936:	dde5                	beqz	a1,8000292e <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002938:	0009a503          	lw	a0,0(s3)
    8000293c:	9cdff0ef          	jal	80002308 <bfree>
      ip->addrs[i] = 0;
    80002940:	0004a023          	sw	zero,0(s1)
    80002944:	b7ed                	j	8000292e <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002946:	0809a583          	lw	a1,128(s3)
    8000294a:	ed89                	bnez	a1,80002964 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000294c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002950:	854e                	mv	a0,s3
    80002952:	e21ff0ef          	jal	80002772 <iupdate>
}
    80002956:	70a2                	ld	ra,40(sp)
    80002958:	7402                	ld	s0,32(sp)
    8000295a:	64e2                	ld	s1,24(sp)
    8000295c:	6942                	ld	s2,16(sp)
    8000295e:	69a2                	ld	s3,8(sp)
    80002960:	6145                	addi	sp,sp,48
    80002962:	8082                	ret
    80002964:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002966:	0009a503          	lw	a0,0(s3)
    8000296a:	faaff0ef          	jal	80002114 <bread>
    8000296e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002970:	05850493          	addi	s1,a0,88
    80002974:	45850913          	addi	s2,a0,1112
    80002978:	a021                	j	80002980 <itrunc+0x6c>
    8000297a:	0491                	addi	s1,s1,4
    8000297c:	01248963          	beq	s1,s2,8000298e <itrunc+0x7a>
      if(a[j])
    80002980:	408c                	lw	a1,0(s1)
    80002982:	dde5                	beqz	a1,8000297a <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002984:	0009a503          	lw	a0,0(s3)
    80002988:	981ff0ef          	jal	80002308 <bfree>
    8000298c:	b7fd                	j	8000297a <itrunc+0x66>
    brelse(bp);
    8000298e:	8552                	mv	a0,s4
    80002990:	88dff0ef          	jal	8000221c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002994:	0809a583          	lw	a1,128(s3)
    80002998:	0009a503          	lw	a0,0(s3)
    8000299c:	96dff0ef          	jal	80002308 <bfree>
    ip->addrs[NDIRECT] = 0;
    800029a0:	0809a023          	sw	zero,128(s3)
    800029a4:	6a02                	ld	s4,0(sp)
    800029a6:	b75d                	j	8000294c <itrunc+0x38>

00000000800029a8 <iput>:
{
    800029a8:	1101                	addi	sp,sp,-32
    800029aa:	ec06                	sd	ra,24(sp)
    800029ac:	e822                	sd	s0,16(sp)
    800029ae:	e426                	sd	s1,8(sp)
    800029b0:	1000                	addi	s0,sp,32
    800029b2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800029b4:	00236517          	auipc	a0,0x236
    800029b8:	f5450513          	addi	a0,a0,-172 # 80238908 <itable>
    800029bc:	789020ef          	jal	80005944 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800029c0:	4498                	lw	a4,8(s1)
    800029c2:	4785                	li	a5,1
    800029c4:	02f70063          	beq	a4,a5,800029e4 <iput+0x3c>
  ip->ref--;
    800029c8:	449c                	lw	a5,8(s1)
    800029ca:	37fd                	addiw	a5,a5,-1
    800029cc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800029ce:	00236517          	auipc	a0,0x236
    800029d2:	f3a50513          	addi	a0,a0,-198 # 80238908 <itable>
    800029d6:	002030ef          	jal	800059d8 <release>
}
    800029da:	60e2                	ld	ra,24(sp)
    800029dc:	6442                	ld	s0,16(sp)
    800029de:	64a2                	ld	s1,8(sp)
    800029e0:	6105                	addi	sp,sp,32
    800029e2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800029e4:	40bc                	lw	a5,64(s1)
    800029e6:	d3ed                	beqz	a5,800029c8 <iput+0x20>
    800029e8:	04a49783          	lh	a5,74(s1)
    800029ec:	fff1                	bnez	a5,800029c8 <iput+0x20>
    800029ee:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800029f0:	01048913          	addi	s2,s1,16
    800029f4:	854a                	mv	a0,s2
    800029f6:	173000ef          	jal	80003368 <acquiresleep>
    release(&itable.lock);
    800029fa:	00236517          	auipc	a0,0x236
    800029fe:	f0e50513          	addi	a0,a0,-242 # 80238908 <itable>
    80002a02:	7d7020ef          	jal	800059d8 <release>
    itrunc(ip);
    80002a06:	8526                	mv	a0,s1
    80002a08:	f0dff0ef          	jal	80002914 <itrunc>
    ip->type = 0;
    80002a0c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002a10:	8526                	mv	a0,s1
    80002a12:	d61ff0ef          	jal	80002772 <iupdate>
    ip->valid = 0;
    80002a16:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002a1a:	854a                	mv	a0,s2
    80002a1c:	193000ef          	jal	800033ae <releasesleep>
    acquire(&itable.lock);
    80002a20:	00236517          	auipc	a0,0x236
    80002a24:	ee850513          	addi	a0,a0,-280 # 80238908 <itable>
    80002a28:	71d020ef          	jal	80005944 <acquire>
    80002a2c:	6902                	ld	s2,0(sp)
    80002a2e:	bf69                	j	800029c8 <iput+0x20>

0000000080002a30 <iunlockput>:
{
    80002a30:	1101                	addi	sp,sp,-32
    80002a32:	ec06                	sd	ra,24(sp)
    80002a34:	e822                	sd	s0,16(sp)
    80002a36:	e426                	sd	s1,8(sp)
    80002a38:	1000                	addi	s0,sp,32
    80002a3a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002a3c:	e99ff0ef          	jal	800028d4 <iunlock>
  iput(ip);
    80002a40:	8526                	mv	a0,s1
    80002a42:	f67ff0ef          	jal	800029a8 <iput>
}
    80002a46:	60e2                	ld	ra,24(sp)
    80002a48:	6442                	ld	s0,16(sp)
    80002a4a:	64a2                	ld	s1,8(sp)
    80002a4c:	6105                	addi	sp,sp,32
    80002a4e:	8082                	ret

0000000080002a50 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002a50:	1141                	addi	sp,sp,-16
    80002a52:	e406                	sd	ra,8(sp)
    80002a54:	e022                	sd	s0,0(sp)
    80002a56:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002a58:	411c                	lw	a5,0(a0)
    80002a5a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002a5c:	415c                	lw	a5,4(a0)
    80002a5e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002a60:	04451783          	lh	a5,68(a0)
    80002a64:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002a68:	04a51783          	lh	a5,74(a0)
    80002a6c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002a70:	04c56783          	lwu	a5,76(a0)
    80002a74:	e99c                	sd	a5,16(a1)
}
    80002a76:	60a2                	ld	ra,8(sp)
    80002a78:	6402                	ld	s0,0(sp)
    80002a7a:	0141                	addi	sp,sp,16
    80002a7c:	8082                	ret

0000000080002a7e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a7e:	457c                	lw	a5,76(a0)
    80002a80:	0ed7e663          	bltu	a5,a3,80002b6c <readi+0xee>
{
    80002a84:	7159                	addi	sp,sp,-112
    80002a86:	f486                	sd	ra,104(sp)
    80002a88:	f0a2                	sd	s0,96(sp)
    80002a8a:	eca6                	sd	s1,88(sp)
    80002a8c:	e0d2                	sd	s4,64(sp)
    80002a8e:	fc56                	sd	s5,56(sp)
    80002a90:	f85a                	sd	s6,48(sp)
    80002a92:	f45e                	sd	s7,40(sp)
    80002a94:	1880                	addi	s0,sp,112
    80002a96:	8b2a                	mv	s6,a0
    80002a98:	8bae                	mv	s7,a1
    80002a9a:	8a32                	mv	s4,a2
    80002a9c:	84b6                	mv	s1,a3
    80002a9e:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002aa0:	9f35                	addw	a4,a4,a3
    return 0;
    80002aa2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002aa4:	0ad76b63          	bltu	a4,a3,80002b5a <readi+0xdc>
    80002aa8:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002aaa:	00e7f463          	bgeu	a5,a4,80002ab2 <readi+0x34>
    n = ip->size - off;
    80002aae:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ab2:	080a8b63          	beqz	s5,80002b48 <readi+0xca>
    80002ab6:	e8ca                	sd	s2,80(sp)
    80002ab8:	f062                	sd	s8,32(sp)
    80002aba:	ec66                	sd	s9,24(sp)
    80002abc:	e86a                	sd	s10,16(sp)
    80002abe:	e46e                	sd	s11,8(sp)
    80002ac0:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ac2:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ac6:	5c7d                	li	s8,-1
    80002ac8:	a80d                	j	80002afa <readi+0x7c>
    80002aca:	020d1d93          	slli	s11,s10,0x20
    80002ace:	020ddd93          	srli	s11,s11,0x20
    80002ad2:	05890613          	addi	a2,s2,88
    80002ad6:	86ee                	mv	a3,s11
    80002ad8:	963e                	add	a2,a2,a5
    80002ada:	85d2                	mv	a1,s4
    80002adc:	855e                	mv	a0,s7
    80002ade:	d9dfe0ef          	jal	8000187a <either_copyout>
    80002ae2:	05850363          	beq	a0,s8,80002b28 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ae6:	854a                	mv	a0,s2
    80002ae8:	f34ff0ef          	jal	8000221c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002aec:	013d09bb          	addw	s3,s10,s3
    80002af0:	009d04bb          	addw	s1,s10,s1
    80002af4:	9a6e                	add	s4,s4,s11
    80002af6:	0559f363          	bgeu	s3,s5,80002b3c <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002afa:	00a4d59b          	srliw	a1,s1,0xa
    80002afe:	855a                	mv	a0,s6
    80002b00:	987ff0ef          	jal	80002486 <bmap>
    80002b04:	85aa                	mv	a1,a0
    if(addr == 0)
    80002b06:	c139                	beqz	a0,80002b4c <readi+0xce>
    bp = bread(ip->dev, addr);
    80002b08:	000b2503          	lw	a0,0(s6)
    80002b0c:	e08ff0ef          	jal	80002114 <bread>
    80002b10:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b12:	3ff4f793          	andi	a5,s1,1023
    80002b16:	40fc873b          	subw	a4,s9,a5
    80002b1a:	413a86bb          	subw	a3,s5,s3
    80002b1e:	8d3a                	mv	s10,a4
    80002b20:	fae6f5e3          	bgeu	a3,a4,80002aca <readi+0x4c>
    80002b24:	8d36                	mv	s10,a3
    80002b26:	b755                	j	80002aca <readi+0x4c>
      brelse(bp);
    80002b28:	854a                	mv	a0,s2
    80002b2a:	ef2ff0ef          	jal	8000221c <brelse>
      tot = -1;
    80002b2e:	59fd                	li	s3,-1
      break;
    80002b30:	6946                	ld	s2,80(sp)
    80002b32:	7c02                	ld	s8,32(sp)
    80002b34:	6ce2                	ld	s9,24(sp)
    80002b36:	6d42                	ld	s10,16(sp)
    80002b38:	6da2                	ld	s11,8(sp)
    80002b3a:	a831                	j	80002b56 <readi+0xd8>
    80002b3c:	6946                	ld	s2,80(sp)
    80002b3e:	7c02                	ld	s8,32(sp)
    80002b40:	6ce2                	ld	s9,24(sp)
    80002b42:	6d42                	ld	s10,16(sp)
    80002b44:	6da2                	ld	s11,8(sp)
    80002b46:	a801                	j	80002b56 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b48:	89d6                	mv	s3,s5
    80002b4a:	a031                	j	80002b56 <readi+0xd8>
    80002b4c:	6946                	ld	s2,80(sp)
    80002b4e:	7c02                	ld	s8,32(sp)
    80002b50:	6ce2                	ld	s9,24(sp)
    80002b52:	6d42                	ld	s10,16(sp)
    80002b54:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002b56:	854e                	mv	a0,s3
    80002b58:	69a6                	ld	s3,72(sp)
}
    80002b5a:	70a6                	ld	ra,104(sp)
    80002b5c:	7406                	ld	s0,96(sp)
    80002b5e:	64e6                	ld	s1,88(sp)
    80002b60:	6a06                	ld	s4,64(sp)
    80002b62:	7ae2                	ld	s5,56(sp)
    80002b64:	7b42                	ld	s6,48(sp)
    80002b66:	7ba2                	ld	s7,40(sp)
    80002b68:	6165                	addi	sp,sp,112
    80002b6a:	8082                	ret
    return 0;
    80002b6c:	4501                	li	a0,0
}
    80002b6e:	8082                	ret

0000000080002b70 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002b70:	457c                	lw	a5,76(a0)
    80002b72:	0ed7eb63          	bltu	a5,a3,80002c68 <writei+0xf8>
{
    80002b76:	7159                	addi	sp,sp,-112
    80002b78:	f486                	sd	ra,104(sp)
    80002b7a:	f0a2                	sd	s0,96(sp)
    80002b7c:	e8ca                	sd	s2,80(sp)
    80002b7e:	e0d2                	sd	s4,64(sp)
    80002b80:	fc56                	sd	s5,56(sp)
    80002b82:	f85a                	sd	s6,48(sp)
    80002b84:	f45e                	sd	s7,40(sp)
    80002b86:	1880                	addi	s0,sp,112
    80002b88:	8aaa                	mv	s5,a0
    80002b8a:	8bae                	mv	s7,a1
    80002b8c:	8a32                	mv	s4,a2
    80002b8e:	8936                	mv	s2,a3
    80002b90:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002b92:	00e687bb          	addw	a5,a3,a4
    80002b96:	0cd7eb63          	bltu	a5,a3,80002c6c <writei+0xfc>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002b9a:	00043737          	lui	a4,0x43
    80002b9e:	0cf76963          	bltu	a4,a5,80002c70 <writei+0x100>
    80002ba2:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ba4:	0a0b0a63          	beqz	s6,80002c58 <writei+0xe8>
    80002ba8:	eca6                	sd	s1,88(sp)
    80002baa:	f062                	sd	s8,32(sp)
    80002bac:	ec66                	sd	s9,24(sp)
    80002bae:	e86a                	sd	s10,16(sp)
    80002bb0:	e46e                	sd	s11,8(sp)
    80002bb2:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002bb4:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002bb8:	5c7d                	li	s8,-1
    80002bba:	a825                	j	80002bf2 <writei+0x82>
    80002bbc:	020d1d93          	slli	s11,s10,0x20
    80002bc0:	020ddd93          	srli	s11,s11,0x20
    80002bc4:	05848513          	addi	a0,s1,88
    80002bc8:	86ee                	mv	a3,s11
    80002bca:	8652                	mv	a2,s4
    80002bcc:	85de                	mv	a1,s7
    80002bce:	953e                	add	a0,a0,a5
    80002bd0:	cf5fe0ef          	jal	800018c4 <either_copyin>
    80002bd4:	05850663          	beq	a0,s8,80002c20 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002bd8:	8526                	mv	a0,s1
    80002bda:	688000ef          	jal	80003262 <log_write>
    brelse(bp);
    80002bde:	8526                	mv	a0,s1
    80002be0:	e3cff0ef          	jal	8000221c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002be4:	013d09bb          	addw	s3,s10,s3
    80002be8:	012d093b          	addw	s2,s10,s2
    80002bec:	9a6e                	add	s4,s4,s11
    80002bee:	0369fc63          	bgeu	s3,s6,80002c26 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80002bf2:	00a9559b          	srliw	a1,s2,0xa
    80002bf6:	8556                	mv	a0,s5
    80002bf8:	88fff0ef          	jal	80002486 <bmap>
    80002bfc:	85aa                	mv	a1,a0
    if(addr == 0)
    80002bfe:	c505                	beqz	a0,80002c26 <writei+0xb6>
    bp = bread(ip->dev, addr);
    80002c00:	000aa503          	lw	a0,0(s5)
    80002c04:	d10ff0ef          	jal	80002114 <bread>
    80002c08:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c0a:	3ff97793          	andi	a5,s2,1023
    80002c0e:	40fc873b          	subw	a4,s9,a5
    80002c12:	413b06bb          	subw	a3,s6,s3
    80002c16:	8d3a                	mv	s10,a4
    80002c18:	fae6f2e3          	bgeu	a3,a4,80002bbc <writei+0x4c>
    80002c1c:	8d36                	mv	s10,a3
    80002c1e:	bf79                	j	80002bbc <writei+0x4c>
      brelse(bp);
    80002c20:	8526                	mv	a0,s1
    80002c22:	dfaff0ef          	jal	8000221c <brelse>
  }

  if(off > ip->size)
    80002c26:	04caa783          	lw	a5,76(s5)
    80002c2a:	0327f963          	bgeu	a5,s2,80002c5c <writei+0xec>
    ip->size = off;
    80002c2e:	052aa623          	sw	s2,76(s5)
    80002c32:	64e6                	ld	s1,88(sp)
    80002c34:	7c02                	ld	s8,32(sp)
    80002c36:	6ce2                	ld	s9,24(sp)
    80002c38:	6d42                	ld	s10,16(sp)
    80002c3a:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002c3c:	8556                	mv	a0,s5
    80002c3e:	b35ff0ef          	jal	80002772 <iupdate>

  return tot;
    80002c42:	854e                	mv	a0,s3
    80002c44:	69a6                	ld	s3,72(sp)
}
    80002c46:	70a6                	ld	ra,104(sp)
    80002c48:	7406                	ld	s0,96(sp)
    80002c4a:	6946                	ld	s2,80(sp)
    80002c4c:	6a06                	ld	s4,64(sp)
    80002c4e:	7ae2                	ld	s5,56(sp)
    80002c50:	7b42                	ld	s6,48(sp)
    80002c52:	7ba2                	ld	s7,40(sp)
    80002c54:	6165                	addi	sp,sp,112
    80002c56:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c58:	89da                	mv	s3,s6
    80002c5a:	b7cd                	j	80002c3c <writei+0xcc>
    80002c5c:	64e6                	ld	s1,88(sp)
    80002c5e:	7c02                	ld	s8,32(sp)
    80002c60:	6ce2                	ld	s9,24(sp)
    80002c62:	6d42                	ld	s10,16(sp)
    80002c64:	6da2                	ld	s11,8(sp)
    80002c66:	bfd9                	j	80002c3c <writei+0xcc>
    return -1;
    80002c68:	557d                	li	a0,-1
}
    80002c6a:	8082                	ret
    return -1;
    80002c6c:	557d                	li	a0,-1
    80002c6e:	bfe1                	j	80002c46 <writei+0xd6>
    return -1;
    80002c70:	557d                	li	a0,-1
    80002c72:	bfd1                	j	80002c46 <writei+0xd6>

0000000080002c74 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002c74:	1141                	addi	sp,sp,-16
    80002c76:	e406                	sd	ra,8(sp)
    80002c78:	e022                	sd	s0,0(sp)
    80002c7a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002c7c:	4639                	li	a2,14
    80002c7e:	e96fd0ef          	jal	80000314 <strncmp>
}
    80002c82:	60a2                	ld	ra,8(sp)
    80002c84:	6402                	ld	s0,0(sp)
    80002c86:	0141                	addi	sp,sp,16
    80002c88:	8082                	ret

0000000080002c8a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002c8a:	711d                	addi	sp,sp,-96
    80002c8c:	ec86                	sd	ra,88(sp)
    80002c8e:	e8a2                	sd	s0,80(sp)
    80002c90:	e4a6                	sd	s1,72(sp)
    80002c92:	e0ca                	sd	s2,64(sp)
    80002c94:	fc4e                	sd	s3,56(sp)
    80002c96:	f852                	sd	s4,48(sp)
    80002c98:	f456                	sd	s5,40(sp)
    80002c9a:	f05a                	sd	s6,32(sp)
    80002c9c:	ec5e                	sd	s7,24(sp)
    80002c9e:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002ca0:	04451703          	lh	a4,68(a0)
    80002ca4:	4785                	li	a5,1
    80002ca6:	00f71f63          	bne	a4,a5,80002cc4 <dirlookup+0x3a>
    80002caa:	892a                	mv	s2,a0
    80002cac:	8aae                	mv	s5,a1
    80002cae:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cb0:	457c                	lw	a5,76(a0)
    80002cb2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002cb4:	fa040a13          	addi	s4,s0,-96
    80002cb8:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002cba:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002cbe:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cc0:	e39d                	bnez	a5,80002ce6 <dirlookup+0x5c>
    80002cc2:	a8b9                	j	80002d20 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002cc4:	00005517          	auipc	a0,0x5
    80002cc8:	83450513          	addi	a0,a0,-1996 # 800074f8 <etext+0x4f8>
    80002ccc:	14b020ef          	jal	80005616 <panic>
      panic("dirlookup read");
    80002cd0:	00005517          	auipc	a0,0x5
    80002cd4:	84050513          	addi	a0,a0,-1984 # 80007510 <etext+0x510>
    80002cd8:	13f020ef          	jal	80005616 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cdc:	24c1                	addiw	s1,s1,16
    80002cde:	04c92783          	lw	a5,76(s2)
    80002ce2:	02f4fe63          	bgeu	s1,a5,80002d1e <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002ce6:	874e                	mv	a4,s3
    80002ce8:	86a6                	mv	a3,s1
    80002cea:	8652                	mv	a2,s4
    80002cec:	4581                	li	a1,0
    80002cee:	854a                	mv	a0,s2
    80002cf0:	d8fff0ef          	jal	80002a7e <readi>
    80002cf4:	fd351ee3          	bne	a0,s3,80002cd0 <dirlookup+0x46>
    if(de.inum == 0)
    80002cf8:	fa045783          	lhu	a5,-96(s0)
    80002cfc:	d3e5                	beqz	a5,80002cdc <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80002cfe:	85da                	mv	a1,s6
    80002d00:	8556                	mv	a0,s5
    80002d02:	f73ff0ef          	jal	80002c74 <namecmp>
    80002d06:	f979                	bnez	a0,80002cdc <dirlookup+0x52>
      if(poff)
    80002d08:	000b8463          	beqz	s7,80002d10 <dirlookup+0x86>
        *poff = off;
    80002d0c:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80002d10:	fa045583          	lhu	a1,-96(s0)
    80002d14:	00092503          	lw	a0,0(s2)
    80002d18:	82fff0ef          	jal	80002546 <iget>
    80002d1c:	a011                	j	80002d20 <dirlookup+0x96>
  return 0;
    80002d1e:	4501                	li	a0,0
}
    80002d20:	60e6                	ld	ra,88(sp)
    80002d22:	6446                	ld	s0,80(sp)
    80002d24:	64a6                	ld	s1,72(sp)
    80002d26:	6906                	ld	s2,64(sp)
    80002d28:	79e2                	ld	s3,56(sp)
    80002d2a:	7a42                	ld	s4,48(sp)
    80002d2c:	7aa2                	ld	s5,40(sp)
    80002d2e:	7b02                	ld	s6,32(sp)
    80002d30:	6be2                	ld	s7,24(sp)
    80002d32:	6125                	addi	sp,sp,96
    80002d34:	8082                	ret

0000000080002d36 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002d36:	711d                	addi	sp,sp,-96
    80002d38:	ec86                	sd	ra,88(sp)
    80002d3a:	e8a2                	sd	s0,80(sp)
    80002d3c:	e4a6                	sd	s1,72(sp)
    80002d3e:	e0ca                	sd	s2,64(sp)
    80002d40:	fc4e                	sd	s3,56(sp)
    80002d42:	f852                	sd	s4,48(sp)
    80002d44:	f456                	sd	s5,40(sp)
    80002d46:	f05a                	sd	s6,32(sp)
    80002d48:	ec5e                	sd	s7,24(sp)
    80002d4a:	e862                	sd	s8,16(sp)
    80002d4c:	e466                	sd	s9,8(sp)
    80002d4e:	e06a                	sd	s10,0(sp)
    80002d50:	1080                	addi	s0,sp,96
    80002d52:	84aa                	mv	s1,a0
    80002d54:	8b2e                	mv	s6,a1
    80002d56:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002d58:	00054703          	lbu	a4,0(a0)
    80002d5c:	02f00793          	li	a5,47
    80002d60:	00f70f63          	beq	a4,a5,80002d7e <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002d64:	9f2fe0ef          	jal	80000f56 <myproc>
    80002d68:	15053503          	ld	a0,336(a0)
    80002d6c:	a85ff0ef          	jal	800027f0 <idup>
    80002d70:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002d72:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002d76:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002d78:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002d7a:	4b85                	li	s7,1
    80002d7c:	a879                	j	80002e1a <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002d7e:	4585                	li	a1,1
    80002d80:	852e                	mv	a0,a1
    80002d82:	fc4ff0ef          	jal	80002546 <iget>
    80002d86:	8a2a                	mv	s4,a0
    80002d88:	b7ed                	j	80002d72 <namex+0x3c>
      iunlockput(ip);
    80002d8a:	8552                	mv	a0,s4
    80002d8c:	ca5ff0ef          	jal	80002a30 <iunlockput>
      return 0;
    80002d90:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002d92:	8552                	mv	a0,s4
    80002d94:	60e6                	ld	ra,88(sp)
    80002d96:	6446                	ld	s0,80(sp)
    80002d98:	64a6                	ld	s1,72(sp)
    80002d9a:	6906                	ld	s2,64(sp)
    80002d9c:	79e2                	ld	s3,56(sp)
    80002d9e:	7a42                	ld	s4,48(sp)
    80002da0:	7aa2                	ld	s5,40(sp)
    80002da2:	7b02                	ld	s6,32(sp)
    80002da4:	6be2                	ld	s7,24(sp)
    80002da6:	6c42                	ld	s8,16(sp)
    80002da8:	6ca2                	ld	s9,8(sp)
    80002daa:	6d02                	ld	s10,0(sp)
    80002dac:	6125                	addi	sp,sp,96
    80002dae:	8082                	ret
      iunlock(ip);
    80002db0:	8552                	mv	a0,s4
    80002db2:	b23ff0ef          	jal	800028d4 <iunlock>
      return ip;
    80002db6:	bff1                	j	80002d92 <namex+0x5c>
      iunlockput(ip);
    80002db8:	8552                	mv	a0,s4
    80002dba:	c77ff0ef          	jal	80002a30 <iunlockput>
      return 0;
    80002dbe:	8a4e                	mv	s4,s3
    80002dc0:	bfc9                	j	80002d92 <namex+0x5c>
  len = path - s;
    80002dc2:	40998633          	sub	a2,s3,s1
    80002dc6:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002dca:	09ac5063          	bge	s8,s10,80002e4a <namex+0x114>
    memmove(name, s, DIRSIZ);
    80002dce:	8666                	mv	a2,s9
    80002dd0:	85a6                	mv	a1,s1
    80002dd2:	8556                	mv	a0,s5
    80002dd4:	cccfd0ef          	jal	800002a0 <memmove>
    80002dd8:	84ce                	mv	s1,s3
  while(*path == '/')
    80002dda:	0004c783          	lbu	a5,0(s1)
    80002dde:	01279763          	bne	a5,s2,80002dec <namex+0xb6>
    path++;
    80002de2:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002de4:	0004c783          	lbu	a5,0(s1)
    80002de8:	ff278de3          	beq	a5,s2,80002de2 <namex+0xac>
    ilock(ip);
    80002dec:	8552                	mv	a0,s4
    80002dee:	a39ff0ef          	jal	80002826 <ilock>
    if(ip->type != T_DIR){
    80002df2:	044a1783          	lh	a5,68(s4)
    80002df6:	f9779ae3          	bne	a5,s7,80002d8a <namex+0x54>
    if(nameiparent && *path == '\0'){
    80002dfa:	000b0563          	beqz	s6,80002e04 <namex+0xce>
    80002dfe:	0004c783          	lbu	a5,0(s1)
    80002e02:	d7dd                	beqz	a5,80002db0 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002e04:	4601                	li	a2,0
    80002e06:	85d6                	mv	a1,s5
    80002e08:	8552                	mv	a0,s4
    80002e0a:	e81ff0ef          	jal	80002c8a <dirlookup>
    80002e0e:	89aa                	mv	s3,a0
    80002e10:	d545                	beqz	a0,80002db8 <namex+0x82>
    iunlockput(ip);
    80002e12:	8552                	mv	a0,s4
    80002e14:	c1dff0ef          	jal	80002a30 <iunlockput>
    ip = next;
    80002e18:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002e1a:	0004c783          	lbu	a5,0(s1)
    80002e1e:	01279763          	bne	a5,s2,80002e2c <namex+0xf6>
    path++;
    80002e22:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002e24:	0004c783          	lbu	a5,0(s1)
    80002e28:	ff278de3          	beq	a5,s2,80002e22 <namex+0xec>
  if(*path == 0)
    80002e2c:	cb8d                	beqz	a5,80002e5e <namex+0x128>
  while(*path != '/' && *path != 0)
    80002e2e:	0004c783          	lbu	a5,0(s1)
    80002e32:	89a6                	mv	s3,s1
  len = path - s;
    80002e34:	4d01                	li	s10,0
    80002e36:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002e38:	01278963          	beq	a5,s2,80002e4a <namex+0x114>
    80002e3c:	d3d9                	beqz	a5,80002dc2 <namex+0x8c>
    path++;
    80002e3e:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002e40:	0009c783          	lbu	a5,0(s3)
    80002e44:	ff279ce3          	bne	a5,s2,80002e3c <namex+0x106>
    80002e48:	bfad                	j	80002dc2 <namex+0x8c>
    memmove(name, s, len);
    80002e4a:	2601                	sext.w	a2,a2
    80002e4c:	85a6                	mv	a1,s1
    80002e4e:	8556                	mv	a0,s5
    80002e50:	c50fd0ef          	jal	800002a0 <memmove>
    name[len] = 0;
    80002e54:	9d56                	add	s10,s10,s5
    80002e56:	000d0023          	sb	zero,0(s10)
    80002e5a:	84ce                	mv	s1,s3
    80002e5c:	bfbd                	j	80002dda <namex+0xa4>
  if(nameiparent){
    80002e5e:	f20b0ae3          	beqz	s6,80002d92 <namex+0x5c>
    iput(ip);
    80002e62:	8552                	mv	a0,s4
    80002e64:	b45ff0ef          	jal	800029a8 <iput>
    return 0;
    80002e68:	4a01                	li	s4,0
    80002e6a:	b725                	j	80002d92 <namex+0x5c>

0000000080002e6c <dirlink>:
{
    80002e6c:	715d                	addi	sp,sp,-80
    80002e6e:	e486                	sd	ra,72(sp)
    80002e70:	e0a2                	sd	s0,64(sp)
    80002e72:	f84a                	sd	s2,48(sp)
    80002e74:	ec56                	sd	s5,24(sp)
    80002e76:	e85a                	sd	s6,16(sp)
    80002e78:	0880                	addi	s0,sp,80
    80002e7a:	892a                	mv	s2,a0
    80002e7c:	8aae                	mv	s5,a1
    80002e7e:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002e80:	4601                	li	a2,0
    80002e82:	e09ff0ef          	jal	80002c8a <dirlookup>
    80002e86:	ed1d                	bnez	a0,80002ec4 <dirlink+0x58>
    80002e88:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e8a:	04c92483          	lw	s1,76(s2)
    80002e8e:	c4b9                	beqz	s1,80002edc <dirlink+0x70>
    80002e90:	f44e                	sd	s3,40(sp)
    80002e92:	f052                	sd	s4,32(sp)
    80002e94:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e96:	fb040a13          	addi	s4,s0,-80
    80002e9a:	49c1                	li	s3,16
    80002e9c:	874e                	mv	a4,s3
    80002e9e:	86a6                	mv	a3,s1
    80002ea0:	8652                	mv	a2,s4
    80002ea2:	4581                	li	a1,0
    80002ea4:	854a                	mv	a0,s2
    80002ea6:	bd9ff0ef          	jal	80002a7e <readi>
    80002eaa:	03351163          	bne	a0,s3,80002ecc <dirlink+0x60>
    if(de.inum == 0)
    80002eae:	fb045783          	lhu	a5,-80(s0)
    80002eb2:	c39d                	beqz	a5,80002ed8 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002eb4:	24c1                	addiw	s1,s1,16
    80002eb6:	04c92783          	lw	a5,76(s2)
    80002eba:	fef4e1e3          	bltu	s1,a5,80002e9c <dirlink+0x30>
    80002ebe:	79a2                	ld	s3,40(sp)
    80002ec0:	7a02                	ld	s4,32(sp)
    80002ec2:	a829                	j	80002edc <dirlink+0x70>
    iput(ip);
    80002ec4:	ae5ff0ef          	jal	800029a8 <iput>
    return -1;
    80002ec8:	557d                	li	a0,-1
    80002eca:	a83d                	j	80002f08 <dirlink+0x9c>
      panic("dirlink read");
    80002ecc:	00004517          	auipc	a0,0x4
    80002ed0:	65450513          	addi	a0,a0,1620 # 80007520 <etext+0x520>
    80002ed4:	742020ef          	jal	80005616 <panic>
    80002ed8:	79a2                	ld	s3,40(sp)
    80002eda:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80002edc:	4639                	li	a2,14
    80002ede:	85d6                	mv	a1,s5
    80002ee0:	fb240513          	addi	a0,s0,-78
    80002ee4:	c6afd0ef          	jal	8000034e <strncpy>
  de.inum = inum;
    80002ee8:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002eec:	4741                	li	a4,16
    80002eee:	86a6                	mv	a3,s1
    80002ef0:	fb040613          	addi	a2,s0,-80
    80002ef4:	4581                	li	a1,0
    80002ef6:	854a                	mv	a0,s2
    80002ef8:	c79ff0ef          	jal	80002b70 <writei>
    80002efc:	1541                	addi	a0,a0,-16
    80002efe:	00a03533          	snez	a0,a0
    80002f02:	40a0053b          	negw	a0,a0
    80002f06:	74e2                	ld	s1,56(sp)
}
    80002f08:	60a6                	ld	ra,72(sp)
    80002f0a:	6406                	ld	s0,64(sp)
    80002f0c:	7942                	ld	s2,48(sp)
    80002f0e:	6ae2                	ld	s5,24(sp)
    80002f10:	6b42                	ld	s6,16(sp)
    80002f12:	6161                	addi	sp,sp,80
    80002f14:	8082                	ret

0000000080002f16 <namei>:

struct inode*
namei(char *path)
{
    80002f16:	1101                	addi	sp,sp,-32
    80002f18:	ec06                	sd	ra,24(sp)
    80002f1a:	e822                	sd	s0,16(sp)
    80002f1c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002f1e:	fe040613          	addi	a2,s0,-32
    80002f22:	4581                	li	a1,0
    80002f24:	e13ff0ef          	jal	80002d36 <namex>
}
    80002f28:	60e2                	ld	ra,24(sp)
    80002f2a:	6442                	ld	s0,16(sp)
    80002f2c:	6105                	addi	sp,sp,32
    80002f2e:	8082                	ret

0000000080002f30 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002f30:	1141                	addi	sp,sp,-16
    80002f32:	e406                	sd	ra,8(sp)
    80002f34:	e022                	sd	s0,0(sp)
    80002f36:	0800                	addi	s0,sp,16
    80002f38:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002f3a:	4585                	li	a1,1
    80002f3c:	dfbff0ef          	jal	80002d36 <namex>
}
    80002f40:	60a2                	ld	ra,8(sp)
    80002f42:	6402                	ld	s0,0(sp)
    80002f44:	0141                	addi	sp,sp,16
    80002f46:	8082                	ret

0000000080002f48 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002f48:	1101                	addi	sp,sp,-32
    80002f4a:	ec06                	sd	ra,24(sp)
    80002f4c:	e822                	sd	s0,16(sp)
    80002f4e:	e426                	sd	s1,8(sp)
    80002f50:	e04a                	sd	s2,0(sp)
    80002f52:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002f54:	00237917          	auipc	s2,0x237
    80002f58:	45c90913          	addi	s2,s2,1116 # 8023a3b0 <log>
    80002f5c:	01892583          	lw	a1,24(s2)
    80002f60:	02892503          	lw	a0,40(s2)
    80002f64:	9b0ff0ef          	jal	80002114 <bread>
    80002f68:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002f6a:	02c92603          	lw	a2,44(s2)
    80002f6e:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002f70:	00c05f63          	blez	a2,80002f8e <write_head+0x46>
    80002f74:	00237717          	auipc	a4,0x237
    80002f78:	46c70713          	addi	a4,a4,1132 # 8023a3e0 <log+0x30>
    80002f7c:	87aa                	mv	a5,a0
    80002f7e:	060a                	slli	a2,a2,0x2
    80002f80:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002f82:	4314                	lw	a3,0(a4)
    80002f84:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002f86:	0711                	addi	a4,a4,4
    80002f88:	0791                	addi	a5,a5,4
    80002f8a:	fec79ce3          	bne	a5,a2,80002f82 <write_head+0x3a>
  }
  bwrite(buf);
    80002f8e:	8526                	mv	a0,s1
    80002f90:	a5aff0ef          	jal	800021ea <bwrite>
  brelse(buf);
    80002f94:	8526                	mv	a0,s1
    80002f96:	a86ff0ef          	jal	8000221c <brelse>
}
    80002f9a:	60e2                	ld	ra,24(sp)
    80002f9c:	6442                	ld	s0,16(sp)
    80002f9e:	64a2                	ld	s1,8(sp)
    80002fa0:	6902                	ld	s2,0(sp)
    80002fa2:	6105                	addi	sp,sp,32
    80002fa4:	8082                	ret

0000000080002fa6 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fa6:	00237797          	auipc	a5,0x237
    80002faa:	4367a783          	lw	a5,1078(a5) # 8023a3dc <log+0x2c>
    80002fae:	0af05263          	blez	a5,80003052 <install_trans+0xac>
{
    80002fb2:	715d                	addi	sp,sp,-80
    80002fb4:	e486                	sd	ra,72(sp)
    80002fb6:	e0a2                	sd	s0,64(sp)
    80002fb8:	fc26                	sd	s1,56(sp)
    80002fba:	f84a                	sd	s2,48(sp)
    80002fbc:	f44e                	sd	s3,40(sp)
    80002fbe:	f052                	sd	s4,32(sp)
    80002fc0:	ec56                	sd	s5,24(sp)
    80002fc2:	e85a                	sd	s6,16(sp)
    80002fc4:	e45e                	sd	s7,8(sp)
    80002fc6:	0880                	addi	s0,sp,80
    80002fc8:	8b2a                	mv	s6,a0
    80002fca:	00237a97          	auipc	s5,0x237
    80002fce:	416a8a93          	addi	s5,s5,1046 # 8023a3e0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fd2:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002fd4:	00237997          	auipc	s3,0x237
    80002fd8:	3dc98993          	addi	s3,s3,988 # 8023a3b0 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002fdc:	40000b93          	li	s7,1024
    80002fe0:	a829                	j	80002ffa <install_trans+0x54>
    brelse(lbuf);
    80002fe2:	854a                	mv	a0,s2
    80002fe4:	a38ff0ef          	jal	8000221c <brelse>
    brelse(dbuf);
    80002fe8:	8526                	mv	a0,s1
    80002fea:	a32ff0ef          	jal	8000221c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fee:	2a05                	addiw	s4,s4,1
    80002ff0:	0a91                	addi	s5,s5,4
    80002ff2:	02c9a783          	lw	a5,44(s3)
    80002ff6:	04fa5363          	bge	s4,a5,8000303c <install_trans+0x96>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002ffa:	0189a583          	lw	a1,24(s3)
    80002ffe:	014585bb          	addw	a1,a1,s4
    80003002:	2585                	addiw	a1,a1,1
    80003004:	0289a503          	lw	a0,40(s3)
    80003008:	90cff0ef          	jal	80002114 <bread>
    8000300c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000300e:	000aa583          	lw	a1,0(s5)
    80003012:	0289a503          	lw	a0,40(s3)
    80003016:	8feff0ef          	jal	80002114 <bread>
    8000301a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000301c:	865e                	mv	a2,s7
    8000301e:	05890593          	addi	a1,s2,88
    80003022:	05850513          	addi	a0,a0,88
    80003026:	a7afd0ef          	jal	800002a0 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000302a:	8526                	mv	a0,s1
    8000302c:	9beff0ef          	jal	800021ea <bwrite>
    if(recovering == 0)
    80003030:	fa0b19e3          	bnez	s6,80002fe2 <install_trans+0x3c>
      bunpin(dbuf);
    80003034:	8526                	mv	a0,s1
    80003036:	a9eff0ef          	jal	800022d4 <bunpin>
    8000303a:	b765                	j	80002fe2 <install_trans+0x3c>
}
    8000303c:	60a6                	ld	ra,72(sp)
    8000303e:	6406                	ld	s0,64(sp)
    80003040:	74e2                	ld	s1,56(sp)
    80003042:	7942                	ld	s2,48(sp)
    80003044:	79a2                	ld	s3,40(sp)
    80003046:	7a02                	ld	s4,32(sp)
    80003048:	6ae2                	ld	s5,24(sp)
    8000304a:	6b42                	ld	s6,16(sp)
    8000304c:	6ba2                	ld	s7,8(sp)
    8000304e:	6161                	addi	sp,sp,80
    80003050:	8082                	ret
    80003052:	8082                	ret

0000000080003054 <initlog>:
{
    80003054:	7179                	addi	sp,sp,-48
    80003056:	f406                	sd	ra,40(sp)
    80003058:	f022                	sd	s0,32(sp)
    8000305a:	ec26                	sd	s1,24(sp)
    8000305c:	e84a                	sd	s2,16(sp)
    8000305e:	e44e                	sd	s3,8(sp)
    80003060:	1800                	addi	s0,sp,48
    80003062:	892a                	mv	s2,a0
    80003064:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003066:	00237497          	auipc	s1,0x237
    8000306a:	34a48493          	addi	s1,s1,842 # 8023a3b0 <log>
    8000306e:	00004597          	auipc	a1,0x4
    80003072:	4c258593          	addi	a1,a1,1218 # 80007530 <etext+0x530>
    80003076:	8526                	mv	a0,s1
    80003078:	049020ef          	jal	800058c0 <initlock>
  log.start = sb->logstart;
    8000307c:	0149a583          	lw	a1,20(s3)
    80003080:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003082:	0109a783          	lw	a5,16(s3)
    80003086:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003088:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000308c:	854a                	mv	a0,s2
    8000308e:	886ff0ef          	jal	80002114 <bread>
  log.lh.n = lh->n;
    80003092:	4d30                	lw	a2,88(a0)
    80003094:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003096:	00c05f63          	blez	a2,800030b4 <initlog+0x60>
    8000309a:	87aa                	mv	a5,a0
    8000309c:	00237717          	auipc	a4,0x237
    800030a0:	34470713          	addi	a4,a4,836 # 8023a3e0 <log+0x30>
    800030a4:	060a                	slli	a2,a2,0x2
    800030a6:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800030a8:	4ff4                	lw	a3,92(a5)
    800030aa:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800030ac:	0791                	addi	a5,a5,4
    800030ae:	0711                	addi	a4,a4,4
    800030b0:	fec79ce3          	bne	a5,a2,800030a8 <initlog+0x54>
  brelse(buf);
    800030b4:	968ff0ef          	jal	8000221c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800030b8:	4505                	li	a0,1
    800030ba:	eedff0ef          	jal	80002fa6 <install_trans>
  log.lh.n = 0;
    800030be:	00237797          	auipc	a5,0x237
    800030c2:	3007af23          	sw	zero,798(a5) # 8023a3dc <log+0x2c>
  write_head(); // clear the log
    800030c6:	e83ff0ef          	jal	80002f48 <write_head>
}
    800030ca:	70a2                	ld	ra,40(sp)
    800030cc:	7402                	ld	s0,32(sp)
    800030ce:	64e2                	ld	s1,24(sp)
    800030d0:	6942                	ld	s2,16(sp)
    800030d2:	69a2                	ld	s3,8(sp)
    800030d4:	6145                	addi	sp,sp,48
    800030d6:	8082                	ret

00000000800030d8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800030d8:	1101                	addi	sp,sp,-32
    800030da:	ec06                	sd	ra,24(sp)
    800030dc:	e822                	sd	s0,16(sp)
    800030de:	e426                	sd	s1,8(sp)
    800030e0:	e04a                	sd	s2,0(sp)
    800030e2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800030e4:	00237517          	auipc	a0,0x237
    800030e8:	2cc50513          	addi	a0,a0,716 # 8023a3b0 <log>
    800030ec:	059020ef          	jal	80005944 <acquire>
  while(1){
    if(log.committing){
    800030f0:	00237497          	auipc	s1,0x237
    800030f4:	2c048493          	addi	s1,s1,704 # 8023a3b0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800030f8:	4979                	li	s2,30
    800030fa:	a029                	j	80003104 <begin_op+0x2c>
      sleep(&log, &log.lock);
    800030fc:	85a6                	mv	a1,s1
    800030fe:	8526                	mv	a0,s1
    80003100:	c24fe0ef          	jal	80001524 <sleep>
    if(log.committing){
    80003104:	50dc                	lw	a5,36(s1)
    80003106:	fbfd                	bnez	a5,800030fc <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003108:	5098                	lw	a4,32(s1)
    8000310a:	2705                	addiw	a4,a4,1
    8000310c:	0027179b          	slliw	a5,a4,0x2
    80003110:	9fb9                	addw	a5,a5,a4
    80003112:	0017979b          	slliw	a5,a5,0x1
    80003116:	54d4                	lw	a3,44(s1)
    80003118:	9fb5                	addw	a5,a5,a3
    8000311a:	00f95763          	bge	s2,a5,80003128 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000311e:	85a6                	mv	a1,s1
    80003120:	8526                	mv	a0,s1
    80003122:	c02fe0ef          	jal	80001524 <sleep>
    80003126:	bff9                	j	80003104 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003128:	00237517          	auipc	a0,0x237
    8000312c:	28850513          	addi	a0,a0,648 # 8023a3b0 <log>
    80003130:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003132:	0a7020ef          	jal	800059d8 <release>
      break;
    }
  }
}
    80003136:	60e2                	ld	ra,24(sp)
    80003138:	6442                	ld	s0,16(sp)
    8000313a:	64a2                	ld	s1,8(sp)
    8000313c:	6902                	ld	s2,0(sp)
    8000313e:	6105                	addi	sp,sp,32
    80003140:	8082                	ret

0000000080003142 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003142:	7139                	addi	sp,sp,-64
    80003144:	fc06                	sd	ra,56(sp)
    80003146:	f822                	sd	s0,48(sp)
    80003148:	f426                	sd	s1,40(sp)
    8000314a:	f04a                	sd	s2,32(sp)
    8000314c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000314e:	00237497          	auipc	s1,0x237
    80003152:	26248493          	addi	s1,s1,610 # 8023a3b0 <log>
    80003156:	8526                	mv	a0,s1
    80003158:	7ec020ef          	jal	80005944 <acquire>
  log.outstanding -= 1;
    8000315c:	509c                	lw	a5,32(s1)
    8000315e:	37fd                	addiw	a5,a5,-1
    80003160:	893e                	mv	s2,a5
    80003162:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003164:	50dc                	lw	a5,36(s1)
    80003166:	ef9d                	bnez	a5,800031a4 <end_op+0x62>
    panic("log.committing");
  if(log.outstanding == 0){
    80003168:	04091863          	bnez	s2,800031b8 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    8000316c:	00237497          	auipc	s1,0x237
    80003170:	24448493          	addi	s1,s1,580 # 8023a3b0 <log>
    80003174:	4785                	li	a5,1
    80003176:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003178:	8526                	mv	a0,s1
    8000317a:	05f020ef          	jal	800059d8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000317e:	54dc                	lw	a5,44(s1)
    80003180:	04f04c63          	bgtz	a5,800031d8 <end_op+0x96>
    acquire(&log.lock);
    80003184:	00237497          	auipc	s1,0x237
    80003188:	22c48493          	addi	s1,s1,556 # 8023a3b0 <log>
    8000318c:	8526                	mv	a0,s1
    8000318e:	7b6020ef          	jal	80005944 <acquire>
    log.committing = 0;
    80003192:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003196:	8526                	mv	a0,s1
    80003198:	bd8fe0ef          	jal	80001570 <wakeup>
    release(&log.lock);
    8000319c:	8526                	mv	a0,s1
    8000319e:	03b020ef          	jal	800059d8 <release>
}
    800031a2:	a02d                	j	800031cc <end_op+0x8a>
    800031a4:	ec4e                	sd	s3,24(sp)
    800031a6:	e852                	sd	s4,16(sp)
    800031a8:	e456                	sd	s5,8(sp)
    800031aa:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    800031ac:	00004517          	auipc	a0,0x4
    800031b0:	38c50513          	addi	a0,a0,908 # 80007538 <etext+0x538>
    800031b4:	462020ef          	jal	80005616 <panic>
    wakeup(&log);
    800031b8:	00237497          	auipc	s1,0x237
    800031bc:	1f848493          	addi	s1,s1,504 # 8023a3b0 <log>
    800031c0:	8526                	mv	a0,s1
    800031c2:	baefe0ef          	jal	80001570 <wakeup>
  release(&log.lock);
    800031c6:	8526                	mv	a0,s1
    800031c8:	011020ef          	jal	800059d8 <release>
}
    800031cc:	70e2                	ld	ra,56(sp)
    800031ce:	7442                	ld	s0,48(sp)
    800031d0:	74a2                	ld	s1,40(sp)
    800031d2:	7902                	ld	s2,32(sp)
    800031d4:	6121                	addi	sp,sp,64
    800031d6:	8082                	ret
    800031d8:	ec4e                	sd	s3,24(sp)
    800031da:	e852                	sd	s4,16(sp)
    800031dc:	e456                	sd	s5,8(sp)
    800031de:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800031e0:	00237a97          	auipc	s5,0x237
    800031e4:	200a8a93          	addi	s5,s5,512 # 8023a3e0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800031e8:	00237a17          	auipc	s4,0x237
    800031ec:	1c8a0a13          	addi	s4,s4,456 # 8023a3b0 <log>
    memmove(to->data, from->data, BSIZE);
    800031f0:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800031f4:	018a2583          	lw	a1,24(s4)
    800031f8:	012585bb          	addw	a1,a1,s2
    800031fc:	2585                	addiw	a1,a1,1
    800031fe:	028a2503          	lw	a0,40(s4)
    80003202:	f13fe0ef          	jal	80002114 <bread>
    80003206:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003208:	000aa583          	lw	a1,0(s5)
    8000320c:	028a2503          	lw	a0,40(s4)
    80003210:	f05fe0ef          	jal	80002114 <bread>
    80003214:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003216:	865a                	mv	a2,s6
    80003218:	05850593          	addi	a1,a0,88
    8000321c:	05848513          	addi	a0,s1,88
    80003220:	880fd0ef          	jal	800002a0 <memmove>
    bwrite(to);  // write the log
    80003224:	8526                	mv	a0,s1
    80003226:	fc5fe0ef          	jal	800021ea <bwrite>
    brelse(from);
    8000322a:	854e                	mv	a0,s3
    8000322c:	ff1fe0ef          	jal	8000221c <brelse>
    brelse(to);
    80003230:	8526                	mv	a0,s1
    80003232:	febfe0ef          	jal	8000221c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003236:	2905                	addiw	s2,s2,1
    80003238:	0a91                	addi	s5,s5,4
    8000323a:	02ca2783          	lw	a5,44(s4)
    8000323e:	faf94be3          	blt	s2,a5,800031f4 <end_op+0xb2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003242:	d07ff0ef          	jal	80002f48 <write_head>
    install_trans(0); // Now install writes to home locations
    80003246:	4501                	li	a0,0
    80003248:	d5fff0ef          	jal	80002fa6 <install_trans>
    log.lh.n = 0;
    8000324c:	00237797          	auipc	a5,0x237
    80003250:	1807a823          	sw	zero,400(a5) # 8023a3dc <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003254:	cf5ff0ef          	jal	80002f48 <write_head>
    80003258:	69e2                	ld	s3,24(sp)
    8000325a:	6a42                	ld	s4,16(sp)
    8000325c:	6aa2                	ld	s5,8(sp)
    8000325e:	6b02                	ld	s6,0(sp)
    80003260:	b715                	j	80003184 <end_op+0x42>

0000000080003262 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003262:	1101                	addi	sp,sp,-32
    80003264:	ec06                	sd	ra,24(sp)
    80003266:	e822                	sd	s0,16(sp)
    80003268:	e426                	sd	s1,8(sp)
    8000326a:	e04a                	sd	s2,0(sp)
    8000326c:	1000                	addi	s0,sp,32
    8000326e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003270:	00237917          	auipc	s2,0x237
    80003274:	14090913          	addi	s2,s2,320 # 8023a3b0 <log>
    80003278:	854a                	mv	a0,s2
    8000327a:	6ca020ef          	jal	80005944 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000327e:	02c92603          	lw	a2,44(s2)
    80003282:	47f5                	li	a5,29
    80003284:	06c7c363          	blt	a5,a2,800032ea <log_write+0x88>
    80003288:	00237797          	auipc	a5,0x237
    8000328c:	1447a783          	lw	a5,324(a5) # 8023a3cc <log+0x1c>
    80003290:	37fd                	addiw	a5,a5,-1
    80003292:	04f65c63          	bge	a2,a5,800032ea <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003296:	00237797          	auipc	a5,0x237
    8000329a:	13a7a783          	lw	a5,314(a5) # 8023a3d0 <log+0x20>
    8000329e:	04f05c63          	blez	a5,800032f6 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800032a2:	4781                	li	a5,0
    800032a4:	04c05f63          	blez	a2,80003302 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800032a8:	44cc                	lw	a1,12(s1)
    800032aa:	00237717          	auipc	a4,0x237
    800032ae:	13670713          	addi	a4,a4,310 # 8023a3e0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800032b2:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800032b4:	4314                	lw	a3,0(a4)
    800032b6:	04b68663          	beq	a3,a1,80003302 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    800032ba:	2785                	addiw	a5,a5,1
    800032bc:	0711                	addi	a4,a4,4
    800032be:	fef61be3          	bne	a2,a5,800032b4 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800032c2:	0621                	addi	a2,a2,8
    800032c4:	060a                	slli	a2,a2,0x2
    800032c6:	00237797          	auipc	a5,0x237
    800032ca:	0ea78793          	addi	a5,a5,234 # 8023a3b0 <log>
    800032ce:	97b2                	add	a5,a5,a2
    800032d0:	44d8                	lw	a4,12(s1)
    800032d2:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800032d4:	8526                	mv	a0,s1
    800032d6:	fcbfe0ef          	jal	800022a0 <bpin>
    log.lh.n++;
    800032da:	00237717          	auipc	a4,0x237
    800032de:	0d670713          	addi	a4,a4,214 # 8023a3b0 <log>
    800032e2:	575c                	lw	a5,44(a4)
    800032e4:	2785                	addiw	a5,a5,1
    800032e6:	d75c                	sw	a5,44(a4)
    800032e8:	a80d                	j	8000331a <log_write+0xb8>
    panic("too big a transaction");
    800032ea:	00004517          	auipc	a0,0x4
    800032ee:	25e50513          	addi	a0,a0,606 # 80007548 <etext+0x548>
    800032f2:	324020ef          	jal	80005616 <panic>
    panic("log_write outside of trans");
    800032f6:	00004517          	auipc	a0,0x4
    800032fa:	26a50513          	addi	a0,a0,618 # 80007560 <etext+0x560>
    800032fe:	318020ef          	jal	80005616 <panic>
  log.lh.block[i] = b->blockno;
    80003302:	00878693          	addi	a3,a5,8
    80003306:	068a                	slli	a3,a3,0x2
    80003308:	00237717          	auipc	a4,0x237
    8000330c:	0a870713          	addi	a4,a4,168 # 8023a3b0 <log>
    80003310:	9736                	add	a4,a4,a3
    80003312:	44d4                	lw	a3,12(s1)
    80003314:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003316:	faf60fe3          	beq	a2,a5,800032d4 <log_write+0x72>
  }
  release(&log.lock);
    8000331a:	00237517          	auipc	a0,0x237
    8000331e:	09650513          	addi	a0,a0,150 # 8023a3b0 <log>
    80003322:	6b6020ef          	jal	800059d8 <release>
}
    80003326:	60e2                	ld	ra,24(sp)
    80003328:	6442                	ld	s0,16(sp)
    8000332a:	64a2                	ld	s1,8(sp)
    8000332c:	6902                	ld	s2,0(sp)
    8000332e:	6105                	addi	sp,sp,32
    80003330:	8082                	ret

0000000080003332 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003332:	1101                	addi	sp,sp,-32
    80003334:	ec06                	sd	ra,24(sp)
    80003336:	e822                	sd	s0,16(sp)
    80003338:	e426                	sd	s1,8(sp)
    8000333a:	e04a                	sd	s2,0(sp)
    8000333c:	1000                	addi	s0,sp,32
    8000333e:	84aa                	mv	s1,a0
    80003340:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003342:	00004597          	auipc	a1,0x4
    80003346:	23e58593          	addi	a1,a1,574 # 80007580 <etext+0x580>
    8000334a:	0521                	addi	a0,a0,8
    8000334c:	574020ef          	jal	800058c0 <initlock>
  lk->name = name;
    80003350:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003354:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003358:	0204a423          	sw	zero,40(s1)
}
    8000335c:	60e2                	ld	ra,24(sp)
    8000335e:	6442                	ld	s0,16(sp)
    80003360:	64a2                	ld	s1,8(sp)
    80003362:	6902                	ld	s2,0(sp)
    80003364:	6105                	addi	sp,sp,32
    80003366:	8082                	ret

0000000080003368 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003368:	1101                	addi	sp,sp,-32
    8000336a:	ec06                	sd	ra,24(sp)
    8000336c:	e822                	sd	s0,16(sp)
    8000336e:	e426                	sd	s1,8(sp)
    80003370:	e04a                	sd	s2,0(sp)
    80003372:	1000                	addi	s0,sp,32
    80003374:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003376:	00850913          	addi	s2,a0,8
    8000337a:	854a                	mv	a0,s2
    8000337c:	5c8020ef          	jal	80005944 <acquire>
  while (lk->locked) {
    80003380:	409c                	lw	a5,0(s1)
    80003382:	c799                	beqz	a5,80003390 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003384:	85ca                	mv	a1,s2
    80003386:	8526                	mv	a0,s1
    80003388:	99cfe0ef          	jal	80001524 <sleep>
  while (lk->locked) {
    8000338c:	409c                	lw	a5,0(s1)
    8000338e:	fbfd                	bnez	a5,80003384 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003390:	4785                	li	a5,1
    80003392:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003394:	bc3fd0ef          	jal	80000f56 <myproc>
    80003398:	591c                	lw	a5,48(a0)
    8000339a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000339c:	854a                	mv	a0,s2
    8000339e:	63a020ef          	jal	800059d8 <release>
}
    800033a2:	60e2                	ld	ra,24(sp)
    800033a4:	6442                	ld	s0,16(sp)
    800033a6:	64a2                	ld	s1,8(sp)
    800033a8:	6902                	ld	s2,0(sp)
    800033aa:	6105                	addi	sp,sp,32
    800033ac:	8082                	ret

00000000800033ae <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800033ae:	1101                	addi	sp,sp,-32
    800033b0:	ec06                	sd	ra,24(sp)
    800033b2:	e822                	sd	s0,16(sp)
    800033b4:	e426                	sd	s1,8(sp)
    800033b6:	e04a                	sd	s2,0(sp)
    800033b8:	1000                	addi	s0,sp,32
    800033ba:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800033bc:	00850913          	addi	s2,a0,8
    800033c0:	854a                	mv	a0,s2
    800033c2:	582020ef          	jal	80005944 <acquire>
  lk->locked = 0;
    800033c6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800033ca:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800033ce:	8526                	mv	a0,s1
    800033d0:	9a0fe0ef          	jal	80001570 <wakeup>
  release(&lk->lk);
    800033d4:	854a                	mv	a0,s2
    800033d6:	602020ef          	jal	800059d8 <release>
}
    800033da:	60e2                	ld	ra,24(sp)
    800033dc:	6442                	ld	s0,16(sp)
    800033de:	64a2                	ld	s1,8(sp)
    800033e0:	6902                	ld	s2,0(sp)
    800033e2:	6105                	addi	sp,sp,32
    800033e4:	8082                	ret

00000000800033e6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800033e6:	7179                	addi	sp,sp,-48
    800033e8:	f406                	sd	ra,40(sp)
    800033ea:	f022                	sd	s0,32(sp)
    800033ec:	ec26                	sd	s1,24(sp)
    800033ee:	e84a                	sd	s2,16(sp)
    800033f0:	1800                	addi	s0,sp,48
    800033f2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800033f4:	00850913          	addi	s2,a0,8
    800033f8:	854a                	mv	a0,s2
    800033fa:	54a020ef          	jal	80005944 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800033fe:	409c                	lw	a5,0(s1)
    80003400:	ef81                	bnez	a5,80003418 <holdingsleep+0x32>
    80003402:	4481                	li	s1,0
  release(&lk->lk);
    80003404:	854a                	mv	a0,s2
    80003406:	5d2020ef          	jal	800059d8 <release>
  return r;
}
    8000340a:	8526                	mv	a0,s1
    8000340c:	70a2                	ld	ra,40(sp)
    8000340e:	7402                	ld	s0,32(sp)
    80003410:	64e2                	ld	s1,24(sp)
    80003412:	6942                	ld	s2,16(sp)
    80003414:	6145                	addi	sp,sp,48
    80003416:	8082                	ret
    80003418:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000341a:	0284a983          	lw	s3,40(s1)
    8000341e:	b39fd0ef          	jal	80000f56 <myproc>
    80003422:	5904                	lw	s1,48(a0)
    80003424:	413484b3          	sub	s1,s1,s3
    80003428:	0014b493          	seqz	s1,s1
    8000342c:	69a2                	ld	s3,8(sp)
    8000342e:	bfd9                	j	80003404 <holdingsleep+0x1e>

0000000080003430 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003430:	1141                	addi	sp,sp,-16
    80003432:	e406                	sd	ra,8(sp)
    80003434:	e022                	sd	s0,0(sp)
    80003436:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003438:	00004597          	auipc	a1,0x4
    8000343c:	15858593          	addi	a1,a1,344 # 80007590 <etext+0x590>
    80003440:	00237517          	auipc	a0,0x237
    80003444:	0b850513          	addi	a0,a0,184 # 8023a4f8 <ftable>
    80003448:	478020ef          	jal	800058c0 <initlock>
}
    8000344c:	60a2                	ld	ra,8(sp)
    8000344e:	6402                	ld	s0,0(sp)
    80003450:	0141                	addi	sp,sp,16
    80003452:	8082                	ret

0000000080003454 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003454:	1101                	addi	sp,sp,-32
    80003456:	ec06                	sd	ra,24(sp)
    80003458:	e822                	sd	s0,16(sp)
    8000345a:	e426                	sd	s1,8(sp)
    8000345c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000345e:	00237517          	auipc	a0,0x237
    80003462:	09a50513          	addi	a0,a0,154 # 8023a4f8 <ftable>
    80003466:	4de020ef          	jal	80005944 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000346a:	00237497          	auipc	s1,0x237
    8000346e:	0a648493          	addi	s1,s1,166 # 8023a510 <ftable+0x18>
    80003472:	00238717          	auipc	a4,0x238
    80003476:	03e70713          	addi	a4,a4,62 # 8023b4b0 <disk>
    if(f->ref == 0){
    8000347a:	40dc                	lw	a5,4(s1)
    8000347c:	cf89                	beqz	a5,80003496 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000347e:	02848493          	addi	s1,s1,40
    80003482:	fee49ce3          	bne	s1,a4,8000347a <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003486:	00237517          	auipc	a0,0x237
    8000348a:	07250513          	addi	a0,a0,114 # 8023a4f8 <ftable>
    8000348e:	54a020ef          	jal	800059d8 <release>
  return 0;
    80003492:	4481                	li	s1,0
    80003494:	a809                	j	800034a6 <filealloc+0x52>
      f->ref = 1;
    80003496:	4785                	li	a5,1
    80003498:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000349a:	00237517          	auipc	a0,0x237
    8000349e:	05e50513          	addi	a0,a0,94 # 8023a4f8 <ftable>
    800034a2:	536020ef          	jal	800059d8 <release>
}
    800034a6:	8526                	mv	a0,s1
    800034a8:	60e2                	ld	ra,24(sp)
    800034aa:	6442                	ld	s0,16(sp)
    800034ac:	64a2                	ld	s1,8(sp)
    800034ae:	6105                	addi	sp,sp,32
    800034b0:	8082                	ret

00000000800034b2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800034b2:	1101                	addi	sp,sp,-32
    800034b4:	ec06                	sd	ra,24(sp)
    800034b6:	e822                	sd	s0,16(sp)
    800034b8:	e426                	sd	s1,8(sp)
    800034ba:	1000                	addi	s0,sp,32
    800034bc:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800034be:	00237517          	auipc	a0,0x237
    800034c2:	03a50513          	addi	a0,a0,58 # 8023a4f8 <ftable>
    800034c6:	47e020ef          	jal	80005944 <acquire>
  if(f->ref < 1)
    800034ca:	40dc                	lw	a5,4(s1)
    800034cc:	02f05063          	blez	a5,800034ec <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800034d0:	2785                	addiw	a5,a5,1
    800034d2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800034d4:	00237517          	auipc	a0,0x237
    800034d8:	02450513          	addi	a0,a0,36 # 8023a4f8 <ftable>
    800034dc:	4fc020ef          	jal	800059d8 <release>
  return f;
}
    800034e0:	8526                	mv	a0,s1
    800034e2:	60e2                	ld	ra,24(sp)
    800034e4:	6442                	ld	s0,16(sp)
    800034e6:	64a2                	ld	s1,8(sp)
    800034e8:	6105                	addi	sp,sp,32
    800034ea:	8082                	ret
    panic("filedup");
    800034ec:	00004517          	auipc	a0,0x4
    800034f0:	0ac50513          	addi	a0,a0,172 # 80007598 <etext+0x598>
    800034f4:	122020ef          	jal	80005616 <panic>

00000000800034f8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800034f8:	7139                	addi	sp,sp,-64
    800034fa:	fc06                	sd	ra,56(sp)
    800034fc:	f822                	sd	s0,48(sp)
    800034fe:	f426                	sd	s1,40(sp)
    80003500:	0080                	addi	s0,sp,64
    80003502:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003504:	00237517          	auipc	a0,0x237
    80003508:	ff450513          	addi	a0,a0,-12 # 8023a4f8 <ftable>
    8000350c:	438020ef          	jal	80005944 <acquire>
  if(f->ref < 1)
    80003510:	40dc                	lw	a5,4(s1)
    80003512:	04f05863          	blez	a5,80003562 <fileclose+0x6a>
    panic("fileclose");
  if(--f->ref > 0){
    80003516:	37fd                	addiw	a5,a5,-1
    80003518:	c0dc                	sw	a5,4(s1)
    8000351a:	04f04e63          	bgtz	a5,80003576 <fileclose+0x7e>
    8000351e:	f04a                	sd	s2,32(sp)
    80003520:	ec4e                	sd	s3,24(sp)
    80003522:	e852                	sd	s4,16(sp)
    80003524:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003526:	0004a903          	lw	s2,0(s1)
    8000352a:	0094ca83          	lbu	s5,9(s1)
    8000352e:	0104ba03          	ld	s4,16(s1)
    80003532:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003536:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000353a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000353e:	00237517          	auipc	a0,0x237
    80003542:	fba50513          	addi	a0,a0,-70 # 8023a4f8 <ftable>
    80003546:	492020ef          	jal	800059d8 <release>

  if(ff.type == FD_PIPE){
    8000354a:	4785                	li	a5,1
    8000354c:	04f90063          	beq	s2,a5,8000358c <fileclose+0x94>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003550:	3979                	addiw	s2,s2,-2
    80003552:	4785                	li	a5,1
    80003554:	0527f563          	bgeu	a5,s2,8000359e <fileclose+0xa6>
    80003558:	7902                	ld	s2,32(sp)
    8000355a:	69e2                	ld	s3,24(sp)
    8000355c:	6a42                	ld	s4,16(sp)
    8000355e:	6aa2                	ld	s5,8(sp)
    80003560:	a00d                	j	80003582 <fileclose+0x8a>
    80003562:	f04a                	sd	s2,32(sp)
    80003564:	ec4e                	sd	s3,24(sp)
    80003566:	e852                	sd	s4,16(sp)
    80003568:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000356a:	00004517          	auipc	a0,0x4
    8000356e:	03650513          	addi	a0,a0,54 # 800075a0 <etext+0x5a0>
    80003572:	0a4020ef          	jal	80005616 <panic>
    release(&ftable.lock);
    80003576:	00237517          	auipc	a0,0x237
    8000357a:	f8250513          	addi	a0,a0,-126 # 8023a4f8 <ftable>
    8000357e:	45a020ef          	jal	800059d8 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003582:	70e2                	ld	ra,56(sp)
    80003584:	7442                	ld	s0,48(sp)
    80003586:	74a2                	ld	s1,40(sp)
    80003588:	6121                	addi	sp,sp,64
    8000358a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000358c:	85d6                	mv	a1,s5
    8000358e:	8552                	mv	a0,s4
    80003590:	340000ef          	jal	800038d0 <pipeclose>
    80003594:	7902                	ld	s2,32(sp)
    80003596:	69e2                	ld	s3,24(sp)
    80003598:	6a42                	ld	s4,16(sp)
    8000359a:	6aa2                	ld	s5,8(sp)
    8000359c:	b7dd                	j	80003582 <fileclose+0x8a>
    begin_op();
    8000359e:	b3bff0ef          	jal	800030d8 <begin_op>
    iput(ff.ip);
    800035a2:	854e                	mv	a0,s3
    800035a4:	c04ff0ef          	jal	800029a8 <iput>
    end_op();
    800035a8:	b9bff0ef          	jal	80003142 <end_op>
    800035ac:	7902                	ld	s2,32(sp)
    800035ae:	69e2                	ld	s3,24(sp)
    800035b0:	6a42                	ld	s4,16(sp)
    800035b2:	6aa2                	ld	s5,8(sp)
    800035b4:	b7f9                	j	80003582 <fileclose+0x8a>

00000000800035b6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800035b6:	715d                	addi	sp,sp,-80
    800035b8:	e486                	sd	ra,72(sp)
    800035ba:	e0a2                	sd	s0,64(sp)
    800035bc:	fc26                	sd	s1,56(sp)
    800035be:	f44e                	sd	s3,40(sp)
    800035c0:	0880                	addi	s0,sp,80
    800035c2:	84aa                	mv	s1,a0
    800035c4:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800035c6:	991fd0ef          	jal	80000f56 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800035ca:	409c                	lw	a5,0(s1)
    800035cc:	37f9                	addiw	a5,a5,-2
    800035ce:	4705                	li	a4,1
    800035d0:	04f76263          	bltu	a4,a5,80003614 <filestat+0x5e>
    800035d4:	f84a                	sd	s2,48(sp)
    800035d6:	f052                	sd	s4,32(sp)
    800035d8:	892a                	mv	s2,a0
    ilock(f->ip);
    800035da:	6c88                	ld	a0,24(s1)
    800035dc:	a4aff0ef          	jal	80002826 <ilock>
    stati(f->ip, &st);
    800035e0:	fb840a13          	addi	s4,s0,-72
    800035e4:	85d2                	mv	a1,s4
    800035e6:	6c88                	ld	a0,24(s1)
    800035e8:	c68ff0ef          	jal	80002a50 <stati>
    iunlock(f->ip);
    800035ec:	6c88                	ld	a0,24(s1)
    800035ee:	ae6ff0ef          	jal	800028d4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800035f2:	46e1                	li	a3,24
    800035f4:	8652                	mv	a2,s4
    800035f6:	85ce                	mv	a1,s3
    800035f8:	05093503          	ld	a0,80(s2)
    800035fc:	eccfd0ef          	jal	80000cc8 <copyout>
    80003600:	41f5551b          	sraiw	a0,a0,0x1f
    80003604:	7942                	ld	s2,48(sp)
    80003606:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003608:	60a6                	ld	ra,72(sp)
    8000360a:	6406                	ld	s0,64(sp)
    8000360c:	74e2                	ld	s1,56(sp)
    8000360e:	79a2                	ld	s3,40(sp)
    80003610:	6161                	addi	sp,sp,80
    80003612:	8082                	ret
  return -1;
    80003614:	557d                	li	a0,-1
    80003616:	bfcd                	j	80003608 <filestat+0x52>

0000000080003618 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003618:	7179                	addi	sp,sp,-48
    8000361a:	f406                	sd	ra,40(sp)
    8000361c:	f022                	sd	s0,32(sp)
    8000361e:	e84a                	sd	s2,16(sp)
    80003620:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003622:	00854783          	lbu	a5,8(a0)
    80003626:	cfd1                	beqz	a5,800036c2 <fileread+0xaa>
    80003628:	ec26                	sd	s1,24(sp)
    8000362a:	e44e                	sd	s3,8(sp)
    8000362c:	84aa                	mv	s1,a0
    8000362e:	89ae                	mv	s3,a1
    80003630:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003632:	411c                	lw	a5,0(a0)
    80003634:	4705                	li	a4,1
    80003636:	04e78363          	beq	a5,a4,8000367c <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000363a:	470d                	li	a4,3
    8000363c:	04e78763          	beq	a5,a4,8000368a <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003640:	4709                	li	a4,2
    80003642:	06e79a63          	bne	a5,a4,800036b6 <fileread+0x9e>
    ilock(f->ip);
    80003646:	6d08                	ld	a0,24(a0)
    80003648:	9deff0ef          	jal	80002826 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000364c:	874a                	mv	a4,s2
    8000364e:	5094                	lw	a3,32(s1)
    80003650:	864e                	mv	a2,s3
    80003652:	4585                	li	a1,1
    80003654:	6c88                	ld	a0,24(s1)
    80003656:	c28ff0ef          	jal	80002a7e <readi>
    8000365a:	892a                	mv	s2,a0
    8000365c:	00a05563          	blez	a0,80003666 <fileread+0x4e>
      f->off += r;
    80003660:	509c                	lw	a5,32(s1)
    80003662:	9fa9                	addw	a5,a5,a0
    80003664:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003666:	6c88                	ld	a0,24(s1)
    80003668:	a6cff0ef          	jal	800028d4 <iunlock>
    8000366c:	64e2                	ld	s1,24(sp)
    8000366e:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003670:	854a                	mv	a0,s2
    80003672:	70a2                	ld	ra,40(sp)
    80003674:	7402                	ld	s0,32(sp)
    80003676:	6942                	ld	s2,16(sp)
    80003678:	6145                	addi	sp,sp,48
    8000367a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000367c:	6908                	ld	a0,16(a0)
    8000367e:	3a2000ef          	jal	80003a20 <piperead>
    80003682:	892a                	mv	s2,a0
    80003684:	64e2                	ld	s1,24(sp)
    80003686:	69a2                	ld	s3,8(sp)
    80003688:	b7e5                	j	80003670 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000368a:	02451783          	lh	a5,36(a0)
    8000368e:	03079693          	slli	a3,a5,0x30
    80003692:	92c1                	srli	a3,a3,0x30
    80003694:	4725                	li	a4,9
    80003696:	02d76863          	bltu	a4,a3,800036c6 <fileread+0xae>
    8000369a:	0792                	slli	a5,a5,0x4
    8000369c:	00237717          	auipc	a4,0x237
    800036a0:	dbc70713          	addi	a4,a4,-580 # 8023a458 <devsw>
    800036a4:	97ba                	add	a5,a5,a4
    800036a6:	639c                	ld	a5,0(a5)
    800036a8:	c39d                	beqz	a5,800036ce <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800036aa:	4505                	li	a0,1
    800036ac:	9782                	jalr	a5
    800036ae:	892a                	mv	s2,a0
    800036b0:	64e2                	ld	s1,24(sp)
    800036b2:	69a2                	ld	s3,8(sp)
    800036b4:	bf75                	j	80003670 <fileread+0x58>
    panic("fileread");
    800036b6:	00004517          	auipc	a0,0x4
    800036ba:	efa50513          	addi	a0,a0,-262 # 800075b0 <etext+0x5b0>
    800036be:	759010ef          	jal	80005616 <panic>
    return -1;
    800036c2:	597d                	li	s2,-1
    800036c4:	b775                	j	80003670 <fileread+0x58>
      return -1;
    800036c6:	597d                	li	s2,-1
    800036c8:	64e2                	ld	s1,24(sp)
    800036ca:	69a2                	ld	s3,8(sp)
    800036cc:	b755                	j	80003670 <fileread+0x58>
    800036ce:	597d                	li	s2,-1
    800036d0:	64e2                	ld	s1,24(sp)
    800036d2:	69a2                	ld	s3,8(sp)
    800036d4:	bf71                	j	80003670 <fileread+0x58>

00000000800036d6 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800036d6:	00954783          	lbu	a5,9(a0)
    800036da:	10078e63          	beqz	a5,800037f6 <filewrite+0x120>
{
    800036de:	711d                	addi	sp,sp,-96
    800036e0:	ec86                	sd	ra,88(sp)
    800036e2:	e8a2                	sd	s0,80(sp)
    800036e4:	e0ca                	sd	s2,64(sp)
    800036e6:	f456                	sd	s5,40(sp)
    800036e8:	f05a                	sd	s6,32(sp)
    800036ea:	1080                	addi	s0,sp,96
    800036ec:	892a                	mv	s2,a0
    800036ee:	8b2e                	mv	s6,a1
    800036f0:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    800036f2:	411c                	lw	a5,0(a0)
    800036f4:	4705                	li	a4,1
    800036f6:	02e78963          	beq	a5,a4,80003728 <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800036fa:	470d                	li	a4,3
    800036fc:	02e78a63          	beq	a5,a4,80003730 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003700:	4709                	li	a4,2
    80003702:	0ce79e63          	bne	a5,a4,800037de <filewrite+0x108>
    80003706:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003708:	0ac05963          	blez	a2,800037ba <filewrite+0xe4>
    8000370c:	e4a6                	sd	s1,72(sp)
    8000370e:	fc4e                	sd	s3,56(sp)
    80003710:	ec5e                	sd	s7,24(sp)
    80003712:	e862                	sd	s8,16(sp)
    80003714:	e466                	sd	s9,8(sp)
    int i = 0;
    80003716:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80003718:	6b85                	lui	s7,0x1
    8000371a:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000371e:	6c85                	lui	s9,0x1
    80003720:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003724:	4c05                	li	s8,1
    80003726:	a8ad                	j	800037a0 <filewrite+0xca>
    ret = pipewrite(f->pipe, addr, n);
    80003728:	6908                	ld	a0,16(a0)
    8000372a:	1fe000ef          	jal	80003928 <pipewrite>
    8000372e:	a04d                	j	800037d0 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003730:	02451783          	lh	a5,36(a0)
    80003734:	03079693          	slli	a3,a5,0x30
    80003738:	92c1                	srli	a3,a3,0x30
    8000373a:	4725                	li	a4,9
    8000373c:	0ad76f63          	bltu	a4,a3,800037fa <filewrite+0x124>
    80003740:	0792                	slli	a5,a5,0x4
    80003742:	00237717          	auipc	a4,0x237
    80003746:	d1670713          	addi	a4,a4,-746 # 8023a458 <devsw>
    8000374a:	97ba                	add	a5,a5,a4
    8000374c:	679c                	ld	a5,8(a5)
    8000374e:	cbc5                	beqz	a5,800037fe <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003750:	4505                	li	a0,1
    80003752:	9782                	jalr	a5
    80003754:	a8b5                	j	800037d0 <filewrite+0xfa>
      if(n1 > max)
    80003756:	2981                	sext.w	s3,s3
      begin_op();
    80003758:	981ff0ef          	jal	800030d8 <begin_op>
      ilock(f->ip);
    8000375c:	01893503          	ld	a0,24(s2)
    80003760:	8c6ff0ef          	jal	80002826 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003764:	874e                	mv	a4,s3
    80003766:	02092683          	lw	a3,32(s2)
    8000376a:	016a0633          	add	a2,s4,s6
    8000376e:	85e2                	mv	a1,s8
    80003770:	01893503          	ld	a0,24(s2)
    80003774:	bfcff0ef          	jal	80002b70 <writei>
    80003778:	84aa                	mv	s1,a0
    8000377a:	00a05763          	blez	a0,80003788 <filewrite+0xb2>
        f->off += r;
    8000377e:	02092783          	lw	a5,32(s2)
    80003782:	9fa9                	addw	a5,a5,a0
    80003784:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003788:	01893503          	ld	a0,24(s2)
    8000378c:	948ff0ef          	jal	800028d4 <iunlock>
      end_op();
    80003790:	9b3ff0ef          	jal	80003142 <end_op>

      if(r != n1){
    80003794:	02999563          	bne	s3,s1,800037be <filewrite+0xe8>
        // error from writei
        break;
      }
      i += r;
    80003798:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    8000379c:	015a5963          	bge	s4,s5,800037ae <filewrite+0xd8>
      int n1 = n - i;
    800037a0:	414a87bb          	subw	a5,s5,s4
    800037a4:	89be                	mv	s3,a5
      if(n1 > max)
    800037a6:	fafbd8e3          	bge	s7,a5,80003756 <filewrite+0x80>
    800037aa:	89e6                	mv	s3,s9
    800037ac:	b76d                	j	80003756 <filewrite+0x80>
    800037ae:	64a6                	ld	s1,72(sp)
    800037b0:	79e2                	ld	s3,56(sp)
    800037b2:	6be2                	ld	s7,24(sp)
    800037b4:	6c42                	ld	s8,16(sp)
    800037b6:	6ca2                	ld	s9,8(sp)
    800037b8:	a801                	j	800037c8 <filewrite+0xf2>
    int i = 0;
    800037ba:	4a01                	li	s4,0
    800037bc:	a031                	j	800037c8 <filewrite+0xf2>
    800037be:	64a6                	ld	s1,72(sp)
    800037c0:	79e2                	ld	s3,56(sp)
    800037c2:	6be2                	ld	s7,24(sp)
    800037c4:	6c42                	ld	s8,16(sp)
    800037c6:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    800037c8:	034a9d63          	bne	s5,s4,80003802 <filewrite+0x12c>
    800037cc:	8556                	mv	a0,s5
    800037ce:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800037d0:	60e6                	ld	ra,88(sp)
    800037d2:	6446                	ld	s0,80(sp)
    800037d4:	6906                	ld	s2,64(sp)
    800037d6:	7aa2                	ld	s5,40(sp)
    800037d8:	7b02                	ld	s6,32(sp)
    800037da:	6125                	addi	sp,sp,96
    800037dc:	8082                	ret
    800037de:	e4a6                	sd	s1,72(sp)
    800037e0:	fc4e                	sd	s3,56(sp)
    800037e2:	f852                	sd	s4,48(sp)
    800037e4:	ec5e                	sd	s7,24(sp)
    800037e6:	e862                	sd	s8,16(sp)
    800037e8:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800037ea:	00004517          	auipc	a0,0x4
    800037ee:	dd650513          	addi	a0,a0,-554 # 800075c0 <etext+0x5c0>
    800037f2:	625010ef          	jal	80005616 <panic>
    return -1;
    800037f6:	557d                	li	a0,-1
}
    800037f8:	8082                	ret
      return -1;
    800037fa:	557d                	li	a0,-1
    800037fc:	bfd1                	j	800037d0 <filewrite+0xfa>
    800037fe:	557d                	li	a0,-1
    80003800:	bfc1                	j	800037d0 <filewrite+0xfa>
    ret = (i == n ? n : -1);
    80003802:	557d                	li	a0,-1
    80003804:	7a42                	ld	s4,48(sp)
    80003806:	b7e9                	j	800037d0 <filewrite+0xfa>

0000000080003808 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003808:	7179                	addi	sp,sp,-48
    8000380a:	f406                	sd	ra,40(sp)
    8000380c:	f022                	sd	s0,32(sp)
    8000380e:	ec26                	sd	s1,24(sp)
    80003810:	e052                	sd	s4,0(sp)
    80003812:	1800                	addi	s0,sp,48
    80003814:	84aa                	mv	s1,a0
    80003816:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003818:	0005b023          	sd	zero,0(a1)
    8000381c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003820:	c35ff0ef          	jal	80003454 <filealloc>
    80003824:	e088                	sd	a0,0(s1)
    80003826:	c549                	beqz	a0,800038b0 <pipealloc+0xa8>
    80003828:	c2dff0ef          	jal	80003454 <filealloc>
    8000382c:	00aa3023          	sd	a0,0(s4)
    80003830:	cd25                	beqz	a0,800038a8 <pipealloc+0xa0>
    80003832:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003834:	925fc0ef          	jal	80000158 <kalloc>
    80003838:	892a                	mv	s2,a0
    8000383a:	c12d                	beqz	a0,8000389c <pipealloc+0x94>
    8000383c:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000383e:	4985                	li	s3,1
    80003840:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003844:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003848:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000384c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003850:	00004597          	auipc	a1,0x4
    80003854:	d8058593          	addi	a1,a1,-640 # 800075d0 <etext+0x5d0>
    80003858:	068020ef          	jal	800058c0 <initlock>
  (*f0)->type = FD_PIPE;
    8000385c:	609c                	ld	a5,0(s1)
    8000385e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003862:	609c                	ld	a5,0(s1)
    80003864:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003868:	609c                	ld	a5,0(s1)
    8000386a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000386e:	609c                	ld	a5,0(s1)
    80003870:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003874:	000a3783          	ld	a5,0(s4)
    80003878:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000387c:	000a3783          	ld	a5,0(s4)
    80003880:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003884:	000a3783          	ld	a5,0(s4)
    80003888:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000388c:	000a3783          	ld	a5,0(s4)
    80003890:	0127b823          	sd	s2,16(a5)
  return 0;
    80003894:	4501                	li	a0,0
    80003896:	6942                	ld	s2,16(sp)
    80003898:	69a2                	ld	s3,8(sp)
    8000389a:	a01d                	j	800038c0 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000389c:	6088                	ld	a0,0(s1)
    8000389e:	c119                	beqz	a0,800038a4 <pipealloc+0x9c>
    800038a0:	6942                	ld	s2,16(sp)
    800038a2:	a029                	j	800038ac <pipealloc+0xa4>
    800038a4:	6942                	ld	s2,16(sp)
    800038a6:	a029                	j	800038b0 <pipealloc+0xa8>
    800038a8:	6088                	ld	a0,0(s1)
    800038aa:	c10d                	beqz	a0,800038cc <pipealloc+0xc4>
    fileclose(*f0);
    800038ac:	c4dff0ef          	jal	800034f8 <fileclose>
  if(*f1)
    800038b0:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800038b4:	557d                	li	a0,-1
  if(*f1)
    800038b6:	c789                	beqz	a5,800038c0 <pipealloc+0xb8>
    fileclose(*f1);
    800038b8:	853e                	mv	a0,a5
    800038ba:	c3fff0ef          	jal	800034f8 <fileclose>
  return -1;
    800038be:	557d                	li	a0,-1
}
    800038c0:	70a2                	ld	ra,40(sp)
    800038c2:	7402                	ld	s0,32(sp)
    800038c4:	64e2                	ld	s1,24(sp)
    800038c6:	6a02                	ld	s4,0(sp)
    800038c8:	6145                	addi	sp,sp,48
    800038ca:	8082                	ret
  return -1;
    800038cc:	557d                	li	a0,-1
    800038ce:	bfcd                	j	800038c0 <pipealloc+0xb8>

00000000800038d0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800038d0:	1101                	addi	sp,sp,-32
    800038d2:	ec06                	sd	ra,24(sp)
    800038d4:	e822                	sd	s0,16(sp)
    800038d6:	e426                	sd	s1,8(sp)
    800038d8:	e04a                	sd	s2,0(sp)
    800038da:	1000                	addi	s0,sp,32
    800038dc:	84aa                	mv	s1,a0
    800038de:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800038e0:	064020ef          	jal	80005944 <acquire>
  if(writable){
    800038e4:	02090763          	beqz	s2,80003912 <pipeclose+0x42>
    pi->writeopen = 0;
    800038e8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800038ec:	21848513          	addi	a0,s1,536
    800038f0:	c81fd0ef          	jal	80001570 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800038f4:	2204b783          	ld	a5,544(s1)
    800038f8:	e785                	bnez	a5,80003920 <pipeclose+0x50>
    release(&pi->lock);
    800038fa:	8526                	mv	a0,s1
    800038fc:	0dc020ef          	jal	800059d8 <release>
    kfree((char*)pi);
    80003900:	8526                	mv	a0,s1
    80003902:	f1afc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003906:	60e2                	ld	ra,24(sp)
    80003908:	6442                	ld	s0,16(sp)
    8000390a:	64a2                	ld	s1,8(sp)
    8000390c:	6902                	ld	s2,0(sp)
    8000390e:	6105                	addi	sp,sp,32
    80003910:	8082                	ret
    pi->readopen = 0;
    80003912:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003916:	21c48513          	addi	a0,s1,540
    8000391a:	c57fd0ef          	jal	80001570 <wakeup>
    8000391e:	bfd9                	j	800038f4 <pipeclose+0x24>
    release(&pi->lock);
    80003920:	8526                	mv	a0,s1
    80003922:	0b6020ef          	jal	800059d8 <release>
}
    80003926:	b7c5                	j	80003906 <pipeclose+0x36>

0000000080003928 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003928:	7159                	addi	sp,sp,-112
    8000392a:	f486                	sd	ra,104(sp)
    8000392c:	f0a2                	sd	s0,96(sp)
    8000392e:	eca6                	sd	s1,88(sp)
    80003930:	e8ca                	sd	s2,80(sp)
    80003932:	e4ce                	sd	s3,72(sp)
    80003934:	e0d2                	sd	s4,64(sp)
    80003936:	fc56                	sd	s5,56(sp)
    80003938:	1880                	addi	s0,sp,112
    8000393a:	84aa                	mv	s1,a0
    8000393c:	8aae                	mv	s5,a1
    8000393e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003940:	e16fd0ef          	jal	80000f56 <myproc>
    80003944:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003946:	8526                	mv	a0,s1
    80003948:	7fd010ef          	jal	80005944 <acquire>
  while(i < n){
    8000394c:	0d405263          	blez	s4,80003a10 <pipewrite+0xe8>
    80003950:	f85a                	sd	s6,48(sp)
    80003952:	f45e                	sd	s7,40(sp)
    80003954:	f062                	sd	s8,32(sp)
    80003956:	ec66                	sd	s9,24(sp)
    80003958:	e86a                	sd	s10,16(sp)
  int i = 0;
    8000395a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000395c:	f9f40c13          	addi	s8,s0,-97
    80003960:	4b85                	li	s7,1
    80003962:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003964:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003968:	21c48c93          	addi	s9,s1,540
    8000396c:	a82d                	j	800039a6 <pipewrite+0x7e>
      release(&pi->lock);
    8000396e:	8526                	mv	a0,s1
    80003970:	068020ef          	jal	800059d8 <release>
      return -1;
    80003974:	597d                	li	s2,-1
    80003976:	7b42                	ld	s6,48(sp)
    80003978:	7ba2                	ld	s7,40(sp)
    8000397a:	7c02                	ld	s8,32(sp)
    8000397c:	6ce2                	ld	s9,24(sp)
    8000397e:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003980:	854a                	mv	a0,s2
    80003982:	70a6                	ld	ra,104(sp)
    80003984:	7406                	ld	s0,96(sp)
    80003986:	64e6                	ld	s1,88(sp)
    80003988:	6946                	ld	s2,80(sp)
    8000398a:	69a6                	ld	s3,72(sp)
    8000398c:	6a06                	ld	s4,64(sp)
    8000398e:	7ae2                	ld	s5,56(sp)
    80003990:	6165                	addi	sp,sp,112
    80003992:	8082                	ret
      wakeup(&pi->nread);
    80003994:	856a                	mv	a0,s10
    80003996:	bdbfd0ef          	jal	80001570 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000399a:	85a6                	mv	a1,s1
    8000399c:	8566                	mv	a0,s9
    8000399e:	b87fd0ef          	jal	80001524 <sleep>
  while(i < n){
    800039a2:	05495a63          	bge	s2,s4,800039f6 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    800039a6:	2204a783          	lw	a5,544(s1)
    800039aa:	d3f1                	beqz	a5,8000396e <pipewrite+0x46>
    800039ac:	854e                	mv	a0,s3
    800039ae:	daffd0ef          	jal	8000175c <killed>
    800039b2:	fd55                	bnez	a0,8000396e <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800039b4:	2184a783          	lw	a5,536(s1)
    800039b8:	21c4a703          	lw	a4,540(s1)
    800039bc:	2007879b          	addiw	a5,a5,512
    800039c0:	fcf70ae3          	beq	a4,a5,80003994 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800039c4:	86de                	mv	a3,s7
    800039c6:	01590633          	add	a2,s2,s5
    800039ca:	85e2                	mv	a1,s8
    800039cc:	0509b503          	ld	a0,80(s3)
    800039d0:	914fd0ef          	jal	80000ae4 <copyin>
    800039d4:	05650063          	beq	a0,s6,80003a14 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800039d8:	21c4a783          	lw	a5,540(s1)
    800039dc:	0017871b          	addiw	a4,a5,1
    800039e0:	20e4ae23          	sw	a4,540(s1)
    800039e4:	1ff7f793          	andi	a5,a5,511
    800039e8:	97a6                	add	a5,a5,s1
    800039ea:	f9f44703          	lbu	a4,-97(s0)
    800039ee:	00e78c23          	sb	a4,24(a5)
      i++;
    800039f2:	2905                	addiw	s2,s2,1
    800039f4:	b77d                	j	800039a2 <pipewrite+0x7a>
    800039f6:	7b42                	ld	s6,48(sp)
    800039f8:	7ba2                	ld	s7,40(sp)
    800039fa:	7c02                	ld	s8,32(sp)
    800039fc:	6ce2                	ld	s9,24(sp)
    800039fe:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80003a00:	21848513          	addi	a0,s1,536
    80003a04:	b6dfd0ef          	jal	80001570 <wakeup>
  release(&pi->lock);
    80003a08:	8526                	mv	a0,s1
    80003a0a:	7cf010ef          	jal	800059d8 <release>
  return i;
    80003a0e:	bf8d                	j	80003980 <pipewrite+0x58>
  int i = 0;
    80003a10:	4901                	li	s2,0
    80003a12:	b7fd                	j	80003a00 <pipewrite+0xd8>
    80003a14:	7b42                	ld	s6,48(sp)
    80003a16:	7ba2                	ld	s7,40(sp)
    80003a18:	7c02                	ld	s8,32(sp)
    80003a1a:	6ce2                	ld	s9,24(sp)
    80003a1c:	6d42                	ld	s10,16(sp)
    80003a1e:	b7cd                	j	80003a00 <pipewrite+0xd8>

0000000080003a20 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003a20:	711d                	addi	sp,sp,-96
    80003a22:	ec86                	sd	ra,88(sp)
    80003a24:	e8a2                	sd	s0,80(sp)
    80003a26:	e4a6                	sd	s1,72(sp)
    80003a28:	e0ca                	sd	s2,64(sp)
    80003a2a:	fc4e                	sd	s3,56(sp)
    80003a2c:	f852                	sd	s4,48(sp)
    80003a2e:	f456                	sd	s5,40(sp)
    80003a30:	1080                	addi	s0,sp,96
    80003a32:	84aa                	mv	s1,a0
    80003a34:	892e                	mv	s2,a1
    80003a36:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003a38:	d1efd0ef          	jal	80000f56 <myproc>
    80003a3c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003a3e:	8526                	mv	a0,s1
    80003a40:	705010ef          	jal	80005944 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a44:	2184a703          	lw	a4,536(s1)
    80003a48:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003a4c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a50:	02f71763          	bne	a4,a5,80003a7e <piperead+0x5e>
    80003a54:	2244a783          	lw	a5,548(s1)
    80003a58:	cf85                	beqz	a5,80003a90 <piperead+0x70>
    if(killed(pr)){
    80003a5a:	8552                	mv	a0,s4
    80003a5c:	d01fd0ef          	jal	8000175c <killed>
    80003a60:	e11d                	bnez	a0,80003a86 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003a62:	85a6                	mv	a1,s1
    80003a64:	854e                	mv	a0,s3
    80003a66:	abffd0ef          	jal	80001524 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a6a:	2184a703          	lw	a4,536(s1)
    80003a6e:	21c4a783          	lw	a5,540(s1)
    80003a72:	fef701e3          	beq	a4,a5,80003a54 <piperead+0x34>
    80003a76:	f05a                	sd	s6,32(sp)
    80003a78:	ec5e                	sd	s7,24(sp)
    80003a7a:	e862                	sd	s8,16(sp)
    80003a7c:	a829                	j	80003a96 <piperead+0x76>
    80003a7e:	f05a                	sd	s6,32(sp)
    80003a80:	ec5e                	sd	s7,24(sp)
    80003a82:	e862                	sd	s8,16(sp)
    80003a84:	a809                	j	80003a96 <piperead+0x76>
      release(&pi->lock);
    80003a86:	8526                	mv	a0,s1
    80003a88:	751010ef          	jal	800059d8 <release>
      return -1;
    80003a8c:	59fd                	li	s3,-1
    80003a8e:	a0a5                	j	80003af6 <piperead+0xd6>
    80003a90:	f05a                	sd	s6,32(sp)
    80003a92:	ec5e                	sd	s7,24(sp)
    80003a94:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a96:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a98:	faf40c13          	addi	s8,s0,-81
    80003a9c:	4b85                	li	s7,1
    80003a9e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003aa0:	05505163          	blez	s5,80003ae2 <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    80003aa4:	2184a783          	lw	a5,536(s1)
    80003aa8:	21c4a703          	lw	a4,540(s1)
    80003aac:	02f70b63          	beq	a4,a5,80003ae2 <piperead+0xc2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003ab0:	0017871b          	addiw	a4,a5,1
    80003ab4:	20e4ac23          	sw	a4,536(s1)
    80003ab8:	1ff7f793          	andi	a5,a5,511
    80003abc:	97a6                	add	a5,a5,s1
    80003abe:	0187c783          	lbu	a5,24(a5)
    80003ac2:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003ac6:	86de                	mv	a3,s7
    80003ac8:	8662                	mv	a2,s8
    80003aca:	85ca                	mv	a1,s2
    80003acc:	050a3503          	ld	a0,80(s4)
    80003ad0:	9f8fd0ef          	jal	80000cc8 <copyout>
    80003ad4:	01650763          	beq	a0,s6,80003ae2 <piperead+0xc2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003ad8:	2985                	addiw	s3,s3,1
    80003ada:	0905                	addi	s2,s2,1
    80003adc:	fd3a94e3          	bne	s5,s3,80003aa4 <piperead+0x84>
    80003ae0:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003ae2:	21c48513          	addi	a0,s1,540
    80003ae6:	a8bfd0ef          	jal	80001570 <wakeup>
  release(&pi->lock);
    80003aea:	8526                	mv	a0,s1
    80003aec:	6ed010ef          	jal	800059d8 <release>
    80003af0:	7b02                	ld	s6,32(sp)
    80003af2:	6be2                	ld	s7,24(sp)
    80003af4:	6c42                	ld	s8,16(sp)
  return i;
}
    80003af6:	854e                	mv	a0,s3
    80003af8:	60e6                	ld	ra,88(sp)
    80003afa:	6446                	ld	s0,80(sp)
    80003afc:	64a6                	ld	s1,72(sp)
    80003afe:	6906                	ld	s2,64(sp)
    80003b00:	79e2                	ld	s3,56(sp)
    80003b02:	7a42                	ld	s4,48(sp)
    80003b04:	7aa2                	ld	s5,40(sp)
    80003b06:	6125                	addi	sp,sp,96
    80003b08:	8082                	ret

0000000080003b0a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003b0a:	1141                	addi	sp,sp,-16
    80003b0c:	e406                	sd	ra,8(sp)
    80003b0e:	e022                	sd	s0,0(sp)
    80003b10:	0800                	addi	s0,sp,16
    80003b12:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003b14:	0035151b          	slliw	a0,a0,0x3
    80003b18:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80003b1a:	8b89                	andi	a5,a5,2
    80003b1c:	c399                	beqz	a5,80003b22 <flags2perm+0x18>
      perm |= PTE_W;
    80003b1e:	00456513          	ori	a0,a0,4
    return perm;
}
    80003b22:	60a2                	ld	ra,8(sp)
    80003b24:	6402                	ld	s0,0(sp)
    80003b26:	0141                	addi	sp,sp,16
    80003b28:	8082                	ret

0000000080003b2a <exec>:

int
exec(char *path, char **argv)
{
    80003b2a:	de010113          	addi	sp,sp,-544
    80003b2e:	20113c23          	sd	ra,536(sp)
    80003b32:	20813823          	sd	s0,528(sp)
    80003b36:	20913423          	sd	s1,520(sp)
    80003b3a:	21213023          	sd	s2,512(sp)
    80003b3e:	1400                	addi	s0,sp,544
    80003b40:	892a                	mv	s2,a0
    80003b42:	dea43823          	sd	a0,-528(s0)
    80003b46:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003b4a:	c0cfd0ef          	jal	80000f56 <myproc>
    80003b4e:	84aa                	mv	s1,a0

  begin_op();
    80003b50:	d88ff0ef          	jal	800030d8 <begin_op>

  if((ip = namei(path)) == 0){
    80003b54:	854a                	mv	a0,s2
    80003b56:	bc0ff0ef          	jal	80002f16 <namei>
    80003b5a:	cd21                	beqz	a0,80003bb2 <exec+0x88>
    80003b5c:	fbd2                	sd	s4,496(sp)
    80003b5e:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003b60:	cc7fe0ef          	jal	80002826 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003b64:	04000713          	li	a4,64
    80003b68:	4681                	li	a3,0
    80003b6a:	e5040613          	addi	a2,s0,-432
    80003b6e:	4581                	li	a1,0
    80003b70:	8552                	mv	a0,s4
    80003b72:	f0dfe0ef          	jal	80002a7e <readi>
    80003b76:	04000793          	li	a5,64
    80003b7a:	00f51a63          	bne	a0,a5,80003b8e <exec+0x64>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003b7e:	e5042703          	lw	a4,-432(s0)
    80003b82:	464c47b7          	lui	a5,0x464c4
    80003b86:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003b8a:	02f70863          	beq	a4,a5,80003bba <exec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003b8e:	8552                	mv	a0,s4
    80003b90:	ea1fe0ef          	jal	80002a30 <iunlockput>
    end_op();
    80003b94:	daeff0ef          	jal	80003142 <end_op>
  }
  return -1;
    80003b98:	557d                	li	a0,-1
    80003b9a:	7a5e                	ld	s4,496(sp)
}
    80003b9c:	21813083          	ld	ra,536(sp)
    80003ba0:	21013403          	ld	s0,528(sp)
    80003ba4:	20813483          	ld	s1,520(sp)
    80003ba8:	20013903          	ld	s2,512(sp)
    80003bac:	22010113          	addi	sp,sp,544
    80003bb0:	8082                	ret
    end_op();
    80003bb2:	d90ff0ef          	jal	80003142 <end_op>
    return -1;
    80003bb6:	557d                	li	a0,-1
    80003bb8:	b7d5                	j	80003b9c <exec+0x72>
    80003bba:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003bbc:	8526                	mv	a0,s1
    80003bbe:	c40fd0ef          	jal	80000ffe <proc_pagetable>
    80003bc2:	8b2a                	mv	s6,a0
    80003bc4:	26050d63          	beqz	a0,80003e3e <exec+0x314>
    80003bc8:	ffce                	sd	s3,504(sp)
    80003bca:	f7d6                	sd	s5,488(sp)
    80003bcc:	efde                	sd	s7,472(sp)
    80003bce:	ebe2                	sd	s8,464(sp)
    80003bd0:	e7e6                	sd	s9,456(sp)
    80003bd2:	e3ea                	sd	s10,448(sp)
    80003bd4:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003bd6:	e7042683          	lw	a3,-400(s0)
    80003bda:	e8845783          	lhu	a5,-376(s0)
    80003bde:	0e078763          	beqz	a5,80003ccc <exec+0x1a2>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003be2:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003be4:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003be6:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80003bea:	6c85                	lui	s9,0x1
    80003bec:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003bf0:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003bf4:	6a85                	lui	s5,0x1
    80003bf6:	a085                	j	80003c56 <exec+0x12c>
      panic("loadseg: address should exist");
    80003bf8:	00004517          	auipc	a0,0x4
    80003bfc:	9e050513          	addi	a0,a0,-1568 # 800075d8 <etext+0x5d8>
    80003c00:	217010ef          	jal	80005616 <panic>
    if(sz - i < PGSIZE)
    80003c04:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003c06:	874a                	mv	a4,s2
    80003c08:	009c06bb          	addw	a3,s8,s1
    80003c0c:	4581                	li	a1,0
    80003c0e:	8552                	mv	a0,s4
    80003c10:	e6ffe0ef          	jal	80002a7e <readi>
    80003c14:	22a91963          	bne	s2,a0,80003e46 <exec+0x31c>
  for(i = 0; i < sz; i += PGSIZE){
    80003c18:	009a84bb          	addw	s1,s5,s1
    80003c1c:	0334f263          	bgeu	s1,s3,80003c40 <exec+0x116>
    pa = walkaddr(pagetable, va + i);
    80003c20:	02049593          	slli	a1,s1,0x20
    80003c24:	9181                	srli	a1,a1,0x20
    80003c26:	95de                	add	a1,a1,s7
    80003c28:	855a                	mv	a0,s6
    80003c2a:	941fc0ef          	jal	8000056a <walkaddr>
    80003c2e:	862a                	mv	a2,a0
    if(pa == 0)
    80003c30:	d561                	beqz	a0,80003bf8 <exec+0xce>
    if(sz - i < PGSIZE)
    80003c32:	409987bb          	subw	a5,s3,s1
    80003c36:	893e                	mv	s2,a5
    80003c38:	fcfcf6e3          	bgeu	s9,a5,80003c04 <exec+0xda>
    80003c3c:	8956                	mv	s2,s5
    80003c3e:	b7d9                	j	80003c04 <exec+0xda>
    sz = sz1;
    80003c40:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003c44:	2d05                	addiw	s10,s10,1
    80003c46:	e0843783          	ld	a5,-504(s0)
    80003c4a:	0387869b          	addiw	a3,a5,56
    80003c4e:	e8845783          	lhu	a5,-376(s0)
    80003c52:	06fd5e63          	bge	s10,a5,80003cce <exec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003c56:	e0d43423          	sd	a3,-504(s0)
    80003c5a:	876e                	mv	a4,s11
    80003c5c:	e1840613          	addi	a2,s0,-488
    80003c60:	4581                	li	a1,0
    80003c62:	8552                	mv	a0,s4
    80003c64:	e1bfe0ef          	jal	80002a7e <readi>
    80003c68:	1db51d63          	bne	a0,s11,80003e42 <exec+0x318>
    if(ph.type != ELF_PROG_LOAD)
    80003c6c:	e1842783          	lw	a5,-488(s0)
    80003c70:	4705                	li	a4,1
    80003c72:	fce799e3          	bne	a5,a4,80003c44 <exec+0x11a>
    if(ph.memsz < ph.filesz)
    80003c76:	e4043483          	ld	s1,-448(s0)
    80003c7a:	e3843783          	ld	a5,-456(s0)
    80003c7e:	1ef4e263          	bltu	s1,a5,80003e62 <exec+0x338>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003c82:	e2843783          	ld	a5,-472(s0)
    80003c86:	94be                	add	s1,s1,a5
    80003c88:	1ef4e063          	bltu	s1,a5,80003e68 <exec+0x33e>
    if(ph.vaddr % PGSIZE != 0)
    80003c8c:	de843703          	ld	a4,-536(s0)
    80003c90:	8ff9                	and	a5,a5,a4
    80003c92:	1c079e63          	bnez	a5,80003e6e <exec+0x344>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003c96:	e1c42503          	lw	a0,-484(s0)
    80003c9a:	e71ff0ef          	jal	80003b0a <flags2perm>
    80003c9e:	86aa                	mv	a3,a0
    80003ca0:	8626                	mv	a2,s1
    80003ca2:	85ca                	mv	a1,s2
    80003ca4:	855a                	mv	a0,s6
    80003ca6:	c3dfc0ef          	jal	800008e2 <uvmalloc>
    80003caa:	dea43c23          	sd	a0,-520(s0)
    80003cae:	1c050363          	beqz	a0,80003e74 <exec+0x34a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003cb2:	e2843b83          	ld	s7,-472(s0)
    80003cb6:	e2042c03          	lw	s8,-480(s0)
    80003cba:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003cbe:	00098463          	beqz	s3,80003cc6 <exec+0x19c>
    80003cc2:	4481                	li	s1,0
    80003cc4:	bfb1                	j	80003c20 <exec+0xf6>
    sz = sz1;
    80003cc6:	df843903          	ld	s2,-520(s0)
    80003cca:	bfad                	j	80003c44 <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003ccc:	4901                	li	s2,0
  iunlockput(ip);
    80003cce:	8552                	mv	a0,s4
    80003cd0:	d61fe0ef          	jal	80002a30 <iunlockput>
  end_op();
    80003cd4:	c6eff0ef          	jal	80003142 <end_op>
  p = myproc();
    80003cd8:	a7efd0ef          	jal	80000f56 <myproc>
    80003cdc:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003cde:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003ce2:	6985                	lui	s3,0x1
    80003ce4:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003ce6:	99ca                	add	s3,s3,s2
    80003ce8:	77fd                	lui	a5,0xfffff
    80003cea:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003cee:	4691                	li	a3,4
    80003cf0:	6609                	lui	a2,0x2
    80003cf2:	964e                	add	a2,a2,s3
    80003cf4:	85ce                	mv	a1,s3
    80003cf6:	855a                	mv	a0,s6
    80003cf8:	bebfc0ef          	jal	800008e2 <uvmalloc>
    80003cfc:	8a2a                	mv	s4,a0
    80003cfe:	e105                	bnez	a0,80003d1e <exec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003d00:	85ce                	mv	a1,s3
    80003d02:	855a                	mv	a0,s6
    80003d04:	b7efd0ef          	jal	80001082 <proc_freepagetable>
  return -1;
    80003d08:	557d                	li	a0,-1
    80003d0a:	79fe                	ld	s3,504(sp)
    80003d0c:	7a5e                	ld	s4,496(sp)
    80003d0e:	7abe                	ld	s5,488(sp)
    80003d10:	7b1e                	ld	s6,480(sp)
    80003d12:	6bfe                	ld	s7,472(sp)
    80003d14:	6c5e                	ld	s8,464(sp)
    80003d16:	6cbe                	ld	s9,456(sp)
    80003d18:	6d1e                	ld	s10,448(sp)
    80003d1a:	7dfa                	ld	s11,440(sp)
    80003d1c:	b541                	j	80003b9c <exec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003d1e:	75f9                	lui	a1,0xffffe
    80003d20:	95aa                	add	a1,a1,a0
    80003d22:	855a                	mv	a0,s6
    80003d24:	886fd0ef          	jal	80000daa <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003d28:	7bfd                	lui	s7,0xfffff
    80003d2a:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80003d2c:	e0043783          	ld	a5,-512(s0)
    80003d30:	6388                	ld	a0,0(a5)
  sp = sz;
    80003d32:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003d34:	4481                	li	s1,0
    ustack[argc] = sp;
    80003d36:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003d3a:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003d3e:	cd21                	beqz	a0,80003d96 <exec+0x26c>
    sp -= strlen(argv[argc]) + 1;
    80003d40:	e84fc0ef          	jal	800003c4 <strlen>
    80003d44:	0015079b          	addiw	a5,a0,1
    80003d48:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003d4c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003d50:	13796563          	bltu	s2,s7,80003e7a <exec+0x350>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003d54:	e0043d83          	ld	s11,-512(s0)
    80003d58:	000db983          	ld	s3,0(s11)
    80003d5c:	854e                	mv	a0,s3
    80003d5e:	e66fc0ef          	jal	800003c4 <strlen>
    80003d62:	0015069b          	addiw	a3,a0,1
    80003d66:	864e                	mv	a2,s3
    80003d68:	85ca                	mv	a1,s2
    80003d6a:	855a                	mv	a0,s6
    80003d6c:	f5dfc0ef          	jal	80000cc8 <copyout>
    80003d70:	10054763          	bltz	a0,80003e7e <exec+0x354>
    ustack[argc] = sp;
    80003d74:	00349793          	slli	a5,s1,0x3
    80003d78:	97e6                	add	a5,a5,s9
    80003d7a:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7fdbb910>
  for(argc = 0; argv[argc]; argc++) {
    80003d7e:	0485                	addi	s1,s1,1
    80003d80:	008d8793          	addi	a5,s11,8
    80003d84:	e0f43023          	sd	a5,-512(s0)
    80003d88:	008db503          	ld	a0,8(s11)
    80003d8c:	c509                	beqz	a0,80003d96 <exec+0x26c>
    if(argc >= MAXARG)
    80003d8e:	fb8499e3          	bne	s1,s8,80003d40 <exec+0x216>
  sz = sz1;
    80003d92:	89d2                	mv	s3,s4
    80003d94:	b7b5                	j	80003d00 <exec+0x1d6>
  ustack[argc] = 0;
    80003d96:	00349793          	slli	a5,s1,0x3
    80003d9a:	f9078793          	addi	a5,a5,-112
    80003d9e:	97a2                	add	a5,a5,s0
    80003da0:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003da4:	00148693          	addi	a3,s1,1
    80003da8:	068e                	slli	a3,a3,0x3
    80003daa:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003dae:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003db2:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80003db4:	f57966e3          	bltu	s2,s7,80003d00 <exec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003db8:	e9040613          	addi	a2,s0,-368
    80003dbc:	85ca                	mv	a1,s2
    80003dbe:	855a                	mv	a0,s6
    80003dc0:	f09fc0ef          	jal	80000cc8 <copyout>
    80003dc4:	f2054ee3          	bltz	a0,80003d00 <exec+0x1d6>
  p->trapframe->a1 = sp;
    80003dc8:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003dcc:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003dd0:	df043783          	ld	a5,-528(s0)
    80003dd4:	0007c703          	lbu	a4,0(a5)
    80003dd8:	cf11                	beqz	a4,80003df4 <exec+0x2ca>
    80003dda:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003ddc:	02f00693          	li	a3,47
    80003de0:	a029                	j	80003dea <exec+0x2c0>
  for(last=s=path; *s; s++)
    80003de2:	0785                	addi	a5,a5,1
    80003de4:	fff7c703          	lbu	a4,-1(a5)
    80003de8:	c711                	beqz	a4,80003df4 <exec+0x2ca>
    if(*s == '/')
    80003dea:	fed71ce3          	bne	a4,a3,80003de2 <exec+0x2b8>
      last = s+1;
    80003dee:	def43823          	sd	a5,-528(s0)
    80003df2:	bfc5                	j	80003de2 <exec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    80003df4:	4641                	li	a2,16
    80003df6:	df043583          	ld	a1,-528(s0)
    80003dfa:	158a8513          	addi	a0,s5,344
    80003dfe:	d90fc0ef          	jal	8000038e <safestrcpy>
  oldpagetable = p->pagetable;
    80003e02:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003e06:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003e0a:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003e0e:	058ab783          	ld	a5,88(s5)
    80003e12:	e6843703          	ld	a4,-408(s0)
    80003e16:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003e18:	058ab783          	ld	a5,88(s5)
    80003e1c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003e20:	85ea                	mv	a1,s10
    80003e22:	a60fd0ef          	jal	80001082 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003e26:	0004851b          	sext.w	a0,s1
    80003e2a:	79fe                	ld	s3,504(sp)
    80003e2c:	7a5e                	ld	s4,496(sp)
    80003e2e:	7abe                	ld	s5,488(sp)
    80003e30:	7b1e                	ld	s6,480(sp)
    80003e32:	6bfe                	ld	s7,472(sp)
    80003e34:	6c5e                	ld	s8,464(sp)
    80003e36:	6cbe                	ld	s9,456(sp)
    80003e38:	6d1e                	ld	s10,448(sp)
    80003e3a:	7dfa                	ld	s11,440(sp)
    80003e3c:	b385                	j	80003b9c <exec+0x72>
    80003e3e:	7b1e                	ld	s6,480(sp)
    80003e40:	b3b9                	j	80003b8e <exec+0x64>
    80003e42:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003e46:	df843583          	ld	a1,-520(s0)
    80003e4a:	855a                	mv	a0,s6
    80003e4c:	a36fd0ef          	jal	80001082 <proc_freepagetable>
  if(ip){
    80003e50:	79fe                	ld	s3,504(sp)
    80003e52:	7abe                	ld	s5,488(sp)
    80003e54:	7b1e                	ld	s6,480(sp)
    80003e56:	6bfe                	ld	s7,472(sp)
    80003e58:	6c5e                	ld	s8,464(sp)
    80003e5a:	6cbe                	ld	s9,456(sp)
    80003e5c:	6d1e                	ld	s10,448(sp)
    80003e5e:	7dfa                	ld	s11,440(sp)
    80003e60:	b33d                	j	80003b8e <exec+0x64>
    80003e62:	df243c23          	sd	s2,-520(s0)
    80003e66:	b7c5                	j	80003e46 <exec+0x31c>
    80003e68:	df243c23          	sd	s2,-520(s0)
    80003e6c:	bfe9                	j	80003e46 <exec+0x31c>
    80003e6e:	df243c23          	sd	s2,-520(s0)
    80003e72:	bfd1                	j	80003e46 <exec+0x31c>
    80003e74:	df243c23          	sd	s2,-520(s0)
    80003e78:	b7f9                	j	80003e46 <exec+0x31c>
  sz = sz1;
    80003e7a:	89d2                	mv	s3,s4
    80003e7c:	b551                	j	80003d00 <exec+0x1d6>
    80003e7e:	89d2                	mv	s3,s4
    80003e80:	b541                	j	80003d00 <exec+0x1d6>

0000000080003e82 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003e82:	7179                	addi	sp,sp,-48
    80003e84:	f406                	sd	ra,40(sp)
    80003e86:	f022                	sd	s0,32(sp)
    80003e88:	ec26                	sd	s1,24(sp)
    80003e8a:	e84a                	sd	s2,16(sp)
    80003e8c:	1800                	addi	s0,sp,48
    80003e8e:	892e                	mv	s2,a1
    80003e90:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003e92:	fdc40593          	addi	a1,s0,-36
    80003e96:	f93fd0ef          	jal	80001e28 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003e9a:	fdc42703          	lw	a4,-36(s0)
    80003e9e:	47bd                	li	a5,15
    80003ea0:	02e7e963          	bltu	a5,a4,80003ed2 <argfd+0x50>
    80003ea4:	8b2fd0ef          	jal	80000f56 <myproc>
    80003ea8:	fdc42703          	lw	a4,-36(s0)
    80003eac:	01a70793          	addi	a5,a4,26
    80003eb0:	078e                	slli	a5,a5,0x3
    80003eb2:	953e                	add	a0,a0,a5
    80003eb4:	611c                	ld	a5,0(a0)
    80003eb6:	c385                	beqz	a5,80003ed6 <argfd+0x54>
    return -1;
  if(pfd)
    80003eb8:	00090463          	beqz	s2,80003ec0 <argfd+0x3e>
    *pfd = fd;
    80003ebc:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003ec0:	4501                	li	a0,0
  if(pf)
    80003ec2:	c091                	beqz	s1,80003ec6 <argfd+0x44>
    *pf = f;
    80003ec4:	e09c                	sd	a5,0(s1)
}
    80003ec6:	70a2                	ld	ra,40(sp)
    80003ec8:	7402                	ld	s0,32(sp)
    80003eca:	64e2                	ld	s1,24(sp)
    80003ecc:	6942                	ld	s2,16(sp)
    80003ece:	6145                	addi	sp,sp,48
    80003ed0:	8082                	ret
    return -1;
    80003ed2:	557d                	li	a0,-1
    80003ed4:	bfcd                	j	80003ec6 <argfd+0x44>
    80003ed6:	557d                	li	a0,-1
    80003ed8:	b7fd                	j	80003ec6 <argfd+0x44>

0000000080003eda <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003eda:	1101                	addi	sp,sp,-32
    80003edc:	ec06                	sd	ra,24(sp)
    80003ede:	e822                	sd	s0,16(sp)
    80003ee0:	e426                	sd	s1,8(sp)
    80003ee2:	1000                	addi	s0,sp,32
    80003ee4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003ee6:	870fd0ef          	jal	80000f56 <myproc>
    80003eea:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003eec:	0d050793          	addi	a5,a0,208
    80003ef0:	4501                	li	a0,0
    80003ef2:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003ef4:	6398                	ld	a4,0(a5)
    80003ef6:	cb19                	beqz	a4,80003f0c <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003ef8:	2505                	addiw	a0,a0,1
    80003efa:	07a1                	addi	a5,a5,8
    80003efc:	fed51ce3          	bne	a0,a3,80003ef4 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003f00:	557d                	li	a0,-1
}
    80003f02:	60e2                	ld	ra,24(sp)
    80003f04:	6442                	ld	s0,16(sp)
    80003f06:	64a2                	ld	s1,8(sp)
    80003f08:	6105                	addi	sp,sp,32
    80003f0a:	8082                	ret
      p->ofile[fd] = f;
    80003f0c:	01a50793          	addi	a5,a0,26
    80003f10:	078e                	slli	a5,a5,0x3
    80003f12:	963e                	add	a2,a2,a5
    80003f14:	e204                	sd	s1,0(a2)
      return fd;
    80003f16:	b7f5                	j	80003f02 <fdalloc+0x28>

0000000080003f18 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003f18:	715d                	addi	sp,sp,-80
    80003f1a:	e486                	sd	ra,72(sp)
    80003f1c:	e0a2                	sd	s0,64(sp)
    80003f1e:	fc26                	sd	s1,56(sp)
    80003f20:	f84a                	sd	s2,48(sp)
    80003f22:	f44e                	sd	s3,40(sp)
    80003f24:	ec56                	sd	s5,24(sp)
    80003f26:	e85a                	sd	s6,16(sp)
    80003f28:	0880                	addi	s0,sp,80
    80003f2a:	8b2e                	mv	s6,a1
    80003f2c:	89b2                	mv	s3,a2
    80003f2e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003f30:	fb040593          	addi	a1,s0,-80
    80003f34:	ffdfe0ef          	jal	80002f30 <nameiparent>
    80003f38:	84aa                	mv	s1,a0
    80003f3a:	10050a63          	beqz	a0,8000404e <create+0x136>
    return 0;

  ilock(dp);
    80003f3e:	8e9fe0ef          	jal	80002826 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003f42:	4601                	li	a2,0
    80003f44:	fb040593          	addi	a1,s0,-80
    80003f48:	8526                	mv	a0,s1
    80003f4a:	d41fe0ef          	jal	80002c8a <dirlookup>
    80003f4e:	8aaa                	mv	s5,a0
    80003f50:	c129                	beqz	a0,80003f92 <create+0x7a>
    iunlockput(dp);
    80003f52:	8526                	mv	a0,s1
    80003f54:	addfe0ef          	jal	80002a30 <iunlockput>
    ilock(ip);
    80003f58:	8556                	mv	a0,s5
    80003f5a:	8cdfe0ef          	jal	80002826 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003f5e:	4789                	li	a5,2
    80003f60:	02fb1463          	bne	s6,a5,80003f88 <create+0x70>
    80003f64:	044ad783          	lhu	a5,68(s5)
    80003f68:	37f9                	addiw	a5,a5,-2
    80003f6a:	17c2                	slli	a5,a5,0x30
    80003f6c:	93c1                	srli	a5,a5,0x30
    80003f6e:	4705                	li	a4,1
    80003f70:	00f76c63          	bltu	a4,a5,80003f88 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003f74:	8556                	mv	a0,s5
    80003f76:	60a6                	ld	ra,72(sp)
    80003f78:	6406                	ld	s0,64(sp)
    80003f7a:	74e2                	ld	s1,56(sp)
    80003f7c:	7942                	ld	s2,48(sp)
    80003f7e:	79a2                	ld	s3,40(sp)
    80003f80:	6ae2                	ld	s5,24(sp)
    80003f82:	6b42                	ld	s6,16(sp)
    80003f84:	6161                	addi	sp,sp,80
    80003f86:	8082                	ret
    iunlockput(ip);
    80003f88:	8556                	mv	a0,s5
    80003f8a:	aa7fe0ef          	jal	80002a30 <iunlockput>
    return 0;
    80003f8e:	4a81                	li	s5,0
    80003f90:	b7d5                	j	80003f74 <create+0x5c>
    80003f92:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003f94:	85da                	mv	a1,s6
    80003f96:	4088                	lw	a0,0(s1)
    80003f98:	f1efe0ef          	jal	800026b6 <ialloc>
    80003f9c:	8a2a                	mv	s4,a0
    80003f9e:	cd15                	beqz	a0,80003fda <create+0xc2>
  ilock(ip);
    80003fa0:	887fe0ef          	jal	80002826 <ilock>
  ip->major = major;
    80003fa4:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003fa8:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003fac:	4905                	li	s2,1
    80003fae:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003fb2:	8552                	mv	a0,s4
    80003fb4:	fbefe0ef          	jal	80002772 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003fb8:	032b0763          	beq	s6,s2,80003fe6 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003fbc:	004a2603          	lw	a2,4(s4)
    80003fc0:	fb040593          	addi	a1,s0,-80
    80003fc4:	8526                	mv	a0,s1
    80003fc6:	ea7fe0ef          	jal	80002e6c <dirlink>
    80003fca:	06054563          	bltz	a0,80004034 <create+0x11c>
  iunlockput(dp);
    80003fce:	8526                	mv	a0,s1
    80003fd0:	a61fe0ef          	jal	80002a30 <iunlockput>
  return ip;
    80003fd4:	8ad2                	mv	s5,s4
    80003fd6:	7a02                	ld	s4,32(sp)
    80003fd8:	bf71                	j	80003f74 <create+0x5c>
    iunlockput(dp);
    80003fda:	8526                	mv	a0,s1
    80003fdc:	a55fe0ef          	jal	80002a30 <iunlockput>
    return 0;
    80003fe0:	8ad2                	mv	s5,s4
    80003fe2:	7a02                	ld	s4,32(sp)
    80003fe4:	bf41                	j	80003f74 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003fe6:	004a2603          	lw	a2,4(s4)
    80003fea:	00003597          	auipc	a1,0x3
    80003fee:	60e58593          	addi	a1,a1,1550 # 800075f8 <etext+0x5f8>
    80003ff2:	8552                	mv	a0,s4
    80003ff4:	e79fe0ef          	jal	80002e6c <dirlink>
    80003ff8:	02054e63          	bltz	a0,80004034 <create+0x11c>
    80003ffc:	40d0                	lw	a2,4(s1)
    80003ffe:	00003597          	auipc	a1,0x3
    80004002:	60258593          	addi	a1,a1,1538 # 80007600 <etext+0x600>
    80004006:	8552                	mv	a0,s4
    80004008:	e65fe0ef          	jal	80002e6c <dirlink>
    8000400c:	02054463          	bltz	a0,80004034 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004010:	004a2603          	lw	a2,4(s4)
    80004014:	fb040593          	addi	a1,s0,-80
    80004018:	8526                	mv	a0,s1
    8000401a:	e53fe0ef          	jal	80002e6c <dirlink>
    8000401e:	00054b63          	bltz	a0,80004034 <create+0x11c>
    dp->nlink++;  // for ".."
    80004022:	04a4d783          	lhu	a5,74(s1)
    80004026:	2785                	addiw	a5,a5,1
    80004028:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000402c:	8526                	mv	a0,s1
    8000402e:	f44fe0ef          	jal	80002772 <iupdate>
    80004032:	bf71                	j	80003fce <create+0xb6>
  ip->nlink = 0;
    80004034:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004038:	8552                	mv	a0,s4
    8000403a:	f38fe0ef          	jal	80002772 <iupdate>
  iunlockput(ip);
    8000403e:	8552                	mv	a0,s4
    80004040:	9f1fe0ef          	jal	80002a30 <iunlockput>
  iunlockput(dp);
    80004044:	8526                	mv	a0,s1
    80004046:	9ebfe0ef          	jal	80002a30 <iunlockput>
  return 0;
    8000404a:	7a02                	ld	s4,32(sp)
    8000404c:	b725                	j	80003f74 <create+0x5c>
    return 0;
    8000404e:	8aaa                	mv	s5,a0
    80004050:	b715                	j	80003f74 <create+0x5c>

0000000080004052 <sys_dup>:
{
    80004052:	7179                	addi	sp,sp,-48
    80004054:	f406                	sd	ra,40(sp)
    80004056:	f022                	sd	s0,32(sp)
    80004058:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000405a:	fd840613          	addi	a2,s0,-40
    8000405e:	4581                	li	a1,0
    80004060:	4501                	li	a0,0
    80004062:	e21ff0ef          	jal	80003e82 <argfd>
    return -1;
    80004066:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004068:	02054363          	bltz	a0,8000408e <sys_dup+0x3c>
    8000406c:	ec26                	sd	s1,24(sp)
    8000406e:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004070:	fd843903          	ld	s2,-40(s0)
    80004074:	854a                	mv	a0,s2
    80004076:	e65ff0ef          	jal	80003eda <fdalloc>
    8000407a:	84aa                	mv	s1,a0
    return -1;
    8000407c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000407e:	00054d63          	bltz	a0,80004098 <sys_dup+0x46>
  filedup(f);
    80004082:	854a                	mv	a0,s2
    80004084:	c2eff0ef          	jal	800034b2 <filedup>
  return fd;
    80004088:	87a6                	mv	a5,s1
    8000408a:	64e2                	ld	s1,24(sp)
    8000408c:	6942                	ld	s2,16(sp)
}
    8000408e:	853e                	mv	a0,a5
    80004090:	70a2                	ld	ra,40(sp)
    80004092:	7402                	ld	s0,32(sp)
    80004094:	6145                	addi	sp,sp,48
    80004096:	8082                	ret
    80004098:	64e2                	ld	s1,24(sp)
    8000409a:	6942                	ld	s2,16(sp)
    8000409c:	bfcd                	j	8000408e <sys_dup+0x3c>

000000008000409e <sys_read>:
{
    8000409e:	7179                	addi	sp,sp,-48
    800040a0:	f406                	sd	ra,40(sp)
    800040a2:	f022                	sd	s0,32(sp)
    800040a4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800040a6:	fd840593          	addi	a1,s0,-40
    800040aa:	4505                	li	a0,1
    800040ac:	d99fd0ef          	jal	80001e44 <argaddr>
  argint(2, &n);
    800040b0:	fe440593          	addi	a1,s0,-28
    800040b4:	4509                	li	a0,2
    800040b6:	d73fd0ef          	jal	80001e28 <argint>
  if(argfd(0, 0, &f) < 0)
    800040ba:	fe840613          	addi	a2,s0,-24
    800040be:	4581                	li	a1,0
    800040c0:	4501                	li	a0,0
    800040c2:	dc1ff0ef          	jal	80003e82 <argfd>
    800040c6:	87aa                	mv	a5,a0
    return -1;
    800040c8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800040ca:	0007ca63          	bltz	a5,800040de <sys_read+0x40>
  return fileread(f, p, n);
    800040ce:	fe442603          	lw	a2,-28(s0)
    800040d2:	fd843583          	ld	a1,-40(s0)
    800040d6:	fe843503          	ld	a0,-24(s0)
    800040da:	d3eff0ef          	jal	80003618 <fileread>
}
    800040de:	70a2                	ld	ra,40(sp)
    800040e0:	7402                	ld	s0,32(sp)
    800040e2:	6145                	addi	sp,sp,48
    800040e4:	8082                	ret

00000000800040e6 <sys_write>:
{
    800040e6:	7179                	addi	sp,sp,-48
    800040e8:	f406                	sd	ra,40(sp)
    800040ea:	f022                	sd	s0,32(sp)
    800040ec:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800040ee:	fd840593          	addi	a1,s0,-40
    800040f2:	4505                	li	a0,1
    800040f4:	d51fd0ef          	jal	80001e44 <argaddr>
  argint(2, &n);
    800040f8:	fe440593          	addi	a1,s0,-28
    800040fc:	4509                	li	a0,2
    800040fe:	d2bfd0ef          	jal	80001e28 <argint>
  if(argfd(0, 0, &f) < 0)
    80004102:	fe840613          	addi	a2,s0,-24
    80004106:	4581                	li	a1,0
    80004108:	4501                	li	a0,0
    8000410a:	d79ff0ef          	jal	80003e82 <argfd>
    8000410e:	87aa                	mv	a5,a0
    return -1;
    80004110:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004112:	0007ca63          	bltz	a5,80004126 <sys_write+0x40>
  return filewrite(f, p, n);
    80004116:	fe442603          	lw	a2,-28(s0)
    8000411a:	fd843583          	ld	a1,-40(s0)
    8000411e:	fe843503          	ld	a0,-24(s0)
    80004122:	db4ff0ef          	jal	800036d6 <filewrite>
}
    80004126:	70a2                	ld	ra,40(sp)
    80004128:	7402                	ld	s0,32(sp)
    8000412a:	6145                	addi	sp,sp,48
    8000412c:	8082                	ret

000000008000412e <sys_close>:
{
    8000412e:	1101                	addi	sp,sp,-32
    80004130:	ec06                	sd	ra,24(sp)
    80004132:	e822                	sd	s0,16(sp)
    80004134:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004136:	fe040613          	addi	a2,s0,-32
    8000413a:	fec40593          	addi	a1,s0,-20
    8000413e:	4501                	li	a0,0
    80004140:	d43ff0ef          	jal	80003e82 <argfd>
    return -1;
    80004144:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004146:	02054063          	bltz	a0,80004166 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    8000414a:	e0dfc0ef          	jal	80000f56 <myproc>
    8000414e:	fec42783          	lw	a5,-20(s0)
    80004152:	07e9                	addi	a5,a5,26
    80004154:	078e                	slli	a5,a5,0x3
    80004156:	953e                	add	a0,a0,a5
    80004158:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000415c:	fe043503          	ld	a0,-32(s0)
    80004160:	b98ff0ef          	jal	800034f8 <fileclose>
  return 0;
    80004164:	4781                	li	a5,0
}
    80004166:	853e                	mv	a0,a5
    80004168:	60e2                	ld	ra,24(sp)
    8000416a:	6442                	ld	s0,16(sp)
    8000416c:	6105                	addi	sp,sp,32
    8000416e:	8082                	ret

0000000080004170 <sys_fstat>:
{
    80004170:	1101                	addi	sp,sp,-32
    80004172:	ec06                	sd	ra,24(sp)
    80004174:	e822                	sd	s0,16(sp)
    80004176:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004178:	fe040593          	addi	a1,s0,-32
    8000417c:	4505                	li	a0,1
    8000417e:	cc7fd0ef          	jal	80001e44 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004182:	fe840613          	addi	a2,s0,-24
    80004186:	4581                	li	a1,0
    80004188:	4501                	li	a0,0
    8000418a:	cf9ff0ef          	jal	80003e82 <argfd>
    8000418e:	87aa                	mv	a5,a0
    return -1;
    80004190:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004192:	0007c863          	bltz	a5,800041a2 <sys_fstat+0x32>
  return filestat(f, st);
    80004196:	fe043583          	ld	a1,-32(s0)
    8000419a:	fe843503          	ld	a0,-24(s0)
    8000419e:	c18ff0ef          	jal	800035b6 <filestat>
}
    800041a2:	60e2                	ld	ra,24(sp)
    800041a4:	6442                	ld	s0,16(sp)
    800041a6:	6105                	addi	sp,sp,32
    800041a8:	8082                	ret

00000000800041aa <sys_link>:
{
    800041aa:	7169                	addi	sp,sp,-304
    800041ac:	f606                	sd	ra,296(sp)
    800041ae:	f222                	sd	s0,288(sp)
    800041b0:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800041b2:	08000613          	li	a2,128
    800041b6:	ed040593          	addi	a1,s0,-304
    800041ba:	4501                	li	a0,0
    800041bc:	ca5fd0ef          	jal	80001e60 <argstr>
    return -1;
    800041c0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800041c2:	0c054e63          	bltz	a0,8000429e <sys_link+0xf4>
    800041c6:	08000613          	li	a2,128
    800041ca:	f5040593          	addi	a1,s0,-176
    800041ce:	4505                	li	a0,1
    800041d0:	c91fd0ef          	jal	80001e60 <argstr>
    return -1;
    800041d4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800041d6:	0c054463          	bltz	a0,8000429e <sys_link+0xf4>
    800041da:	ee26                	sd	s1,280(sp)
  begin_op();
    800041dc:	efdfe0ef          	jal	800030d8 <begin_op>
  if((ip = namei(old)) == 0){
    800041e0:	ed040513          	addi	a0,s0,-304
    800041e4:	d33fe0ef          	jal	80002f16 <namei>
    800041e8:	84aa                	mv	s1,a0
    800041ea:	c53d                	beqz	a0,80004258 <sys_link+0xae>
  ilock(ip);
    800041ec:	e3afe0ef          	jal	80002826 <ilock>
  if(ip->type == T_DIR){
    800041f0:	04449703          	lh	a4,68(s1)
    800041f4:	4785                	li	a5,1
    800041f6:	06f70663          	beq	a4,a5,80004262 <sys_link+0xb8>
    800041fa:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800041fc:	04a4d783          	lhu	a5,74(s1)
    80004200:	2785                	addiw	a5,a5,1
    80004202:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004206:	8526                	mv	a0,s1
    80004208:	d6afe0ef          	jal	80002772 <iupdate>
  iunlock(ip);
    8000420c:	8526                	mv	a0,s1
    8000420e:	ec6fe0ef          	jal	800028d4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004212:	fd040593          	addi	a1,s0,-48
    80004216:	f5040513          	addi	a0,s0,-176
    8000421a:	d17fe0ef          	jal	80002f30 <nameiparent>
    8000421e:	892a                	mv	s2,a0
    80004220:	cd21                	beqz	a0,80004278 <sys_link+0xce>
  ilock(dp);
    80004222:	e04fe0ef          	jal	80002826 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004226:	00092703          	lw	a4,0(s2)
    8000422a:	409c                	lw	a5,0(s1)
    8000422c:	04f71363          	bne	a4,a5,80004272 <sys_link+0xc8>
    80004230:	40d0                	lw	a2,4(s1)
    80004232:	fd040593          	addi	a1,s0,-48
    80004236:	854a                	mv	a0,s2
    80004238:	c35fe0ef          	jal	80002e6c <dirlink>
    8000423c:	02054b63          	bltz	a0,80004272 <sys_link+0xc8>
  iunlockput(dp);
    80004240:	854a                	mv	a0,s2
    80004242:	feefe0ef          	jal	80002a30 <iunlockput>
  iput(ip);
    80004246:	8526                	mv	a0,s1
    80004248:	f60fe0ef          	jal	800029a8 <iput>
  end_op();
    8000424c:	ef7fe0ef          	jal	80003142 <end_op>
  return 0;
    80004250:	4781                	li	a5,0
    80004252:	64f2                	ld	s1,280(sp)
    80004254:	6952                	ld	s2,272(sp)
    80004256:	a0a1                	j	8000429e <sys_link+0xf4>
    end_op();
    80004258:	eebfe0ef          	jal	80003142 <end_op>
    return -1;
    8000425c:	57fd                	li	a5,-1
    8000425e:	64f2                	ld	s1,280(sp)
    80004260:	a83d                	j	8000429e <sys_link+0xf4>
    iunlockput(ip);
    80004262:	8526                	mv	a0,s1
    80004264:	fccfe0ef          	jal	80002a30 <iunlockput>
    end_op();
    80004268:	edbfe0ef          	jal	80003142 <end_op>
    return -1;
    8000426c:	57fd                	li	a5,-1
    8000426e:	64f2                	ld	s1,280(sp)
    80004270:	a03d                	j	8000429e <sys_link+0xf4>
    iunlockput(dp);
    80004272:	854a                	mv	a0,s2
    80004274:	fbcfe0ef          	jal	80002a30 <iunlockput>
  ilock(ip);
    80004278:	8526                	mv	a0,s1
    8000427a:	dacfe0ef          	jal	80002826 <ilock>
  ip->nlink--;
    8000427e:	04a4d783          	lhu	a5,74(s1)
    80004282:	37fd                	addiw	a5,a5,-1
    80004284:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004288:	8526                	mv	a0,s1
    8000428a:	ce8fe0ef          	jal	80002772 <iupdate>
  iunlockput(ip);
    8000428e:	8526                	mv	a0,s1
    80004290:	fa0fe0ef          	jal	80002a30 <iunlockput>
  end_op();
    80004294:	eaffe0ef          	jal	80003142 <end_op>
  return -1;
    80004298:	57fd                	li	a5,-1
    8000429a:	64f2                	ld	s1,280(sp)
    8000429c:	6952                	ld	s2,272(sp)
}
    8000429e:	853e                	mv	a0,a5
    800042a0:	70b2                	ld	ra,296(sp)
    800042a2:	7412                	ld	s0,288(sp)
    800042a4:	6155                	addi	sp,sp,304
    800042a6:	8082                	ret

00000000800042a8 <sys_unlink>:
{
    800042a8:	7111                	addi	sp,sp,-256
    800042aa:	fd86                	sd	ra,248(sp)
    800042ac:	f9a2                	sd	s0,240(sp)
    800042ae:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    800042b0:	08000613          	li	a2,128
    800042b4:	f2040593          	addi	a1,s0,-224
    800042b8:	4501                	li	a0,0
    800042ba:	ba7fd0ef          	jal	80001e60 <argstr>
    800042be:	16054663          	bltz	a0,8000442a <sys_unlink+0x182>
    800042c2:	f5a6                	sd	s1,232(sp)
  begin_op();
    800042c4:	e15fe0ef          	jal	800030d8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800042c8:	fa040593          	addi	a1,s0,-96
    800042cc:	f2040513          	addi	a0,s0,-224
    800042d0:	c61fe0ef          	jal	80002f30 <nameiparent>
    800042d4:	84aa                	mv	s1,a0
    800042d6:	c955                	beqz	a0,8000438a <sys_unlink+0xe2>
  ilock(dp);
    800042d8:	d4efe0ef          	jal	80002826 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800042dc:	00003597          	auipc	a1,0x3
    800042e0:	31c58593          	addi	a1,a1,796 # 800075f8 <etext+0x5f8>
    800042e4:	fa040513          	addi	a0,s0,-96
    800042e8:	98dfe0ef          	jal	80002c74 <namecmp>
    800042ec:	12050463          	beqz	a0,80004414 <sys_unlink+0x16c>
    800042f0:	00003597          	auipc	a1,0x3
    800042f4:	31058593          	addi	a1,a1,784 # 80007600 <etext+0x600>
    800042f8:	fa040513          	addi	a0,s0,-96
    800042fc:	979fe0ef          	jal	80002c74 <namecmp>
    80004300:	10050a63          	beqz	a0,80004414 <sys_unlink+0x16c>
    80004304:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004306:	f1c40613          	addi	a2,s0,-228
    8000430a:	fa040593          	addi	a1,s0,-96
    8000430e:	8526                	mv	a0,s1
    80004310:	97bfe0ef          	jal	80002c8a <dirlookup>
    80004314:	892a                	mv	s2,a0
    80004316:	0e050e63          	beqz	a0,80004412 <sys_unlink+0x16a>
    8000431a:	edce                	sd	s3,216(sp)
  ilock(ip);
    8000431c:	d0afe0ef          	jal	80002826 <ilock>
  if(ip->nlink < 1)
    80004320:	04a91783          	lh	a5,74(s2)
    80004324:	06f05863          	blez	a5,80004394 <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004328:	04491703          	lh	a4,68(s2)
    8000432c:	4785                	li	a5,1
    8000432e:	06f70b63          	beq	a4,a5,800043a4 <sys_unlink+0xfc>
  memset(&de, 0, sizeof(de));
    80004332:	fb040993          	addi	s3,s0,-80
    80004336:	4641                	li	a2,16
    80004338:	4581                	li	a1,0
    8000433a:	854e                	mv	a0,s3
    8000433c:	f01fb0ef          	jal	8000023c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004340:	4741                	li	a4,16
    80004342:	f1c42683          	lw	a3,-228(s0)
    80004346:	864e                	mv	a2,s3
    80004348:	4581                	li	a1,0
    8000434a:	8526                	mv	a0,s1
    8000434c:	825fe0ef          	jal	80002b70 <writei>
    80004350:	47c1                	li	a5,16
    80004352:	08f51f63          	bne	a0,a5,800043f0 <sys_unlink+0x148>
  if(ip->type == T_DIR){
    80004356:	04491703          	lh	a4,68(s2)
    8000435a:	4785                	li	a5,1
    8000435c:	0af70263          	beq	a4,a5,80004400 <sys_unlink+0x158>
  iunlockput(dp);
    80004360:	8526                	mv	a0,s1
    80004362:	ecefe0ef          	jal	80002a30 <iunlockput>
  ip->nlink--;
    80004366:	04a95783          	lhu	a5,74(s2)
    8000436a:	37fd                	addiw	a5,a5,-1
    8000436c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004370:	854a                	mv	a0,s2
    80004372:	c00fe0ef          	jal	80002772 <iupdate>
  iunlockput(ip);
    80004376:	854a                	mv	a0,s2
    80004378:	eb8fe0ef          	jal	80002a30 <iunlockput>
  end_op();
    8000437c:	dc7fe0ef          	jal	80003142 <end_op>
  return 0;
    80004380:	4501                	li	a0,0
    80004382:	74ae                	ld	s1,232(sp)
    80004384:	790e                	ld	s2,224(sp)
    80004386:	69ee                	ld	s3,216(sp)
    80004388:	a869                	j	80004422 <sys_unlink+0x17a>
    end_op();
    8000438a:	db9fe0ef          	jal	80003142 <end_op>
    return -1;
    8000438e:	557d                	li	a0,-1
    80004390:	74ae                	ld	s1,232(sp)
    80004392:	a841                	j	80004422 <sys_unlink+0x17a>
    80004394:	e9d2                	sd	s4,208(sp)
    80004396:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80004398:	00003517          	auipc	a0,0x3
    8000439c:	27050513          	addi	a0,a0,624 # 80007608 <etext+0x608>
    800043a0:	276010ef          	jal	80005616 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800043a4:	04c92703          	lw	a4,76(s2)
    800043a8:	02000793          	li	a5,32
    800043ac:	f8e7f3e3          	bgeu	a5,a4,80004332 <sys_unlink+0x8a>
    800043b0:	e9d2                	sd	s4,208(sp)
    800043b2:	e5d6                	sd	s5,200(sp)
    800043b4:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043b6:	f0840a93          	addi	s5,s0,-248
    800043ba:	4a41                	li	s4,16
    800043bc:	8752                	mv	a4,s4
    800043be:	86ce                	mv	a3,s3
    800043c0:	8656                	mv	a2,s5
    800043c2:	4581                	li	a1,0
    800043c4:	854a                	mv	a0,s2
    800043c6:	eb8fe0ef          	jal	80002a7e <readi>
    800043ca:	01451d63          	bne	a0,s4,800043e4 <sys_unlink+0x13c>
    if(de.inum != 0)
    800043ce:	f0845783          	lhu	a5,-248(s0)
    800043d2:	efb1                	bnez	a5,8000442e <sys_unlink+0x186>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800043d4:	29c1                	addiw	s3,s3,16
    800043d6:	04c92783          	lw	a5,76(s2)
    800043da:	fef9e1e3          	bltu	s3,a5,800043bc <sys_unlink+0x114>
    800043de:	6a4e                	ld	s4,208(sp)
    800043e0:	6aae                	ld	s5,200(sp)
    800043e2:	bf81                	j	80004332 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800043e4:	00003517          	auipc	a0,0x3
    800043e8:	23c50513          	addi	a0,a0,572 # 80007620 <etext+0x620>
    800043ec:	22a010ef          	jal	80005616 <panic>
    800043f0:	e9d2                	sd	s4,208(sp)
    800043f2:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    800043f4:	00003517          	auipc	a0,0x3
    800043f8:	24450513          	addi	a0,a0,580 # 80007638 <etext+0x638>
    800043fc:	21a010ef          	jal	80005616 <panic>
    dp->nlink--;
    80004400:	04a4d783          	lhu	a5,74(s1)
    80004404:	37fd                	addiw	a5,a5,-1
    80004406:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000440a:	8526                	mv	a0,s1
    8000440c:	b66fe0ef          	jal	80002772 <iupdate>
    80004410:	bf81                	j	80004360 <sys_unlink+0xb8>
    80004412:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80004414:	8526                	mv	a0,s1
    80004416:	e1afe0ef          	jal	80002a30 <iunlockput>
  end_op();
    8000441a:	d29fe0ef          	jal	80003142 <end_op>
  return -1;
    8000441e:	557d                	li	a0,-1
    80004420:	74ae                	ld	s1,232(sp)
}
    80004422:	70ee                	ld	ra,248(sp)
    80004424:	744e                	ld	s0,240(sp)
    80004426:	6111                	addi	sp,sp,256
    80004428:	8082                	ret
    return -1;
    8000442a:	557d                	li	a0,-1
    8000442c:	bfdd                	j	80004422 <sys_unlink+0x17a>
    iunlockput(ip);
    8000442e:	854a                	mv	a0,s2
    80004430:	e00fe0ef          	jal	80002a30 <iunlockput>
    goto bad;
    80004434:	790e                	ld	s2,224(sp)
    80004436:	69ee                	ld	s3,216(sp)
    80004438:	6a4e                	ld	s4,208(sp)
    8000443a:	6aae                	ld	s5,200(sp)
    8000443c:	bfe1                	j	80004414 <sys_unlink+0x16c>

000000008000443e <sys_open>:

uint64
sys_open(void)
{
    8000443e:	7131                	addi	sp,sp,-192
    80004440:	fd06                	sd	ra,184(sp)
    80004442:	f922                	sd	s0,176(sp)
    80004444:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004446:	f4c40593          	addi	a1,s0,-180
    8000444a:	4505                	li	a0,1
    8000444c:	9ddfd0ef          	jal	80001e28 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004450:	08000613          	li	a2,128
    80004454:	f5040593          	addi	a1,s0,-176
    80004458:	4501                	li	a0,0
    8000445a:	a07fd0ef          	jal	80001e60 <argstr>
    8000445e:	87aa                	mv	a5,a0
    return -1;
    80004460:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004462:	0a07c363          	bltz	a5,80004508 <sys_open+0xca>
    80004466:	f526                	sd	s1,168(sp)

  begin_op();
    80004468:	c71fe0ef          	jal	800030d8 <begin_op>

  if(omode & O_CREATE){
    8000446c:	f4c42783          	lw	a5,-180(s0)
    80004470:	2007f793          	andi	a5,a5,512
    80004474:	c3dd                	beqz	a5,8000451a <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    80004476:	4681                	li	a3,0
    80004478:	4601                	li	a2,0
    8000447a:	4589                	li	a1,2
    8000447c:	f5040513          	addi	a0,s0,-176
    80004480:	a99ff0ef          	jal	80003f18 <create>
    80004484:	84aa                	mv	s1,a0
    if(ip == 0){
    80004486:	c549                	beqz	a0,80004510 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004488:	04449703          	lh	a4,68(s1)
    8000448c:	478d                	li	a5,3
    8000448e:	00f71763          	bne	a4,a5,8000449c <sys_open+0x5e>
    80004492:	0464d703          	lhu	a4,70(s1)
    80004496:	47a5                	li	a5,9
    80004498:	0ae7ee63          	bltu	a5,a4,80004554 <sys_open+0x116>
    8000449c:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000449e:	fb7fe0ef          	jal	80003454 <filealloc>
    800044a2:	892a                	mv	s2,a0
    800044a4:	c561                	beqz	a0,8000456c <sys_open+0x12e>
    800044a6:	ed4e                	sd	s3,152(sp)
    800044a8:	a33ff0ef          	jal	80003eda <fdalloc>
    800044ac:	89aa                	mv	s3,a0
    800044ae:	0a054b63          	bltz	a0,80004564 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800044b2:	04449703          	lh	a4,68(s1)
    800044b6:	478d                	li	a5,3
    800044b8:	0cf70363          	beq	a4,a5,8000457e <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800044bc:	4789                	li	a5,2
    800044be:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800044c2:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800044c6:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800044ca:	f4c42783          	lw	a5,-180(s0)
    800044ce:	0017f713          	andi	a4,a5,1
    800044d2:	00174713          	xori	a4,a4,1
    800044d6:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800044da:	0037f713          	andi	a4,a5,3
    800044de:	00e03733          	snez	a4,a4
    800044e2:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800044e6:	4007f793          	andi	a5,a5,1024
    800044ea:	c791                	beqz	a5,800044f6 <sys_open+0xb8>
    800044ec:	04449703          	lh	a4,68(s1)
    800044f0:	4789                	li	a5,2
    800044f2:	08f70d63          	beq	a4,a5,8000458c <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    800044f6:	8526                	mv	a0,s1
    800044f8:	bdcfe0ef          	jal	800028d4 <iunlock>
  end_op();
    800044fc:	c47fe0ef          	jal	80003142 <end_op>

  return fd;
    80004500:	854e                	mv	a0,s3
    80004502:	74aa                	ld	s1,168(sp)
    80004504:	790a                	ld	s2,160(sp)
    80004506:	69ea                	ld	s3,152(sp)
}
    80004508:	70ea                	ld	ra,184(sp)
    8000450a:	744a                	ld	s0,176(sp)
    8000450c:	6129                	addi	sp,sp,192
    8000450e:	8082                	ret
      end_op();
    80004510:	c33fe0ef          	jal	80003142 <end_op>
      return -1;
    80004514:	557d                	li	a0,-1
    80004516:	74aa                	ld	s1,168(sp)
    80004518:	bfc5                	j	80004508 <sys_open+0xca>
    if((ip = namei(path)) == 0){
    8000451a:	f5040513          	addi	a0,s0,-176
    8000451e:	9f9fe0ef          	jal	80002f16 <namei>
    80004522:	84aa                	mv	s1,a0
    80004524:	c11d                	beqz	a0,8000454a <sys_open+0x10c>
    ilock(ip);
    80004526:	b00fe0ef          	jal	80002826 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000452a:	04449703          	lh	a4,68(s1)
    8000452e:	4785                	li	a5,1
    80004530:	f4f71ce3          	bne	a4,a5,80004488 <sys_open+0x4a>
    80004534:	f4c42783          	lw	a5,-180(s0)
    80004538:	d3b5                	beqz	a5,8000449c <sys_open+0x5e>
      iunlockput(ip);
    8000453a:	8526                	mv	a0,s1
    8000453c:	cf4fe0ef          	jal	80002a30 <iunlockput>
      end_op();
    80004540:	c03fe0ef          	jal	80003142 <end_op>
      return -1;
    80004544:	557d                	li	a0,-1
    80004546:	74aa                	ld	s1,168(sp)
    80004548:	b7c1                	j	80004508 <sys_open+0xca>
      end_op();
    8000454a:	bf9fe0ef          	jal	80003142 <end_op>
      return -1;
    8000454e:	557d                	li	a0,-1
    80004550:	74aa                	ld	s1,168(sp)
    80004552:	bf5d                	j	80004508 <sys_open+0xca>
    iunlockput(ip);
    80004554:	8526                	mv	a0,s1
    80004556:	cdafe0ef          	jal	80002a30 <iunlockput>
    end_op();
    8000455a:	be9fe0ef          	jal	80003142 <end_op>
    return -1;
    8000455e:	557d                	li	a0,-1
    80004560:	74aa                	ld	s1,168(sp)
    80004562:	b75d                	j	80004508 <sys_open+0xca>
      fileclose(f);
    80004564:	854a                	mv	a0,s2
    80004566:	f93fe0ef          	jal	800034f8 <fileclose>
    8000456a:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000456c:	8526                	mv	a0,s1
    8000456e:	cc2fe0ef          	jal	80002a30 <iunlockput>
    end_op();
    80004572:	bd1fe0ef          	jal	80003142 <end_op>
    return -1;
    80004576:	557d                	li	a0,-1
    80004578:	74aa                	ld	s1,168(sp)
    8000457a:	790a                	ld	s2,160(sp)
    8000457c:	b771                	j	80004508 <sys_open+0xca>
    f->type = FD_DEVICE;
    8000457e:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004582:	04649783          	lh	a5,70(s1)
    80004586:	02f91223          	sh	a5,36(s2)
    8000458a:	bf35                	j	800044c6 <sys_open+0x88>
    itrunc(ip);
    8000458c:	8526                	mv	a0,s1
    8000458e:	b86fe0ef          	jal	80002914 <itrunc>
    80004592:	b795                	j	800044f6 <sys_open+0xb8>

0000000080004594 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004594:	7175                	addi	sp,sp,-144
    80004596:	e506                	sd	ra,136(sp)
    80004598:	e122                	sd	s0,128(sp)
    8000459a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000459c:	b3dfe0ef          	jal	800030d8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800045a0:	08000613          	li	a2,128
    800045a4:	f7040593          	addi	a1,s0,-144
    800045a8:	4501                	li	a0,0
    800045aa:	8b7fd0ef          	jal	80001e60 <argstr>
    800045ae:	02054363          	bltz	a0,800045d4 <sys_mkdir+0x40>
    800045b2:	4681                	li	a3,0
    800045b4:	4601                	li	a2,0
    800045b6:	4585                	li	a1,1
    800045b8:	f7040513          	addi	a0,s0,-144
    800045bc:	95dff0ef          	jal	80003f18 <create>
    800045c0:	c911                	beqz	a0,800045d4 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800045c2:	c6efe0ef          	jal	80002a30 <iunlockput>
  end_op();
    800045c6:	b7dfe0ef          	jal	80003142 <end_op>
  return 0;
    800045ca:	4501                	li	a0,0
}
    800045cc:	60aa                	ld	ra,136(sp)
    800045ce:	640a                	ld	s0,128(sp)
    800045d0:	6149                	addi	sp,sp,144
    800045d2:	8082                	ret
    end_op();
    800045d4:	b6ffe0ef          	jal	80003142 <end_op>
    return -1;
    800045d8:	557d                	li	a0,-1
    800045da:	bfcd                	j	800045cc <sys_mkdir+0x38>

00000000800045dc <sys_mknod>:

uint64
sys_mknod(void)
{
    800045dc:	7135                	addi	sp,sp,-160
    800045de:	ed06                	sd	ra,152(sp)
    800045e0:	e922                	sd	s0,144(sp)
    800045e2:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800045e4:	af5fe0ef          	jal	800030d8 <begin_op>
  argint(1, &major);
    800045e8:	f6c40593          	addi	a1,s0,-148
    800045ec:	4505                	li	a0,1
    800045ee:	83bfd0ef          	jal	80001e28 <argint>
  argint(2, &minor);
    800045f2:	f6840593          	addi	a1,s0,-152
    800045f6:	4509                	li	a0,2
    800045f8:	831fd0ef          	jal	80001e28 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800045fc:	08000613          	li	a2,128
    80004600:	f7040593          	addi	a1,s0,-144
    80004604:	4501                	li	a0,0
    80004606:	85bfd0ef          	jal	80001e60 <argstr>
    8000460a:	02054563          	bltz	a0,80004634 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000460e:	f6841683          	lh	a3,-152(s0)
    80004612:	f6c41603          	lh	a2,-148(s0)
    80004616:	458d                	li	a1,3
    80004618:	f7040513          	addi	a0,s0,-144
    8000461c:	8fdff0ef          	jal	80003f18 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004620:	c911                	beqz	a0,80004634 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004622:	c0efe0ef          	jal	80002a30 <iunlockput>
  end_op();
    80004626:	b1dfe0ef          	jal	80003142 <end_op>
  return 0;
    8000462a:	4501                	li	a0,0
}
    8000462c:	60ea                	ld	ra,152(sp)
    8000462e:	644a                	ld	s0,144(sp)
    80004630:	610d                	addi	sp,sp,160
    80004632:	8082                	ret
    end_op();
    80004634:	b0ffe0ef          	jal	80003142 <end_op>
    return -1;
    80004638:	557d                	li	a0,-1
    8000463a:	bfcd                	j	8000462c <sys_mknod+0x50>

000000008000463c <sys_chdir>:

uint64
sys_chdir(void)
{
    8000463c:	7135                	addi	sp,sp,-160
    8000463e:	ed06                	sd	ra,152(sp)
    80004640:	e922                	sd	s0,144(sp)
    80004642:	e14a                	sd	s2,128(sp)
    80004644:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004646:	911fc0ef          	jal	80000f56 <myproc>
    8000464a:	892a                	mv	s2,a0
  
  begin_op();
    8000464c:	a8dfe0ef          	jal	800030d8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004650:	08000613          	li	a2,128
    80004654:	f6040593          	addi	a1,s0,-160
    80004658:	4501                	li	a0,0
    8000465a:	807fd0ef          	jal	80001e60 <argstr>
    8000465e:	04054363          	bltz	a0,800046a4 <sys_chdir+0x68>
    80004662:	e526                	sd	s1,136(sp)
    80004664:	f6040513          	addi	a0,s0,-160
    80004668:	8affe0ef          	jal	80002f16 <namei>
    8000466c:	84aa                	mv	s1,a0
    8000466e:	c915                	beqz	a0,800046a2 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004670:	9b6fe0ef          	jal	80002826 <ilock>
  if(ip->type != T_DIR){
    80004674:	04449703          	lh	a4,68(s1)
    80004678:	4785                	li	a5,1
    8000467a:	02f71963          	bne	a4,a5,800046ac <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000467e:	8526                	mv	a0,s1
    80004680:	a54fe0ef          	jal	800028d4 <iunlock>
  iput(p->cwd);
    80004684:	15093503          	ld	a0,336(s2)
    80004688:	b20fe0ef          	jal	800029a8 <iput>
  end_op();
    8000468c:	ab7fe0ef          	jal	80003142 <end_op>
  p->cwd = ip;
    80004690:	14993823          	sd	s1,336(s2)
  return 0;
    80004694:	4501                	li	a0,0
    80004696:	64aa                	ld	s1,136(sp)
}
    80004698:	60ea                	ld	ra,152(sp)
    8000469a:	644a                	ld	s0,144(sp)
    8000469c:	690a                	ld	s2,128(sp)
    8000469e:	610d                	addi	sp,sp,160
    800046a0:	8082                	ret
    800046a2:	64aa                	ld	s1,136(sp)
    end_op();
    800046a4:	a9ffe0ef          	jal	80003142 <end_op>
    return -1;
    800046a8:	557d                	li	a0,-1
    800046aa:	b7fd                	j	80004698 <sys_chdir+0x5c>
    iunlockput(ip);
    800046ac:	8526                	mv	a0,s1
    800046ae:	b82fe0ef          	jal	80002a30 <iunlockput>
    end_op();
    800046b2:	a91fe0ef          	jal	80003142 <end_op>
    return -1;
    800046b6:	557d                	li	a0,-1
    800046b8:	64aa                	ld	s1,136(sp)
    800046ba:	bff9                	j	80004698 <sys_chdir+0x5c>

00000000800046bc <sys_exec>:

uint64
sys_exec(void)
{
    800046bc:	7105                	addi	sp,sp,-480
    800046be:	ef86                	sd	ra,472(sp)
    800046c0:	eba2                	sd	s0,464(sp)
    800046c2:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800046c4:	e2840593          	addi	a1,s0,-472
    800046c8:	4505                	li	a0,1
    800046ca:	f7afd0ef          	jal	80001e44 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800046ce:	08000613          	li	a2,128
    800046d2:	f3040593          	addi	a1,s0,-208
    800046d6:	4501                	li	a0,0
    800046d8:	f88fd0ef          	jal	80001e60 <argstr>
    800046dc:	87aa                	mv	a5,a0
    return -1;
    800046de:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800046e0:	0e07c063          	bltz	a5,800047c0 <sys_exec+0x104>
    800046e4:	e7a6                	sd	s1,456(sp)
    800046e6:	e3ca                	sd	s2,448(sp)
    800046e8:	ff4e                	sd	s3,440(sp)
    800046ea:	fb52                	sd	s4,432(sp)
    800046ec:	f756                	sd	s5,424(sp)
    800046ee:	f35a                	sd	s6,416(sp)
    800046f0:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800046f2:	e3040a13          	addi	s4,s0,-464
    800046f6:	10000613          	li	a2,256
    800046fa:	4581                	li	a1,0
    800046fc:	8552                	mv	a0,s4
    800046fe:	b3ffb0ef          	jal	8000023c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004702:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80004704:	89d2                	mv	s3,s4
    80004706:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004708:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000470c:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    8000470e:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004712:	00391513          	slli	a0,s2,0x3
    80004716:	85d6                	mv	a1,s5
    80004718:	e2843783          	ld	a5,-472(s0)
    8000471c:	953e                	add	a0,a0,a5
    8000471e:	e80fd0ef          	jal	80001d9e <fetchaddr>
    80004722:	02054663          	bltz	a0,8000474e <sys_exec+0x92>
    if(uarg == 0){
    80004726:	e2043783          	ld	a5,-480(s0)
    8000472a:	c7a1                	beqz	a5,80004772 <sys_exec+0xb6>
    argv[i] = kalloc();
    8000472c:	a2dfb0ef          	jal	80000158 <kalloc>
    80004730:	85aa                	mv	a1,a0
    80004732:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004736:	cd01                	beqz	a0,8000474e <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004738:	865a                	mv	a2,s6
    8000473a:	e2043503          	ld	a0,-480(s0)
    8000473e:	eaafd0ef          	jal	80001de8 <fetchstr>
    80004742:	00054663          	bltz	a0,8000474e <sys_exec+0x92>
    if(i >= NELEM(argv)){
    80004746:	0905                	addi	s2,s2,1
    80004748:	09a1                	addi	s3,s3,8
    8000474a:	fd7914e3          	bne	s2,s7,80004712 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000474e:	100a0a13          	addi	s4,s4,256
    80004752:	6088                	ld	a0,0(s1)
    80004754:	cd31                	beqz	a0,800047b0 <sys_exec+0xf4>
    kfree(argv[i]);
    80004756:	8c7fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000475a:	04a1                	addi	s1,s1,8
    8000475c:	ff449be3          	bne	s1,s4,80004752 <sys_exec+0x96>
  return -1;
    80004760:	557d                	li	a0,-1
    80004762:	64be                	ld	s1,456(sp)
    80004764:	691e                	ld	s2,448(sp)
    80004766:	79fa                	ld	s3,440(sp)
    80004768:	7a5a                	ld	s4,432(sp)
    8000476a:	7aba                	ld	s5,424(sp)
    8000476c:	7b1a                	ld	s6,416(sp)
    8000476e:	6bfa                	ld	s7,408(sp)
    80004770:	a881                	j	800047c0 <sys_exec+0x104>
      argv[i] = 0;
    80004772:	0009079b          	sext.w	a5,s2
    80004776:	e3040593          	addi	a1,s0,-464
    8000477a:	078e                	slli	a5,a5,0x3
    8000477c:	97ae                	add	a5,a5,a1
    8000477e:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80004782:	f3040513          	addi	a0,s0,-208
    80004786:	ba4ff0ef          	jal	80003b2a <exec>
    8000478a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000478c:	100a0a13          	addi	s4,s4,256
    80004790:	6088                	ld	a0,0(s1)
    80004792:	c511                	beqz	a0,8000479e <sys_exec+0xe2>
    kfree(argv[i]);
    80004794:	889fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004798:	04a1                	addi	s1,s1,8
    8000479a:	ff449be3          	bne	s1,s4,80004790 <sys_exec+0xd4>
  return ret;
    8000479e:	854a                	mv	a0,s2
    800047a0:	64be                	ld	s1,456(sp)
    800047a2:	691e                	ld	s2,448(sp)
    800047a4:	79fa                	ld	s3,440(sp)
    800047a6:	7a5a                	ld	s4,432(sp)
    800047a8:	7aba                	ld	s5,424(sp)
    800047aa:	7b1a                	ld	s6,416(sp)
    800047ac:	6bfa                	ld	s7,408(sp)
    800047ae:	a809                	j	800047c0 <sys_exec+0x104>
  return -1;
    800047b0:	557d                	li	a0,-1
    800047b2:	64be                	ld	s1,456(sp)
    800047b4:	691e                	ld	s2,448(sp)
    800047b6:	79fa                	ld	s3,440(sp)
    800047b8:	7a5a                	ld	s4,432(sp)
    800047ba:	7aba                	ld	s5,424(sp)
    800047bc:	7b1a                	ld	s6,416(sp)
    800047be:	6bfa                	ld	s7,408(sp)
}
    800047c0:	60fe                	ld	ra,472(sp)
    800047c2:	645e                	ld	s0,464(sp)
    800047c4:	613d                	addi	sp,sp,480
    800047c6:	8082                	ret

00000000800047c8 <sys_pipe>:

uint64
sys_pipe(void)
{
    800047c8:	7139                	addi	sp,sp,-64
    800047ca:	fc06                	sd	ra,56(sp)
    800047cc:	f822                	sd	s0,48(sp)
    800047ce:	f426                	sd	s1,40(sp)
    800047d0:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800047d2:	f84fc0ef          	jal	80000f56 <myproc>
    800047d6:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800047d8:	fd840593          	addi	a1,s0,-40
    800047dc:	4501                	li	a0,0
    800047de:	e66fd0ef          	jal	80001e44 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800047e2:	fc840593          	addi	a1,s0,-56
    800047e6:	fd040513          	addi	a0,s0,-48
    800047ea:	81eff0ef          	jal	80003808 <pipealloc>
    return -1;
    800047ee:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800047f0:	0a054463          	bltz	a0,80004898 <sys_pipe+0xd0>
  fd0 = -1;
    800047f4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800047f8:	fd043503          	ld	a0,-48(s0)
    800047fc:	edeff0ef          	jal	80003eda <fdalloc>
    80004800:	fca42223          	sw	a0,-60(s0)
    80004804:	08054163          	bltz	a0,80004886 <sys_pipe+0xbe>
    80004808:	fc843503          	ld	a0,-56(s0)
    8000480c:	eceff0ef          	jal	80003eda <fdalloc>
    80004810:	fca42023          	sw	a0,-64(s0)
    80004814:	06054063          	bltz	a0,80004874 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004818:	4691                	li	a3,4
    8000481a:	fc440613          	addi	a2,s0,-60
    8000481e:	fd843583          	ld	a1,-40(s0)
    80004822:	68a8                	ld	a0,80(s1)
    80004824:	ca4fc0ef          	jal	80000cc8 <copyout>
    80004828:	00054e63          	bltz	a0,80004844 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000482c:	4691                	li	a3,4
    8000482e:	fc040613          	addi	a2,s0,-64
    80004832:	fd843583          	ld	a1,-40(s0)
    80004836:	95b6                	add	a1,a1,a3
    80004838:	68a8                	ld	a0,80(s1)
    8000483a:	c8efc0ef          	jal	80000cc8 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000483e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004840:	04055c63          	bgez	a0,80004898 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004844:	fc442783          	lw	a5,-60(s0)
    80004848:	07e9                	addi	a5,a5,26
    8000484a:	078e                	slli	a5,a5,0x3
    8000484c:	97a6                	add	a5,a5,s1
    8000484e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004852:	fc042783          	lw	a5,-64(s0)
    80004856:	07e9                	addi	a5,a5,26
    80004858:	078e                	slli	a5,a5,0x3
    8000485a:	94be                	add	s1,s1,a5
    8000485c:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004860:	fd043503          	ld	a0,-48(s0)
    80004864:	c95fe0ef          	jal	800034f8 <fileclose>
    fileclose(wf);
    80004868:	fc843503          	ld	a0,-56(s0)
    8000486c:	c8dfe0ef          	jal	800034f8 <fileclose>
    return -1;
    80004870:	57fd                	li	a5,-1
    80004872:	a01d                	j	80004898 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004874:	fc442783          	lw	a5,-60(s0)
    80004878:	0007c763          	bltz	a5,80004886 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    8000487c:	07e9                	addi	a5,a5,26
    8000487e:	078e                	slli	a5,a5,0x3
    80004880:	97a6                	add	a5,a5,s1
    80004882:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004886:	fd043503          	ld	a0,-48(s0)
    8000488a:	c6ffe0ef          	jal	800034f8 <fileclose>
    fileclose(wf);
    8000488e:	fc843503          	ld	a0,-56(s0)
    80004892:	c67fe0ef          	jal	800034f8 <fileclose>
    return -1;
    80004896:	57fd                	li	a5,-1
}
    80004898:	853e                	mv	a0,a5
    8000489a:	70e2                	ld	ra,56(sp)
    8000489c:	7442                	ld	s0,48(sp)
    8000489e:	74a2                	ld	s1,40(sp)
    800048a0:	6121                	addi	sp,sp,64
    800048a2:	8082                	ret
	...

00000000800048b0 <kernelvec>:
    800048b0:	7111                	addi	sp,sp,-256
    800048b2:	e006                	sd	ra,0(sp)
    800048b4:	e40a                	sd	sp,8(sp)
    800048b6:	e80e                	sd	gp,16(sp)
    800048b8:	ec12                	sd	tp,24(sp)
    800048ba:	f016                	sd	t0,32(sp)
    800048bc:	f41a                	sd	t1,40(sp)
    800048be:	f81e                	sd	t2,48(sp)
    800048c0:	e4aa                	sd	a0,72(sp)
    800048c2:	e8ae                	sd	a1,80(sp)
    800048c4:	ecb2                	sd	a2,88(sp)
    800048c6:	f0b6                	sd	a3,96(sp)
    800048c8:	f4ba                	sd	a4,104(sp)
    800048ca:	f8be                	sd	a5,112(sp)
    800048cc:	fcc2                	sd	a6,120(sp)
    800048ce:	e146                	sd	a7,128(sp)
    800048d0:	edf2                	sd	t3,216(sp)
    800048d2:	f1f6                	sd	t4,224(sp)
    800048d4:	f5fa                	sd	t5,232(sp)
    800048d6:	f9fe                	sd	t6,240(sp)
    800048d8:	bd6fd0ef          	jal	80001cae <kerneltrap>
    800048dc:	6082                	ld	ra,0(sp)
    800048de:	6122                	ld	sp,8(sp)
    800048e0:	61c2                	ld	gp,16(sp)
    800048e2:	7282                	ld	t0,32(sp)
    800048e4:	7322                	ld	t1,40(sp)
    800048e6:	73c2                	ld	t2,48(sp)
    800048e8:	6526                	ld	a0,72(sp)
    800048ea:	65c6                	ld	a1,80(sp)
    800048ec:	6666                	ld	a2,88(sp)
    800048ee:	7686                	ld	a3,96(sp)
    800048f0:	7726                	ld	a4,104(sp)
    800048f2:	77c6                	ld	a5,112(sp)
    800048f4:	7866                	ld	a6,120(sp)
    800048f6:	688a                	ld	a7,128(sp)
    800048f8:	6e6e                	ld	t3,216(sp)
    800048fa:	7e8e                	ld	t4,224(sp)
    800048fc:	7f2e                	ld	t5,232(sp)
    800048fe:	7fce                	ld	t6,240(sp)
    80004900:	6111                	addi	sp,sp,256
    80004902:	10200073          	sret
	...

000000008000490e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000490e:	1141                	addi	sp,sp,-16
    80004910:	e406                	sd	ra,8(sp)
    80004912:	e022                	sd	s0,0(sp)
    80004914:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004916:	0c000737          	lui	a4,0xc000
    8000491a:	4785                	li	a5,1
    8000491c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000491e:	c35c                	sw	a5,4(a4)
}
    80004920:	60a2                	ld	ra,8(sp)
    80004922:	6402                	ld	s0,0(sp)
    80004924:	0141                	addi	sp,sp,16
    80004926:	8082                	ret

0000000080004928 <plicinithart>:

void
plicinithart(void)
{
    80004928:	1141                	addi	sp,sp,-16
    8000492a:	e406                	sd	ra,8(sp)
    8000492c:	e022                	sd	s0,0(sp)
    8000492e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004930:	df2fc0ef          	jal	80000f22 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004934:	0085171b          	slliw	a4,a0,0x8
    80004938:	0c0027b7          	lui	a5,0xc002
    8000493c:	97ba                	add	a5,a5,a4
    8000493e:	40200713          	li	a4,1026
    80004942:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004946:	00d5151b          	slliw	a0,a0,0xd
    8000494a:	0c2017b7          	lui	a5,0xc201
    8000494e:	97aa                	add	a5,a5,a0
    80004950:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004954:	60a2                	ld	ra,8(sp)
    80004956:	6402                	ld	s0,0(sp)
    80004958:	0141                	addi	sp,sp,16
    8000495a:	8082                	ret

000000008000495c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000495c:	1141                	addi	sp,sp,-16
    8000495e:	e406                	sd	ra,8(sp)
    80004960:	e022                	sd	s0,0(sp)
    80004962:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004964:	dbefc0ef          	jal	80000f22 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004968:	00d5151b          	slliw	a0,a0,0xd
    8000496c:	0c2017b7          	lui	a5,0xc201
    80004970:	97aa                	add	a5,a5,a0
  return irq;
}
    80004972:	43c8                	lw	a0,4(a5)
    80004974:	60a2                	ld	ra,8(sp)
    80004976:	6402                	ld	s0,0(sp)
    80004978:	0141                	addi	sp,sp,16
    8000497a:	8082                	ret

000000008000497c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000497c:	1101                	addi	sp,sp,-32
    8000497e:	ec06                	sd	ra,24(sp)
    80004980:	e822                	sd	s0,16(sp)
    80004982:	e426                	sd	s1,8(sp)
    80004984:	1000                	addi	s0,sp,32
    80004986:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004988:	d9afc0ef          	jal	80000f22 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000498c:	00d5179b          	slliw	a5,a0,0xd
    80004990:	0c201737          	lui	a4,0xc201
    80004994:	97ba                	add	a5,a5,a4
    80004996:	c3c4                	sw	s1,4(a5)
}
    80004998:	60e2                	ld	ra,24(sp)
    8000499a:	6442                	ld	s0,16(sp)
    8000499c:	64a2                	ld	s1,8(sp)
    8000499e:	6105                	addi	sp,sp,32
    800049a0:	8082                	ret

00000000800049a2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800049a2:	1141                	addi	sp,sp,-16
    800049a4:	e406                	sd	ra,8(sp)
    800049a6:	e022                	sd	s0,0(sp)
    800049a8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800049aa:	479d                	li	a5,7
    800049ac:	04a7ca63          	blt	a5,a0,80004a00 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800049b0:	00237797          	auipc	a5,0x237
    800049b4:	b0078793          	addi	a5,a5,-1280 # 8023b4b0 <disk>
    800049b8:	97aa                	add	a5,a5,a0
    800049ba:	0187c783          	lbu	a5,24(a5)
    800049be:	e7b9                	bnez	a5,80004a0c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800049c0:	00451693          	slli	a3,a0,0x4
    800049c4:	00237797          	auipc	a5,0x237
    800049c8:	aec78793          	addi	a5,a5,-1300 # 8023b4b0 <disk>
    800049cc:	6398                	ld	a4,0(a5)
    800049ce:	9736                	add	a4,a4,a3
    800049d0:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    800049d4:	6398                	ld	a4,0(a5)
    800049d6:	9736                	add	a4,a4,a3
    800049d8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800049dc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800049e0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800049e4:	97aa                	add	a5,a5,a0
    800049e6:	4705                	li	a4,1
    800049e8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800049ec:	00237517          	auipc	a0,0x237
    800049f0:	adc50513          	addi	a0,a0,-1316 # 8023b4c8 <disk+0x18>
    800049f4:	b7dfc0ef          	jal	80001570 <wakeup>
}
    800049f8:	60a2                	ld	ra,8(sp)
    800049fa:	6402                	ld	s0,0(sp)
    800049fc:	0141                	addi	sp,sp,16
    800049fe:	8082                	ret
    panic("free_desc 1");
    80004a00:	00003517          	auipc	a0,0x3
    80004a04:	c4850513          	addi	a0,a0,-952 # 80007648 <etext+0x648>
    80004a08:	40f000ef          	jal	80005616 <panic>
    panic("free_desc 2");
    80004a0c:	00003517          	auipc	a0,0x3
    80004a10:	c4c50513          	addi	a0,a0,-948 # 80007658 <etext+0x658>
    80004a14:	403000ef          	jal	80005616 <panic>

0000000080004a18 <virtio_disk_init>:
{
    80004a18:	1101                	addi	sp,sp,-32
    80004a1a:	ec06                	sd	ra,24(sp)
    80004a1c:	e822                	sd	s0,16(sp)
    80004a1e:	e426                	sd	s1,8(sp)
    80004a20:	e04a                	sd	s2,0(sp)
    80004a22:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004a24:	00003597          	auipc	a1,0x3
    80004a28:	c4458593          	addi	a1,a1,-956 # 80007668 <etext+0x668>
    80004a2c:	00237517          	auipc	a0,0x237
    80004a30:	bac50513          	addi	a0,a0,-1108 # 8023b5d8 <disk+0x128>
    80004a34:	68d000ef          	jal	800058c0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004a38:	100017b7          	lui	a5,0x10001
    80004a3c:	4398                	lw	a4,0(a5)
    80004a3e:	2701                	sext.w	a4,a4
    80004a40:	747277b7          	lui	a5,0x74727
    80004a44:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004a48:	14f71863          	bne	a4,a5,80004b98 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004a4c:	100017b7          	lui	a5,0x10001
    80004a50:	43dc                	lw	a5,4(a5)
    80004a52:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004a54:	4709                	li	a4,2
    80004a56:	14e79163          	bne	a5,a4,80004b98 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004a5a:	100017b7          	lui	a5,0x10001
    80004a5e:	479c                	lw	a5,8(a5)
    80004a60:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004a62:	12e79b63          	bne	a5,a4,80004b98 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004a66:	100017b7          	lui	a5,0x10001
    80004a6a:	47d8                	lw	a4,12(a5)
    80004a6c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004a6e:	554d47b7          	lui	a5,0x554d4
    80004a72:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004a76:	12f71163          	bne	a4,a5,80004b98 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a7a:	100017b7          	lui	a5,0x10001
    80004a7e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a82:	4705                	li	a4,1
    80004a84:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a86:	470d                	li	a4,3
    80004a88:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004a8a:	10001737          	lui	a4,0x10001
    80004a8e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004a90:	c7ffe6b7          	lui	a3,0xc7ffe
    80004a94:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47dbb06f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004a98:	8f75                	and	a4,a4,a3
    80004a9a:	100016b7          	lui	a3,0x10001
    80004a9e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004aa0:	472d                	li	a4,11
    80004aa2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004aa4:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004aa8:	439c                	lw	a5,0(a5)
    80004aaa:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004aae:	8ba1                	andi	a5,a5,8
    80004ab0:	0e078a63          	beqz	a5,80004ba4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004ab4:	100017b7          	lui	a5,0x10001
    80004ab8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004abc:	43fc                	lw	a5,68(a5)
    80004abe:	2781                	sext.w	a5,a5
    80004ac0:	0e079863          	bnez	a5,80004bb0 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004ac4:	100017b7          	lui	a5,0x10001
    80004ac8:	5bdc                	lw	a5,52(a5)
    80004aca:	2781                	sext.w	a5,a5
  if(max == 0)
    80004acc:	0e078863          	beqz	a5,80004bbc <virtio_disk_init+0x1a4>
  if(max < NUM)
    80004ad0:	471d                	li	a4,7
    80004ad2:	0ef77b63          	bgeu	a4,a5,80004bc8 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80004ad6:	e82fb0ef          	jal	80000158 <kalloc>
    80004ada:	00237497          	auipc	s1,0x237
    80004ade:	9d648493          	addi	s1,s1,-1578 # 8023b4b0 <disk>
    80004ae2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004ae4:	e74fb0ef          	jal	80000158 <kalloc>
    80004ae8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004aea:	e6efb0ef          	jal	80000158 <kalloc>
    80004aee:	87aa                	mv	a5,a0
    80004af0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004af2:	6088                	ld	a0,0(s1)
    80004af4:	0e050063          	beqz	a0,80004bd4 <virtio_disk_init+0x1bc>
    80004af8:	00237717          	auipc	a4,0x237
    80004afc:	9c073703          	ld	a4,-1600(a4) # 8023b4b8 <disk+0x8>
    80004b00:	cb71                	beqz	a4,80004bd4 <virtio_disk_init+0x1bc>
    80004b02:	cbe9                	beqz	a5,80004bd4 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80004b04:	6605                	lui	a2,0x1
    80004b06:	4581                	li	a1,0
    80004b08:	f34fb0ef          	jal	8000023c <memset>
  memset(disk.avail, 0, PGSIZE);
    80004b0c:	00237497          	auipc	s1,0x237
    80004b10:	9a448493          	addi	s1,s1,-1628 # 8023b4b0 <disk>
    80004b14:	6605                	lui	a2,0x1
    80004b16:	4581                	li	a1,0
    80004b18:	6488                	ld	a0,8(s1)
    80004b1a:	f22fb0ef          	jal	8000023c <memset>
  memset(disk.used, 0, PGSIZE);
    80004b1e:	6605                	lui	a2,0x1
    80004b20:	4581                	li	a1,0
    80004b22:	6888                	ld	a0,16(s1)
    80004b24:	f18fb0ef          	jal	8000023c <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004b28:	100017b7          	lui	a5,0x10001
    80004b2c:	4721                	li	a4,8
    80004b2e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004b30:	4098                	lw	a4,0(s1)
    80004b32:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004b36:	40d8                	lw	a4,4(s1)
    80004b38:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004b3c:	649c                	ld	a5,8(s1)
    80004b3e:	0007869b          	sext.w	a3,a5
    80004b42:	10001737          	lui	a4,0x10001
    80004b46:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004b4a:	9781                	srai	a5,a5,0x20
    80004b4c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004b50:	689c                	ld	a5,16(s1)
    80004b52:	0007869b          	sext.w	a3,a5
    80004b56:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004b5a:	9781                	srai	a5,a5,0x20
    80004b5c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004b60:	4785                	li	a5,1
    80004b62:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004b64:	00f48c23          	sb	a5,24(s1)
    80004b68:	00f48ca3          	sb	a5,25(s1)
    80004b6c:	00f48d23          	sb	a5,26(s1)
    80004b70:	00f48da3          	sb	a5,27(s1)
    80004b74:	00f48e23          	sb	a5,28(s1)
    80004b78:	00f48ea3          	sb	a5,29(s1)
    80004b7c:	00f48f23          	sb	a5,30(s1)
    80004b80:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004b84:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b88:	07272823          	sw	s2,112(a4)
}
    80004b8c:	60e2                	ld	ra,24(sp)
    80004b8e:	6442                	ld	s0,16(sp)
    80004b90:	64a2                	ld	s1,8(sp)
    80004b92:	6902                	ld	s2,0(sp)
    80004b94:	6105                	addi	sp,sp,32
    80004b96:	8082                	ret
    panic("could not find virtio disk");
    80004b98:	00003517          	auipc	a0,0x3
    80004b9c:	ae050513          	addi	a0,a0,-1312 # 80007678 <etext+0x678>
    80004ba0:	277000ef          	jal	80005616 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004ba4:	00003517          	auipc	a0,0x3
    80004ba8:	af450513          	addi	a0,a0,-1292 # 80007698 <etext+0x698>
    80004bac:	26b000ef          	jal	80005616 <panic>
    panic("virtio disk should not be ready");
    80004bb0:	00003517          	auipc	a0,0x3
    80004bb4:	b0850513          	addi	a0,a0,-1272 # 800076b8 <etext+0x6b8>
    80004bb8:	25f000ef          	jal	80005616 <panic>
    panic("virtio disk has no queue 0");
    80004bbc:	00003517          	auipc	a0,0x3
    80004bc0:	b1c50513          	addi	a0,a0,-1252 # 800076d8 <etext+0x6d8>
    80004bc4:	253000ef          	jal	80005616 <panic>
    panic("virtio disk max queue too short");
    80004bc8:	00003517          	auipc	a0,0x3
    80004bcc:	b3050513          	addi	a0,a0,-1232 # 800076f8 <etext+0x6f8>
    80004bd0:	247000ef          	jal	80005616 <panic>
    panic("virtio disk kalloc");
    80004bd4:	00003517          	auipc	a0,0x3
    80004bd8:	b4450513          	addi	a0,a0,-1212 # 80007718 <etext+0x718>
    80004bdc:	23b000ef          	jal	80005616 <panic>

0000000080004be0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004be0:	711d                	addi	sp,sp,-96
    80004be2:	ec86                	sd	ra,88(sp)
    80004be4:	e8a2                	sd	s0,80(sp)
    80004be6:	e4a6                	sd	s1,72(sp)
    80004be8:	e0ca                	sd	s2,64(sp)
    80004bea:	fc4e                	sd	s3,56(sp)
    80004bec:	f852                	sd	s4,48(sp)
    80004bee:	f456                	sd	s5,40(sp)
    80004bf0:	f05a                	sd	s6,32(sp)
    80004bf2:	ec5e                	sd	s7,24(sp)
    80004bf4:	e862                	sd	s8,16(sp)
    80004bf6:	1080                	addi	s0,sp,96
    80004bf8:	89aa                	mv	s3,a0
    80004bfa:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004bfc:	00c52b83          	lw	s7,12(a0)
    80004c00:	001b9b9b          	slliw	s7,s7,0x1
    80004c04:	1b82                	slli	s7,s7,0x20
    80004c06:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80004c0a:	00237517          	auipc	a0,0x237
    80004c0e:	9ce50513          	addi	a0,a0,-1586 # 8023b5d8 <disk+0x128>
    80004c12:	533000ef          	jal	80005944 <acquire>
  for(int i = 0; i < NUM; i++){
    80004c16:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004c18:	00237a97          	auipc	s5,0x237
    80004c1c:	898a8a93          	addi	s5,s5,-1896 # 8023b4b0 <disk>
  for(int i = 0; i < 3; i++){
    80004c20:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80004c22:	5c7d                	li	s8,-1
    80004c24:	a095                	j	80004c88 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80004c26:	00fa8733          	add	a4,s5,a5
    80004c2a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80004c2e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004c30:	0207c563          	bltz	a5,80004c5a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80004c34:	2905                	addiw	s2,s2,1
    80004c36:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004c38:	05490c63          	beq	s2,s4,80004c90 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80004c3c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004c3e:	00237717          	auipc	a4,0x237
    80004c42:	87270713          	addi	a4,a4,-1934 # 8023b4b0 <disk>
    80004c46:	4781                	li	a5,0
    if(disk.free[i]){
    80004c48:	01874683          	lbu	a3,24(a4)
    80004c4c:	fee9                	bnez	a3,80004c26 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80004c4e:	2785                	addiw	a5,a5,1
    80004c50:	0705                	addi	a4,a4,1
    80004c52:	fe979be3          	bne	a5,s1,80004c48 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80004c56:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80004c5a:	01205d63          	blez	s2,80004c74 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004c5e:	fa042503          	lw	a0,-96(s0)
    80004c62:	d41ff0ef          	jal	800049a2 <free_desc>
      for(int j = 0; j < i; j++)
    80004c66:	4785                	li	a5,1
    80004c68:	0127d663          	bge	a5,s2,80004c74 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004c6c:	fa442503          	lw	a0,-92(s0)
    80004c70:	d33ff0ef          	jal	800049a2 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004c74:	00237597          	auipc	a1,0x237
    80004c78:	96458593          	addi	a1,a1,-1692 # 8023b5d8 <disk+0x128>
    80004c7c:	00237517          	auipc	a0,0x237
    80004c80:	84c50513          	addi	a0,a0,-1972 # 8023b4c8 <disk+0x18>
    80004c84:	8a1fc0ef          	jal	80001524 <sleep>
  for(int i = 0; i < 3; i++){
    80004c88:	fa040613          	addi	a2,s0,-96
    80004c8c:	4901                	li	s2,0
    80004c8e:	b77d                	j	80004c3c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c90:	fa042503          	lw	a0,-96(s0)
    80004c94:	00451693          	slli	a3,a0,0x4

  if(write)
    80004c98:	00237797          	auipc	a5,0x237
    80004c9c:	81878793          	addi	a5,a5,-2024 # 8023b4b0 <disk>
    80004ca0:	00a50713          	addi	a4,a0,10
    80004ca4:	0712                	slli	a4,a4,0x4
    80004ca6:	973e                	add	a4,a4,a5
    80004ca8:	01603633          	snez	a2,s6
    80004cac:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004cae:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004cb2:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004cb6:	6398                	ld	a4,0(a5)
    80004cb8:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004cba:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80004cbe:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004cc0:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004cc2:	6390                	ld	a2,0(a5)
    80004cc4:	00d605b3          	add	a1,a2,a3
    80004cc8:	4741                	li	a4,16
    80004cca:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004ccc:	4805                	li	a6,1
    80004cce:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004cd2:	fa442703          	lw	a4,-92(s0)
    80004cd6:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004cda:	0712                	slli	a4,a4,0x4
    80004cdc:	963a                	add	a2,a2,a4
    80004cde:	05898593          	addi	a1,s3,88
    80004ce2:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004ce4:	0007b883          	ld	a7,0(a5)
    80004ce8:	9746                	add	a4,a4,a7
    80004cea:	40000613          	li	a2,1024
    80004cee:	c710                	sw	a2,8(a4)
  if(write)
    80004cf0:	001b3613          	seqz	a2,s6
    80004cf4:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004cf8:	01066633          	or	a2,a2,a6
    80004cfc:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004d00:	fa842583          	lw	a1,-88(s0)
    80004d04:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004d08:	00250613          	addi	a2,a0,2
    80004d0c:	0612                	slli	a2,a2,0x4
    80004d0e:	963e                	add	a2,a2,a5
    80004d10:	577d                	li	a4,-1
    80004d12:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004d16:	0592                	slli	a1,a1,0x4
    80004d18:	98ae                	add	a7,a7,a1
    80004d1a:	03068713          	addi	a4,a3,48
    80004d1e:	973e                	add	a4,a4,a5
    80004d20:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004d24:	6398                	ld	a4,0(a5)
    80004d26:	972e                	add	a4,a4,a1
    80004d28:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004d2c:	4689                	li	a3,2
    80004d2e:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004d32:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004d36:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80004d3a:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004d3e:	6794                	ld	a3,8(a5)
    80004d40:	0026d703          	lhu	a4,2(a3)
    80004d44:	8b1d                	andi	a4,a4,7
    80004d46:	0706                	slli	a4,a4,0x1
    80004d48:	96ba                	add	a3,a3,a4
    80004d4a:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004d4e:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004d52:	6798                	ld	a4,8(a5)
    80004d54:	00275783          	lhu	a5,2(a4)
    80004d58:	2785                	addiw	a5,a5,1
    80004d5a:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004d5e:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004d62:	100017b7          	lui	a5,0x10001
    80004d66:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004d6a:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80004d6e:	00237917          	auipc	s2,0x237
    80004d72:	86a90913          	addi	s2,s2,-1942 # 8023b5d8 <disk+0x128>
  while(b->disk == 1) {
    80004d76:	84c2                	mv	s1,a6
    80004d78:	01079a63          	bne	a5,a6,80004d8c <virtio_disk_rw+0x1ac>
    sleep(b, &disk.vdisk_lock);
    80004d7c:	85ca                	mv	a1,s2
    80004d7e:	854e                	mv	a0,s3
    80004d80:	fa4fc0ef          	jal	80001524 <sleep>
  while(b->disk == 1) {
    80004d84:	0049a783          	lw	a5,4(s3)
    80004d88:	fe978ae3          	beq	a5,s1,80004d7c <virtio_disk_rw+0x19c>
  }

  disk.info[idx[0]].b = 0;
    80004d8c:	fa042903          	lw	s2,-96(s0)
    80004d90:	00290713          	addi	a4,s2,2
    80004d94:	0712                	slli	a4,a4,0x4
    80004d96:	00236797          	auipc	a5,0x236
    80004d9a:	71a78793          	addi	a5,a5,1818 # 8023b4b0 <disk>
    80004d9e:	97ba                	add	a5,a5,a4
    80004da0:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004da4:	00236997          	auipc	s3,0x236
    80004da8:	70c98993          	addi	s3,s3,1804 # 8023b4b0 <disk>
    80004dac:	00491713          	slli	a4,s2,0x4
    80004db0:	0009b783          	ld	a5,0(s3)
    80004db4:	97ba                	add	a5,a5,a4
    80004db6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004dba:	854a                	mv	a0,s2
    80004dbc:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004dc0:	be3ff0ef          	jal	800049a2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004dc4:	8885                	andi	s1,s1,1
    80004dc6:	f0fd                	bnez	s1,80004dac <virtio_disk_rw+0x1cc>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004dc8:	00237517          	auipc	a0,0x237
    80004dcc:	81050513          	addi	a0,a0,-2032 # 8023b5d8 <disk+0x128>
    80004dd0:	409000ef          	jal	800059d8 <release>
}
    80004dd4:	60e6                	ld	ra,88(sp)
    80004dd6:	6446                	ld	s0,80(sp)
    80004dd8:	64a6                	ld	s1,72(sp)
    80004dda:	6906                	ld	s2,64(sp)
    80004ddc:	79e2                	ld	s3,56(sp)
    80004dde:	7a42                	ld	s4,48(sp)
    80004de0:	7aa2                	ld	s5,40(sp)
    80004de2:	7b02                	ld	s6,32(sp)
    80004de4:	6be2                	ld	s7,24(sp)
    80004de6:	6c42                	ld	s8,16(sp)
    80004de8:	6125                	addi	sp,sp,96
    80004dea:	8082                	ret

0000000080004dec <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004dec:	1101                	addi	sp,sp,-32
    80004dee:	ec06                	sd	ra,24(sp)
    80004df0:	e822                	sd	s0,16(sp)
    80004df2:	e426                	sd	s1,8(sp)
    80004df4:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004df6:	00236497          	auipc	s1,0x236
    80004dfa:	6ba48493          	addi	s1,s1,1722 # 8023b4b0 <disk>
    80004dfe:	00236517          	auipc	a0,0x236
    80004e02:	7da50513          	addi	a0,a0,2010 # 8023b5d8 <disk+0x128>
    80004e06:	33f000ef          	jal	80005944 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004e0a:	100017b7          	lui	a5,0x10001
    80004e0e:	53bc                	lw	a5,96(a5)
    80004e10:	8b8d                	andi	a5,a5,3
    80004e12:	10001737          	lui	a4,0x10001
    80004e16:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004e18:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004e1c:	689c                	ld	a5,16(s1)
    80004e1e:	0204d703          	lhu	a4,32(s1)
    80004e22:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004e26:	04f70663          	beq	a4,a5,80004e72 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004e2a:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004e2e:	6898                	ld	a4,16(s1)
    80004e30:	0204d783          	lhu	a5,32(s1)
    80004e34:	8b9d                	andi	a5,a5,7
    80004e36:	078e                	slli	a5,a5,0x3
    80004e38:	97ba                	add	a5,a5,a4
    80004e3a:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004e3c:	00278713          	addi	a4,a5,2
    80004e40:	0712                	slli	a4,a4,0x4
    80004e42:	9726                	add	a4,a4,s1
    80004e44:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80004e48:	e321                	bnez	a4,80004e88 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004e4a:	0789                	addi	a5,a5,2
    80004e4c:	0792                	slli	a5,a5,0x4
    80004e4e:	97a6                	add	a5,a5,s1
    80004e50:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004e52:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004e56:	f1afc0ef          	jal	80001570 <wakeup>

    disk.used_idx += 1;
    80004e5a:	0204d783          	lhu	a5,32(s1)
    80004e5e:	2785                	addiw	a5,a5,1
    80004e60:	17c2                	slli	a5,a5,0x30
    80004e62:	93c1                	srli	a5,a5,0x30
    80004e64:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004e68:	6898                	ld	a4,16(s1)
    80004e6a:	00275703          	lhu	a4,2(a4)
    80004e6e:	faf71ee3          	bne	a4,a5,80004e2a <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004e72:	00236517          	auipc	a0,0x236
    80004e76:	76650513          	addi	a0,a0,1894 # 8023b5d8 <disk+0x128>
    80004e7a:	35f000ef          	jal	800059d8 <release>
}
    80004e7e:	60e2                	ld	ra,24(sp)
    80004e80:	6442                	ld	s0,16(sp)
    80004e82:	64a2                	ld	s1,8(sp)
    80004e84:	6105                	addi	sp,sp,32
    80004e86:	8082                	ret
      panic("virtio_disk_intr status");
    80004e88:	00003517          	auipc	a0,0x3
    80004e8c:	8a850513          	addi	a0,a0,-1880 # 80007730 <etext+0x730>
    80004e90:	786000ef          	jal	80005616 <panic>

0000000080004e94 <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004e94:	1141                	addi	sp,sp,-16
    80004e96:	e406                	sd	ra,8(sp)
    80004e98:	e022                	sd	s0,0(sp)
    80004e9a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004e9c:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004ea0:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004ea4:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004ea8:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004eac:	577d                	li	a4,-1
    80004eae:	177e                	slli	a4,a4,0x3f
    80004eb0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004eb2:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004eb6:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004eba:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004ebe:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004ec2:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004ec6:	000f4737          	lui	a4,0xf4
    80004eca:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004ece:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004ed0:	14d79073          	csrw	stimecmp,a5
}
    80004ed4:	60a2                	ld	ra,8(sp)
    80004ed6:	6402                	ld	s0,0(sp)
    80004ed8:	0141                	addi	sp,sp,16
    80004eda:	8082                	ret

0000000080004edc <start>:
{
    80004edc:	1141                	addi	sp,sp,-16
    80004ede:	e406                	sd	ra,8(sp)
    80004ee0:	e022                	sd	s0,0(sp)
    80004ee2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004ee4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004ee8:	7779                	lui	a4,0xffffe
    80004eea:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdbb10f>
    80004eee:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004ef0:	6705                	lui	a4,0x1
    80004ef2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004ef6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004ef8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004efc:	ffffb797          	auipc	a5,0xffffb
    80004f00:	4f678793          	addi	a5,a5,1270 # 800003f2 <main>
    80004f04:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004f08:	4781                	li	a5,0
    80004f0a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004f0e:	67c1                	lui	a5,0x10
    80004f10:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004f12:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004f16:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004f1a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004f1e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004f22:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004f26:	57fd                	li	a5,-1
    80004f28:	83a9                	srli	a5,a5,0xa
    80004f2a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004f2e:	47bd                	li	a5,15
    80004f30:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004f34:	f61ff0ef          	jal	80004e94 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004f38:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004f3c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004f3e:	823e                	mv	tp,a5
  asm volatile("mret");
    80004f40:	30200073          	mret
}
    80004f44:	60a2                	ld	ra,8(sp)
    80004f46:	6402                	ld	s0,0(sp)
    80004f48:	0141                	addi	sp,sp,16
    80004f4a:	8082                	ret

0000000080004f4c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004f4c:	711d                	addi	sp,sp,-96
    80004f4e:	ec86                	sd	ra,88(sp)
    80004f50:	e8a2                	sd	s0,80(sp)
    80004f52:	e0ca                	sd	s2,64(sp)
    80004f54:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    80004f56:	04c05863          	blez	a2,80004fa6 <consolewrite+0x5a>
    80004f5a:	e4a6                	sd	s1,72(sp)
    80004f5c:	fc4e                	sd	s3,56(sp)
    80004f5e:	f852                	sd	s4,48(sp)
    80004f60:	f456                	sd	s5,40(sp)
    80004f62:	f05a                	sd	s6,32(sp)
    80004f64:	ec5e                	sd	s7,24(sp)
    80004f66:	8a2a                	mv	s4,a0
    80004f68:	84ae                	mv	s1,a1
    80004f6a:	89b2                	mv	s3,a2
    80004f6c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004f6e:	faf40b93          	addi	s7,s0,-81
    80004f72:	4b05                	li	s6,1
    80004f74:	5afd                	li	s5,-1
    80004f76:	86da                	mv	a3,s6
    80004f78:	8626                	mv	a2,s1
    80004f7a:	85d2                	mv	a1,s4
    80004f7c:	855e                	mv	a0,s7
    80004f7e:	947fc0ef          	jal	800018c4 <either_copyin>
    80004f82:	03550463          	beq	a0,s5,80004faa <consolewrite+0x5e>
      break;
    uartputc(c);
    80004f86:	faf44503          	lbu	a0,-81(s0)
    80004f8a:	02d000ef          	jal	800057b6 <uartputc>
  for(i = 0; i < n; i++){
    80004f8e:	2905                	addiw	s2,s2,1
    80004f90:	0485                	addi	s1,s1,1
    80004f92:	ff2992e3          	bne	s3,s2,80004f76 <consolewrite+0x2a>
    80004f96:	894e                	mv	s2,s3
    80004f98:	64a6                	ld	s1,72(sp)
    80004f9a:	79e2                	ld	s3,56(sp)
    80004f9c:	7a42                	ld	s4,48(sp)
    80004f9e:	7aa2                	ld	s5,40(sp)
    80004fa0:	7b02                	ld	s6,32(sp)
    80004fa2:	6be2                	ld	s7,24(sp)
    80004fa4:	a809                	j	80004fb6 <consolewrite+0x6a>
    80004fa6:	4901                	li	s2,0
    80004fa8:	a039                	j	80004fb6 <consolewrite+0x6a>
    80004faa:	64a6                	ld	s1,72(sp)
    80004fac:	79e2                	ld	s3,56(sp)
    80004fae:	7a42                	ld	s4,48(sp)
    80004fb0:	7aa2                	ld	s5,40(sp)
    80004fb2:	7b02                	ld	s6,32(sp)
    80004fb4:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    80004fb6:	854a                	mv	a0,s2
    80004fb8:	60e6                	ld	ra,88(sp)
    80004fba:	6446                	ld	s0,80(sp)
    80004fbc:	6906                	ld	s2,64(sp)
    80004fbe:	6125                	addi	sp,sp,96
    80004fc0:	8082                	ret

0000000080004fc2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004fc2:	711d                	addi	sp,sp,-96
    80004fc4:	ec86                	sd	ra,88(sp)
    80004fc6:	e8a2                	sd	s0,80(sp)
    80004fc8:	e4a6                	sd	s1,72(sp)
    80004fca:	e0ca                	sd	s2,64(sp)
    80004fcc:	fc4e                	sd	s3,56(sp)
    80004fce:	f852                	sd	s4,48(sp)
    80004fd0:	f456                	sd	s5,40(sp)
    80004fd2:	f05a                	sd	s6,32(sp)
    80004fd4:	1080                	addi	s0,sp,96
    80004fd6:	8aaa                	mv	s5,a0
    80004fd8:	8a2e                	mv	s4,a1
    80004fda:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004fdc:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    80004fde:	0023e517          	auipc	a0,0x23e
    80004fe2:	61250513          	addi	a0,a0,1554 # 802435f0 <cons>
    80004fe6:	15f000ef          	jal	80005944 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004fea:	0023e497          	auipc	s1,0x23e
    80004fee:	60648493          	addi	s1,s1,1542 # 802435f0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004ff2:	0023e917          	auipc	s2,0x23e
    80004ff6:	69690913          	addi	s2,s2,1686 # 80243688 <cons+0x98>
  while(n > 0){
    80004ffa:	0b305b63          	blez	s3,800050b0 <consoleread+0xee>
    while(cons.r == cons.w){
    80004ffe:	0984a783          	lw	a5,152(s1)
    80005002:	09c4a703          	lw	a4,156(s1)
    80005006:	0af71063          	bne	a4,a5,800050a6 <consoleread+0xe4>
      if(killed(myproc())){
    8000500a:	f4dfb0ef          	jal	80000f56 <myproc>
    8000500e:	f4efc0ef          	jal	8000175c <killed>
    80005012:	e12d                	bnez	a0,80005074 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    80005014:	85a6                	mv	a1,s1
    80005016:	854a                	mv	a0,s2
    80005018:	d0cfc0ef          	jal	80001524 <sleep>
    while(cons.r == cons.w){
    8000501c:	0984a783          	lw	a5,152(s1)
    80005020:	09c4a703          	lw	a4,156(s1)
    80005024:	fef703e3          	beq	a4,a5,8000500a <consoleread+0x48>
    80005028:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000502a:	0023e717          	auipc	a4,0x23e
    8000502e:	5c670713          	addi	a4,a4,1478 # 802435f0 <cons>
    80005032:	0017869b          	addiw	a3,a5,1
    80005036:	08d72c23          	sw	a3,152(a4)
    8000503a:	07f7f693          	andi	a3,a5,127
    8000503e:	9736                	add	a4,a4,a3
    80005040:	01874703          	lbu	a4,24(a4)
    80005044:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005048:	4691                	li	a3,4
    8000504a:	04db8663          	beq	s7,a3,80005096 <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000504e:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005052:	4685                	li	a3,1
    80005054:	faf40613          	addi	a2,s0,-81
    80005058:	85d2                	mv	a1,s4
    8000505a:	8556                	mv	a0,s5
    8000505c:	81ffc0ef          	jal	8000187a <either_copyout>
    80005060:	57fd                	li	a5,-1
    80005062:	04f50663          	beq	a0,a5,800050ae <consoleread+0xec>
      break;

    dst++;
    80005066:	0a05                	addi	s4,s4,1
    --n;
    80005068:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000506a:	47a9                	li	a5,10
    8000506c:	04fb8b63          	beq	s7,a5,800050c2 <consoleread+0x100>
    80005070:	6be2                	ld	s7,24(sp)
    80005072:	b761                	j	80004ffa <consoleread+0x38>
        release(&cons.lock);
    80005074:	0023e517          	auipc	a0,0x23e
    80005078:	57c50513          	addi	a0,a0,1404 # 802435f0 <cons>
    8000507c:	15d000ef          	jal	800059d8 <release>
        return -1;
    80005080:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005082:	60e6                	ld	ra,88(sp)
    80005084:	6446                	ld	s0,80(sp)
    80005086:	64a6                	ld	s1,72(sp)
    80005088:	6906                	ld	s2,64(sp)
    8000508a:	79e2                	ld	s3,56(sp)
    8000508c:	7a42                	ld	s4,48(sp)
    8000508e:	7aa2                	ld	s5,40(sp)
    80005090:	7b02                	ld	s6,32(sp)
    80005092:	6125                	addi	sp,sp,96
    80005094:	8082                	ret
      if(n < target){
    80005096:	0169fa63          	bgeu	s3,s6,800050aa <consoleread+0xe8>
        cons.r--;
    8000509a:	0023e717          	auipc	a4,0x23e
    8000509e:	5ef72723          	sw	a5,1518(a4) # 80243688 <cons+0x98>
    800050a2:	6be2                	ld	s7,24(sp)
    800050a4:	a031                	j	800050b0 <consoleread+0xee>
    800050a6:	ec5e                	sd	s7,24(sp)
    800050a8:	b749                	j	8000502a <consoleread+0x68>
    800050aa:	6be2                	ld	s7,24(sp)
    800050ac:	a011                	j	800050b0 <consoleread+0xee>
    800050ae:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    800050b0:	0023e517          	auipc	a0,0x23e
    800050b4:	54050513          	addi	a0,a0,1344 # 802435f0 <cons>
    800050b8:	121000ef          	jal	800059d8 <release>
  return target - n;
    800050bc:	413b053b          	subw	a0,s6,s3
    800050c0:	b7c9                	j	80005082 <consoleread+0xc0>
    800050c2:	6be2                	ld	s7,24(sp)
    800050c4:	b7f5                	j	800050b0 <consoleread+0xee>

00000000800050c6 <consputc>:
{
    800050c6:	1141                	addi	sp,sp,-16
    800050c8:	e406                	sd	ra,8(sp)
    800050ca:	e022                	sd	s0,0(sp)
    800050cc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800050ce:	10000793          	li	a5,256
    800050d2:	00f50863          	beq	a0,a5,800050e2 <consputc+0x1c>
    uartputc_sync(c);
    800050d6:	5fe000ef          	jal	800056d4 <uartputc_sync>
}
    800050da:	60a2                	ld	ra,8(sp)
    800050dc:	6402                	ld	s0,0(sp)
    800050de:	0141                	addi	sp,sp,16
    800050e0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800050e2:	4521                	li	a0,8
    800050e4:	5f0000ef          	jal	800056d4 <uartputc_sync>
    800050e8:	02000513          	li	a0,32
    800050ec:	5e8000ef          	jal	800056d4 <uartputc_sync>
    800050f0:	4521                	li	a0,8
    800050f2:	5e2000ef          	jal	800056d4 <uartputc_sync>
    800050f6:	b7d5                	j	800050da <consputc+0x14>

00000000800050f8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800050f8:	7179                	addi	sp,sp,-48
    800050fa:	f406                	sd	ra,40(sp)
    800050fc:	f022                	sd	s0,32(sp)
    800050fe:	ec26                	sd	s1,24(sp)
    80005100:	1800                	addi	s0,sp,48
    80005102:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005104:	0023e517          	auipc	a0,0x23e
    80005108:	4ec50513          	addi	a0,a0,1260 # 802435f0 <cons>
    8000510c:	039000ef          	jal	80005944 <acquire>

  switch(c){
    80005110:	47d5                	li	a5,21
    80005112:	08f48e63          	beq	s1,a5,800051ae <consoleintr+0xb6>
    80005116:	0297c563          	blt	a5,s1,80005140 <consoleintr+0x48>
    8000511a:	47a1                	li	a5,8
    8000511c:	0ef48863          	beq	s1,a5,8000520c <consoleintr+0x114>
    80005120:	47c1                	li	a5,16
    80005122:	10f49963          	bne	s1,a5,80005234 <consoleintr+0x13c>
  case C('P'):  // Print process list.
    procdump();
    80005126:	fe8fc0ef          	jal	8000190e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000512a:	0023e517          	auipc	a0,0x23e
    8000512e:	4c650513          	addi	a0,a0,1222 # 802435f0 <cons>
    80005132:	0a7000ef          	jal	800059d8 <release>
}
    80005136:	70a2                	ld	ra,40(sp)
    80005138:	7402                	ld	s0,32(sp)
    8000513a:	64e2                	ld	s1,24(sp)
    8000513c:	6145                	addi	sp,sp,48
    8000513e:	8082                	ret
  switch(c){
    80005140:	07f00793          	li	a5,127
    80005144:	0cf48463          	beq	s1,a5,8000520c <consoleintr+0x114>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005148:	0023e717          	auipc	a4,0x23e
    8000514c:	4a870713          	addi	a4,a4,1192 # 802435f0 <cons>
    80005150:	0a072783          	lw	a5,160(a4)
    80005154:	09872703          	lw	a4,152(a4)
    80005158:	9f99                	subw	a5,a5,a4
    8000515a:	07f00713          	li	a4,127
    8000515e:	fcf766e3          	bltu	a4,a5,8000512a <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80005162:	47b5                	li	a5,13
    80005164:	0cf48b63          	beq	s1,a5,8000523a <consoleintr+0x142>
      consputc(c);
    80005168:	8526                	mv	a0,s1
    8000516a:	f5dff0ef          	jal	800050c6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000516e:	0023e797          	auipc	a5,0x23e
    80005172:	48278793          	addi	a5,a5,1154 # 802435f0 <cons>
    80005176:	0a07a683          	lw	a3,160(a5)
    8000517a:	0016871b          	addiw	a4,a3,1
    8000517e:	863a                	mv	a2,a4
    80005180:	0ae7a023          	sw	a4,160(a5)
    80005184:	07f6f693          	andi	a3,a3,127
    80005188:	97b6                	add	a5,a5,a3
    8000518a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000518e:	47a9                	li	a5,10
    80005190:	0cf48963          	beq	s1,a5,80005262 <consoleintr+0x16a>
    80005194:	4791                	li	a5,4
    80005196:	0cf48663          	beq	s1,a5,80005262 <consoleintr+0x16a>
    8000519a:	0023e797          	auipc	a5,0x23e
    8000519e:	4ee7a783          	lw	a5,1262(a5) # 80243688 <cons+0x98>
    800051a2:	9f1d                	subw	a4,a4,a5
    800051a4:	08000793          	li	a5,128
    800051a8:	f8f711e3          	bne	a4,a5,8000512a <consoleintr+0x32>
    800051ac:	a85d                	j	80005262 <consoleintr+0x16a>
    800051ae:	e84a                	sd	s2,16(sp)
    800051b0:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    800051b2:	0023e717          	auipc	a4,0x23e
    800051b6:	43e70713          	addi	a4,a4,1086 # 802435f0 <cons>
    800051ba:	0a072783          	lw	a5,160(a4)
    800051be:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800051c2:	0023e497          	auipc	s1,0x23e
    800051c6:	42e48493          	addi	s1,s1,1070 # 802435f0 <cons>
    while(cons.e != cons.w &&
    800051ca:	4929                	li	s2,10
      consputc(BACKSPACE);
    800051cc:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    800051d0:	02f70863          	beq	a4,a5,80005200 <consoleintr+0x108>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800051d4:	37fd                	addiw	a5,a5,-1
    800051d6:	07f7f713          	andi	a4,a5,127
    800051da:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800051dc:	01874703          	lbu	a4,24(a4)
    800051e0:	03270363          	beq	a4,s2,80005206 <consoleintr+0x10e>
      cons.e--;
    800051e4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800051e8:	854e                	mv	a0,s3
    800051ea:	eddff0ef          	jal	800050c6 <consputc>
    while(cons.e != cons.w &&
    800051ee:	0a04a783          	lw	a5,160(s1)
    800051f2:	09c4a703          	lw	a4,156(s1)
    800051f6:	fcf71fe3          	bne	a4,a5,800051d4 <consoleintr+0xdc>
    800051fa:	6942                	ld	s2,16(sp)
    800051fc:	69a2                	ld	s3,8(sp)
    800051fe:	b735                	j	8000512a <consoleintr+0x32>
    80005200:	6942                	ld	s2,16(sp)
    80005202:	69a2                	ld	s3,8(sp)
    80005204:	b71d                	j	8000512a <consoleintr+0x32>
    80005206:	6942                	ld	s2,16(sp)
    80005208:	69a2                	ld	s3,8(sp)
    8000520a:	b705                	j	8000512a <consoleintr+0x32>
    if(cons.e != cons.w){
    8000520c:	0023e717          	auipc	a4,0x23e
    80005210:	3e470713          	addi	a4,a4,996 # 802435f0 <cons>
    80005214:	0a072783          	lw	a5,160(a4)
    80005218:	09c72703          	lw	a4,156(a4)
    8000521c:	f0f707e3          	beq	a4,a5,8000512a <consoleintr+0x32>
      cons.e--;
    80005220:	37fd                	addiw	a5,a5,-1
    80005222:	0023e717          	auipc	a4,0x23e
    80005226:	46f72723          	sw	a5,1134(a4) # 80243690 <cons+0xa0>
      consputc(BACKSPACE);
    8000522a:	10000513          	li	a0,256
    8000522e:	e99ff0ef          	jal	800050c6 <consputc>
    80005232:	bde5                	j	8000512a <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005234:	ee048be3          	beqz	s1,8000512a <consoleintr+0x32>
    80005238:	bf01                	j	80005148 <consoleintr+0x50>
      consputc(c);
    8000523a:	4529                	li	a0,10
    8000523c:	e8bff0ef          	jal	800050c6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005240:	0023e797          	auipc	a5,0x23e
    80005244:	3b078793          	addi	a5,a5,944 # 802435f0 <cons>
    80005248:	0a07a703          	lw	a4,160(a5)
    8000524c:	0017069b          	addiw	a3,a4,1
    80005250:	8636                	mv	a2,a3
    80005252:	0ad7a023          	sw	a3,160(a5)
    80005256:	07f77713          	andi	a4,a4,127
    8000525a:	97ba                	add	a5,a5,a4
    8000525c:	4729                	li	a4,10
    8000525e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005262:	0023e797          	auipc	a5,0x23e
    80005266:	42c7a523          	sw	a2,1066(a5) # 8024368c <cons+0x9c>
        wakeup(&cons.r);
    8000526a:	0023e517          	auipc	a0,0x23e
    8000526e:	41e50513          	addi	a0,a0,1054 # 80243688 <cons+0x98>
    80005272:	afefc0ef          	jal	80001570 <wakeup>
    80005276:	bd55                	j	8000512a <consoleintr+0x32>

0000000080005278 <consoleinit>:

void
consoleinit(void)
{
    80005278:	1141                	addi	sp,sp,-16
    8000527a:	e406                	sd	ra,8(sp)
    8000527c:	e022                	sd	s0,0(sp)
    8000527e:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005280:	00002597          	auipc	a1,0x2
    80005284:	4c858593          	addi	a1,a1,1224 # 80007748 <etext+0x748>
    80005288:	0023e517          	auipc	a0,0x23e
    8000528c:	36850513          	addi	a0,a0,872 # 802435f0 <cons>
    80005290:	630000ef          	jal	800058c0 <initlock>

  uartinit();
    80005294:	3ea000ef          	jal	8000567e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005298:	00235797          	auipc	a5,0x235
    8000529c:	1c078793          	addi	a5,a5,448 # 8023a458 <devsw>
    800052a0:	00000717          	auipc	a4,0x0
    800052a4:	d2270713          	addi	a4,a4,-734 # 80004fc2 <consoleread>
    800052a8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800052aa:	00000717          	auipc	a4,0x0
    800052ae:	ca270713          	addi	a4,a4,-862 # 80004f4c <consolewrite>
    800052b2:	ef98                	sd	a4,24(a5)
}
    800052b4:	60a2                	ld	ra,8(sp)
    800052b6:	6402                	ld	s0,0(sp)
    800052b8:	0141                	addi	sp,sp,16
    800052ba:	8082                	ret

00000000800052bc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800052bc:	7179                	addi	sp,sp,-48
    800052be:	f406                	sd	ra,40(sp)
    800052c0:	f022                	sd	s0,32(sp)
    800052c2:	ec26                	sd	s1,24(sp)
    800052c4:	e84a                	sd	s2,16(sp)
    800052c6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800052c8:	c219                	beqz	a2,800052ce <printint+0x12>
    800052ca:	06054a63          	bltz	a0,8000533e <printint+0x82>
    x = -xx;
  else
    x = xx;
    800052ce:	4e01                	li	t3,0

  i = 0;
    800052d0:	fd040313          	addi	t1,s0,-48
    x = xx;
    800052d4:	869a                	mv	a3,t1
  i = 0;
    800052d6:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800052d8:	00002817          	auipc	a6,0x2
    800052dc:	5c880813          	addi	a6,a6,1480 # 800078a0 <digits>
    800052e0:	88be                	mv	a7,a5
    800052e2:	0017861b          	addiw	a2,a5,1
    800052e6:	87b2                	mv	a5,a2
    800052e8:	02b57733          	remu	a4,a0,a1
    800052ec:	9742                	add	a4,a4,a6
    800052ee:	00074703          	lbu	a4,0(a4)
    800052f2:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800052f6:	872a                	mv	a4,a0
    800052f8:	02b55533          	divu	a0,a0,a1
    800052fc:	0685                	addi	a3,a3,1
    800052fe:	feb771e3          	bgeu	a4,a1,800052e0 <printint+0x24>

  if(sign)
    80005302:	000e0c63          	beqz	t3,8000531a <printint+0x5e>
    buf[i++] = '-';
    80005306:	fe060793          	addi	a5,a2,-32
    8000530a:	00878633          	add	a2,a5,s0
    8000530e:	02d00793          	li	a5,45
    80005312:	fef60823          	sb	a5,-16(a2)
    80005316:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    8000531a:	fff7891b          	addiw	s2,a5,-1
    8000531e:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    80005322:	fff4c503          	lbu	a0,-1(s1)
    80005326:	da1ff0ef          	jal	800050c6 <consputc>
  while(--i >= 0)
    8000532a:	397d                	addiw	s2,s2,-1
    8000532c:	14fd                	addi	s1,s1,-1
    8000532e:	fe095ae3          	bgez	s2,80005322 <printint+0x66>
}
    80005332:	70a2                	ld	ra,40(sp)
    80005334:	7402                	ld	s0,32(sp)
    80005336:	64e2                	ld	s1,24(sp)
    80005338:	6942                	ld	s2,16(sp)
    8000533a:	6145                	addi	sp,sp,48
    8000533c:	8082                	ret
    x = -xx;
    8000533e:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005342:	4e05                	li	t3,1
    x = -xx;
    80005344:	b771                	j	800052d0 <printint+0x14>

0000000080005346 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005346:	7155                	addi	sp,sp,-208
    80005348:	e506                	sd	ra,136(sp)
    8000534a:	e122                	sd	s0,128(sp)
    8000534c:	f0d2                	sd	s4,96(sp)
    8000534e:	0900                	addi	s0,sp,144
    80005350:	8a2a                	mv	s4,a0
    80005352:	e40c                	sd	a1,8(s0)
    80005354:	e810                	sd	a2,16(s0)
    80005356:	ec14                	sd	a3,24(s0)
    80005358:	f018                	sd	a4,32(s0)
    8000535a:	f41c                	sd	a5,40(s0)
    8000535c:	03043823          	sd	a6,48(s0)
    80005360:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    80005364:	0023e797          	auipc	a5,0x23e
    80005368:	34c7a783          	lw	a5,844(a5) # 802436b0 <pr+0x18>
    8000536c:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    80005370:	e3a1                	bnez	a5,800053b0 <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005372:	00840793          	addi	a5,s0,8
    80005376:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000537a:	00054503          	lbu	a0,0(a0)
    8000537e:	26050663          	beqz	a0,800055ea <printf+0x2a4>
    80005382:	fca6                	sd	s1,120(sp)
    80005384:	f8ca                	sd	s2,112(sp)
    80005386:	f4ce                	sd	s3,104(sp)
    80005388:	ecd6                	sd	s5,88(sp)
    8000538a:	e8da                	sd	s6,80(sp)
    8000538c:	e0e2                	sd	s8,64(sp)
    8000538e:	fc66                	sd	s9,56(sp)
    80005390:	f86a                	sd	s10,48(sp)
    80005392:	f46e                	sd	s11,40(sp)
    80005394:	4981                	li	s3,0
    if(cx != '%'){
    80005396:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    8000539a:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000539e:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800053a2:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800053a6:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800053aa:	07000d93          	li	s11,112
    800053ae:	a80d                	j	800053e0 <printf+0x9a>
    acquire(&pr.lock);
    800053b0:	0023e517          	auipc	a0,0x23e
    800053b4:	2e850513          	addi	a0,a0,744 # 80243698 <pr>
    800053b8:	58c000ef          	jal	80005944 <acquire>
  va_start(ap, fmt);
    800053bc:	00840793          	addi	a5,s0,8
    800053c0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800053c4:	000a4503          	lbu	a0,0(s4)
    800053c8:	fd4d                	bnez	a0,80005382 <printf+0x3c>
    800053ca:	ac3d                	j	80005608 <printf+0x2c2>
      consputc(cx);
    800053cc:	cfbff0ef          	jal	800050c6 <consputc>
      continue;
    800053d0:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800053d2:	2485                	addiw	s1,s1,1
    800053d4:	89a6                	mv	s3,s1
    800053d6:	94d2                	add	s1,s1,s4
    800053d8:	0004c503          	lbu	a0,0(s1)
    800053dc:	1e050b63          	beqz	a0,800055d2 <printf+0x28c>
    if(cx != '%'){
    800053e0:	ff5516e3          	bne	a0,s5,800053cc <printf+0x86>
    i++;
    800053e4:	0019879b          	addiw	a5,s3,1
    800053e8:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    800053ea:	00fa0733          	add	a4,s4,a5
    800053ee:	00074903          	lbu	s2,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    800053f2:	1e090063          	beqz	s2,800055d2 <printf+0x28c>
    800053f6:	00174703          	lbu	a4,1(a4)
    c1 = c2 = 0;
    800053fa:	86ba                	mv	a3,a4
    if(c1) c2 = fmt[i+2] & 0xff;
    800053fc:	c701                	beqz	a4,80005404 <printf+0xbe>
    800053fe:	97d2                	add	a5,a5,s4
    80005400:	0027c683          	lbu	a3,2(a5)
    if(c0 == 'd'){
    80005404:	03690763          	beq	s2,s6,80005432 <printf+0xec>
    } else if(c0 == 'l' && c1 == 'd'){
    80005408:	05890163          	beq	s2,s8,8000544a <printf+0x104>
    } else if(c0 == 'u'){
    8000540c:	0d990b63          	beq	s2,s9,800054e2 <printf+0x19c>
    } else if(c0 == 'x'){
    80005410:	13a90163          	beq	s2,s10,80005532 <printf+0x1ec>
    } else if(c0 == 'p'){
    80005414:	13b90b63          	beq	s2,s11,8000554a <printf+0x204>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80005418:	07300793          	li	a5,115
    8000541c:	16f90a63          	beq	s2,a5,80005590 <printf+0x24a>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    80005420:	1b590463          	beq	s2,s5,800055c8 <printf+0x282>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005424:	8556                	mv	a0,s5
    80005426:	ca1ff0ef          	jal	800050c6 <consputc>
      consputc(c0);
    8000542a:	854a                	mv	a0,s2
    8000542c:	c9bff0ef          	jal	800050c6 <consputc>
    80005430:	b74d                	j	800053d2 <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    80005432:	f8843783          	ld	a5,-120(s0)
    80005436:	00878713          	addi	a4,a5,8
    8000543a:	f8e43423          	sd	a4,-120(s0)
    8000543e:	4605                	li	a2,1
    80005440:	45a9                	li	a1,10
    80005442:	4388                	lw	a0,0(a5)
    80005444:	e79ff0ef          	jal	800052bc <printint>
    80005448:	b769                	j	800053d2 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    8000544a:	03670663          	beq	a4,s6,80005476 <printf+0x130>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000544e:	05870263          	beq	a4,s8,80005492 <printf+0x14c>
    } else if(c0 == 'l' && c1 == 'u'){
    80005452:	0b970463          	beq	a4,s9,800054fa <printf+0x1b4>
    } else if(c0 == 'l' && c1 == 'x'){
    80005456:	fda717e3          	bne	a4,s10,80005424 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    8000545a:	f8843783          	ld	a5,-120(s0)
    8000545e:	00878713          	addi	a4,a5,8
    80005462:	f8e43423          	sd	a4,-120(s0)
    80005466:	4601                	li	a2,0
    80005468:	45c1                	li	a1,16
    8000546a:	6388                	ld	a0,0(a5)
    8000546c:	e51ff0ef          	jal	800052bc <printint>
      i += 1;
    80005470:	0029849b          	addiw	s1,s3,2
    80005474:	bfb9                	j	800053d2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005476:	f8843783          	ld	a5,-120(s0)
    8000547a:	00878713          	addi	a4,a5,8
    8000547e:	f8e43423          	sd	a4,-120(s0)
    80005482:	4605                	li	a2,1
    80005484:	45a9                	li	a1,10
    80005486:	6388                	ld	a0,0(a5)
    80005488:	e35ff0ef          	jal	800052bc <printint>
      i += 1;
    8000548c:	0029849b          	addiw	s1,s3,2
    80005490:	b789                	j	800053d2 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005492:	06400793          	li	a5,100
    80005496:	02f68863          	beq	a3,a5,800054c6 <printf+0x180>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    8000549a:	07500793          	li	a5,117
    8000549e:	06f68c63          	beq	a3,a5,80005516 <printf+0x1d0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800054a2:	07800793          	li	a5,120
    800054a6:	f6f69fe3          	bne	a3,a5,80005424 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    800054aa:	f8843783          	ld	a5,-120(s0)
    800054ae:	00878713          	addi	a4,a5,8
    800054b2:	f8e43423          	sd	a4,-120(s0)
    800054b6:	4601                	li	a2,0
    800054b8:	45c1                	li	a1,16
    800054ba:	6388                	ld	a0,0(a5)
    800054bc:	e01ff0ef          	jal	800052bc <printint>
      i += 2;
    800054c0:	0039849b          	addiw	s1,s3,3
    800054c4:	b739                	j	800053d2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800054c6:	f8843783          	ld	a5,-120(s0)
    800054ca:	00878713          	addi	a4,a5,8
    800054ce:	f8e43423          	sd	a4,-120(s0)
    800054d2:	4605                	li	a2,1
    800054d4:	45a9                	li	a1,10
    800054d6:	6388                	ld	a0,0(a5)
    800054d8:	de5ff0ef          	jal	800052bc <printint>
      i += 2;
    800054dc:	0039849b          	addiw	s1,s3,3
    800054e0:	bdcd                	j	800053d2 <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    800054e2:	f8843783          	ld	a5,-120(s0)
    800054e6:	00878713          	addi	a4,a5,8
    800054ea:	f8e43423          	sd	a4,-120(s0)
    800054ee:	4601                	li	a2,0
    800054f0:	45a9                	li	a1,10
    800054f2:	4388                	lw	a0,0(a5)
    800054f4:	dc9ff0ef          	jal	800052bc <printint>
    800054f8:	bde9                	j	800053d2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800054fa:	f8843783          	ld	a5,-120(s0)
    800054fe:	00878713          	addi	a4,a5,8
    80005502:	f8e43423          	sd	a4,-120(s0)
    80005506:	4601                	li	a2,0
    80005508:	45a9                	li	a1,10
    8000550a:	6388                	ld	a0,0(a5)
    8000550c:	db1ff0ef          	jal	800052bc <printint>
      i += 1;
    80005510:	0029849b          	addiw	s1,s3,2
    80005514:	bd7d                	j	800053d2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005516:	f8843783          	ld	a5,-120(s0)
    8000551a:	00878713          	addi	a4,a5,8
    8000551e:	f8e43423          	sd	a4,-120(s0)
    80005522:	4601                	li	a2,0
    80005524:	45a9                	li	a1,10
    80005526:	6388                	ld	a0,0(a5)
    80005528:	d95ff0ef          	jal	800052bc <printint>
      i += 2;
    8000552c:	0039849b          	addiw	s1,s3,3
    80005530:	b54d                	j	800053d2 <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    80005532:	f8843783          	ld	a5,-120(s0)
    80005536:	00878713          	addi	a4,a5,8
    8000553a:	f8e43423          	sd	a4,-120(s0)
    8000553e:	4601                	li	a2,0
    80005540:	45c1                	li	a1,16
    80005542:	4388                	lw	a0,0(a5)
    80005544:	d79ff0ef          	jal	800052bc <printint>
    80005548:	b569                	j	800053d2 <printf+0x8c>
    8000554a:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    8000554c:	f8843783          	ld	a5,-120(s0)
    80005550:	00878713          	addi	a4,a5,8
    80005554:	f8e43423          	sd	a4,-120(s0)
    80005558:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000555c:	03000513          	li	a0,48
    80005560:	b67ff0ef          	jal	800050c6 <consputc>
  consputc('x');
    80005564:	07800513          	li	a0,120
    80005568:	b5fff0ef          	jal	800050c6 <consputc>
    8000556c:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000556e:	00002b97          	auipc	s7,0x2
    80005572:	332b8b93          	addi	s7,s7,818 # 800078a0 <digits>
    80005576:	03c9d793          	srli	a5,s3,0x3c
    8000557a:	97de                	add	a5,a5,s7
    8000557c:	0007c503          	lbu	a0,0(a5)
    80005580:	b47ff0ef          	jal	800050c6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005584:	0992                	slli	s3,s3,0x4
    80005586:	397d                	addiw	s2,s2,-1
    80005588:	fe0917e3          	bnez	s2,80005576 <printf+0x230>
    8000558c:	6ba6                	ld	s7,72(sp)
    8000558e:	b591                	j	800053d2 <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    80005590:	f8843783          	ld	a5,-120(s0)
    80005594:	00878713          	addi	a4,a5,8
    80005598:	f8e43423          	sd	a4,-120(s0)
    8000559c:	0007b903          	ld	s2,0(a5)
    800055a0:	00090d63          	beqz	s2,800055ba <printf+0x274>
      for(; *s; s++)
    800055a4:	00094503          	lbu	a0,0(s2)
    800055a8:	e20505e3          	beqz	a0,800053d2 <printf+0x8c>
        consputc(*s);
    800055ac:	b1bff0ef          	jal	800050c6 <consputc>
      for(; *s; s++)
    800055b0:	0905                	addi	s2,s2,1
    800055b2:	00094503          	lbu	a0,0(s2)
    800055b6:	f97d                	bnez	a0,800055ac <printf+0x266>
    800055b8:	bd29                	j	800053d2 <printf+0x8c>
        s = "(null)";
    800055ba:	00002917          	auipc	s2,0x2
    800055be:	19690913          	addi	s2,s2,406 # 80007750 <etext+0x750>
      for(; *s; s++)
    800055c2:	02800513          	li	a0,40
    800055c6:	b7dd                	j	800055ac <printf+0x266>
      consputc('%');
    800055c8:	02500513          	li	a0,37
    800055cc:	afbff0ef          	jal	800050c6 <consputc>
    800055d0:	b509                	j	800053d2 <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    800055d2:	f7843783          	ld	a5,-136(s0)
    800055d6:	e385                	bnez	a5,800055f6 <printf+0x2b0>
    800055d8:	74e6                	ld	s1,120(sp)
    800055da:	7946                	ld	s2,112(sp)
    800055dc:	79a6                	ld	s3,104(sp)
    800055de:	6ae6                	ld	s5,88(sp)
    800055e0:	6b46                	ld	s6,80(sp)
    800055e2:	6c06                	ld	s8,64(sp)
    800055e4:	7ce2                	ld	s9,56(sp)
    800055e6:	7d42                	ld	s10,48(sp)
    800055e8:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    800055ea:	4501                	li	a0,0
    800055ec:	60aa                	ld	ra,136(sp)
    800055ee:	640a                	ld	s0,128(sp)
    800055f0:	7a06                	ld	s4,96(sp)
    800055f2:	6169                	addi	sp,sp,208
    800055f4:	8082                	ret
    800055f6:	74e6                	ld	s1,120(sp)
    800055f8:	7946                	ld	s2,112(sp)
    800055fa:	79a6                	ld	s3,104(sp)
    800055fc:	6ae6                	ld	s5,88(sp)
    800055fe:	6b46                	ld	s6,80(sp)
    80005600:	6c06                	ld	s8,64(sp)
    80005602:	7ce2                	ld	s9,56(sp)
    80005604:	7d42                	ld	s10,48(sp)
    80005606:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80005608:	0023e517          	auipc	a0,0x23e
    8000560c:	09050513          	addi	a0,a0,144 # 80243698 <pr>
    80005610:	3c8000ef          	jal	800059d8 <release>
    80005614:	bfd9                	j	800055ea <printf+0x2a4>

0000000080005616 <panic>:

void
panic(char *s)
{
    80005616:	1101                	addi	sp,sp,-32
    80005618:	ec06                	sd	ra,24(sp)
    8000561a:	e822                	sd	s0,16(sp)
    8000561c:	e426                	sd	s1,8(sp)
    8000561e:	1000                	addi	s0,sp,32
    80005620:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005622:	0023e797          	auipc	a5,0x23e
    80005626:	0807a723          	sw	zero,142(a5) # 802436b0 <pr+0x18>
  printf("panic: ");
    8000562a:	00002517          	auipc	a0,0x2
    8000562e:	12e50513          	addi	a0,a0,302 # 80007758 <etext+0x758>
    80005632:	d15ff0ef          	jal	80005346 <printf>
  printf("%s\n", s);
    80005636:	85a6                	mv	a1,s1
    80005638:	00002517          	auipc	a0,0x2
    8000563c:	12850513          	addi	a0,a0,296 # 80007760 <etext+0x760>
    80005640:	d07ff0ef          	jal	80005346 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005644:	4785                	li	a5,1
    80005646:	00005717          	auipc	a4,0x5
    8000564a:	d6f72323          	sw	a5,-666(a4) # 8000a3ac <panicked>
  for(;;)
    8000564e:	a001                	j	8000564e <panic+0x38>

0000000080005650 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005650:	1101                	addi	sp,sp,-32
    80005652:	ec06                	sd	ra,24(sp)
    80005654:	e822                	sd	s0,16(sp)
    80005656:	e426                	sd	s1,8(sp)
    80005658:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000565a:	0023e497          	auipc	s1,0x23e
    8000565e:	03e48493          	addi	s1,s1,62 # 80243698 <pr>
    80005662:	00002597          	auipc	a1,0x2
    80005666:	10658593          	addi	a1,a1,262 # 80007768 <etext+0x768>
    8000566a:	8526                	mv	a0,s1
    8000566c:	254000ef          	jal	800058c0 <initlock>
  pr.locking = 1;
    80005670:	4785                	li	a5,1
    80005672:	cc9c                	sw	a5,24(s1)
}
    80005674:	60e2                	ld	ra,24(sp)
    80005676:	6442                	ld	s0,16(sp)
    80005678:	64a2                	ld	s1,8(sp)
    8000567a:	6105                	addi	sp,sp,32
    8000567c:	8082                	ret

000000008000567e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000567e:	1141                	addi	sp,sp,-16
    80005680:	e406                	sd	ra,8(sp)
    80005682:	e022                	sd	s0,0(sp)
    80005684:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005686:	100007b7          	lui	a5,0x10000
    8000568a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000568e:	10000737          	lui	a4,0x10000
    80005692:	f8000693          	li	a3,-128
    80005696:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000569a:	468d                	li	a3,3
    8000569c:	10000637          	lui	a2,0x10000
    800056a0:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800056a4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800056a8:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800056ac:	8732                	mv	a4,a2
    800056ae:	461d                	li	a2,7
    800056b0:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800056b4:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800056b8:	00002597          	auipc	a1,0x2
    800056bc:	0b858593          	addi	a1,a1,184 # 80007770 <etext+0x770>
    800056c0:	0023e517          	auipc	a0,0x23e
    800056c4:	ff850513          	addi	a0,a0,-8 # 802436b8 <uart_tx_lock>
    800056c8:	1f8000ef          	jal	800058c0 <initlock>
}
    800056cc:	60a2                	ld	ra,8(sp)
    800056ce:	6402                	ld	s0,0(sp)
    800056d0:	0141                	addi	sp,sp,16
    800056d2:	8082                	ret

00000000800056d4 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800056d4:	1101                	addi	sp,sp,-32
    800056d6:	ec06                	sd	ra,24(sp)
    800056d8:	e822                	sd	s0,16(sp)
    800056da:	e426                	sd	s1,8(sp)
    800056dc:	1000                	addi	s0,sp,32
    800056de:	84aa                	mv	s1,a0
  push_off();
    800056e0:	224000ef          	jal	80005904 <push_off>

  if(panicked){
    800056e4:	00005797          	auipc	a5,0x5
    800056e8:	cc87a783          	lw	a5,-824(a5) # 8000a3ac <panicked>
    800056ec:	e795                	bnez	a5,80005718 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800056ee:	10000737          	lui	a4,0x10000
    800056f2:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800056f4:	00074783          	lbu	a5,0(a4)
    800056f8:	0207f793          	andi	a5,a5,32
    800056fc:	dfe5                	beqz	a5,800056f4 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800056fe:	0ff4f513          	zext.b	a0,s1
    80005702:	100007b7          	lui	a5,0x10000
    80005706:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000570a:	27e000ef          	jal	80005988 <pop_off>
}
    8000570e:	60e2                	ld	ra,24(sp)
    80005710:	6442                	ld	s0,16(sp)
    80005712:	64a2                	ld	s1,8(sp)
    80005714:	6105                	addi	sp,sp,32
    80005716:	8082                	ret
    for(;;)
    80005718:	a001                	j	80005718 <uartputc_sync+0x44>

000000008000571a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000571a:	00005797          	auipc	a5,0x5
    8000571e:	c967b783          	ld	a5,-874(a5) # 8000a3b0 <uart_tx_r>
    80005722:	00005717          	auipc	a4,0x5
    80005726:	c9673703          	ld	a4,-874(a4) # 8000a3b8 <uart_tx_w>
    8000572a:	08f70163          	beq	a4,a5,800057ac <uartstart+0x92>
{
    8000572e:	7139                	addi	sp,sp,-64
    80005730:	fc06                	sd	ra,56(sp)
    80005732:	f822                	sd	s0,48(sp)
    80005734:	f426                	sd	s1,40(sp)
    80005736:	f04a                	sd	s2,32(sp)
    80005738:	ec4e                	sd	s3,24(sp)
    8000573a:	e852                	sd	s4,16(sp)
    8000573c:	e456                	sd	s5,8(sp)
    8000573e:	e05a                	sd	s6,0(sp)
    80005740:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005742:	10000937          	lui	s2,0x10000
    80005746:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005748:	0023ea97          	auipc	s5,0x23e
    8000574c:	f70a8a93          	addi	s5,s5,-144 # 802436b8 <uart_tx_lock>
    uart_tx_r += 1;
    80005750:	00005497          	auipc	s1,0x5
    80005754:	c6048493          	addi	s1,s1,-928 # 8000a3b0 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005758:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000575c:	00005997          	auipc	s3,0x5
    80005760:	c5c98993          	addi	s3,s3,-932 # 8000a3b8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005764:	00094703          	lbu	a4,0(s2)
    80005768:	02077713          	andi	a4,a4,32
    8000576c:	c715                	beqz	a4,80005798 <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000576e:	01f7f713          	andi	a4,a5,31
    80005772:	9756                	add	a4,a4,s5
    80005774:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005778:	0785                	addi	a5,a5,1
    8000577a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000577c:	8526                	mv	a0,s1
    8000577e:	df3fb0ef          	jal	80001570 <wakeup>
    WriteReg(THR, c);
    80005782:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005786:	609c                	ld	a5,0(s1)
    80005788:	0009b703          	ld	a4,0(s3)
    8000578c:	fcf71ce3          	bne	a4,a5,80005764 <uartstart+0x4a>
      ReadReg(ISR);
    80005790:	100007b7          	lui	a5,0x10000
    80005794:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    80005798:	70e2                	ld	ra,56(sp)
    8000579a:	7442                	ld	s0,48(sp)
    8000579c:	74a2                	ld	s1,40(sp)
    8000579e:	7902                	ld	s2,32(sp)
    800057a0:	69e2                	ld	s3,24(sp)
    800057a2:	6a42                	ld	s4,16(sp)
    800057a4:	6aa2                	ld	s5,8(sp)
    800057a6:	6b02                	ld	s6,0(sp)
    800057a8:	6121                	addi	sp,sp,64
    800057aa:	8082                	ret
      ReadReg(ISR);
    800057ac:	100007b7          	lui	a5,0x10000
    800057b0:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    800057b4:	8082                	ret

00000000800057b6 <uartputc>:
{
    800057b6:	7179                	addi	sp,sp,-48
    800057b8:	f406                	sd	ra,40(sp)
    800057ba:	f022                	sd	s0,32(sp)
    800057bc:	ec26                	sd	s1,24(sp)
    800057be:	e84a                	sd	s2,16(sp)
    800057c0:	e44e                	sd	s3,8(sp)
    800057c2:	e052                	sd	s4,0(sp)
    800057c4:	1800                	addi	s0,sp,48
    800057c6:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800057c8:	0023e517          	auipc	a0,0x23e
    800057cc:	ef050513          	addi	a0,a0,-272 # 802436b8 <uart_tx_lock>
    800057d0:	174000ef          	jal	80005944 <acquire>
  if(panicked){
    800057d4:	00005797          	auipc	a5,0x5
    800057d8:	bd87a783          	lw	a5,-1064(a5) # 8000a3ac <panicked>
    800057dc:	efbd                	bnez	a5,8000585a <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800057de:	00005717          	auipc	a4,0x5
    800057e2:	bda73703          	ld	a4,-1062(a4) # 8000a3b8 <uart_tx_w>
    800057e6:	00005797          	auipc	a5,0x5
    800057ea:	bca7b783          	ld	a5,-1078(a5) # 8000a3b0 <uart_tx_r>
    800057ee:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800057f2:	0023e997          	auipc	s3,0x23e
    800057f6:	ec698993          	addi	s3,s3,-314 # 802436b8 <uart_tx_lock>
    800057fa:	00005497          	auipc	s1,0x5
    800057fe:	bb648493          	addi	s1,s1,-1098 # 8000a3b0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005802:	00005917          	auipc	s2,0x5
    80005806:	bb690913          	addi	s2,s2,-1098 # 8000a3b8 <uart_tx_w>
    8000580a:	00e79d63          	bne	a5,a4,80005824 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000580e:	85ce                	mv	a1,s3
    80005810:	8526                	mv	a0,s1
    80005812:	d13fb0ef          	jal	80001524 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005816:	00093703          	ld	a4,0(s2)
    8000581a:	609c                	ld	a5,0(s1)
    8000581c:	02078793          	addi	a5,a5,32
    80005820:	fee787e3          	beq	a5,a4,8000580e <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005824:	0023e497          	auipc	s1,0x23e
    80005828:	e9448493          	addi	s1,s1,-364 # 802436b8 <uart_tx_lock>
    8000582c:	01f77793          	andi	a5,a4,31
    80005830:	97a6                	add	a5,a5,s1
    80005832:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005836:	0705                	addi	a4,a4,1
    80005838:	00005797          	auipc	a5,0x5
    8000583c:	b8e7b023          	sd	a4,-1152(a5) # 8000a3b8 <uart_tx_w>
  uartstart();
    80005840:	edbff0ef          	jal	8000571a <uartstart>
  release(&uart_tx_lock);
    80005844:	8526                	mv	a0,s1
    80005846:	192000ef          	jal	800059d8 <release>
}
    8000584a:	70a2                	ld	ra,40(sp)
    8000584c:	7402                	ld	s0,32(sp)
    8000584e:	64e2                	ld	s1,24(sp)
    80005850:	6942                	ld	s2,16(sp)
    80005852:	69a2                	ld	s3,8(sp)
    80005854:	6a02                	ld	s4,0(sp)
    80005856:	6145                	addi	sp,sp,48
    80005858:	8082                	ret
    for(;;)
    8000585a:	a001                	j	8000585a <uartputc+0xa4>

000000008000585c <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000585c:	1141                	addi	sp,sp,-16
    8000585e:	e406                	sd	ra,8(sp)
    80005860:	e022                	sd	s0,0(sp)
    80005862:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005864:	100007b7          	lui	a5,0x10000
    80005868:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000586c:	8b85                	andi	a5,a5,1
    8000586e:	cb89                	beqz	a5,80005880 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005870:	100007b7          	lui	a5,0x10000
    80005874:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005878:	60a2                	ld	ra,8(sp)
    8000587a:	6402                	ld	s0,0(sp)
    8000587c:	0141                	addi	sp,sp,16
    8000587e:	8082                	ret
    return -1;
    80005880:	557d                	li	a0,-1
    80005882:	bfdd                	j	80005878 <uartgetc+0x1c>

0000000080005884 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005884:	1101                	addi	sp,sp,-32
    80005886:	ec06                	sd	ra,24(sp)
    80005888:	e822                	sd	s0,16(sp)
    8000588a:	e426                	sd	s1,8(sp)
    8000588c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000588e:	54fd                	li	s1,-1
    int c = uartgetc();
    80005890:	fcdff0ef          	jal	8000585c <uartgetc>
    if(c == -1)
    80005894:	00950563          	beq	a0,s1,8000589e <uartintr+0x1a>
      break;
    consoleintr(c);
    80005898:	861ff0ef          	jal	800050f8 <consoleintr>
  while(1){
    8000589c:	bfd5                	j	80005890 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000589e:	0023e497          	auipc	s1,0x23e
    800058a2:	e1a48493          	addi	s1,s1,-486 # 802436b8 <uart_tx_lock>
    800058a6:	8526                	mv	a0,s1
    800058a8:	09c000ef          	jal	80005944 <acquire>
  uartstart();
    800058ac:	e6fff0ef          	jal	8000571a <uartstart>
  release(&uart_tx_lock);
    800058b0:	8526                	mv	a0,s1
    800058b2:	126000ef          	jal	800059d8 <release>
}
    800058b6:	60e2                	ld	ra,24(sp)
    800058b8:	6442                	ld	s0,16(sp)
    800058ba:	64a2                	ld	s1,8(sp)
    800058bc:	6105                	addi	sp,sp,32
    800058be:	8082                	ret

00000000800058c0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800058c0:	1141                	addi	sp,sp,-16
    800058c2:	e406                	sd	ra,8(sp)
    800058c4:	e022                	sd	s0,0(sp)
    800058c6:	0800                	addi	s0,sp,16
  lk->name = name;
    800058c8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800058ca:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800058ce:	00053823          	sd	zero,16(a0)
}
    800058d2:	60a2                	ld	ra,8(sp)
    800058d4:	6402                	ld	s0,0(sp)
    800058d6:	0141                	addi	sp,sp,16
    800058d8:	8082                	ret

00000000800058da <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800058da:	411c                	lw	a5,0(a0)
    800058dc:	e399                	bnez	a5,800058e2 <holding+0x8>
    800058de:	4501                	li	a0,0
  return r;
}
    800058e0:	8082                	ret
{
    800058e2:	1101                	addi	sp,sp,-32
    800058e4:	ec06                	sd	ra,24(sp)
    800058e6:	e822                	sd	s0,16(sp)
    800058e8:	e426                	sd	s1,8(sp)
    800058ea:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800058ec:	6904                	ld	s1,16(a0)
    800058ee:	e48fb0ef          	jal	80000f36 <mycpu>
    800058f2:	40a48533          	sub	a0,s1,a0
    800058f6:	00153513          	seqz	a0,a0
}
    800058fa:	60e2                	ld	ra,24(sp)
    800058fc:	6442                	ld	s0,16(sp)
    800058fe:	64a2                	ld	s1,8(sp)
    80005900:	6105                	addi	sp,sp,32
    80005902:	8082                	ret

0000000080005904 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005904:	1101                	addi	sp,sp,-32
    80005906:	ec06                	sd	ra,24(sp)
    80005908:	e822                	sd	s0,16(sp)
    8000590a:	e426                	sd	s1,8(sp)
    8000590c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000590e:	100024f3          	csrr	s1,sstatus
    80005912:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005916:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005918:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000591c:	e1afb0ef          	jal	80000f36 <mycpu>
    80005920:	5d3c                	lw	a5,120(a0)
    80005922:	cb99                	beqz	a5,80005938 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005924:	e12fb0ef          	jal	80000f36 <mycpu>
    80005928:	5d3c                	lw	a5,120(a0)
    8000592a:	2785                	addiw	a5,a5,1
    8000592c:	dd3c                	sw	a5,120(a0)
}
    8000592e:	60e2                	ld	ra,24(sp)
    80005930:	6442                	ld	s0,16(sp)
    80005932:	64a2                	ld	s1,8(sp)
    80005934:	6105                	addi	sp,sp,32
    80005936:	8082                	ret
    mycpu()->intena = old;
    80005938:	dfefb0ef          	jal	80000f36 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000593c:	8085                	srli	s1,s1,0x1
    8000593e:	8885                	andi	s1,s1,1
    80005940:	dd64                	sw	s1,124(a0)
    80005942:	b7cd                	j	80005924 <push_off+0x20>

0000000080005944 <acquire>:
{
    80005944:	1101                	addi	sp,sp,-32
    80005946:	ec06                	sd	ra,24(sp)
    80005948:	e822                	sd	s0,16(sp)
    8000594a:	e426                	sd	s1,8(sp)
    8000594c:	1000                	addi	s0,sp,32
    8000594e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005950:	fb5ff0ef          	jal	80005904 <push_off>
  if(holding(lk))
    80005954:	8526                	mv	a0,s1
    80005956:	f85ff0ef          	jal	800058da <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000595a:	4705                	li	a4,1
  if(holding(lk))
    8000595c:	e105                	bnez	a0,8000597c <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000595e:	87ba                	mv	a5,a4
    80005960:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005964:	2781                	sext.w	a5,a5
    80005966:	ffe5                	bnez	a5,8000595e <acquire+0x1a>
  __sync_synchronize();
    80005968:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    8000596c:	dcafb0ef          	jal	80000f36 <mycpu>
    80005970:	e888                	sd	a0,16(s1)
}
    80005972:	60e2                	ld	ra,24(sp)
    80005974:	6442                	ld	s0,16(sp)
    80005976:	64a2                	ld	s1,8(sp)
    80005978:	6105                	addi	sp,sp,32
    8000597a:	8082                	ret
    panic("acquire");
    8000597c:	00002517          	auipc	a0,0x2
    80005980:	dfc50513          	addi	a0,a0,-516 # 80007778 <etext+0x778>
    80005984:	c93ff0ef          	jal	80005616 <panic>

0000000080005988 <pop_off>:

void
pop_off(void)
{
    80005988:	1141                	addi	sp,sp,-16
    8000598a:	e406                	sd	ra,8(sp)
    8000598c:	e022                	sd	s0,0(sp)
    8000598e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005990:	da6fb0ef          	jal	80000f36 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005994:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005998:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000599a:	e39d                	bnez	a5,800059c0 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000599c:	5d3c                	lw	a5,120(a0)
    8000599e:	02f05763          	blez	a5,800059cc <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    800059a2:	37fd                	addiw	a5,a5,-1
    800059a4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800059a6:	eb89                	bnez	a5,800059b8 <pop_off+0x30>
    800059a8:	5d7c                	lw	a5,124(a0)
    800059aa:	c799                	beqz	a5,800059b8 <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800059ac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800059b0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800059b4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800059b8:	60a2                	ld	ra,8(sp)
    800059ba:	6402                	ld	s0,0(sp)
    800059bc:	0141                	addi	sp,sp,16
    800059be:	8082                	ret
    panic("pop_off - interruptible");
    800059c0:	00002517          	auipc	a0,0x2
    800059c4:	dc050513          	addi	a0,a0,-576 # 80007780 <etext+0x780>
    800059c8:	c4fff0ef          	jal	80005616 <panic>
    panic("pop_off");
    800059cc:	00002517          	auipc	a0,0x2
    800059d0:	dcc50513          	addi	a0,a0,-564 # 80007798 <etext+0x798>
    800059d4:	c43ff0ef          	jal	80005616 <panic>

00000000800059d8 <release>:
{
    800059d8:	1101                	addi	sp,sp,-32
    800059da:	ec06                	sd	ra,24(sp)
    800059dc:	e822                	sd	s0,16(sp)
    800059de:	e426                	sd	s1,8(sp)
    800059e0:	1000                	addi	s0,sp,32
    800059e2:	84aa                	mv	s1,a0
  if(!holding(lk))
    800059e4:	ef7ff0ef          	jal	800058da <holding>
    800059e8:	c105                	beqz	a0,80005a08 <release+0x30>
  lk->cpu = 0;
    800059ea:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800059ee:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800059f2:	0310000f          	fence	rw,w
    800059f6:	0004a023          	sw	zero,0(s1)
  pop_off();
    800059fa:	f8fff0ef          	jal	80005988 <pop_off>
}
    800059fe:	60e2                	ld	ra,24(sp)
    80005a00:	6442                	ld	s0,16(sp)
    80005a02:	64a2                	ld	s1,8(sp)
    80005a04:	6105                	addi	sp,sp,32
    80005a06:	8082                	ret
    panic("release");
    80005a08:	00002517          	auipc	a0,0x2
    80005a0c:	d9850513          	addi	a0,a0,-616 # 800077a0 <etext+0x7a0>
    80005a10:	c07ff0ef          	jal	80005616 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
