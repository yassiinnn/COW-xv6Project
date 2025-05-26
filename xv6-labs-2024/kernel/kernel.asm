
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001b117          	auipc	sp,0x1b
    80000004:	4d010113          	addi	sp,sp,1232 # 8001b4d0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	497040ef          	jal	80004cac <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e3a9                	bnez	a5,8000006e <kfree+0x52>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00023797          	auipc	a5,0x23
    80000034:	5a078793          	addi	a5,a5,1440 # 800235d0 <end>
    80000038:	02f56b63          	bltu	a0,a5,8000006e <kfree+0x52>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57763          	bgeu	a0,a5,8000006e <kfree+0x52>
  memset(pa, 1, PGSIZE);
#endif
  
  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000044:	0000a917          	auipc	s2,0xa
    80000048:	25c90913          	addi	s2,s2,604 # 8000a2a0 <kmem>
    8000004c:	854a                	mv	a0,s2
    8000004e:	6c6050ef          	jal	80005714 <acquire>
  r->next = kmem.freelist;
    80000052:	01893783          	ld	a5,24(s2)
    80000056:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000058:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000005c:	854a                	mv	a0,s2
    8000005e:	74a050ef          	jal	800057a8 <release>
}
    80000062:	60e2                	ld	ra,24(sp)
    80000064:	6442                	ld	s0,16(sp)
    80000066:	64a2                	ld	s1,8(sp)
    80000068:	6902                	ld	s2,0(sp)
    8000006a:	6105                	addi	sp,sp,32
    8000006c:	8082                	ret
    panic("kfree");
    8000006e:	00007517          	auipc	a0,0x7
    80000072:	f9250513          	addi	a0,a0,-110 # 80007000 <etext>
    80000076:	370050ef          	jal	800053e6 <panic>

000000008000007a <freerange>:
{
    8000007a:	7179                	addi	sp,sp,-48
    8000007c:	f406                	sd	ra,40(sp)
    8000007e:	f022                	sd	s0,32(sp)
    80000080:	ec26                	sd	s1,24(sp)
    80000082:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000084:	6785                	lui	a5,0x1
    80000086:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    8000008a:	00e504b3          	add	s1,a0,a4
    8000008e:	777d                	lui	a4,0xfffff
    80000090:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80000092:	94be                	add	s1,s1,a5
    80000094:	0295e263          	bltu	a1,s1,800000b8 <freerange+0x3e>
    80000098:	e84a                	sd	s2,16(sp)
    8000009a:	e44e                	sd	s3,8(sp)
    8000009c:	e052                	sd	s4,0(sp)
    8000009e:	892e                	mv	s2,a1
    kfree(p);
    800000a0:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000a2:	89be                	mv	s3,a5
    kfree(p);
    800000a4:	01448533          	add	a0,s1,s4
    800000a8:	f75ff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000ac:	94ce                	add	s1,s1,s3
    800000ae:	fe997be3          	bgeu	s2,s1,800000a4 <freerange+0x2a>
    800000b2:	6942                	ld	s2,16(sp)
    800000b4:	69a2                	ld	s3,8(sp)
    800000b6:	6a02                	ld	s4,0(sp)
}
    800000b8:	70a2                	ld	ra,40(sp)
    800000ba:	7402                	ld	s0,32(sp)
    800000bc:	64e2                	ld	s1,24(sp)
    800000be:	6145                	addi	sp,sp,48
    800000c0:	8082                	ret

00000000800000c2 <kinit>:
{
    800000c2:	1141                	addi	sp,sp,-16
    800000c4:	e406                	sd	ra,8(sp)
    800000c6:	e022                	sd	s0,0(sp)
    800000c8:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000ca:	00007597          	auipc	a1,0x7
    800000ce:	f4658593          	addi	a1,a1,-186 # 80007010 <etext+0x10>
    800000d2:	0000a517          	auipc	a0,0xa
    800000d6:	1ce50513          	addi	a0,a0,462 # 8000a2a0 <kmem>
    800000da:	5b6050ef          	jal	80005690 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000de:	45c5                	li	a1,17
    800000e0:	05ee                	slli	a1,a1,0x1b
    800000e2:	00023517          	auipc	a0,0x23
    800000e6:	4ee50513          	addi	a0,a0,1262 # 800235d0 <end>
    800000ea:	f91ff0ef          	jal	8000007a <freerange>
}
    800000ee:	60a2                	ld	ra,8(sp)
    800000f0:	6402                	ld	s0,0(sp)
    800000f2:	0141                	addi	sp,sp,16
    800000f4:	8082                	ret

00000000800000f6 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000f6:	1101                	addi	sp,sp,-32
    800000f8:	ec06                	sd	ra,24(sp)
    800000fa:	e822                	sd	s0,16(sp)
    800000fc:	e426                	sd	s1,8(sp)
    800000fe:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000100:	0000a497          	auipc	s1,0xa
    80000104:	1a048493          	addi	s1,s1,416 # 8000a2a0 <kmem>
    80000108:	8526                	mv	a0,s1
    8000010a:	60a050ef          	jal	80005714 <acquire>
  r = kmem.freelist;
    8000010e:	6c84                	ld	s1,24(s1)
  if(r) {
    80000110:	c491                	beqz	s1,8000011c <kalloc+0x26>
    kmem.freelist = r->next;
    80000112:	609c                	ld	a5,0(s1)
    80000114:	0000a717          	auipc	a4,0xa
    80000118:	1af73223          	sd	a5,420(a4) # 8000a2b8 <kmem+0x18>
  }
  release(&kmem.lock);
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	18450513          	addi	a0,a0,388 # 8000a2a0 <kmem>
    80000124:	684050ef          	jal	800057a8 <release>
#ifndef LAB_SYSCALL
  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
#endif
  return (void*)r;
}
    80000128:	8526                	mv	a0,s1
    8000012a:	60e2                	ld	ra,24(sp)
    8000012c:	6442                	ld	s0,16(sp)
    8000012e:	64a2                	ld	s1,8(sp)
    80000130:	6105                	addi	sp,sp,32
    80000132:	8082                	ret

0000000080000134 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000134:	1141                	addi	sp,sp,-16
    80000136:	e406                	sd	ra,8(sp)
    80000138:	e022                	sd	s0,0(sp)
    8000013a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000013c:	ca19                	beqz	a2,80000152 <memset+0x1e>
    8000013e:	87aa                	mv	a5,a0
    80000140:	1602                	slli	a2,a2,0x20
    80000142:	9201                	srli	a2,a2,0x20
    80000144:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000148:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000014c:	0785                	addi	a5,a5,1
    8000014e:	fee79de3          	bne	a5,a4,80000148 <memset+0x14>
  }
  return dst;
}
    80000152:	60a2                	ld	ra,8(sp)
    80000154:	6402                	ld	s0,0(sp)
    80000156:	0141                	addi	sp,sp,16
    80000158:	8082                	ret

000000008000015a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000015a:	1141                	addi	sp,sp,-16
    8000015c:	e406                	sd	ra,8(sp)
    8000015e:	e022                	sd	s0,0(sp)
    80000160:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000162:	ca0d                	beqz	a2,80000194 <memcmp+0x3a>
    80000164:	fff6069b          	addiw	a3,a2,-1
    80000168:	1682                	slli	a3,a3,0x20
    8000016a:	9281                	srli	a3,a3,0x20
    8000016c:	0685                	addi	a3,a3,1
    8000016e:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000170:	00054783          	lbu	a5,0(a0)
    80000174:	0005c703          	lbu	a4,0(a1)
    80000178:	00e79863          	bne	a5,a4,80000188 <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    8000017c:	0505                	addi	a0,a0,1
    8000017e:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000180:	fed518e3          	bne	a0,a3,80000170 <memcmp+0x16>
  }

  return 0;
    80000184:	4501                	li	a0,0
    80000186:	a019                	j	8000018c <memcmp+0x32>
      return *s1 - *s2;
    80000188:	40e7853b          	subw	a0,a5,a4
}
    8000018c:	60a2                	ld	ra,8(sp)
    8000018e:	6402                	ld	s0,0(sp)
    80000190:	0141                	addi	sp,sp,16
    80000192:	8082                	ret
  return 0;
    80000194:	4501                	li	a0,0
    80000196:	bfdd                	j	8000018c <memcmp+0x32>

0000000080000198 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000198:	1141                	addi	sp,sp,-16
    8000019a:	e406                	sd	ra,8(sp)
    8000019c:	e022                	sd	s0,0(sp)
    8000019e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001a0:	c205                	beqz	a2,800001c0 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001a2:	02a5e363          	bltu	a1,a0,800001c8 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001a6:	1602                	slli	a2,a2,0x20
    800001a8:	9201                	srli	a2,a2,0x20
    800001aa:	00c587b3          	add	a5,a1,a2
{
    800001ae:	872a                	mv	a4,a0
      *d++ = *s++;
    800001b0:	0585                	addi	a1,a1,1
    800001b2:	0705                	addi	a4,a4,1
    800001b4:	fff5c683          	lbu	a3,-1(a1)
    800001b8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001bc:	feb79ae3          	bne	a5,a1,800001b0 <memmove+0x18>

  return dst;
}
    800001c0:	60a2                	ld	ra,8(sp)
    800001c2:	6402                	ld	s0,0(sp)
    800001c4:	0141                	addi	sp,sp,16
    800001c6:	8082                	ret
  if(s < d && s + n > d){
    800001c8:	02061693          	slli	a3,a2,0x20
    800001cc:	9281                	srli	a3,a3,0x20
    800001ce:	00d58733          	add	a4,a1,a3
    800001d2:	fce57ae3          	bgeu	a0,a4,800001a6 <memmove+0xe>
    d += n;
    800001d6:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001d8:	fff6079b          	addiw	a5,a2,-1
    800001dc:	1782                	slli	a5,a5,0x20
    800001de:	9381                	srli	a5,a5,0x20
    800001e0:	fff7c793          	not	a5,a5
    800001e4:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800001e6:	177d                	addi	a4,a4,-1
    800001e8:	16fd                	addi	a3,a3,-1
    800001ea:	00074603          	lbu	a2,0(a4)
    800001ee:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800001f2:	fee79ae3          	bne	a5,a4,800001e6 <memmove+0x4e>
    800001f6:	b7e9                	j	800001c0 <memmove+0x28>

00000000800001f8 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800001f8:	1141                	addi	sp,sp,-16
    800001fa:	e406                	sd	ra,8(sp)
    800001fc:	e022                	sd	s0,0(sp)
    800001fe:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000200:	f99ff0ef          	jal	80000198 <memmove>
}
    80000204:	60a2                	ld	ra,8(sp)
    80000206:	6402                	ld	s0,0(sp)
    80000208:	0141                	addi	sp,sp,16
    8000020a:	8082                	ret

000000008000020c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000020c:	1141                	addi	sp,sp,-16
    8000020e:	e406                	sd	ra,8(sp)
    80000210:	e022                	sd	s0,0(sp)
    80000212:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000214:	ce11                	beqz	a2,80000230 <strncmp+0x24>
    80000216:	00054783          	lbu	a5,0(a0)
    8000021a:	cf89                	beqz	a5,80000234 <strncmp+0x28>
    8000021c:	0005c703          	lbu	a4,0(a1)
    80000220:	00f71a63          	bne	a4,a5,80000234 <strncmp+0x28>
    n--, p++, q++;
    80000224:	367d                	addiw	a2,a2,-1
    80000226:	0505                	addi	a0,a0,1
    80000228:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000022a:	f675                	bnez	a2,80000216 <strncmp+0xa>
  if(n == 0)
    return 0;
    8000022c:	4501                	li	a0,0
    8000022e:	a801                	j	8000023e <strncmp+0x32>
    80000230:	4501                	li	a0,0
    80000232:	a031                	j	8000023e <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000234:	00054503          	lbu	a0,0(a0)
    80000238:	0005c783          	lbu	a5,0(a1)
    8000023c:	9d1d                	subw	a0,a0,a5
}
    8000023e:	60a2                	ld	ra,8(sp)
    80000240:	6402                	ld	s0,0(sp)
    80000242:	0141                	addi	sp,sp,16
    80000244:	8082                	ret

0000000080000246 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000246:	1141                	addi	sp,sp,-16
    80000248:	e406                	sd	ra,8(sp)
    8000024a:	e022                	sd	s0,0(sp)
    8000024c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000024e:	87aa                	mv	a5,a0
    80000250:	86b2                	mv	a3,a2
    80000252:	367d                	addiw	a2,a2,-1
    80000254:	02d05563          	blez	a3,8000027e <strncpy+0x38>
    80000258:	0785                	addi	a5,a5,1
    8000025a:	0005c703          	lbu	a4,0(a1)
    8000025e:	fee78fa3          	sb	a4,-1(a5)
    80000262:	0585                	addi	a1,a1,1
    80000264:	f775                	bnez	a4,80000250 <strncpy+0xa>
    ;
  while(n-- > 0)
    80000266:	873e                	mv	a4,a5
    80000268:	00c05b63          	blez	a2,8000027e <strncpy+0x38>
    8000026c:	9fb5                	addw	a5,a5,a3
    8000026e:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000270:	0705                	addi	a4,a4,1
    80000272:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000276:	40e786bb          	subw	a3,a5,a4
    8000027a:	fed04be3          	bgtz	a3,80000270 <strncpy+0x2a>
  return os;
}
    8000027e:	60a2                	ld	ra,8(sp)
    80000280:	6402                	ld	s0,0(sp)
    80000282:	0141                	addi	sp,sp,16
    80000284:	8082                	ret

0000000080000286 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e406                	sd	ra,8(sp)
    8000028a:	e022                	sd	s0,0(sp)
    8000028c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000028e:	02c05363          	blez	a2,800002b4 <safestrcpy+0x2e>
    80000292:	fff6069b          	addiw	a3,a2,-1
    80000296:	1682                	slli	a3,a3,0x20
    80000298:	9281                	srli	a3,a3,0x20
    8000029a:	96ae                	add	a3,a3,a1
    8000029c:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000029e:	00d58963          	beq	a1,a3,800002b0 <safestrcpy+0x2a>
    800002a2:	0585                	addi	a1,a1,1
    800002a4:	0785                	addi	a5,a5,1
    800002a6:	fff5c703          	lbu	a4,-1(a1)
    800002aa:	fee78fa3          	sb	a4,-1(a5)
    800002ae:	fb65                	bnez	a4,8000029e <safestrcpy+0x18>
    ;
  *s = 0;
    800002b0:	00078023          	sb	zero,0(a5)
  return os;
}
    800002b4:	60a2                	ld	ra,8(sp)
    800002b6:	6402                	ld	s0,0(sp)
    800002b8:	0141                	addi	sp,sp,16
    800002ba:	8082                	ret

00000000800002bc <strlen>:

int
strlen(const char *s)
{
    800002bc:	1141                	addi	sp,sp,-16
    800002be:	e406                	sd	ra,8(sp)
    800002c0:	e022                	sd	s0,0(sp)
    800002c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002c4:	00054783          	lbu	a5,0(a0)
    800002c8:	cf99                	beqz	a5,800002e6 <strlen+0x2a>
    800002ca:	0505                	addi	a0,a0,1
    800002cc:	87aa                	mv	a5,a0
    800002ce:	86be                	mv	a3,a5
    800002d0:	0785                	addi	a5,a5,1
    800002d2:	fff7c703          	lbu	a4,-1(a5)
    800002d6:	ff65                	bnez	a4,800002ce <strlen+0x12>
    800002d8:	40a6853b          	subw	a0,a3,a0
    800002dc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800002de:	60a2                	ld	ra,8(sp)
    800002e0:	6402                	ld	s0,0(sp)
    800002e2:	0141                	addi	sp,sp,16
    800002e4:	8082                	ret
  for(n = 0; s[n]; n++)
    800002e6:	4501                	li	a0,0
    800002e8:	bfdd                	j	800002de <strlen+0x22>

00000000800002ea <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800002ea:	1141                	addi	sp,sp,-16
    800002ec:	e406                	sd	ra,8(sp)
    800002ee:	e022                	sd	s0,0(sp)
    800002f0:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800002f2:	225000ef          	jal	80000d16 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800002f6:	0000a717          	auipc	a4,0xa
    800002fa:	f7a70713          	addi	a4,a4,-134 # 8000a270 <started>
  if(cpuid() == 0){
    800002fe:	c51d                	beqz	a0,8000032c <main+0x42>
    while(started == 0)
    80000300:	431c                	lw	a5,0(a4)
    80000302:	2781                	sext.w	a5,a5
    80000304:	dff5                	beqz	a5,80000300 <main+0x16>
      ;
    __sync_synchronize();
    80000306:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    8000030a:	20d000ef          	jal	80000d16 <cpuid>
    8000030e:	85aa                	mv	a1,a0
    80000310:	00007517          	auipc	a0,0x7
    80000314:	d2850513          	addi	a0,a0,-728 # 80007038 <etext+0x38>
    80000318:	5ff040ef          	jal	80005116 <printf>
    kvminithart();    // turn on paging
    8000031c:	080000ef          	jal	8000039c <kvminithart>
    trapinithart();   // install kernel trap vector
    80000320:	514010ef          	jal	80001834 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000324:	3d4040ef          	jal	800046f8 <plicinithart>
  }

  scheduler();        
    80000328:	657000ef          	jal	8000117e <scheduler>
    consoleinit();
    8000032c:	51d040ef          	jal	80005048 <consoleinit>
    printfinit();
    80000330:	0f0050ef          	jal	80005420 <printfinit>
    printf("\n");
    80000334:	00007517          	auipc	a0,0x7
    80000338:	ce450513          	addi	a0,a0,-796 # 80007018 <etext+0x18>
    8000033c:	5db040ef          	jal	80005116 <printf>
    printf("xv6 kernel is booting\n");
    80000340:	00007517          	auipc	a0,0x7
    80000344:	ce050513          	addi	a0,a0,-800 # 80007020 <etext+0x20>
    80000348:	5cf040ef          	jal	80005116 <printf>
    printf("\n");
    8000034c:	00007517          	auipc	a0,0x7
    80000350:	ccc50513          	addi	a0,a0,-820 # 80007018 <etext+0x18>
    80000354:	5c3040ef          	jal	80005116 <printf>
    kinit();         // physical page allocator
    80000358:	d6bff0ef          	jal	800000c2 <kinit>
    kvminit();       // create kernel page table
    8000035c:	2ce000ef          	jal	8000062a <kvminit>
    kvminithart();   // turn on paging
    80000360:	03c000ef          	jal	8000039c <kvminithart>
    procinit();      // process table
    80000364:	103000ef          	jal	80000c66 <procinit>
    trapinit();      // trap vectors
    80000368:	4a8010ef          	jal	80001810 <trapinit>
    trapinithart();  // install kernel trap vector
    8000036c:	4c8010ef          	jal	80001834 <trapinithart>
    plicinit();      // set up interrupt controller
    80000370:	36e040ef          	jal	800046de <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000374:	384040ef          	jal	800046f8 <plicinithart>
    binit();         // buffer cache
    80000378:	2eb010ef          	jal	80001e62 <binit>
    iinit();         // inode table
    8000037c:	0b6020ef          	jal	80002432 <iinit>
    fileinit();      // file table
    80000380:	685020ef          	jal	80003204 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000384:	464040ef          	jal	800047e8 <virtio_disk_init>
    userinit();      // first user process
    80000388:	42b000ef          	jal	80000fb2 <userinit>
    __sync_synchronize();
    8000038c:	0330000f          	fence	rw,rw
    started = 1;
    80000390:	4785                	li	a5,1
    80000392:	0000a717          	auipc	a4,0xa
    80000396:	ecf72f23          	sw	a5,-290(a4) # 8000a270 <started>
    8000039a:	b779                	j	80000328 <main+0x3e>

000000008000039c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000039c:	1141                	addi	sp,sp,-16
    8000039e:	e406                	sd	ra,8(sp)
    800003a0:	e022                	sd	s0,0(sp)
    800003a2:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003a4:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003a8:	0000a797          	auipc	a5,0xa
    800003ac:	ed07b783          	ld	a5,-304(a5) # 8000a278 <kernel_pagetable>
    800003b0:	83b1                	srli	a5,a5,0xc
    800003b2:	577d                	li	a4,-1
    800003b4:	177e                	slli	a4,a4,0x3f
    800003b6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003b8:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003bc:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003c0:	60a2                	ld	ra,8(sp)
    800003c2:	6402                	ld	s0,0(sp)
    800003c4:	0141                	addi	sp,sp,16
    800003c6:	8082                	ret

00000000800003c8 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003c8:	7139                	addi	sp,sp,-64
    800003ca:	fc06                	sd	ra,56(sp)
    800003cc:	f822                	sd	s0,48(sp)
    800003ce:	f426                	sd	s1,40(sp)
    800003d0:	f04a                	sd	s2,32(sp)
    800003d2:	ec4e                	sd	s3,24(sp)
    800003d4:	e852                	sd	s4,16(sp)
    800003d6:	e456                	sd	s5,8(sp)
    800003d8:	e05a                	sd	s6,0(sp)
    800003da:	0080                	addi	s0,sp,64
    800003dc:	84aa                	mv	s1,a0
    800003de:	89ae                	mv	s3,a1
    800003e0:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003e2:	57fd                	li	a5,-1
    800003e4:	83e9                	srli	a5,a5,0x1a
    800003e6:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800003e8:	4b31                	li	s6,12
  if(va >= MAXVA)
    800003ea:	04b7e263          	bltu	a5,a1,8000042e <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    800003ee:	0149d933          	srl	s2,s3,s4
    800003f2:	1ff97913          	andi	s2,s2,511
    800003f6:	090e                	slli	s2,s2,0x3
    800003f8:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800003fa:	00093483          	ld	s1,0(s2)
    800003fe:	0014f793          	andi	a5,s1,1
    80000402:	cf85                	beqz	a5,8000043a <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000404:	80a9                	srli	s1,s1,0xa
    80000406:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000408:	3a5d                	addiw	s4,s4,-9
    8000040a:	ff6a12e3          	bne	s4,s6,800003ee <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    8000040e:	00c9d513          	srli	a0,s3,0xc
    80000412:	1ff57513          	andi	a0,a0,511
    80000416:	050e                	slli	a0,a0,0x3
    80000418:	9526                	add	a0,a0,s1
}
    8000041a:	70e2                	ld	ra,56(sp)
    8000041c:	7442                	ld	s0,48(sp)
    8000041e:	74a2                	ld	s1,40(sp)
    80000420:	7902                	ld	s2,32(sp)
    80000422:	69e2                	ld	s3,24(sp)
    80000424:	6a42                	ld	s4,16(sp)
    80000426:	6aa2                	ld	s5,8(sp)
    80000428:	6b02                	ld	s6,0(sp)
    8000042a:	6121                	addi	sp,sp,64
    8000042c:	8082                	ret
    panic("walk");
    8000042e:	00007517          	auipc	a0,0x7
    80000432:	c2250513          	addi	a0,a0,-990 # 80007050 <etext+0x50>
    80000436:	7b1040ef          	jal	800053e6 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000043a:	020a8263          	beqz	s5,8000045e <walk+0x96>
    8000043e:	cb9ff0ef          	jal	800000f6 <kalloc>
    80000442:	84aa                	mv	s1,a0
    80000444:	d979                	beqz	a0,8000041a <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000446:	6605                	lui	a2,0x1
    80000448:	4581                	li	a1,0
    8000044a:	cebff0ef          	jal	80000134 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000044e:	00c4d793          	srli	a5,s1,0xc
    80000452:	07aa                	slli	a5,a5,0xa
    80000454:	0017e793          	ori	a5,a5,1
    80000458:	00f93023          	sd	a5,0(s2)
    8000045c:	b775                	j	80000408 <walk+0x40>
        return 0;
    8000045e:	4501                	li	a0,0
    80000460:	bf6d                	j	8000041a <walk+0x52>

0000000080000462 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000462:	57fd                	li	a5,-1
    80000464:	83e9                	srli	a5,a5,0x1a
    80000466:	00b7f463          	bgeu	a5,a1,8000046e <walkaddr+0xc>
    return 0;
    8000046a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000046c:	8082                	ret
{
    8000046e:	1141                	addi	sp,sp,-16
    80000470:	e406                	sd	ra,8(sp)
    80000472:	e022                	sd	s0,0(sp)
    80000474:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000476:	4601                	li	a2,0
    80000478:	f51ff0ef          	jal	800003c8 <walk>
  if(pte == 0)
    8000047c:	c105                	beqz	a0,8000049c <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    8000047e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000480:	0117f693          	andi	a3,a5,17
    80000484:	4745                	li	a4,17
    return 0;
    80000486:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000488:	00e68663          	beq	a3,a4,80000494 <walkaddr+0x32>
}
    8000048c:	60a2                	ld	ra,8(sp)
    8000048e:	6402                	ld	s0,0(sp)
    80000490:	0141                	addi	sp,sp,16
    80000492:	8082                	ret
  pa = PTE2PA(*pte);
    80000494:	83a9                	srli	a5,a5,0xa
    80000496:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000049a:	bfcd                	j	8000048c <walkaddr+0x2a>
    return 0;
    8000049c:	4501                	li	a0,0
    8000049e:	b7fd                	j	8000048c <walkaddr+0x2a>

00000000800004a0 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004a0:	715d                	addi	sp,sp,-80
    800004a2:	e486                	sd	ra,72(sp)
    800004a4:	e0a2                	sd	s0,64(sp)
    800004a6:	fc26                	sd	s1,56(sp)
    800004a8:	f84a                	sd	s2,48(sp)
    800004aa:	f44e                	sd	s3,40(sp)
    800004ac:	f052                	sd	s4,32(sp)
    800004ae:	ec56                	sd	s5,24(sp)
    800004b0:	e85a                	sd	s6,16(sp)
    800004b2:	e45e                	sd	s7,8(sp)
    800004b4:	e062                	sd	s8,0(sp)
    800004b6:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004b8:	03459793          	slli	a5,a1,0x34
    800004bc:	e7b1                	bnez	a5,80000508 <mappages+0x68>
    800004be:	8aaa                	mv	s5,a0
    800004c0:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004c2:	03461793          	slli	a5,a2,0x34
    800004c6:	e7b9                	bnez	a5,80000514 <mappages+0x74>
    panic("mappages: size not aligned");

  if(size == 0)
    800004c8:	ce21                	beqz	a2,80000520 <mappages+0x80>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004ca:	77fd                	lui	a5,0xfffff
    800004cc:	963e                	add	a2,a2,a5
    800004ce:	00b609b3          	add	s3,a2,a1
  a = va;
    800004d2:	892e                	mv	s2,a1
    800004d4:	40b68a33          	sub	s4,a3,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    800004d8:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004da:	6c05                	lui	s8,0x1
    800004dc:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800004e0:	865e                	mv	a2,s7
    800004e2:	85ca                	mv	a1,s2
    800004e4:	8556                	mv	a0,s5
    800004e6:	ee3ff0ef          	jal	800003c8 <walk>
    800004ea:	c539                	beqz	a0,80000538 <mappages+0x98>
    if(*pte & PTE_V)
    800004ec:	611c                	ld	a5,0(a0)
    800004ee:	8b85                	andi	a5,a5,1
    800004f0:	ef95                	bnez	a5,8000052c <mappages+0x8c>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800004f2:	80b1                	srli	s1,s1,0xc
    800004f4:	04aa                	slli	s1,s1,0xa
    800004f6:	0164e4b3          	or	s1,s1,s6
    800004fa:	0014e493          	ori	s1,s1,1
    800004fe:	e104                	sd	s1,0(a0)
    if(a == last)
    80000500:	05390963          	beq	s2,s3,80000552 <mappages+0xb2>
    a += PGSIZE;
    80000504:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    80000506:	bfd9                	j	800004dc <mappages+0x3c>
    panic("mappages: va not aligned");
    80000508:	00007517          	auipc	a0,0x7
    8000050c:	b5050513          	addi	a0,a0,-1200 # 80007058 <etext+0x58>
    80000510:	6d7040ef          	jal	800053e6 <panic>
    panic("mappages: size not aligned");
    80000514:	00007517          	auipc	a0,0x7
    80000518:	b6450513          	addi	a0,a0,-1180 # 80007078 <etext+0x78>
    8000051c:	6cb040ef          	jal	800053e6 <panic>
    panic("mappages: size");
    80000520:	00007517          	auipc	a0,0x7
    80000524:	b7850513          	addi	a0,a0,-1160 # 80007098 <etext+0x98>
    80000528:	6bf040ef          	jal	800053e6 <panic>
      panic("mappages: remap");
    8000052c:	00007517          	auipc	a0,0x7
    80000530:	b7c50513          	addi	a0,a0,-1156 # 800070a8 <etext+0xa8>
    80000534:	6b3040ef          	jal	800053e6 <panic>
      return -1;
    80000538:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000053a:	60a6                	ld	ra,72(sp)
    8000053c:	6406                	ld	s0,64(sp)
    8000053e:	74e2                	ld	s1,56(sp)
    80000540:	7942                	ld	s2,48(sp)
    80000542:	79a2                	ld	s3,40(sp)
    80000544:	7a02                	ld	s4,32(sp)
    80000546:	6ae2                	ld	s5,24(sp)
    80000548:	6b42                	ld	s6,16(sp)
    8000054a:	6ba2                	ld	s7,8(sp)
    8000054c:	6c02                	ld	s8,0(sp)
    8000054e:	6161                	addi	sp,sp,80
    80000550:	8082                	ret
  return 0;
    80000552:	4501                	li	a0,0
    80000554:	b7dd                	j	8000053a <mappages+0x9a>

0000000080000556 <kvmmap>:
{
    80000556:	1141                	addi	sp,sp,-16
    80000558:	e406                	sd	ra,8(sp)
    8000055a:	e022                	sd	s0,0(sp)
    8000055c:	0800                	addi	s0,sp,16
    8000055e:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000560:	86b2                	mv	a3,a2
    80000562:	863e                	mv	a2,a5
    80000564:	f3dff0ef          	jal	800004a0 <mappages>
    80000568:	e509                	bnez	a0,80000572 <kvmmap+0x1c>
}
    8000056a:	60a2                	ld	ra,8(sp)
    8000056c:	6402                	ld	s0,0(sp)
    8000056e:	0141                	addi	sp,sp,16
    80000570:	8082                	ret
    panic("kvmmap");
    80000572:	00007517          	auipc	a0,0x7
    80000576:	b4650513          	addi	a0,a0,-1210 # 800070b8 <etext+0xb8>
    8000057a:	66d040ef          	jal	800053e6 <panic>

000000008000057e <kvmmake>:
{
    8000057e:	1101                	addi	sp,sp,-32
    80000580:	ec06                	sd	ra,24(sp)
    80000582:	e822                	sd	s0,16(sp)
    80000584:	e426                	sd	s1,8(sp)
    80000586:	e04a                	sd	s2,0(sp)
    80000588:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000058a:	b6dff0ef          	jal	800000f6 <kalloc>
    8000058e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000590:	6605                	lui	a2,0x1
    80000592:	4581                	li	a1,0
    80000594:	ba1ff0ef          	jal	80000134 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000598:	4719                	li	a4,6
    8000059a:	6685                	lui	a3,0x1
    8000059c:	10000637          	lui	a2,0x10000
    800005a0:	85b2                	mv	a1,a2
    800005a2:	8526                	mv	a0,s1
    800005a4:	fb3ff0ef          	jal	80000556 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005a8:	4719                	li	a4,6
    800005aa:	6685                	lui	a3,0x1
    800005ac:	10001637          	lui	a2,0x10001
    800005b0:	85b2                	mv	a1,a2
    800005b2:	8526                	mv	a0,s1
    800005b4:	fa3ff0ef          	jal	80000556 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005b8:	4719                	li	a4,6
    800005ba:	040006b7          	lui	a3,0x4000
    800005be:	0c000637          	lui	a2,0xc000
    800005c2:	85b2                	mv	a1,a2
    800005c4:	8526                	mv	a0,s1
    800005c6:	f91ff0ef          	jal	80000556 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005ca:	00007917          	auipc	s2,0x7
    800005ce:	a3690913          	addi	s2,s2,-1482 # 80007000 <etext>
    800005d2:	4729                	li	a4,10
    800005d4:	80007697          	auipc	a3,0x80007
    800005d8:	a2c68693          	addi	a3,a3,-1492 # 7000 <_entry-0x7fff9000>
    800005dc:	4605                	li	a2,1
    800005de:	067e                	slli	a2,a2,0x1f
    800005e0:	85b2                	mv	a1,a2
    800005e2:	8526                	mv	a0,s1
    800005e4:	f73ff0ef          	jal	80000556 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800005e8:	4719                	li	a4,6
    800005ea:	46c5                	li	a3,17
    800005ec:	06ee                	slli	a3,a3,0x1b
    800005ee:	412686b3          	sub	a3,a3,s2
    800005f2:	864a                	mv	a2,s2
    800005f4:	85ca                	mv	a1,s2
    800005f6:	8526                	mv	a0,s1
    800005f8:	f5fff0ef          	jal	80000556 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800005fc:	4729                	li	a4,10
    800005fe:	6685                	lui	a3,0x1
    80000600:	00006617          	auipc	a2,0x6
    80000604:	a0060613          	addi	a2,a2,-1536 # 80006000 <_trampoline>
    80000608:	040005b7          	lui	a1,0x4000
    8000060c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000060e:	05b2                	slli	a1,a1,0xc
    80000610:	8526                	mv	a0,s1
    80000612:	f45ff0ef          	jal	80000556 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000616:	8526                	mv	a0,s1
    80000618:	5b0000ef          	jal	80000bc8 <proc_mapstacks>
}
    8000061c:	8526                	mv	a0,s1
    8000061e:	60e2                	ld	ra,24(sp)
    80000620:	6442                	ld	s0,16(sp)
    80000622:	64a2                	ld	s1,8(sp)
    80000624:	6902                	ld	s2,0(sp)
    80000626:	6105                	addi	sp,sp,32
    80000628:	8082                	ret

000000008000062a <kvminit>:
{
    8000062a:	1141                	addi	sp,sp,-16
    8000062c:	e406                	sd	ra,8(sp)
    8000062e:	e022                	sd	s0,0(sp)
    80000630:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000632:	f4dff0ef          	jal	8000057e <kvmmake>
    80000636:	0000a797          	auipc	a5,0xa
    8000063a:	c4a7b123          	sd	a0,-958(a5) # 8000a278 <kernel_pagetable>
}
    8000063e:	60a2                	ld	ra,8(sp)
    80000640:	6402                	ld	s0,0(sp)
    80000642:	0141                	addi	sp,sp,16
    80000644:	8082                	ret

0000000080000646 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000646:	715d                	addi	sp,sp,-80
    80000648:	e486                	sd	ra,72(sp)
    8000064a:	e0a2                	sd	s0,64(sp)
    8000064c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;
  int sz;

  if((va % PGSIZE) != 0)
    8000064e:	03459793          	slli	a5,a1,0x34
    80000652:	e39d                	bnez	a5,80000678 <uvmunmap+0x32>
    80000654:	f84a                	sd	s2,48(sp)
    80000656:	f44e                	sd	s3,40(sp)
    80000658:	f052                	sd	s4,32(sp)
    8000065a:	ec56                	sd	s5,24(sp)
    8000065c:	e85a                	sd	s6,16(sp)
    8000065e:	e45e                	sd	s7,8(sp)
    80000660:	8a2a                	mv	s4,a0
    80000662:	892e                	mv	s2,a1
    80000664:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000666:	0632                	slli	a2,a2,0xc
    80000668:	00b609b3          	add	s3,a2,a1
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0) {
      printf("va=%ld pte=%ld\n", a, *pte);
      panic("uvmunmap: not mapped");
    }
    if(PTE_FLAGS(*pte) == PTE_V)
    8000066c:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += sz){
    8000066e:	6b05                	lui	s6,0x1
    80000670:	0935f763          	bgeu	a1,s3,800006fe <uvmunmap+0xb8>
    80000674:	fc26                	sd	s1,56(sp)
    80000676:	a8a1                	j	800006ce <uvmunmap+0x88>
    80000678:	fc26                	sd	s1,56(sp)
    8000067a:	f84a                	sd	s2,48(sp)
    8000067c:	f44e                	sd	s3,40(sp)
    8000067e:	f052                	sd	s4,32(sp)
    80000680:	ec56                	sd	s5,24(sp)
    80000682:	e85a                	sd	s6,16(sp)
    80000684:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000686:	00007517          	auipc	a0,0x7
    8000068a:	a3a50513          	addi	a0,a0,-1478 # 800070c0 <etext+0xc0>
    8000068e:	559040ef          	jal	800053e6 <panic>
      panic("uvmunmap: walk");
    80000692:	00007517          	auipc	a0,0x7
    80000696:	a4650513          	addi	a0,a0,-1466 # 800070d8 <etext+0xd8>
    8000069a:	54d040ef          	jal	800053e6 <panic>
      printf("va=%ld pte=%ld\n", a, *pte);
    8000069e:	85ca                	mv	a1,s2
    800006a0:	00007517          	auipc	a0,0x7
    800006a4:	a4850513          	addi	a0,a0,-1464 # 800070e8 <etext+0xe8>
    800006a8:	26f040ef          	jal	80005116 <printf>
      panic("uvmunmap: not mapped");
    800006ac:	00007517          	auipc	a0,0x7
    800006b0:	a4c50513          	addi	a0,a0,-1460 # 800070f8 <etext+0xf8>
    800006b4:	533040ef          	jal	800053e6 <panic>
      panic("uvmunmap: not a leaf");
    800006b8:	00007517          	auipc	a0,0x7
    800006bc:	a5850513          	addi	a0,a0,-1448 # 80007110 <etext+0x110>
    800006c0:	527040ef          	jal	800053e6 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006c4:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006c8:	995a                	add	s2,s2,s6
    800006ca:	03397963          	bgeu	s2,s3,800006fc <uvmunmap+0xb6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006ce:	4601                	li	a2,0
    800006d0:	85ca                	mv	a1,s2
    800006d2:	8552                	mv	a0,s4
    800006d4:	cf5ff0ef          	jal	800003c8 <walk>
    800006d8:	84aa                	mv	s1,a0
    800006da:	dd45                	beqz	a0,80000692 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0) {
    800006dc:	6110                	ld	a2,0(a0)
    800006de:	00167793          	andi	a5,a2,1
    800006e2:	dfd5                	beqz	a5,8000069e <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006e4:	3ff67793          	andi	a5,a2,1023
    800006e8:	fd7788e3          	beq	a5,s7,800006b8 <uvmunmap+0x72>
    if(do_free){
    800006ec:	fc0a8ce3          	beqz	s5,800006c4 <uvmunmap+0x7e>
      uint64 pa = PTE2PA(*pte);
    800006f0:	8229                	srli	a2,a2,0xa
      kfree((void*)pa);
    800006f2:	00c61513          	slli	a0,a2,0xc
    800006f6:	927ff0ef          	jal	8000001c <kfree>
    800006fa:	b7e9                	j	800006c4 <uvmunmap+0x7e>
    800006fc:	74e2                	ld	s1,56(sp)
    800006fe:	7942                	ld	s2,48(sp)
    80000700:	79a2                	ld	s3,40(sp)
    80000702:	7a02                	ld	s4,32(sp)
    80000704:	6ae2                	ld	s5,24(sp)
    80000706:	6b42                	ld	s6,16(sp)
    80000708:	6ba2                	ld	s7,8(sp)
  }
}
    8000070a:	60a6                	ld	ra,72(sp)
    8000070c:	6406                	ld	s0,64(sp)
    8000070e:	6161                	addi	sp,sp,80
    80000710:	8082                	ret

0000000080000712 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000712:	1101                	addi	sp,sp,-32
    80000714:	ec06                	sd	ra,24(sp)
    80000716:	e822                	sd	s0,16(sp)
    80000718:	e426                	sd	s1,8(sp)
    8000071a:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000071c:	9dbff0ef          	jal	800000f6 <kalloc>
    80000720:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000722:	c509                	beqz	a0,8000072c <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000724:	6605                	lui	a2,0x1
    80000726:	4581                	li	a1,0
    80000728:	a0dff0ef          	jal	80000134 <memset>
  return pagetable;
}
    8000072c:	8526                	mv	a0,s1
    8000072e:	60e2                	ld	ra,24(sp)
    80000730:	6442                	ld	s0,16(sp)
    80000732:	64a2                	ld	s1,8(sp)
    80000734:	6105                	addi	sp,sp,32
    80000736:	8082                	ret

0000000080000738 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000738:	7179                	addi	sp,sp,-48
    8000073a:	f406                	sd	ra,40(sp)
    8000073c:	f022                	sd	s0,32(sp)
    8000073e:	ec26                	sd	s1,24(sp)
    80000740:	e84a                	sd	s2,16(sp)
    80000742:	e44e                	sd	s3,8(sp)
    80000744:	e052                	sd	s4,0(sp)
    80000746:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000748:	6785                	lui	a5,0x1
    8000074a:	04f67063          	bgeu	a2,a5,8000078a <uvmfirst+0x52>
    8000074e:	8a2a                	mv	s4,a0
    80000750:	89ae                	mv	s3,a1
    80000752:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000754:	9a3ff0ef          	jal	800000f6 <kalloc>
    80000758:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000075a:	6605                	lui	a2,0x1
    8000075c:	4581                	li	a1,0
    8000075e:	9d7ff0ef          	jal	80000134 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000762:	4779                	li	a4,30
    80000764:	86ca                	mv	a3,s2
    80000766:	6605                	lui	a2,0x1
    80000768:	4581                	li	a1,0
    8000076a:	8552                	mv	a0,s4
    8000076c:	d35ff0ef          	jal	800004a0 <mappages>
  memmove(mem, src, sz);
    80000770:	8626                	mv	a2,s1
    80000772:	85ce                	mv	a1,s3
    80000774:	854a                	mv	a0,s2
    80000776:	a23ff0ef          	jal	80000198 <memmove>
}
    8000077a:	70a2                	ld	ra,40(sp)
    8000077c:	7402                	ld	s0,32(sp)
    8000077e:	64e2                	ld	s1,24(sp)
    80000780:	6942                	ld	s2,16(sp)
    80000782:	69a2                	ld	s3,8(sp)
    80000784:	6a02                	ld	s4,0(sp)
    80000786:	6145                	addi	sp,sp,48
    80000788:	8082                	ret
    panic("uvmfirst: more than a page");
    8000078a:	00007517          	auipc	a0,0x7
    8000078e:	99e50513          	addi	a0,a0,-1634 # 80007128 <etext+0x128>
    80000792:	455040ef          	jal	800053e6 <panic>

0000000080000796 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000796:	1101                	addi	sp,sp,-32
    80000798:	ec06                	sd	ra,24(sp)
    8000079a:	e822                	sd	s0,16(sp)
    8000079c:	e426                	sd	s1,8(sp)
    8000079e:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800007a0:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800007a2:	00b67d63          	bgeu	a2,a1,800007bc <uvmdealloc+0x26>
    800007a6:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800007a8:	6785                	lui	a5,0x1
    800007aa:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007ac:	00f60733          	add	a4,a2,a5
    800007b0:	76fd                	lui	a3,0xfffff
    800007b2:	8f75                	and	a4,a4,a3
    800007b4:	97ae                	add	a5,a5,a1
    800007b6:	8ff5                	and	a5,a5,a3
    800007b8:	00f76863          	bltu	a4,a5,800007c8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800007bc:	8526                	mv	a0,s1
    800007be:	60e2                	ld	ra,24(sp)
    800007c0:	6442                	ld	s0,16(sp)
    800007c2:	64a2                	ld	s1,8(sp)
    800007c4:	6105                	addi	sp,sp,32
    800007c6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007c8:	8f99                	sub	a5,a5,a4
    800007ca:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007cc:	4685                	li	a3,1
    800007ce:	0007861b          	sext.w	a2,a5
    800007d2:	85ba                	mv	a1,a4
    800007d4:	e73ff0ef          	jal	80000646 <uvmunmap>
    800007d8:	b7d5                	j	800007bc <uvmdealloc+0x26>

00000000800007da <uvmalloc>:
  if(newsz < oldsz)
    800007da:	08b66f63          	bltu	a2,a1,80000878 <uvmalloc+0x9e>
{
    800007de:	715d                	addi	sp,sp,-80
    800007e0:	e486                	sd	ra,72(sp)
    800007e2:	e0a2                	sd	s0,64(sp)
    800007e4:	f052                	sd	s4,32(sp)
    800007e6:	ec56                	sd	s5,24(sp)
    800007e8:	e85a                	sd	s6,16(sp)
    800007ea:	0880                	addi	s0,sp,80
    800007ec:	8b2a                	mv	s6,a0
    800007ee:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    800007f0:	6785                	lui	a5,0x1
    800007f2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007f4:	95be                	add	a1,a1,a5
    800007f6:	77fd                	lui	a5,0xfffff
    800007f8:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += sz){
    800007fc:	08ca7063          	bgeu	s4,a2,8000087c <uvmalloc+0xa2>
    80000800:	fc26                	sd	s1,56(sp)
    80000802:	f84a                	sd	s2,48(sp)
    80000804:	f44e                	sd	s3,40(sp)
    80000806:	e45e                	sd	s7,8(sp)
    80000808:	8952                	mv	s2,s4
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000080a:	0126eb93          	ori	s7,a3,18
    8000080e:	6985                	lui	s3,0x1
    mem = kalloc();
    80000810:	8e7ff0ef          	jal	800000f6 <kalloc>
    80000814:	84aa                	mv	s1,a0
    if(mem == 0){
    80000816:	c115                	beqz	a0,8000083a <uvmalloc+0x60>
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000818:	875e                	mv	a4,s7
    8000081a:	86aa                	mv	a3,a0
    8000081c:	864e                	mv	a2,s3
    8000081e:	85ca                	mv	a1,s2
    80000820:	855a                	mv	a0,s6
    80000822:	c7fff0ef          	jal	800004a0 <mappages>
    80000826:	e91d                	bnez	a0,8000085c <uvmalloc+0x82>
  for(a = oldsz; a < newsz; a += sz){
    80000828:	994e                	add	s2,s2,s3
    8000082a:	ff5963e3          	bltu	s2,s5,80000810 <uvmalloc+0x36>
  return newsz;
    8000082e:	8556                	mv	a0,s5
    80000830:	74e2                	ld	s1,56(sp)
    80000832:	7942                	ld	s2,48(sp)
    80000834:	79a2                	ld	s3,40(sp)
    80000836:	6ba2                	ld	s7,8(sp)
    80000838:	a819                	j	8000084e <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000083a:	8652                	mv	a2,s4
    8000083c:	85ca                	mv	a1,s2
    8000083e:	855a                	mv	a0,s6
    80000840:	f57ff0ef          	jal	80000796 <uvmdealloc>
      return 0;
    80000844:	4501                	li	a0,0
    80000846:	74e2                	ld	s1,56(sp)
    80000848:	7942                	ld	s2,48(sp)
    8000084a:	79a2                	ld	s3,40(sp)
    8000084c:	6ba2                	ld	s7,8(sp)
}
    8000084e:	60a6                	ld	ra,72(sp)
    80000850:	6406                	ld	s0,64(sp)
    80000852:	7a02                	ld	s4,32(sp)
    80000854:	6ae2                	ld	s5,24(sp)
    80000856:	6b42                	ld	s6,16(sp)
    80000858:	6161                	addi	sp,sp,80
    8000085a:	8082                	ret
      kfree(mem);
    8000085c:	8526                	mv	a0,s1
    8000085e:	fbeff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000862:	8652                	mv	a2,s4
    80000864:	85ca                	mv	a1,s2
    80000866:	855a                	mv	a0,s6
    80000868:	f2fff0ef          	jal	80000796 <uvmdealloc>
      return 0;
    8000086c:	4501                	li	a0,0
    8000086e:	74e2                	ld	s1,56(sp)
    80000870:	7942                	ld	s2,48(sp)
    80000872:	79a2                	ld	s3,40(sp)
    80000874:	6ba2                	ld	s7,8(sp)
    80000876:	bfe1                	j	8000084e <uvmalloc+0x74>
    return oldsz;
    80000878:	852e                	mv	a0,a1
}
    8000087a:	8082                	ret
  return newsz;
    8000087c:	8532                	mv	a0,a2
    8000087e:	bfc1                	j	8000084e <uvmalloc+0x74>

0000000080000880 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000880:	7179                	addi	sp,sp,-48
    80000882:	f406                	sd	ra,40(sp)
    80000884:	f022                	sd	s0,32(sp)
    80000886:	ec26                	sd	s1,24(sp)
    80000888:	e84a                	sd	s2,16(sp)
    8000088a:	e44e                	sd	s3,8(sp)
    8000088c:	e052                	sd	s4,0(sp)
    8000088e:	1800                	addi	s0,sp,48
    80000890:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000892:	84aa                	mv	s1,a0
    80000894:	6905                	lui	s2,0x1
    80000896:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000898:	4985                	li	s3,1
    8000089a:	a819                	j	800008b0 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000089c:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000089e:	00c79513          	slli	a0,a5,0xc
    800008a2:	fdfff0ef          	jal	80000880 <freewalk>
      pagetable[i] = 0;
    800008a6:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800008aa:	04a1                	addi	s1,s1,8
    800008ac:	01248f63          	beq	s1,s2,800008ca <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800008b0:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008b2:	00f7f713          	andi	a4,a5,15
    800008b6:	ff3703e3          	beq	a4,s3,8000089c <freewalk+0x1c>
    } else if(pte & PTE_V){
    800008ba:	8b85                	andi	a5,a5,1
    800008bc:	d7fd                	beqz	a5,800008aa <freewalk+0x2a>
      panic("freewalk: leaf");
    800008be:	00007517          	auipc	a0,0x7
    800008c2:	88a50513          	addi	a0,a0,-1910 # 80007148 <etext+0x148>
    800008c6:	321040ef          	jal	800053e6 <panic>
    }
  }
  kfree((void*)pagetable);
    800008ca:	8552                	mv	a0,s4
    800008cc:	f50ff0ef          	jal	8000001c <kfree>
}
    800008d0:	70a2                	ld	ra,40(sp)
    800008d2:	7402                	ld	s0,32(sp)
    800008d4:	64e2                	ld	s1,24(sp)
    800008d6:	6942                	ld	s2,16(sp)
    800008d8:	69a2                	ld	s3,8(sp)
    800008da:	6a02                	ld	s4,0(sp)
    800008dc:	6145                	addi	sp,sp,48
    800008de:	8082                	ret

00000000800008e0 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800008e0:	1101                	addi	sp,sp,-32
    800008e2:	ec06                	sd	ra,24(sp)
    800008e4:	e822                	sd	s0,16(sp)
    800008e6:	e426                	sd	s1,8(sp)
    800008e8:	1000                	addi	s0,sp,32
    800008ea:	84aa                	mv	s1,a0
  if(sz > 0)
    800008ec:	e989                	bnez	a1,800008fe <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800008ee:	8526                	mv	a0,s1
    800008f0:	f91ff0ef          	jal	80000880 <freewalk>
}
    800008f4:	60e2                	ld	ra,24(sp)
    800008f6:	6442                	ld	s0,16(sp)
    800008f8:	64a2                	ld	s1,8(sp)
    800008fa:	6105                	addi	sp,sp,32
    800008fc:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800008fe:	6785                	lui	a5,0x1
    80000900:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000902:	95be                	add	a1,a1,a5
    80000904:	4685                	li	a3,1
    80000906:	00c5d613          	srli	a2,a1,0xc
    8000090a:	4581                	li	a1,0
    8000090c:	d3bff0ef          	jal	80000646 <uvmunmap>
    80000910:	bff9                	j	800008ee <uvmfree+0xe>

0000000080000912 <uvmcopy>:
  uint64 pa, i;
  uint flags;
  char *mem;
  int szinc;

  for(i = 0; i < sz; i += szinc){
    80000912:	ca4d                	beqz	a2,800009c4 <uvmcopy+0xb2>
{
    80000914:	715d                	addi	sp,sp,-80
    80000916:	e486                	sd	ra,72(sp)
    80000918:	e0a2                	sd	s0,64(sp)
    8000091a:	fc26                	sd	s1,56(sp)
    8000091c:	f84a                	sd	s2,48(sp)
    8000091e:	f44e                	sd	s3,40(sp)
    80000920:	f052                	sd	s4,32(sp)
    80000922:	ec56                	sd	s5,24(sp)
    80000924:	e85a                	sd	s6,16(sp)
    80000926:	e45e                	sd	s7,8(sp)
    80000928:	e062                	sd	s8,0(sp)
    8000092a:	0880                	addi	s0,sp,80
    8000092c:	8baa                	mv	s7,a0
    8000092e:	8b2e                	mv	s6,a1
    80000930:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += szinc){
    80000932:	4981                	li	s3,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000934:	6a05                	lui	s4,0x1
    if((pte = walk(old, i, 0)) == 0)
    80000936:	4601                	li	a2,0
    80000938:	85ce                	mv	a1,s3
    8000093a:	855e                	mv	a0,s7
    8000093c:	a8dff0ef          	jal	800003c8 <walk>
    80000940:	cd1d                	beqz	a0,8000097e <uvmcopy+0x6c>
    if((*pte & PTE_V) == 0)
    80000942:	6118                	ld	a4,0(a0)
    80000944:	00177793          	andi	a5,a4,1
    80000948:	c3a9                	beqz	a5,8000098a <uvmcopy+0x78>
    pa = PTE2PA(*pte);
    8000094a:	00a75593          	srli	a1,a4,0xa
    8000094e:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000952:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000956:	fa0ff0ef          	jal	800000f6 <kalloc>
    8000095a:	892a                	mv	s2,a0
    8000095c:	c121                	beqz	a0,8000099c <uvmcopy+0x8a>
    memmove(mem, (char*)pa, PGSIZE);
    8000095e:	8652                	mv	a2,s4
    80000960:	85e2                	mv	a1,s8
    80000962:	837ff0ef          	jal	80000198 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000966:	8726                	mv	a4,s1
    80000968:	86ca                	mv	a3,s2
    8000096a:	8652                	mv	a2,s4
    8000096c:	85ce                	mv	a1,s3
    8000096e:	855a                	mv	a0,s6
    80000970:	b31ff0ef          	jal	800004a0 <mappages>
    80000974:	e10d                	bnez	a0,80000996 <uvmcopy+0x84>
  for(i = 0; i < sz; i += szinc){
    80000976:	99d2                	add	s3,s3,s4
    80000978:	fb59efe3          	bltu	s3,s5,80000936 <uvmcopy+0x24>
    8000097c:	a805                	j	800009ac <uvmcopy+0x9a>
      panic("uvmcopy: pte should exist");
    8000097e:	00006517          	auipc	a0,0x6
    80000982:	7da50513          	addi	a0,a0,2010 # 80007158 <etext+0x158>
    80000986:	261040ef          	jal	800053e6 <panic>
      panic("uvmcopy: page not present");
    8000098a:	00006517          	auipc	a0,0x6
    8000098e:	7ee50513          	addi	a0,a0,2030 # 80007178 <etext+0x178>
    80000992:	255040ef          	jal	800053e6 <panic>
      kfree(mem);
    80000996:	854a                	mv	a0,s2
    80000998:	e84ff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000099c:	4685                	li	a3,1
    8000099e:	00c9d613          	srli	a2,s3,0xc
    800009a2:	4581                	li	a1,0
    800009a4:	855a                	mv	a0,s6
    800009a6:	ca1ff0ef          	jal	80000646 <uvmunmap>
  return -1;
    800009aa:	557d                	li	a0,-1
}
    800009ac:	60a6                	ld	ra,72(sp)
    800009ae:	6406                	ld	s0,64(sp)
    800009b0:	74e2                	ld	s1,56(sp)
    800009b2:	7942                	ld	s2,48(sp)
    800009b4:	79a2                	ld	s3,40(sp)
    800009b6:	7a02                	ld	s4,32(sp)
    800009b8:	6ae2                	ld	s5,24(sp)
    800009ba:	6b42                	ld	s6,16(sp)
    800009bc:	6ba2                	ld	s7,8(sp)
    800009be:	6c02                	ld	s8,0(sp)
    800009c0:	6161                	addi	sp,sp,80
    800009c2:	8082                	ret
  return 0;
    800009c4:	4501                	li	a0,0
}
    800009c6:	8082                	ret

00000000800009c8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800009c8:	1141                	addi	sp,sp,-16
    800009ca:	e406                	sd	ra,8(sp)
    800009cc:	e022                	sd	s0,0(sp)
    800009ce:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009d0:	4601                	li	a2,0
    800009d2:	9f7ff0ef          	jal	800003c8 <walk>
  if(pte == 0)
    800009d6:	c901                	beqz	a0,800009e6 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800009d8:	611c                	ld	a5,0(a0)
    800009da:	9bbd                	andi	a5,a5,-17
    800009dc:	e11c                	sd	a5,0(a0)
}
    800009de:	60a2                	ld	ra,8(sp)
    800009e0:	6402                	ld	s0,0(sp)
    800009e2:	0141                	addi	sp,sp,16
    800009e4:	8082                	ret
    panic("uvmclear");
    800009e6:	00006517          	auipc	a0,0x6
    800009ea:	7b250513          	addi	a0,a0,1970 # 80007198 <etext+0x198>
    800009ee:	1f9040ef          	jal	800053e6 <panic>

00000000800009f2 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    800009f2:	c2d1                	beqz	a3,80000a76 <copyout+0x84>
{
    800009f4:	711d                	addi	sp,sp,-96
    800009f6:	ec86                	sd	ra,88(sp)
    800009f8:	e8a2                	sd	s0,80(sp)
    800009fa:	e4a6                	sd	s1,72(sp)
    800009fc:	e0ca                	sd	s2,64(sp)
    800009fe:	fc4e                	sd	s3,56(sp)
    80000a00:	f852                	sd	s4,48(sp)
    80000a02:	f456                	sd	s5,40(sp)
    80000a04:	f05a                	sd	s6,32(sp)
    80000a06:	ec5e                	sd	s7,24(sp)
    80000a08:	e862                	sd	s8,16(sp)
    80000a0a:	e466                	sd	s9,8(sp)
    80000a0c:	1080                	addi	s0,sp,96
    80000a0e:	8b2a                	mv	s6,a0
    80000a10:	89ae                	mv	s3,a1
    80000a12:	8ab2                	mv	s5,a2
    80000a14:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000a16:	7cfd                	lui	s9,0xfffff
    if (va0 >= MAXVA)
    80000a18:	5c7d                	li	s8,-1
    80000a1a:	01ac5c13          	srli	s8,s8,0x1a
      return -1;
    
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000a1e:	6b85                	lui	s7,0x1
    80000a20:	a005                	j	80000a40 <copyout+0x4e>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a22:	412989b3          	sub	s3,s3,s2
    80000a26:	0004861b          	sext.w	a2,s1
    80000a2a:	85d6                	mv	a1,s5
    80000a2c:	954e                	add	a0,a0,s3
    80000a2e:	f6aff0ef          	jal	80000198 <memmove>

    len -= n;
    80000a32:	409a0a33          	sub	s4,s4,s1
    src += n;
    80000a36:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    80000a38:	017909b3          	add	s3,s2,s7
  while(len > 0){
    80000a3c:	020a0b63          	beqz	s4,80000a72 <copyout+0x80>
    va0 = PGROUNDDOWN(dstva);
    80000a40:	0199f933          	and	s2,s3,s9
    if (va0 >= MAXVA)
    80000a44:	032c6b63          	bltu	s8,s2,80000a7a <copyout+0x88>
    if((pte = walk(pagetable, va0, 0)) == 0) {
    80000a48:	4601                	li	a2,0
    80000a4a:	85ca                	mv	a1,s2
    80000a4c:	855a                	mv	a0,s6
    80000a4e:	97bff0ef          	jal	800003c8 <walk>
    80000a52:	c131                	beqz	a0,80000a96 <copyout+0xa4>
    if((*pte & PTE_W) == 0)
    80000a54:	611c                	ld	a5,0(a0)
    80000a56:	8b91                	andi	a5,a5,4
    80000a58:	c3a9                	beqz	a5,80000a9a <copyout+0xa8>
    pa0 = walkaddr(pagetable, va0);
    80000a5a:	85ca                	mv	a1,s2
    80000a5c:	855a                	mv	a0,s6
    80000a5e:	a05ff0ef          	jal	80000462 <walkaddr>
    if(pa0 == 0)
    80000a62:	cd15                	beqz	a0,80000a9e <copyout+0xac>
    n = PGSIZE - (dstva - va0);
    80000a64:	413904b3          	sub	s1,s2,s3
    80000a68:	94de                	add	s1,s1,s7
    if(n > len)
    80000a6a:	fa9a7ce3          	bgeu	s4,s1,80000a22 <copyout+0x30>
    80000a6e:	84d2                	mv	s1,s4
    80000a70:	bf4d                	j	80000a22 <copyout+0x30>
  }
  return 0;
    80000a72:	4501                	li	a0,0
    80000a74:	a021                	j	80000a7c <copyout+0x8a>
    80000a76:	4501                	li	a0,0
}
    80000a78:	8082                	ret
      return -1;
    80000a7a:	557d                	li	a0,-1
}
    80000a7c:	60e6                	ld	ra,88(sp)
    80000a7e:	6446                	ld	s0,80(sp)
    80000a80:	64a6                	ld	s1,72(sp)
    80000a82:	6906                	ld	s2,64(sp)
    80000a84:	79e2                	ld	s3,56(sp)
    80000a86:	7a42                	ld	s4,48(sp)
    80000a88:	7aa2                	ld	s5,40(sp)
    80000a8a:	7b02                	ld	s6,32(sp)
    80000a8c:	6be2                	ld	s7,24(sp)
    80000a8e:	6c42                	ld	s8,16(sp)
    80000a90:	6ca2                	ld	s9,8(sp)
    80000a92:	6125                	addi	sp,sp,96
    80000a94:	8082                	ret
      return -1;
    80000a96:	557d                	li	a0,-1
    80000a98:	b7d5                	j	80000a7c <copyout+0x8a>
      return -1;
    80000a9a:	557d                	li	a0,-1
    80000a9c:	b7c5                	j	80000a7c <copyout+0x8a>
      return -1;
    80000a9e:	557d                	li	a0,-1
    80000aa0:	bff1                	j	80000a7c <copyout+0x8a>

0000000080000aa2 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;
  
  while(len > 0){
    80000aa2:	c6a5                	beqz	a3,80000b0a <copyin+0x68>
{
    80000aa4:	715d                	addi	sp,sp,-80
    80000aa6:	e486                	sd	ra,72(sp)
    80000aa8:	e0a2                	sd	s0,64(sp)
    80000aaa:	fc26                	sd	s1,56(sp)
    80000aac:	f84a                	sd	s2,48(sp)
    80000aae:	f44e                	sd	s3,40(sp)
    80000ab0:	f052                	sd	s4,32(sp)
    80000ab2:	ec56                	sd	s5,24(sp)
    80000ab4:	e85a                	sd	s6,16(sp)
    80000ab6:	e45e                	sd	s7,8(sp)
    80000ab8:	e062                	sd	s8,0(sp)
    80000aba:	0880                	addi	s0,sp,80
    80000abc:	8b2a                	mv	s6,a0
    80000abe:	8a2e                	mv	s4,a1
    80000ac0:	8c32                	mv	s8,a2
    80000ac2:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000ac4:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ac6:	6a85                	lui	s5,0x1
    80000ac8:	a00d                	j	80000aea <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000aca:	018505b3          	add	a1,a0,s8
    80000ace:	0004861b          	sext.w	a2,s1
    80000ad2:	412585b3          	sub	a1,a1,s2
    80000ad6:	8552                	mv	a0,s4
    80000ad8:	ec0ff0ef          	jal	80000198 <memmove>

    len -= n;
    80000adc:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000ae0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000ae2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000ae6:	02098063          	beqz	s3,80000b06 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000aea:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000aee:	85ca                	mv	a1,s2
    80000af0:	855a                	mv	a0,s6
    80000af2:	971ff0ef          	jal	80000462 <walkaddr>
    if(pa0 == 0)
    80000af6:	cd01                	beqz	a0,80000b0e <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000af8:	418904b3          	sub	s1,s2,s8
    80000afc:	94d6                	add	s1,s1,s5
    if(n > len)
    80000afe:	fc99f6e3          	bgeu	s3,s1,80000aca <copyin+0x28>
    80000b02:	84ce                	mv	s1,s3
    80000b04:	b7d9                	j	80000aca <copyin+0x28>
  }
  return 0;
    80000b06:	4501                	li	a0,0
    80000b08:	a021                	j	80000b10 <copyin+0x6e>
    80000b0a:	4501                	li	a0,0
}
    80000b0c:	8082                	ret
      return -1;
    80000b0e:	557d                	li	a0,-1
}
    80000b10:	60a6                	ld	ra,72(sp)
    80000b12:	6406                	ld	s0,64(sp)
    80000b14:	74e2                	ld	s1,56(sp)
    80000b16:	7942                	ld	s2,48(sp)
    80000b18:	79a2                	ld	s3,40(sp)
    80000b1a:	7a02                	ld	s4,32(sp)
    80000b1c:	6ae2                	ld	s5,24(sp)
    80000b1e:	6b42                	ld	s6,16(sp)
    80000b20:	6ba2                	ld	s7,8(sp)
    80000b22:	6c02                	ld	s8,0(sp)
    80000b24:	6161                	addi	sp,sp,80
    80000b26:	8082                	ret

0000000080000b28 <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80000b28:	715d                	addi	sp,sp,-80
    80000b2a:	e486                	sd	ra,72(sp)
    80000b2c:	e0a2                	sd	s0,64(sp)
    80000b2e:	fc26                	sd	s1,56(sp)
    80000b30:	f84a                	sd	s2,48(sp)
    80000b32:	f44e                	sd	s3,40(sp)
    80000b34:	f052                	sd	s4,32(sp)
    80000b36:	ec56                	sd	s5,24(sp)
    80000b38:	e85a                	sd	s6,16(sp)
    80000b3a:	e45e                	sd	s7,8(sp)
    80000b3c:	0880                	addi	s0,sp,80
    80000b3e:	8aaa                	mv	s5,a0
    80000b40:	89ae                	mv	s3,a1
    80000b42:	8bb2                	mv	s7,a2
    80000b44:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    80000b46:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b48:	6a05                	lui	s4,0x1
    80000b4a:	a02d                	j	80000b74 <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b4c:	00078023          	sb	zero,0(a5)
    80000b50:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b52:	0017c793          	xori	a5,a5,1
    80000b56:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b5a:	60a6                	ld	ra,72(sp)
    80000b5c:	6406                	ld	s0,64(sp)
    80000b5e:	74e2                	ld	s1,56(sp)
    80000b60:	7942                	ld	s2,48(sp)
    80000b62:	79a2                	ld	s3,40(sp)
    80000b64:	7a02                	ld	s4,32(sp)
    80000b66:	6ae2                	ld	s5,24(sp)
    80000b68:	6b42                	ld	s6,16(sp)
    80000b6a:	6ba2                	ld	s7,8(sp)
    80000b6c:	6161                	addi	sp,sp,80
    80000b6e:	8082                	ret
    srcva = va0 + PGSIZE;
    80000b70:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80000b74:	c4b1                	beqz	s1,80000bc0 <copyinstr+0x98>
    va0 = PGROUNDDOWN(srcva);
    80000b76:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80000b7a:	85ca                	mv	a1,s2
    80000b7c:	8556                	mv	a0,s5
    80000b7e:	8e5ff0ef          	jal	80000462 <walkaddr>
    if(pa0 == 0)
    80000b82:	c129                	beqz	a0,80000bc4 <copyinstr+0x9c>
    n = PGSIZE - (srcva - va0);
    80000b84:	41790633          	sub	a2,s2,s7
    80000b88:	9652                	add	a2,a2,s4
    if(n > max)
    80000b8a:	00c4f363          	bgeu	s1,a2,80000b90 <copyinstr+0x68>
    80000b8e:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000b90:	412b8bb3          	sub	s7,s7,s2
    80000b94:	9baa                	add	s7,s7,a0
    while(n > 0){
    80000b96:	de69                	beqz	a2,80000b70 <copyinstr+0x48>
    80000b98:	87ce                	mv	a5,s3
      if(*p == '\0'){
    80000b9a:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    80000b9e:	964e                	add	a2,a2,s3
    80000ba0:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000ba2:	00f68733          	add	a4,a3,a5
    80000ba6:	00074703          	lbu	a4,0(a4)
    80000baa:	d34d                	beqz	a4,80000b4c <copyinstr+0x24>
        *dst = *p;
    80000bac:	00e78023          	sb	a4,0(a5)
      dst++;
    80000bb0:	0785                	addi	a5,a5,1
    while(n > 0){
    80000bb2:	fec797e3          	bne	a5,a2,80000ba0 <copyinstr+0x78>
    80000bb6:	14fd                	addi	s1,s1,-1
    80000bb8:	94ce                	add	s1,s1,s3
      --max;
    80000bba:	8c8d                	sub	s1,s1,a1
    80000bbc:	89be                	mv	s3,a5
    80000bbe:	bf4d                	j	80000b70 <copyinstr+0x48>
    80000bc0:	4781                	li	a5,0
    80000bc2:	bf41                	j	80000b52 <copyinstr+0x2a>
      return -1;
    80000bc4:	557d                	li	a0,-1
    80000bc6:	bf51                	j	80000b5a <copyinstr+0x32>

0000000080000bc8 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000bc8:	715d                	addi	sp,sp,-80
    80000bca:	e486                	sd	ra,72(sp)
    80000bcc:	e0a2                	sd	s0,64(sp)
    80000bce:	fc26                	sd	s1,56(sp)
    80000bd0:	f84a                	sd	s2,48(sp)
    80000bd2:	f44e                	sd	s3,40(sp)
    80000bd4:	f052                	sd	s4,32(sp)
    80000bd6:	ec56                	sd	s5,24(sp)
    80000bd8:	e85a                	sd	s6,16(sp)
    80000bda:	e45e                	sd	s7,8(sp)
    80000bdc:	e062                	sd	s8,0(sp)
    80000bde:	0880                	addi	s0,sp,80
    80000be0:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000be2:	0000a497          	auipc	s1,0xa
    80000be6:	b0e48493          	addi	s1,s1,-1266 # 8000a6f0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000bea:	8c26                	mv	s8,s1
    80000bec:	a4fa57b7          	lui	a5,0xa4fa5
    80000bf0:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f819d5>
    80000bf4:	4fa50937          	lui	s2,0x4fa50
    80000bf8:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000bfc:	1902                	slli	s2,s2,0x20
    80000bfe:	993e                	add	s2,s2,a5
    80000c00:	040009b7          	lui	s3,0x4000
    80000c04:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c06:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c08:	4b99                	li	s7,6
    80000c0a:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c0c:	0000fa97          	auipc	s5,0xf
    80000c10:	4e4a8a93          	addi	s5,s5,1252 # 800100f0 <tickslock>
    char *pa = kalloc();
    80000c14:	ce2ff0ef          	jal	800000f6 <kalloc>
    80000c18:	862a                	mv	a2,a0
    if(pa == 0)
    80000c1a:	c121                	beqz	a0,80000c5a <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    80000c1c:	418485b3          	sub	a1,s1,s8
    80000c20:	858d                	srai	a1,a1,0x3
    80000c22:	032585b3          	mul	a1,a1,s2
    80000c26:	2585                	addiw	a1,a1,1
    80000c28:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c2c:	875e                	mv	a4,s7
    80000c2e:	86da                	mv	a3,s6
    80000c30:	40b985b3          	sub	a1,s3,a1
    80000c34:	8552                	mv	a0,s4
    80000c36:	921ff0ef          	jal	80000556 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c3a:	16848493          	addi	s1,s1,360
    80000c3e:	fd549be3          	bne	s1,s5,80000c14 <proc_mapstacks+0x4c>
  }
}
    80000c42:	60a6                	ld	ra,72(sp)
    80000c44:	6406                	ld	s0,64(sp)
    80000c46:	74e2                	ld	s1,56(sp)
    80000c48:	7942                	ld	s2,48(sp)
    80000c4a:	79a2                	ld	s3,40(sp)
    80000c4c:	7a02                	ld	s4,32(sp)
    80000c4e:	6ae2                	ld	s5,24(sp)
    80000c50:	6b42                	ld	s6,16(sp)
    80000c52:	6ba2                	ld	s7,8(sp)
    80000c54:	6c02                	ld	s8,0(sp)
    80000c56:	6161                	addi	sp,sp,80
    80000c58:	8082                	ret
      panic("kalloc");
    80000c5a:	00006517          	auipc	a0,0x6
    80000c5e:	54e50513          	addi	a0,a0,1358 # 800071a8 <etext+0x1a8>
    80000c62:	784040ef          	jal	800053e6 <panic>

0000000080000c66 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000c66:	7139                	addi	sp,sp,-64
    80000c68:	fc06                	sd	ra,56(sp)
    80000c6a:	f822                	sd	s0,48(sp)
    80000c6c:	f426                	sd	s1,40(sp)
    80000c6e:	f04a                	sd	s2,32(sp)
    80000c70:	ec4e                	sd	s3,24(sp)
    80000c72:	e852                	sd	s4,16(sp)
    80000c74:	e456                	sd	s5,8(sp)
    80000c76:	e05a                	sd	s6,0(sp)
    80000c78:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000c7a:	00006597          	auipc	a1,0x6
    80000c7e:	53658593          	addi	a1,a1,1334 # 800071b0 <etext+0x1b0>
    80000c82:	00009517          	auipc	a0,0x9
    80000c86:	63e50513          	addi	a0,a0,1598 # 8000a2c0 <pid_lock>
    80000c8a:	207040ef          	jal	80005690 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000c8e:	00006597          	auipc	a1,0x6
    80000c92:	52a58593          	addi	a1,a1,1322 # 800071b8 <etext+0x1b8>
    80000c96:	00009517          	auipc	a0,0x9
    80000c9a:	64250513          	addi	a0,a0,1602 # 8000a2d8 <wait_lock>
    80000c9e:	1f3040ef          	jal	80005690 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ca2:	0000a497          	auipc	s1,0xa
    80000ca6:	a4e48493          	addi	s1,s1,-1458 # 8000a6f0 <proc>
      initlock(&p->lock, "proc");
    80000caa:	00006b17          	auipc	s6,0x6
    80000cae:	51eb0b13          	addi	s6,s6,1310 # 800071c8 <etext+0x1c8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000cb2:	8aa6                	mv	s5,s1
    80000cb4:	a4fa57b7          	lui	a5,0xa4fa5
    80000cb8:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f819d5>
    80000cbc:	4fa50937          	lui	s2,0x4fa50
    80000cc0:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000cc4:	1902                	slli	s2,s2,0x20
    80000cc6:	993e                	add	s2,s2,a5
    80000cc8:	040009b7          	lui	s3,0x4000
    80000ccc:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000cce:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cd0:	0000fa17          	auipc	s4,0xf
    80000cd4:	420a0a13          	addi	s4,s4,1056 # 800100f0 <tickslock>
      initlock(&p->lock, "proc");
    80000cd8:	85da                	mv	a1,s6
    80000cda:	8526                	mv	a0,s1
    80000cdc:	1b5040ef          	jal	80005690 <initlock>
      p->state = UNUSED;
    80000ce0:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000ce4:	415487b3          	sub	a5,s1,s5
    80000ce8:	878d                	srai	a5,a5,0x3
    80000cea:	032787b3          	mul	a5,a5,s2
    80000cee:	2785                	addiw	a5,a5,1
    80000cf0:	00d7979b          	slliw	a5,a5,0xd
    80000cf4:	40f987b3          	sub	a5,s3,a5
    80000cf8:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cfa:	16848493          	addi	s1,s1,360
    80000cfe:	fd449de3          	bne	s1,s4,80000cd8 <procinit+0x72>
  }
}
    80000d02:	70e2                	ld	ra,56(sp)
    80000d04:	7442                	ld	s0,48(sp)
    80000d06:	74a2                	ld	s1,40(sp)
    80000d08:	7902                	ld	s2,32(sp)
    80000d0a:	69e2                	ld	s3,24(sp)
    80000d0c:	6a42                	ld	s4,16(sp)
    80000d0e:	6aa2                	ld	s5,8(sp)
    80000d10:	6b02                	ld	s6,0(sp)
    80000d12:	6121                	addi	sp,sp,64
    80000d14:	8082                	ret

0000000080000d16 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d16:	1141                	addi	sp,sp,-16
    80000d18:	e406                	sd	ra,8(sp)
    80000d1a:	e022                	sd	s0,0(sp)
    80000d1c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d1e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d20:	2501                	sext.w	a0,a0
    80000d22:	60a2                	ld	ra,8(sp)
    80000d24:	6402                	ld	s0,0(sp)
    80000d26:	0141                	addi	sp,sp,16
    80000d28:	8082                	ret

0000000080000d2a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d2a:	1141                	addi	sp,sp,-16
    80000d2c:	e406                	sd	ra,8(sp)
    80000d2e:	e022                	sd	s0,0(sp)
    80000d30:	0800                	addi	s0,sp,16
    80000d32:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d34:	2781                	sext.w	a5,a5
    80000d36:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d38:	00009517          	auipc	a0,0x9
    80000d3c:	5b850513          	addi	a0,a0,1464 # 8000a2f0 <cpus>
    80000d40:	953e                	add	a0,a0,a5
    80000d42:	60a2                	ld	ra,8(sp)
    80000d44:	6402                	ld	s0,0(sp)
    80000d46:	0141                	addi	sp,sp,16
    80000d48:	8082                	ret

0000000080000d4a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d4a:	1101                	addi	sp,sp,-32
    80000d4c:	ec06                	sd	ra,24(sp)
    80000d4e:	e822                	sd	s0,16(sp)
    80000d50:	e426                	sd	s1,8(sp)
    80000d52:	1000                	addi	s0,sp,32
  push_off();
    80000d54:	181040ef          	jal	800056d4 <push_off>
    80000d58:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d5a:	2781                	sext.w	a5,a5
    80000d5c:	079e                	slli	a5,a5,0x7
    80000d5e:	00009717          	auipc	a4,0x9
    80000d62:	56270713          	addi	a4,a4,1378 # 8000a2c0 <pid_lock>
    80000d66:	97ba                	add	a5,a5,a4
    80000d68:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d6a:	1ef040ef          	jal	80005758 <pop_off>
  return p;
}
    80000d6e:	8526                	mv	a0,s1
    80000d70:	60e2                	ld	ra,24(sp)
    80000d72:	6442                	ld	s0,16(sp)
    80000d74:	64a2                	ld	s1,8(sp)
    80000d76:	6105                	addi	sp,sp,32
    80000d78:	8082                	ret

0000000080000d7a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000d7a:	1141                	addi	sp,sp,-16
    80000d7c:	e406                	sd	ra,8(sp)
    80000d7e:	e022                	sd	s0,0(sp)
    80000d80:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000d82:	fc9ff0ef          	jal	80000d4a <myproc>
    80000d86:	223040ef          	jal	800057a8 <release>

  if (first) {
    80000d8a:	00009797          	auipc	a5,0x9
    80000d8e:	4967a783          	lw	a5,1174(a5) # 8000a220 <first.1>
    80000d92:	e799                	bnez	a5,80000da0 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000d94:	2bd000ef          	jal	80001850 <usertrapret>
}
    80000d98:	60a2                	ld	ra,8(sp)
    80000d9a:	6402                	ld	s0,0(sp)
    80000d9c:	0141                	addi	sp,sp,16
    80000d9e:	8082                	ret
    fsinit(ROOTDEV);
    80000da0:	4505                	li	a0,1
    80000da2:	624010ef          	jal	800023c6 <fsinit>
    first = 0;
    80000da6:	00009797          	auipc	a5,0x9
    80000daa:	4607ad23          	sw	zero,1146(a5) # 8000a220 <first.1>
    __sync_synchronize();
    80000dae:	0330000f          	fence	rw,rw
    80000db2:	b7cd                	j	80000d94 <forkret+0x1a>

0000000080000db4 <allocpid>:
{
    80000db4:	1101                	addi	sp,sp,-32
    80000db6:	ec06                	sd	ra,24(sp)
    80000db8:	e822                	sd	s0,16(sp)
    80000dba:	e426                	sd	s1,8(sp)
    80000dbc:	e04a                	sd	s2,0(sp)
    80000dbe:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000dc0:	00009917          	auipc	s2,0x9
    80000dc4:	50090913          	addi	s2,s2,1280 # 8000a2c0 <pid_lock>
    80000dc8:	854a                	mv	a0,s2
    80000dca:	14b040ef          	jal	80005714 <acquire>
  pid = nextpid;
    80000dce:	00009797          	auipc	a5,0x9
    80000dd2:	45678793          	addi	a5,a5,1110 # 8000a224 <nextpid>
    80000dd6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000dd8:	0014871b          	addiw	a4,s1,1
    80000ddc:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000dde:	854a                	mv	a0,s2
    80000de0:	1c9040ef          	jal	800057a8 <release>
}
    80000de4:	8526                	mv	a0,s1
    80000de6:	60e2                	ld	ra,24(sp)
    80000de8:	6442                	ld	s0,16(sp)
    80000dea:	64a2                	ld	s1,8(sp)
    80000dec:	6902                	ld	s2,0(sp)
    80000dee:	6105                	addi	sp,sp,32
    80000df0:	8082                	ret

0000000080000df2 <proc_pagetable>:
{
    80000df2:	1101                	addi	sp,sp,-32
    80000df4:	ec06                	sd	ra,24(sp)
    80000df6:	e822                	sd	s0,16(sp)
    80000df8:	e426                	sd	s1,8(sp)
    80000dfa:	e04a                	sd	s2,0(sp)
    80000dfc:	1000                	addi	s0,sp,32
    80000dfe:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e00:	913ff0ef          	jal	80000712 <uvmcreate>
    80000e04:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e06:	cd05                	beqz	a0,80000e3e <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e08:	4729                	li	a4,10
    80000e0a:	00005697          	auipc	a3,0x5
    80000e0e:	1f668693          	addi	a3,a3,502 # 80006000 <_trampoline>
    80000e12:	6605                	lui	a2,0x1
    80000e14:	040005b7          	lui	a1,0x4000
    80000e18:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e1a:	05b2                	slli	a1,a1,0xc
    80000e1c:	e84ff0ef          	jal	800004a0 <mappages>
    80000e20:	02054663          	bltz	a0,80000e4c <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e24:	4719                	li	a4,6
    80000e26:	05893683          	ld	a3,88(s2)
    80000e2a:	6605                	lui	a2,0x1
    80000e2c:	020005b7          	lui	a1,0x2000
    80000e30:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000e32:	05b6                	slli	a1,a1,0xd
    80000e34:	8526                	mv	a0,s1
    80000e36:	e6aff0ef          	jal	800004a0 <mappages>
    80000e3a:	00054f63          	bltz	a0,80000e58 <proc_pagetable+0x66>
}
    80000e3e:	8526                	mv	a0,s1
    80000e40:	60e2                	ld	ra,24(sp)
    80000e42:	6442                	ld	s0,16(sp)
    80000e44:	64a2                	ld	s1,8(sp)
    80000e46:	6902                	ld	s2,0(sp)
    80000e48:	6105                	addi	sp,sp,32
    80000e4a:	8082                	ret
    uvmfree(pagetable, 0);
    80000e4c:	4581                	li	a1,0
    80000e4e:	8526                	mv	a0,s1
    80000e50:	a91ff0ef          	jal	800008e0 <uvmfree>
    return 0;
    80000e54:	4481                	li	s1,0
    80000e56:	b7e5                	j	80000e3e <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e58:	4681                	li	a3,0
    80000e5a:	4605                	li	a2,1
    80000e5c:	040005b7          	lui	a1,0x4000
    80000e60:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e62:	05b2                	slli	a1,a1,0xc
    80000e64:	8526                	mv	a0,s1
    80000e66:	fe0ff0ef          	jal	80000646 <uvmunmap>
    uvmfree(pagetable, 0);
    80000e6a:	4581                	li	a1,0
    80000e6c:	8526                	mv	a0,s1
    80000e6e:	a73ff0ef          	jal	800008e0 <uvmfree>
    return 0;
    80000e72:	4481                	li	s1,0
    80000e74:	b7e9                	j	80000e3e <proc_pagetable+0x4c>

0000000080000e76 <proc_freepagetable>:
{
    80000e76:	1101                	addi	sp,sp,-32
    80000e78:	ec06                	sd	ra,24(sp)
    80000e7a:	e822                	sd	s0,16(sp)
    80000e7c:	e426                	sd	s1,8(sp)
    80000e7e:	e04a                	sd	s2,0(sp)
    80000e80:	1000                	addi	s0,sp,32
    80000e82:	84aa                	mv	s1,a0
    80000e84:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e86:	4681                	li	a3,0
    80000e88:	4605                	li	a2,1
    80000e8a:	040005b7          	lui	a1,0x4000
    80000e8e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e90:	05b2                	slli	a1,a1,0xc
    80000e92:	fb4ff0ef          	jal	80000646 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000e96:	4681                	li	a3,0
    80000e98:	4605                	li	a2,1
    80000e9a:	020005b7          	lui	a1,0x2000
    80000e9e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000ea0:	05b6                	slli	a1,a1,0xd
    80000ea2:	8526                	mv	a0,s1
    80000ea4:	fa2ff0ef          	jal	80000646 <uvmunmap>
  uvmfree(pagetable, sz);
    80000ea8:	85ca                	mv	a1,s2
    80000eaa:	8526                	mv	a0,s1
    80000eac:	a35ff0ef          	jal	800008e0 <uvmfree>
}
    80000eb0:	60e2                	ld	ra,24(sp)
    80000eb2:	6442                	ld	s0,16(sp)
    80000eb4:	64a2                	ld	s1,8(sp)
    80000eb6:	6902                	ld	s2,0(sp)
    80000eb8:	6105                	addi	sp,sp,32
    80000eba:	8082                	ret

0000000080000ebc <freeproc>:
{
    80000ebc:	1101                	addi	sp,sp,-32
    80000ebe:	ec06                	sd	ra,24(sp)
    80000ec0:	e822                	sd	s0,16(sp)
    80000ec2:	e426                	sd	s1,8(sp)
    80000ec4:	1000                	addi	s0,sp,32
    80000ec6:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000ec8:	6d28                	ld	a0,88(a0)
    80000eca:	c119                	beqz	a0,80000ed0 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000ecc:	950ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000ed0:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000ed4:	68a8                	ld	a0,80(s1)
    80000ed6:	c501                	beqz	a0,80000ede <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000ed8:	64ac                	ld	a1,72(s1)
    80000eda:	f9dff0ef          	jal	80000e76 <proc_freepagetable>
  p->pagetable = 0;
    80000ede:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000ee2:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000ee6:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000eea:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000eee:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000ef2:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000ef6:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000efa:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000efe:	0004ac23          	sw	zero,24(s1)
}
    80000f02:	60e2                	ld	ra,24(sp)
    80000f04:	6442                	ld	s0,16(sp)
    80000f06:	64a2                	ld	s1,8(sp)
    80000f08:	6105                	addi	sp,sp,32
    80000f0a:	8082                	ret

0000000080000f0c <allocproc>:
{
    80000f0c:	1101                	addi	sp,sp,-32
    80000f0e:	ec06                	sd	ra,24(sp)
    80000f10:	e822                	sd	s0,16(sp)
    80000f12:	e426                	sd	s1,8(sp)
    80000f14:	e04a                	sd	s2,0(sp)
    80000f16:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f18:	00009497          	auipc	s1,0x9
    80000f1c:	7d848493          	addi	s1,s1,2008 # 8000a6f0 <proc>
    80000f20:	0000f917          	auipc	s2,0xf
    80000f24:	1d090913          	addi	s2,s2,464 # 800100f0 <tickslock>
    acquire(&p->lock);
    80000f28:	8526                	mv	a0,s1
    80000f2a:	7ea040ef          	jal	80005714 <acquire>
    if(p->state == UNUSED) {
    80000f2e:	4c9c                	lw	a5,24(s1)
    80000f30:	cb91                	beqz	a5,80000f44 <allocproc+0x38>
      release(&p->lock);
    80000f32:	8526                	mv	a0,s1
    80000f34:	075040ef          	jal	800057a8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f38:	16848493          	addi	s1,s1,360
    80000f3c:	ff2496e3          	bne	s1,s2,80000f28 <allocproc+0x1c>
  return 0;
    80000f40:	4481                	li	s1,0
    80000f42:	a089                	j	80000f84 <allocproc+0x78>
  p->pid = allocpid();
    80000f44:	e71ff0ef          	jal	80000db4 <allocpid>
    80000f48:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000f4a:	4785                	li	a5,1
    80000f4c:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000f4e:	9a8ff0ef          	jal	800000f6 <kalloc>
    80000f52:	892a                	mv	s2,a0
    80000f54:	eca8                	sd	a0,88(s1)
    80000f56:	cd15                	beqz	a0,80000f92 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000f58:	8526                	mv	a0,s1
    80000f5a:	e99ff0ef          	jal	80000df2 <proc_pagetable>
    80000f5e:	892a                	mv	s2,a0
    80000f60:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000f62:	c121                	beqz	a0,80000fa2 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80000f64:	07000613          	li	a2,112
    80000f68:	4581                	li	a1,0
    80000f6a:	06048513          	addi	a0,s1,96
    80000f6e:	9c6ff0ef          	jal	80000134 <memset>
  p->context.ra = (uint64)forkret;
    80000f72:	00000797          	auipc	a5,0x0
    80000f76:	e0878793          	addi	a5,a5,-504 # 80000d7a <forkret>
    80000f7a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000f7c:	60bc                	ld	a5,64(s1)
    80000f7e:	6705                	lui	a4,0x1
    80000f80:	97ba                	add	a5,a5,a4
    80000f82:	f4bc                	sd	a5,104(s1)
}
    80000f84:	8526                	mv	a0,s1
    80000f86:	60e2                	ld	ra,24(sp)
    80000f88:	6442                	ld	s0,16(sp)
    80000f8a:	64a2                	ld	s1,8(sp)
    80000f8c:	6902                	ld	s2,0(sp)
    80000f8e:	6105                	addi	sp,sp,32
    80000f90:	8082                	ret
    freeproc(p);
    80000f92:	8526                	mv	a0,s1
    80000f94:	f29ff0ef          	jal	80000ebc <freeproc>
    release(&p->lock);
    80000f98:	8526                	mv	a0,s1
    80000f9a:	00f040ef          	jal	800057a8 <release>
    return 0;
    80000f9e:	84ca                	mv	s1,s2
    80000fa0:	b7d5                	j	80000f84 <allocproc+0x78>
    freeproc(p);
    80000fa2:	8526                	mv	a0,s1
    80000fa4:	f19ff0ef          	jal	80000ebc <freeproc>
    release(&p->lock);
    80000fa8:	8526                	mv	a0,s1
    80000faa:	7fe040ef          	jal	800057a8 <release>
    return 0;
    80000fae:	84ca                	mv	s1,s2
    80000fb0:	bfd1                	j	80000f84 <allocproc+0x78>

0000000080000fb2 <userinit>:
{
    80000fb2:	1101                	addi	sp,sp,-32
    80000fb4:	ec06                	sd	ra,24(sp)
    80000fb6:	e822                	sd	s0,16(sp)
    80000fb8:	e426                	sd	s1,8(sp)
    80000fba:	1000                	addi	s0,sp,32
  p = allocproc();
    80000fbc:	f51ff0ef          	jal	80000f0c <allocproc>
    80000fc0:	84aa                	mv	s1,a0
  initproc = p;
    80000fc2:	00009797          	auipc	a5,0x9
    80000fc6:	2aa7bf23          	sd	a0,702(a5) # 8000a280 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80000fca:	03400613          	li	a2,52
    80000fce:	00009597          	auipc	a1,0x9
    80000fd2:	26258593          	addi	a1,a1,610 # 8000a230 <initcode>
    80000fd6:	6928                	ld	a0,80(a0)
    80000fd8:	f60ff0ef          	jal	80000738 <uvmfirst>
  p->sz = PGSIZE;
    80000fdc:	6785                	lui	a5,0x1
    80000fde:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80000fe0:	6cb8                	ld	a4,88(s1)
    80000fe2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80000fe6:	6cb8                	ld	a4,88(s1)
    80000fe8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80000fea:	4641                	li	a2,16
    80000fec:	00006597          	auipc	a1,0x6
    80000ff0:	1e458593          	addi	a1,a1,484 # 800071d0 <etext+0x1d0>
    80000ff4:	15848513          	addi	a0,s1,344
    80000ff8:	a8eff0ef          	jal	80000286 <safestrcpy>
  p->cwd = namei("/");
    80000ffc:	00006517          	auipc	a0,0x6
    80001000:	1e450513          	addi	a0,a0,484 # 800071e0 <etext+0x1e0>
    80001004:	4e7010ef          	jal	80002cea <namei>
    80001008:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000100c:	478d                	li	a5,3
    8000100e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001010:	8526                	mv	a0,s1
    80001012:	796040ef          	jal	800057a8 <release>
}
    80001016:	60e2                	ld	ra,24(sp)
    80001018:	6442                	ld	s0,16(sp)
    8000101a:	64a2                	ld	s1,8(sp)
    8000101c:	6105                	addi	sp,sp,32
    8000101e:	8082                	ret

0000000080001020 <growproc>:
{
    80001020:	1101                	addi	sp,sp,-32
    80001022:	ec06                	sd	ra,24(sp)
    80001024:	e822                	sd	s0,16(sp)
    80001026:	e426                	sd	s1,8(sp)
    80001028:	e04a                	sd	s2,0(sp)
    8000102a:	1000                	addi	s0,sp,32
    8000102c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000102e:	d1dff0ef          	jal	80000d4a <myproc>
    80001032:	84aa                	mv	s1,a0
  sz = p->sz;
    80001034:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001036:	01204c63          	bgtz	s2,8000104e <growproc+0x2e>
  } else if(n < 0){
    8000103a:	02094463          	bltz	s2,80001062 <growproc+0x42>
  p->sz = sz;
    8000103e:	e4ac                	sd	a1,72(s1)
  return 0;
    80001040:	4501                	li	a0,0
}
    80001042:	60e2                	ld	ra,24(sp)
    80001044:	6442                	ld	s0,16(sp)
    80001046:	64a2                	ld	s1,8(sp)
    80001048:	6902                	ld	s2,0(sp)
    8000104a:	6105                	addi	sp,sp,32
    8000104c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000104e:	4691                	li	a3,4
    80001050:	00b90633          	add	a2,s2,a1
    80001054:	6928                	ld	a0,80(a0)
    80001056:	f84ff0ef          	jal	800007da <uvmalloc>
    8000105a:	85aa                	mv	a1,a0
    8000105c:	f16d                	bnez	a0,8000103e <growproc+0x1e>
      return -1;
    8000105e:	557d                	li	a0,-1
    80001060:	b7cd                	j	80001042 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001062:	00b90633          	add	a2,s2,a1
    80001066:	6928                	ld	a0,80(a0)
    80001068:	f2eff0ef          	jal	80000796 <uvmdealloc>
    8000106c:	85aa                	mv	a1,a0
    8000106e:	bfc1                	j	8000103e <growproc+0x1e>

0000000080001070 <fork>:
{
    80001070:	7139                	addi	sp,sp,-64
    80001072:	fc06                	sd	ra,56(sp)
    80001074:	f822                	sd	s0,48(sp)
    80001076:	f04a                	sd	s2,32(sp)
    80001078:	e456                	sd	s5,8(sp)
    8000107a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000107c:	ccfff0ef          	jal	80000d4a <myproc>
    80001080:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001082:	e8bff0ef          	jal	80000f0c <allocproc>
    80001086:	0e050a63          	beqz	a0,8000117a <fork+0x10a>
    8000108a:	e852                	sd	s4,16(sp)
    8000108c:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000108e:	048ab603          	ld	a2,72(s5)
    80001092:	692c                	ld	a1,80(a0)
    80001094:	050ab503          	ld	a0,80(s5)
    80001098:	87bff0ef          	jal	80000912 <uvmcopy>
    8000109c:	04054a63          	bltz	a0,800010f0 <fork+0x80>
    800010a0:	f426                	sd	s1,40(sp)
    800010a2:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800010a4:	048ab783          	ld	a5,72(s5)
    800010a8:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800010ac:	058ab683          	ld	a3,88(s5)
    800010b0:	87b6                	mv	a5,a3
    800010b2:	058a3703          	ld	a4,88(s4)
    800010b6:	12068693          	addi	a3,a3,288
    800010ba:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800010be:	6788                	ld	a0,8(a5)
    800010c0:	6b8c                	ld	a1,16(a5)
    800010c2:	6f90                	ld	a2,24(a5)
    800010c4:	01073023          	sd	a6,0(a4)
    800010c8:	e708                	sd	a0,8(a4)
    800010ca:	eb0c                	sd	a1,16(a4)
    800010cc:	ef10                	sd	a2,24(a4)
    800010ce:	02078793          	addi	a5,a5,32
    800010d2:	02070713          	addi	a4,a4,32
    800010d6:	fed792e3          	bne	a5,a3,800010ba <fork+0x4a>
  np->trapframe->a0 = 0;
    800010da:	058a3783          	ld	a5,88(s4)
    800010de:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800010e2:	0d0a8493          	addi	s1,s5,208
    800010e6:	0d0a0913          	addi	s2,s4,208
    800010ea:	150a8993          	addi	s3,s5,336
    800010ee:	a831                	j	8000110a <fork+0x9a>
    freeproc(np);
    800010f0:	8552                	mv	a0,s4
    800010f2:	dcbff0ef          	jal	80000ebc <freeproc>
    release(&np->lock);
    800010f6:	8552                	mv	a0,s4
    800010f8:	6b0040ef          	jal	800057a8 <release>
    return -1;
    800010fc:	597d                	li	s2,-1
    800010fe:	6a42                	ld	s4,16(sp)
    80001100:	a0b5                	j	8000116c <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001102:	04a1                	addi	s1,s1,8
    80001104:	0921                	addi	s2,s2,8
    80001106:	01348963          	beq	s1,s3,80001118 <fork+0xa8>
    if(p->ofile[i])
    8000110a:	6088                	ld	a0,0(s1)
    8000110c:	d97d                	beqz	a0,80001102 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    8000110e:	178020ef          	jal	80003286 <filedup>
    80001112:	00a93023          	sd	a0,0(s2)
    80001116:	b7f5                	j	80001102 <fork+0x92>
  np->cwd = idup(p->cwd);
    80001118:	150ab503          	ld	a0,336(s5)
    8000111c:	4a8010ef          	jal	800025c4 <idup>
    80001120:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001124:	4641                	li	a2,16
    80001126:	158a8593          	addi	a1,s5,344
    8000112a:	158a0513          	addi	a0,s4,344
    8000112e:	958ff0ef          	jal	80000286 <safestrcpy>
  pid = np->pid;
    80001132:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001136:	8552                	mv	a0,s4
    80001138:	670040ef          	jal	800057a8 <release>
  acquire(&wait_lock);
    8000113c:	00009497          	auipc	s1,0x9
    80001140:	19c48493          	addi	s1,s1,412 # 8000a2d8 <wait_lock>
    80001144:	8526                	mv	a0,s1
    80001146:	5ce040ef          	jal	80005714 <acquire>
  np->parent = p;
    8000114a:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000114e:	8526                	mv	a0,s1
    80001150:	658040ef          	jal	800057a8 <release>
  acquire(&np->lock);
    80001154:	8552                	mv	a0,s4
    80001156:	5be040ef          	jal	80005714 <acquire>
  np->state = RUNNABLE;
    8000115a:	478d                	li	a5,3
    8000115c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001160:	8552                	mv	a0,s4
    80001162:	646040ef          	jal	800057a8 <release>
  return pid;
    80001166:	74a2                	ld	s1,40(sp)
    80001168:	69e2                	ld	s3,24(sp)
    8000116a:	6a42                	ld	s4,16(sp)
}
    8000116c:	854a                	mv	a0,s2
    8000116e:	70e2                	ld	ra,56(sp)
    80001170:	7442                	ld	s0,48(sp)
    80001172:	7902                	ld	s2,32(sp)
    80001174:	6aa2                	ld	s5,8(sp)
    80001176:	6121                	addi	sp,sp,64
    80001178:	8082                	ret
    return -1;
    8000117a:	597d                	li	s2,-1
    8000117c:	bfc5                	j	8000116c <fork+0xfc>

000000008000117e <scheduler>:
{
    8000117e:	715d                	addi	sp,sp,-80
    80001180:	e486                	sd	ra,72(sp)
    80001182:	e0a2                	sd	s0,64(sp)
    80001184:	fc26                	sd	s1,56(sp)
    80001186:	f84a                	sd	s2,48(sp)
    80001188:	f44e                	sd	s3,40(sp)
    8000118a:	f052                	sd	s4,32(sp)
    8000118c:	ec56                	sd	s5,24(sp)
    8000118e:	e85a                	sd	s6,16(sp)
    80001190:	e45e                	sd	s7,8(sp)
    80001192:	e062                	sd	s8,0(sp)
    80001194:	0880                	addi	s0,sp,80
    80001196:	8792                	mv	a5,tp
  int id = r_tp();
    80001198:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000119a:	00779b13          	slli	s6,a5,0x7
    8000119e:	00009717          	auipc	a4,0x9
    800011a2:	12270713          	addi	a4,a4,290 # 8000a2c0 <pid_lock>
    800011a6:	975a                	add	a4,a4,s6
    800011a8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011ac:	00009717          	auipc	a4,0x9
    800011b0:	14c70713          	addi	a4,a4,332 # 8000a2f8 <cpus+0x8>
    800011b4:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800011b6:	4c11                	li	s8,4
        c->proc = p;
    800011b8:	079e                	slli	a5,a5,0x7
    800011ba:	00009a17          	auipc	s4,0x9
    800011be:	106a0a13          	addi	s4,s4,262 # 8000a2c0 <pid_lock>
    800011c2:	9a3e                	add	s4,s4,a5
        found = 1;
    800011c4:	4b85                	li	s7,1
    800011c6:	a0a9                	j	80001210 <scheduler+0x92>
      release(&p->lock);
    800011c8:	8526                	mv	a0,s1
    800011ca:	5de040ef          	jal	800057a8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800011ce:	16848493          	addi	s1,s1,360
    800011d2:	03248563          	beq	s1,s2,800011fc <scheduler+0x7e>
      acquire(&p->lock);
    800011d6:	8526                	mv	a0,s1
    800011d8:	53c040ef          	jal	80005714 <acquire>
      if(p->state == RUNNABLE) {
    800011dc:	4c9c                	lw	a5,24(s1)
    800011de:	ff3795e3          	bne	a5,s3,800011c8 <scheduler+0x4a>
        p->state = RUNNING;
    800011e2:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    800011e6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800011ea:	06048593          	addi	a1,s1,96
    800011ee:	855a                	mv	a0,s6
    800011f0:	5b6000ef          	jal	800017a6 <swtch>
        c->proc = 0;
    800011f4:	020a3823          	sd	zero,48(s4)
        found = 1;
    800011f8:	8ade                	mv	s5,s7
    800011fa:	b7f9                	j	800011c8 <scheduler+0x4a>
    if(found == 0) {
    800011fc:	000a9a63          	bnez	s5,80001210 <scheduler+0x92>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001200:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001204:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001208:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    8000120c:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001210:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001214:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001218:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000121c:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    8000121e:	00009497          	auipc	s1,0x9
    80001222:	4d248493          	addi	s1,s1,1234 # 8000a6f0 <proc>
      if(p->state == RUNNABLE) {
    80001226:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001228:	0000f917          	auipc	s2,0xf
    8000122c:	ec890913          	addi	s2,s2,-312 # 800100f0 <tickslock>
    80001230:	b75d                	j	800011d6 <scheduler+0x58>

0000000080001232 <sched>:
{
    80001232:	7179                	addi	sp,sp,-48
    80001234:	f406                	sd	ra,40(sp)
    80001236:	f022                	sd	s0,32(sp)
    80001238:	ec26                	sd	s1,24(sp)
    8000123a:	e84a                	sd	s2,16(sp)
    8000123c:	e44e                	sd	s3,8(sp)
    8000123e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001240:	b0bff0ef          	jal	80000d4a <myproc>
    80001244:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001246:	464040ef          	jal	800056aa <holding>
    8000124a:	c92d                	beqz	a0,800012bc <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000124c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000124e:	2781                	sext.w	a5,a5
    80001250:	079e                	slli	a5,a5,0x7
    80001252:	00009717          	auipc	a4,0x9
    80001256:	06e70713          	addi	a4,a4,110 # 8000a2c0 <pid_lock>
    8000125a:	97ba                	add	a5,a5,a4
    8000125c:	0a87a703          	lw	a4,168(a5)
    80001260:	4785                	li	a5,1
    80001262:	06f71363          	bne	a4,a5,800012c8 <sched+0x96>
  if(p->state == RUNNING)
    80001266:	4c98                	lw	a4,24(s1)
    80001268:	4791                	li	a5,4
    8000126a:	06f70563          	beq	a4,a5,800012d4 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000126e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001272:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001274:	e7b5                	bnez	a5,800012e0 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001276:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001278:	00009917          	auipc	s2,0x9
    8000127c:	04890913          	addi	s2,s2,72 # 8000a2c0 <pid_lock>
    80001280:	2781                	sext.w	a5,a5
    80001282:	079e                	slli	a5,a5,0x7
    80001284:	97ca                	add	a5,a5,s2
    80001286:	0ac7a983          	lw	s3,172(a5)
    8000128a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000128c:	2781                	sext.w	a5,a5
    8000128e:	079e                	slli	a5,a5,0x7
    80001290:	00009597          	auipc	a1,0x9
    80001294:	06858593          	addi	a1,a1,104 # 8000a2f8 <cpus+0x8>
    80001298:	95be                	add	a1,a1,a5
    8000129a:	06048513          	addi	a0,s1,96
    8000129e:	508000ef          	jal	800017a6 <swtch>
    800012a2:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800012a4:	2781                	sext.w	a5,a5
    800012a6:	079e                	slli	a5,a5,0x7
    800012a8:	993e                	add	s2,s2,a5
    800012aa:	0b392623          	sw	s3,172(s2)
}
    800012ae:	70a2                	ld	ra,40(sp)
    800012b0:	7402                	ld	s0,32(sp)
    800012b2:	64e2                	ld	s1,24(sp)
    800012b4:	6942                	ld	s2,16(sp)
    800012b6:	69a2                	ld	s3,8(sp)
    800012b8:	6145                	addi	sp,sp,48
    800012ba:	8082                	ret
    panic("sched p->lock");
    800012bc:	00006517          	auipc	a0,0x6
    800012c0:	f2c50513          	addi	a0,a0,-212 # 800071e8 <etext+0x1e8>
    800012c4:	122040ef          	jal	800053e6 <panic>
    panic("sched locks");
    800012c8:	00006517          	auipc	a0,0x6
    800012cc:	f3050513          	addi	a0,a0,-208 # 800071f8 <etext+0x1f8>
    800012d0:	116040ef          	jal	800053e6 <panic>
    panic("sched running");
    800012d4:	00006517          	auipc	a0,0x6
    800012d8:	f3450513          	addi	a0,a0,-204 # 80007208 <etext+0x208>
    800012dc:	10a040ef          	jal	800053e6 <panic>
    panic("sched interruptible");
    800012e0:	00006517          	auipc	a0,0x6
    800012e4:	f3850513          	addi	a0,a0,-200 # 80007218 <etext+0x218>
    800012e8:	0fe040ef          	jal	800053e6 <panic>

00000000800012ec <yield>:
{
    800012ec:	1101                	addi	sp,sp,-32
    800012ee:	ec06                	sd	ra,24(sp)
    800012f0:	e822                	sd	s0,16(sp)
    800012f2:	e426                	sd	s1,8(sp)
    800012f4:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800012f6:	a55ff0ef          	jal	80000d4a <myproc>
    800012fa:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800012fc:	418040ef          	jal	80005714 <acquire>
  p->state = RUNNABLE;
    80001300:	478d                	li	a5,3
    80001302:	cc9c                	sw	a5,24(s1)
  sched();
    80001304:	f2fff0ef          	jal	80001232 <sched>
  release(&p->lock);
    80001308:	8526                	mv	a0,s1
    8000130a:	49e040ef          	jal	800057a8 <release>
}
    8000130e:	60e2                	ld	ra,24(sp)
    80001310:	6442                	ld	s0,16(sp)
    80001312:	64a2                	ld	s1,8(sp)
    80001314:	6105                	addi	sp,sp,32
    80001316:	8082                	ret

0000000080001318 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001318:	7179                	addi	sp,sp,-48
    8000131a:	f406                	sd	ra,40(sp)
    8000131c:	f022                	sd	s0,32(sp)
    8000131e:	ec26                	sd	s1,24(sp)
    80001320:	e84a                	sd	s2,16(sp)
    80001322:	e44e                	sd	s3,8(sp)
    80001324:	1800                	addi	s0,sp,48
    80001326:	89aa                	mv	s3,a0
    80001328:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000132a:	a21ff0ef          	jal	80000d4a <myproc>
    8000132e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001330:	3e4040ef          	jal	80005714 <acquire>
  release(lk);
    80001334:	854a                	mv	a0,s2
    80001336:	472040ef          	jal	800057a8 <release>

  // Go to sleep.
  p->chan = chan;
    8000133a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000133e:	4789                	li	a5,2
    80001340:	cc9c                	sw	a5,24(s1)

  sched();
    80001342:	ef1ff0ef          	jal	80001232 <sched>

  // Tidy up.
  p->chan = 0;
    80001346:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000134a:	8526                	mv	a0,s1
    8000134c:	45c040ef          	jal	800057a8 <release>
  acquire(lk);
    80001350:	854a                	mv	a0,s2
    80001352:	3c2040ef          	jal	80005714 <acquire>
}
    80001356:	70a2                	ld	ra,40(sp)
    80001358:	7402                	ld	s0,32(sp)
    8000135a:	64e2                	ld	s1,24(sp)
    8000135c:	6942                	ld	s2,16(sp)
    8000135e:	69a2                	ld	s3,8(sp)
    80001360:	6145                	addi	sp,sp,48
    80001362:	8082                	ret

0000000080001364 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001364:	7139                	addi	sp,sp,-64
    80001366:	fc06                	sd	ra,56(sp)
    80001368:	f822                	sd	s0,48(sp)
    8000136a:	f426                	sd	s1,40(sp)
    8000136c:	f04a                	sd	s2,32(sp)
    8000136e:	ec4e                	sd	s3,24(sp)
    80001370:	e852                	sd	s4,16(sp)
    80001372:	e456                	sd	s5,8(sp)
    80001374:	0080                	addi	s0,sp,64
    80001376:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001378:	00009497          	auipc	s1,0x9
    8000137c:	37848493          	addi	s1,s1,888 # 8000a6f0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001380:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001382:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001384:	0000f917          	auipc	s2,0xf
    80001388:	d6c90913          	addi	s2,s2,-660 # 800100f0 <tickslock>
    8000138c:	a801                	j	8000139c <wakeup+0x38>
      }
      release(&p->lock);
    8000138e:	8526                	mv	a0,s1
    80001390:	418040ef          	jal	800057a8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001394:	16848493          	addi	s1,s1,360
    80001398:	03248263          	beq	s1,s2,800013bc <wakeup+0x58>
    if(p != myproc()){
    8000139c:	9afff0ef          	jal	80000d4a <myproc>
    800013a0:	fea48ae3          	beq	s1,a0,80001394 <wakeup+0x30>
      acquire(&p->lock);
    800013a4:	8526                	mv	a0,s1
    800013a6:	36e040ef          	jal	80005714 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800013aa:	4c9c                	lw	a5,24(s1)
    800013ac:	ff3791e3          	bne	a5,s3,8000138e <wakeup+0x2a>
    800013b0:	709c                	ld	a5,32(s1)
    800013b2:	fd479ee3          	bne	a5,s4,8000138e <wakeup+0x2a>
        p->state = RUNNABLE;
    800013b6:	0154ac23          	sw	s5,24(s1)
    800013ba:	bfd1                	j	8000138e <wakeup+0x2a>
    }
  }
}
    800013bc:	70e2                	ld	ra,56(sp)
    800013be:	7442                	ld	s0,48(sp)
    800013c0:	74a2                	ld	s1,40(sp)
    800013c2:	7902                	ld	s2,32(sp)
    800013c4:	69e2                	ld	s3,24(sp)
    800013c6:	6a42                	ld	s4,16(sp)
    800013c8:	6aa2                	ld	s5,8(sp)
    800013ca:	6121                	addi	sp,sp,64
    800013cc:	8082                	ret

00000000800013ce <reparent>:
{
    800013ce:	7179                	addi	sp,sp,-48
    800013d0:	f406                	sd	ra,40(sp)
    800013d2:	f022                	sd	s0,32(sp)
    800013d4:	ec26                	sd	s1,24(sp)
    800013d6:	e84a                	sd	s2,16(sp)
    800013d8:	e44e                	sd	s3,8(sp)
    800013da:	e052                	sd	s4,0(sp)
    800013dc:	1800                	addi	s0,sp,48
    800013de:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800013e0:	00009497          	auipc	s1,0x9
    800013e4:	31048493          	addi	s1,s1,784 # 8000a6f0 <proc>
      pp->parent = initproc;
    800013e8:	00009a17          	auipc	s4,0x9
    800013ec:	e98a0a13          	addi	s4,s4,-360 # 8000a280 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800013f0:	0000f997          	auipc	s3,0xf
    800013f4:	d0098993          	addi	s3,s3,-768 # 800100f0 <tickslock>
    800013f8:	a029                	j	80001402 <reparent+0x34>
    800013fa:	16848493          	addi	s1,s1,360
    800013fe:	01348b63          	beq	s1,s3,80001414 <reparent+0x46>
    if(pp->parent == p){
    80001402:	7c9c                	ld	a5,56(s1)
    80001404:	ff279be3          	bne	a5,s2,800013fa <reparent+0x2c>
      pp->parent = initproc;
    80001408:	000a3503          	ld	a0,0(s4)
    8000140c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000140e:	f57ff0ef          	jal	80001364 <wakeup>
    80001412:	b7e5                	j	800013fa <reparent+0x2c>
}
    80001414:	70a2                	ld	ra,40(sp)
    80001416:	7402                	ld	s0,32(sp)
    80001418:	64e2                	ld	s1,24(sp)
    8000141a:	6942                	ld	s2,16(sp)
    8000141c:	69a2                	ld	s3,8(sp)
    8000141e:	6a02                	ld	s4,0(sp)
    80001420:	6145                	addi	sp,sp,48
    80001422:	8082                	ret

0000000080001424 <exit>:
{
    80001424:	7179                	addi	sp,sp,-48
    80001426:	f406                	sd	ra,40(sp)
    80001428:	f022                	sd	s0,32(sp)
    8000142a:	ec26                	sd	s1,24(sp)
    8000142c:	e84a                	sd	s2,16(sp)
    8000142e:	e44e                	sd	s3,8(sp)
    80001430:	e052                	sd	s4,0(sp)
    80001432:	1800                	addi	s0,sp,48
    80001434:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001436:	915ff0ef          	jal	80000d4a <myproc>
    8000143a:	89aa                	mv	s3,a0
  if(p == initproc)
    8000143c:	00009797          	auipc	a5,0x9
    80001440:	e447b783          	ld	a5,-444(a5) # 8000a280 <initproc>
    80001444:	0d050493          	addi	s1,a0,208
    80001448:	15050913          	addi	s2,a0,336
    8000144c:	00a79b63          	bne	a5,a0,80001462 <exit+0x3e>
    panic("init exiting");
    80001450:	00006517          	auipc	a0,0x6
    80001454:	de050513          	addi	a0,a0,-544 # 80007230 <etext+0x230>
    80001458:	78f030ef          	jal	800053e6 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    8000145c:	04a1                	addi	s1,s1,8
    8000145e:	01248963          	beq	s1,s2,80001470 <exit+0x4c>
    if(p->ofile[fd]){
    80001462:	6088                	ld	a0,0(s1)
    80001464:	dd65                	beqz	a0,8000145c <exit+0x38>
      fileclose(f);
    80001466:	667010ef          	jal	800032cc <fileclose>
      p->ofile[fd] = 0;
    8000146a:	0004b023          	sd	zero,0(s1)
    8000146e:	b7fd                	j	8000145c <exit+0x38>
  begin_op();
    80001470:	23d010ef          	jal	80002eac <begin_op>
  iput(p->cwd);
    80001474:	1509b503          	ld	a0,336(s3)
    80001478:	304010ef          	jal	8000277c <iput>
  end_op();
    8000147c:	29b010ef          	jal	80002f16 <end_op>
  p->cwd = 0;
    80001480:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001484:	00009497          	auipc	s1,0x9
    80001488:	e5448493          	addi	s1,s1,-428 # 8000a2d8 <wait_lock>
    8000148c:	8526                	mv	a0,s1
    8000148e:	286040ef          	jal	80005714 <acquire>
  reparent(p);
    80001492:	854e                	mv	a0,s3
    80001494:	f3bff0ef          	jal	800013ce <reparent>
  wakeup(p->parent);
    80001498:	0389b503          	ld	a0,56(s3)
    8000149c:	ec9ff0ef          	jal	80001364 <wakeup>
  acquire(&p->lock);
    800014a0:	854e                	mv	a0,s3
    800014a2:	272040ef          	jal	80005714 <acquire>
  p->xstate = status;
    800014a6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014aa:	4795                	li	a5,5
    800014ac:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014b0:	8526                	mv	a0,s1
    800014b2:	2f6040ef          	jal	800057a8 <release>
  sched();
    800014b6:	d7dff0ef          	jal	80001232 <sched>
  panic("zombie exit");
    800014ba:	00006517          	auipc	a0,0x6
    800014be:	d8650513          	addi	a0,a0,-634 # 80007240 <etext+0x240>
    800014c2:	725030ef          	jal	800053e6 <panic>

00000000800014c6 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800014c6:	7179                	addi	sp,sp,-48
    800014c8:	f406                	sd	ra,40(sp)
    800014ca:	f022                	sd	s0,32(sp)
    800014cc:	ec26                	sd	s1,24(sp)
    800014ce:	e84a                	sd	s2,16(sp)
    800014d0:	e44e                	sd	s3,8(sp)
    800014d2:	1800                	addi	s0,sp,48
    800014d4:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800014d6:	00009497          	auipc	s1,0x9
    800014da:	21a48493          	addi	s1,s1,538 # 8000a6f0 <proc>
    800014de:	0000f997          	auipc	s3,0xf
    800014e2:	c1298993          	addi	s3,s3,-1006 # 800100f0 <tickslock>
    acquire(&p->lock);
    800014e6:	8526                	mv	a0,s1
    800014e8:	22c040ef          	jal	80005714 <acquire>
    if(p->pid == pid){
    800014ec:	589c                	lw	a5,48(s1)
    800014ee:	01278b63          	beq	a5,s2,80001504 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800014f2:	8526                	mv	a0,s1
    800014f4:	2b4040ef          	jal	800057a8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800014f8:	16848493          	addi	s1,s1,360
    800014fc:	ff3495e3          	bne	s1,s3,800014e6 <kill+0x20>
  }
  return -1;
    80001500:	557d                	li	a0,-1
    80001502:	a819                	j	80001518 <kill+0x52>
      p->killed = 1;
    80001504:	4785                	li	a5,1
    80001506:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001508:	4c98                	lw	a4,24(s1)
    8000150a:	4789                	li	a5,2
    8000150c:	00f70d63          	beq	a4,a5,80001526 <kill+0x60>
      release(&p->lock);
    80001510:	8526                	mv	a0,s1
    80001512:	296040ef          	jal	800057a8 <release>
      return 0;
    80001516:	4501                	li	a0,0
}
    80001518:	70a2                	ld	ra,40(sp)
    8000151a:	7402                	ld	s0,32(sp)
    8000151c:	64e2                	ld	s1,24(sp)
    8000151e:	6942                	ld	s2,16(sp)
    80001520:	69a2                	ld	s3,8(sp)
    80001522:	6145                	addi	sp,sp,48
    80001524:	8082                	ret
        p->state = RUNNABLE;
    80001526:	478d                	li	a5,3
    80001528:	cc9c                	sw	a5,24(s1)
    8000152a:	b7dd                	j	80001510 <kill+0x4a>

000000008000152c <setkilled>:

void
setkilled(struct proc *p)
{
    8000152c:	1101                	addi	sp,sp,-32
    8000152e:	ec06                	sd	ra,24(sp)
    80001530:	e822                	sd	s0,16(sp)
    80001532:	e426                	sd	s1,8(sp)
    80001534:	1000                	addi	s0,sp,32
    80001536:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001538:	1dc040ef          	jal	80005714 <acquire>
  p->killed = 1;
    8000153c:	4785                	li	a5,1
    8000153e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001540:	8526                	mv	a0,s1
    80001542:	266040ef          	jal	800057a8 <release>
}
    80001546:	60e2                	ld	ra,24(sp)
    80001548:	6442                	ld	s0,16(sp)
    8000154a:	64a2                	ld	s1,8(sp)
    8000154c:	6105                	addi	sp,sp,32
    8000154e:	8082                	ret

0000000080001550 <killed>:

int
killed(struct proc *p)
{
    80001550:	1101                	addi	sp,sp,-32
    80001552:	ec06                	sd	ra,24(sp)
    80001554:	e822                	sd	s0,16(sp)
    80001556:	e426                	sd	s1,8(sp)
    80001558:	e04a                	sd	s2,0(sp)
    8000155a:	1000                	addi	s0,sp,32
    8000155c:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000155e:	1b6040ef          	jal	80005714 <acquire>
  k = p->killed;
    80001562:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001566:	8526                	mv	a0,s1
    80001568:	240040ef          	jal	800057a8 <release>
  return k;
}
    8000156c:	854a                	mv	a0,s2
    8000156e:	60e2                	ld	ra,24(sp)
    80001570:	6442                	ld	s0,16(sp)
    80001572:	64a2                	ld	s1,8(sp)
    80001574:	6902                	ld	s2,0(sp)
    80001576:	6105                	addi	sp,sp,32
    80001578:	8082                	ret

000000008000157a <wait>:
{
    8000157a:	715d                	addi	sp,sp,-80
    8000157c:	e486                	sd	ra,72(sp)
    8000157e:	e0a2                	sd	s0,64(sp)
    80001580:	fc26                	sd	s1,56(sp)
    80001582:	f84a                	sd	s2,48(sp)
    80001584:	f44e                	sd	s3,40(sp)
    80001586:	f052                	sd	s4,32(sp)
    80001588:	ec56                	sd	s5,24(sp)
    8000158a:	e85a                	sd	s6,16(sp)
    8000158c:	e45e                	sd	s7,8(sp)
    8000158e:	0880                	addi	s0,sp,80
    80001590:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001592:	fb8ff0ef          	jal	80000d4a <myproc>
    80001596:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001598:	00009517          	auipc	a0,0x9
    8000159c:	d4050513          	addi	a0,a0,-704 # 8000a2d8 <wait_lock>
    800015a0:	174040ef          	jal	80005714 <acquire>
        if(pp->state == ZOMBIE){
    800015a4:	4a15                	li	s4,5
        havekids = 1;
    800015a6:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015a8:	0000f997          	auipc	s3,0xf
    800015ac:	b4898993          	addi	s3,s3,-1208 # 800100f0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015b0:	00009b97          	auipc	s7,0x9
    800015b4:	d28b8b93          	addi	s7,s7,-728 # 8000a2d8 <wait_lock>
    800015b8:	a869                	j	80001652 <wait+0xd8>
          pid = pp->pid;
    800015ba:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800015be:	000b0c63          	beqz	s6,800015d6 <wait+0x5c>
    800015c2:	4691                	li	a3,4
    800015c4:	02c48613          	addi	a2,s1,44
    800015c8:	85da                	mv	a1,s6
    800015ca:	05093503          	ld	a0,80(s2)
    800015ce:	c24ff0ef          	jal	800009f2 <copyout>
    800015d2:	02054a63          	bltz	a0,80001606 <wait+0x8c>
          freeproc(pp);
    800015d6:	8526                	mv	a0,s1
    800015d8:	8e5ff0ef          	jal	80000ebc <freeproc>
          release(&pp->lock);
    800015dc:	8526                	mv	a0,s1
    800015de:	1ca040ef          	jal	800057a8 <release>
          release(&wait_lock);
    800015e2:	00009517          	auipc	a0,0x9
    800015e6:	cf650513          	addi	a0,a0,-778 # 8000a2d8 <wait_lock>
    800015ea:	1be040ef          	jal	800057a8 <release>
}
    800015ee:	854e                	mv	a0,s3
    800015f0:	60a6                	ld	ra,72(sp)
    800015f2:	6406                	ld	s0,64(sp)
    800015f4:	74e2                	ld	s1,56(sp)
    800015f6:	7942                	ld	s2,48(sp)
    800015f8:	79a2                	ld	s3,40(sp)
    800015fa:	7a02                	ld	s4,32(sp)
    800015fc:	6ae2                	ld	s5,24(sp)
    800015fe:	6b42                	ld	s6,16(sp)
    80001600:	6ba2                	ld	s7,8(sp)
    80001602:	6161                	addi	sp,sp,80
    80001604:	8082                	ret
            release(&pp->lock);
    80001606:	8526                	mv	a0,s1
    80001608:	1a0040ef          	jal	800057a8 <release>
            release(&wait_lock);
    8000160c:	00009517          	auipc	a0,0x9
    80001610:	ccc50513          	addi	a0,a0,-820 # 8000a2d8 <wait_lock>
    80001614:	194040ef          	jal	800057a8 <release>
            return -1;
    80001618:	59fd                	li	s3,-1
    8000161a:	bfd1                	j	800015ee <wait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000161c:	16848493          	addi	s1,s1,360
    80001620:	03348063          	beq	s1,s3,80001640 <wait+0xc6>
      if(pp->parent == p){
    80001624:	7c9c                	ld	a5,56(s1)
    80001626:	ff279be3          	bne	a5,s2,8000161c <wait+0xa2>
        acquire(&pp->lock);
    8000162a:	8526                	mv	a0,s1
    8000162c:	0e8040ef          	jal	80005714 <acquire>
        if(pp->state == ZOMBIE){
    80001630:	4c9c                	lw	a5,24(s1)
    80001632:	f94784e3          	beq	a5,s4,800015ba <wait+0x40>
        release(&pp->lock);
    80001636:	8526                	mv	a0,s1
    80001638:	170040ef          	jal	800057a8 <release>
        havekids = 1;
    8000163c:	8756                	mv	a4,s5
    8000163e:	bff9                	j	8000161c <wait+0xa2>
    if(!havekids || killed(p)){
    80001640:	cf19                	beqz	a4,8000165e <wait+0xe4>
    80001642:	854a                	mv	a0,s2
    80001644:	f0dff0ef          	jal	80001550 <killed>
    80001648:	e919                	bnez	a0,8000165e <wait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000164a:	85de                	mv	a1,s7
    8000164c:	854a                	mv	a0,s2
    8000164e:	ccbff0ef          	jal	80001318 <sleep>
    havekids = 0;
    80001652:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001654:	00009497          	auipc	s1,0x9
    80001658:	09c48493          	addi	s1,s1,156 # 8000a6f0 <proc>
    8000165c:	b7e1                	j	80001624 <wait+0xaa>
      release(&wait_lock);
    8000165e:	00009517          	auipc	a0,0x9
    80001662:	c7a50513          	addi	a0,a0,-902 # 8000a2d8 <wait_lock>
    80001666:	142040ef          	jal	800057a8 <release>
      return -1;
    8000166a:	59fd                	li	s3,-1
    8000166c:	b749                	j	800015ee <wait+0x74>

000000008000166e <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000166e:	7179                	addi	sp,sp,-48
    80001670:	f406                	sd	ra,40(sp)
    80001672:	f022                	sd	s0,32(sp)
    80001674:	ec26                	sd	s1,24(sp)
    80001676:	e84a                	sd	s2,16(sp)
    80001678:	e44e                	sd	s3,8(sp)
    8000167a:	e052                	sd	s4,0(sp)
    8000167c:	1800                	addi	s0,sp,48
    8000167e:	84aa                	mv	s1,a0
    80001680:	892e                	mv	s2,a1
    80001682:	89b2                	mv	s3,a2
    80001684:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001686:	ec4ff0ef          	jal	80000d4a <myproc>
  if(user_dst){
    8000168a:	cc99                	beqz	s1,800016a8 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    8000168c:	86d2                	mv	a3,s4
    8000168e:	864e                	mv	a2,s3
    80001690:	85ca                	mv	a1,s2
    80001692:	6928                	ld	a0,80(a0)
    80001694:	b5eff0ef          	jal	800009f2 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001698:	70a2                	ld	ra,40(sp)
    8000169a:	7402                	ld	s0,32(sp)
    8000169c:	64e2                	ld	s1,24(sp)
    8000169e:	6942                	ld	s2,16(sp)
    800016a0:	69a2                	ld	s3,8(sp)
    800016a2:	6a02                	ld	s4,0(sp)
    800016a4:	6145                	addi	sp,sp,48
    800016a6:	8082                	ret
    memmove((char *)dst, src, len);
    800016a8:	000a061b          	sext.w	a2,s4
    800016ac:	85ce                	mv	a1,s3
    800016ae:	854a                	mv	a0,s2
    800016b0:	ae9fe0ef          	jal	80000198 <memmove>
    return 0;
    800016b4:	8526                	mv	a0,s1
    800016b6:	b7cd                	j	80001698 <either_copyout+0x2a>

00000000800016b8 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800016b8:	7179                	addi	sp,sp,-48
    800016ba:	f406                	sd	ra,40(sp)
    800016bc:	f022                	sd	s0,32(sp)
    800016be:	ec26                	sd	s1,24(sp)
    800016c0:	e84a                	sd	s2,16(sp)
    800016c2:	e44e                	sd	s3,8(sp)
    800016c4:	e052                	sd	s4,0(sp)
    800016c6:	1800                	addi	s0,sp,48
    800016c8:	892a                	mv	s2,a0
    800016ca:	84ae                	mv	s1,a1
    800016cc:	89b2                	mv	s3,a2
    800016ce:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016d0:	e7aff0ef          	jal	80000d4a <myproc>
  if(user_src){
    800016d4:	cc99                	beqz	s1,800016f2 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800016d6:	86d2                	mv	a3,s4
    800016d8:	864e                	mv	a2,s3
    800016da:	85ca                	mv	a1,s2
    800016dc:	6928                	ld	a0,80(a0)
    800016de:	bc4ff0ef          	jal	80000aa2 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800016e2:	70a2                	ld	ra,40(sp)
    800016e4:	7402                	ld	s0,32(sp)
    800016e6:	64e2                	ld	s1,24(sp)
    800016e8:	6942                	ld	s2,16(sp)
    800016ea:	69a2                	ld	s3,8(sp)
    800016ec:	6a02                	ld	s4,0(sp)
    800016ee:	6145                	addi	sp,sp,48
    800016f0:	8082                	ret
    memmove(dst, (char*)src, len);
    800016f2:	000a061b          	sext.w	a2,s4
    800016f6:	85ce                	mv	a1,s3
    800016f8:	854a                	mv	a0,s2
    800016fa:	a9ffe0ef          	jal	80000198 <memmove>
    return 0;
    800016fe:	8526                	mv	a0,s1
    80001700:	b7cd                	j	800016e2 <either_copyin+0x2a>

0000000080001702 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001702:	715d                	addi	sp,sp,-80
    80001704:	e486                	sd	ra,72(sp)
    80001706:	e0a2                	sd	s0,64(sp)
    80001708:	fc26                	sd	s1,56(sp)
    8000170a:	f84a                	sd	s2,48(sp)
    8000170c:	f44e                	sd	s3,40(sp)
    8000170e:	f052                	sd	s4,32(sp)
    80001710:	ec56                	sd	s5,24(sp)
    80001712:	e85a                	sd	s6,16(sp)
    80001714:	e45e                	sd	s7,8(sp)
    80001716:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001718:	00006517          	auipc	a0,0x6
    8000171c:	90050513          	addi	a0,a0,-1792 # 80007018 <etext+0x18>
    80001720:	1f7030ef          	jal	80005116 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001724:	00009497          	auipc	s1,0x9
    80001728:	12448493          	addi	s1,s1,292 # 8000a848 <proc+0x158>
    8000172c:	0000f917          	auipc	s2,0xf
    80001730:	b1c90913          	addi	s2,s2,-1252 # 80010248 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001734:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001736:	00006997          	auipc	s3,0x6
    8000173a:	b1a98993          	addi	s3,s3,-1254 # 80007250 <etext+0x250>
    printf("%d %s %s", p->pid, state, p->name);
    8000173e:	00006a97          	auipc	s5,0x6
    80001742:	b1aa8a93          	addi	s5,s5,-1254 # 80007258 <etext+0x258>
    printf("\n");
    80001746:	00006a17          	auipc	s4,0x6
    8000174a:	8d2a0a13          	addi	s4,s4,-1838 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000174e:	00006b97          	auipc	s7,0x6
    80001752:	032b8b93          	addi	s7,s7,50 # 80007780 <states.0>
    80001756:	a829                	j	80001770 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001758:	ed86a583          	lw	a1,-296(a3)
    8000175c:	8556                	mv	a0,s5
    8000175e:	1b9030ef          	jal	80005116 <printf>
    printf("\n");
    80001762:	8552                	mv	a0,s4
    80001764:	1b3030ef          	jal	80005116 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001768:	16848493          	addi	s1,s1,360
    8000176c:	03248263          	beq	s1,s2,80001790 <procdump+0x8e>
    if(p->state == UNUSED)
    80001770:	86a6                	mv	a3,s1
    80001772:	ec04a783          	lw	a5,-320(s1)
    80001776:	dbed                	beqz	a5,80001768 <procdump+0x66>
      state = "???";
    80001778:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000177a:	fcfb6fe3          	bltu	s6,a5,80001758 <procdump+0x56>
    8000177e:	02079713          	slli	a4,a5,0x20
    80001782:	01d75793          	srli	a5,a4,0x1d
    80001786:	97de                	add	a5,a5,s7
    80001788:	6390                	ld	a2,0(a5)
    8000178a:	f679                	bnez	a2,80001758 <procdump+0x56>
      state = "???";
    8000178c:	864e                	mv	a2,s3
    8000178e:	b7e9                	j	80001758 <procdump+0x56>
  }
}
    80001790:	60a6                	ld	ra,72(sp)
    80001792:	6406                	ld	s0,64(sp)
    80001794:	74e2                	ld	s1,56(sp)
    80001796:	7942                	ld	s2,48(sp)
    80001798:	79a2                	ld	s3,40(sp)
    8000179a:	7a02                	ld	s4,32(sp)
    8000179c:	6ae2                	ld	s5,24(sp)
    8000179e:	6b42                	ld	s6,16(sp)
    800017a0:	6ba2                	ld	s7,8(sp)
    800017a2:	6161                	addi	sp,sp,80
    800017a4:	8082                	ret

00000000800017a6 <swtch>:
    800017a6:	00153023          	sd	ra,0(a0)
    800017aa:	00253423          	sd	sp,8(a0)
    800017ae:	e900                	sd	s0,16(a0)
    800017b0:	ed04                	sd	s1,24(a0)
    800017b2:	03253023          	sd	s2,32(a0)
    800017b6:	03353423          	sd	s3,40(a0)
    800017ba:	03453823          	sd	s4,48(a0)
    800017be:	03553c23          	sd	s5,56(a0)
    800017c2:	05653023          	sd	s6,64(a0)
    800017c6:	05753423          	sd	s7,72(a0)
    800017ca:	05853823          	sd	s8,80(a0)
    800017ce:	05953c23          	sd	s9,88(a0)
    800017d2:	07a53023          	sd	s10,96(a0)
    800017d6:	07b53423          	sd	s11,104(a0)
    800017da:	0005b083          	ld	ra,0(a1)
    800017de:	0085b103          	ld	sp,8(a1)
    800017e2:	6980                	ld	s0,16(a1)
    800017e4:	6d84                	ld	s1,24(a1)
    800017e6:	0205b903          	ld	s2,32(a1)
    800017ea:	0285b983          	ld	s3,40(a1)
    800017ee:	0305ba03          	ld	s4,48(a1)
    800017f2:	0385ba83          	ld	s5,56(a1)
    800017f6:	0405bb03          	ld	s6,64(a1)
    800017fa:	0485bb83          	ld	s7,72(a1)
    800017fe:	0505bc03          	ld	s8,80(a1)
    80001802:	0585bc83          	ld	s9,88(a1)
    80001806:	0605bd03          	ld	s10,96(a1)
    8000180a:	0685bd83          	ld	s11,104(a1)
    8000180e:	8082                	ret

0000000080001810 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001810:	1141                	addi	sp,sp,-16
    80001812:	e406                	sd	ra,8(sp)
    80001814:	e022                	sd	s0,0(sp)
    80001816:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001818:	00006597          	auipc	a1,0x6
    8000181c:	a8058593          	addi	a1,a1,-1408 # 80007298 <etext+0x298>
    80001820:	0000f517          	auipc	a0,0xf
    80001824:	8d050513          	addi	a0,a0,-1840 # 800100f0 <tickslock>
    80001828:	669030ef          	jal	80005690 <initlock>
}
    8000182c:	60a2                	ld	ra,8(sp)
    8000182e:	6402                	ld	s0,0(sp)
    80001830:	0141                	addi	sp,sp,16
    80001832:	8082                	ret

0000000080001834 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001834:	1141                	addi	sp,sp,-16
    80001836:	e406                	sd	ra,8(sp)
    80001838:	e022                	sd	s0,0(sp)
    8000183a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000183c:	00003797          	auipc	a5,0x3
    80001840:	e4478793          	addi	a5,a5,-444 # 80004680 <kernelvec>
    80001844:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001848:	60a2                	ld	ra,8(sp)
    8000184a:	6402                	ld	s0,0(sp)
    8000184c:	0141                	addi	sp,sp,16
    8000184e:	8082                	ret

0000000080001850 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001850:	1141                	addi	sp,sp,-16
    80001852:	e406                	sd	ra,8(sp)
    80001854:	e022                	sd	s0,0(sp)
    80001856:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001858:	cf2ff0ef          	jal	80000d4a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000185c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001860:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001862:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001866:	00004697          	auipc	a3,0x4
    8000186a:	79a68693          	addi	a3,a3,1946 # 80006000 <_trampoline>
    8000186e:	00004717          	auipc	a4,0x4
    80001872:	79270713          	addi	a4,a4,1938 # 80006000 <_trampoline>
    80001876:	8f15                	sub	a4,a4,a3
    80001878:	040007b7          	lui	a5,0x4000
    8000187c:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000187e:	07b2                	slli	a5,a5,0xc
    80001880:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001882:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001886:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001888:	18002673          	csrr	a2,satp
    8000188c:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000188e:	6d30                	ld	a2,88(a0)
    80001890:	6138                	ld	a4,64(a0)
    80001892:	6585                	lui	a1,0x1
    80001894:	972e                	add	a4,a4,a1
    80001896:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001898:	6d38                	ld	a4,88(a0)
    8000189a:	00000617          	auipc	a2,0x0
    8000189e:	11060613          	addi	a2,a2,272 # 800019aa <usertrap>
    800018a2:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800018a4:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800018a6:	8612                	mv	a2,tp
    800018a8:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018aa:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800018ae:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800018b2:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018b6:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800018ba:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800018bc:	6f18                	ld	a4,24(a4)
    800018be:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800018c2:	6928                	ld	a0,80(a0)
    800018c4:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800018c6:	00004717          	auipc	a4,0x4
    800018ca:	7d670713          	addi	a4,a4,2006 # 8000609c <userret>
    800018ce:	8f15                	sub	a4,a4,a3
    800018d0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800018d2:	577d                	li	a4,-1
    800018d4:	177e                	slli	a4,a4,0x3f
    800018d6:	8d59                	or	a0,a0,a4
    800018d8:	9782                	jalr	a5
}
    800018da:	60a2                	ld	ra,8(sp)
    800018dc:	6402                	ld	s0,0(sp)
    800018de:	0141                	addi	sp,sp,16
    800018e0:	8082                	ret

00000000800018e2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800018e2:	1101                	addi	sp,sp,-32
    800018e4:	ec06                	sd	ra,24(sp)
    800018e6:	e822                	sd	s0,16(sp)
    800018e8:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800018ea:	c2cff0ef          	jal	80000d16 <cpuid>
    800018ee:	cd11                	beqz	a0,8000190a <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800018f0:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800018f4:	000f4737          	lui	a4,0xf4
    800018f8:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800018fc:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800018fe:	14d79073          	csrw	stimecmp,a5
}
    80001902:	60e2                	ld	ra,24(sp)
    80001904:	6442                	ld	s0,16(sp)
    80001906:	6105                	addi	sp,sp,32
    80001908:	8082                	ret
    8000190a:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    8000190c:	0000e497          	auipc	s1,0xe
    80001910:	7e448493          	addi	s1,s1,2020 # 800100f0 <tickslock>
    80001914:	8526                	mv	a0,s1
    80001916:	5ff030ef          	jal	80005714 <acquire>
    ticks++;
    8000191a:	00009517          	auipc	a0,0x9
    8000191e:	96e50513          	addi	a0,a0,-1682 # 8000a288 <ticks>
    80001922:	411c                	lw	a5,0(a0)
    80001924:	2785                	addiw	a5,a5,1
    80001926:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001928:	a3dff0ef          	jal	80001364 <wakeup>
    release(&tickslock);
    8000192c:	8526                	mv	a0,s1
    8000192e:	67b030ef          	jal	800057a8 <release>
    80001932:	64a2                	ld	s1,8(sp)
    80001934:	bf75                	j	800018f0 <clockintr+0xe>

0000000080001936 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001936:	1101                	addi	sp,sp,-32
    80001938:	ec06                	sd	ra,24(sp)
    8000193a:	e822                	sd	s0,16(sp)
    8000193c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000193e:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001942:	57fd                	li	a5,-1
    80001944:	17fe                	slli	a5,a5,0x3f
    80001946:	07a5                	addi	a5,a5,9
    80001948:	00f70c63          	beq	a4,a5,80001960 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000194c:	57fd                	li	a5,-1
    8000194e:	17fe                	slli	a5,a5,0x3f
    80001950:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001952:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001954:	04f70763          	beq	a4,a5,800019a2 <devintr+0x6c>
  }
}
    80001958:	60e2                	ld	ra,24(sp)
    8000195a:	6442                	ld	s0,16(sp)
    8000195c:	6105                	addi	sp,sp,32
    8000195e:	8082                	ret
    80001960:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001962:	5cb020ef          	jal	8000472c <plic_claim>
    80001966:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001968:	47a9                	li	a5,10
    8000196a:	00f50963          	beq	a0,a5,8000197c <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    8000196e:	4785                	li	a5,1
    80001970:	00f50963          	beq	a0,a5,80001982 <devintr+0x4c>
    return 1;
    80001974:	4505                	li	a0,1
    } else if(irq){
    80001976:	e889                	bnez	s1,80001988 <devintr+0x52>
    80001978:	64a2                	ld	s1,8(sp)
    8000197a:	bff9                	j	80001958 <devintr+0x22>
      uartintr();
    8000197c:	4d9030ef          	jal	80005654 <uartintr>
    if(irq)
    80001980:	a819                	j	80001996 <devintr+0x60>
      virtio_disk_intr();
    80001982:	23a030ef          	jal	80004bbc <virtio_disk_intr>
    if(irq)
    80001986:	a801                	j	80001996 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80001988:	85a6                	mv	a1,s1
    8000198a:	00006517          	auipc	a0,0x6
    8000198e:	91650513          	addi	a0,a0,-1770 # 800072a0 <etext+0x2a0>
    80001992:	784030ef          	jal	80005116 <printf>
      plic_complete(irq);
    80001996:	8526                	mv	a0,s1
    80001998:	5b5020ef          	jal	8000474c <plic_complete>
    return 1;
    8000199c:	4505                	li	a0,1
    8000199e:	64a2                	ld	s1,8(sp)
    800019a0:	bf65                	j	80001958 <devintr+0x22>
    clockintr();
    800019a2:	f41ff0ef          	jal	800018e2 <clockintr>
    return 2;
    800019a6:	4509                	li	a0,2
    800019a8:	bf45                	j	80001958 <devintr+0x22>

00000000800019aa <usertrap>:
{
    800019aa:	1101                	addi	sp,sp,-32
    800019ac:	ec06                	sd	ra,24(sp)
    800019ae:	e822                	sd	s0,16(sp)
    800019b0:	e426                	sd	s1,8(sp)
    800019b2:	e04a                	sd	s2,0(sp)
    800019b4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019b6:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800019ba:	1007f793          	andi	a5,a5,256
    800019be:	ef85                	bnez	a5,800019f6 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800019c0:	00003797          	auipc	a5,0x3
    800019c4:	cc078793          	addi	a5,a5,-832 # 80004680 <kernelvec>
    800019c8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800019cc:	b7eff0ef          	jal	80000d4a <myproc>
    800019d0:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800019d2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800019d4:	14102773          	csrr	a4,sepc
    800019d8:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019da:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800019de:	47a1                	li	a5,8
    800019e0:	02f70163          	beq	a4,a5,80001a02 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800019e4:	f53ff0ef          	jal	80001936 <devintr>
    800019e8:	892a                	mv	s2,a0
    800019ea:	c135                	beqz	a0,80001a4e <usertrap+0xa4>
  if(killed(p))
    800019ec:	8526                	mv	a0,s1
    800019ee:	b63ff0ef          	jal	80001550 <killed>
    800019f2:	cd1d                	beqz	a0,80001a30 <usertrap+0x86>
    800019f4:	a81d                	j	80001a2a <usertrap+0x80>
    panic("usertrap: not from user mode");
    800019f6:	00006517          	auipc	a0,0x6
    800019fa:	8ca50513          	addi	a0,a0,-1846 # 800072c0 <etext+0x2c0>
    800019fe:	1e9030ef          	jal	800053e6 <panic>
    if(killed(p))
    80001a02:	b4fff0ef          	jal	80001550 <killed>
    80001a06:	e121                	bnez	a0,80001a46 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001a08:	6cb8                	ld	a4,88(s1)
    80001a0a:	6f1c                	ld	a5,24(a4)
    80001a0c:	0791                	addi	a5,a5,4
    80001a0e:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a10:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001a14:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a18:	10079073          	csrw	sstatus,a5
    syscall();
    80001a1c:	240000ef          	jal	80001c5c <syscall>
  if(killed(p))
    80001a20:	8526                	mv	a0,s1
    80001a22:	b2fff0ef          	jal	80001550 <killed>
    80001a26:	c901                	beqz	a0,80001a36 <usertrap+0x8c>
    80001a28:	4901                	li	s2,0
    exit(-1);
    80001a2a:	557d                	li	a0,-1
    80001a2c:	9f9ff0ef          	jal	80001424 <exit>
  if(which_dev == 2)
    80001a30:	4789                	li	a5,2
    80001a32:	04f90563          	beq	s2,a5,80001a7c <usertrap+0xd2>
  usertrapret();
    80001a36:	e1bff0ef          	jal	80001850 <usertrapret>
}
    80001a3a:	60e2                	ld	ra,24(sp)
    80001a3c:	6442                	ld	s0,16(sp)
    80001a3e:	64a2                	ld	s1,8(sp)
    80001a40:	6902                	ld	s2,0(sp)
    80001a42:	6105                	addi	sp,sp,32
    80001a44:	8082                	ret
      exit(-1);
    80001a46:	557d                	li	a0,-1
    80001a48:	9ddff0ef          	jal	80001424 <exit>
    80001a4c:	bf75                	j	80001a08 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a4e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a52:	5890                	lw	a2,48(s1)
    80001a54:	00006517          	auipc	a0,0x6
    80001a58:	88c50513          	addi	a0,a0,-1908 # 800072e0 <etext+0x2e0>
    80001a5c:	6ba030ef          	jal	80005116 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a60:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a64:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a68:	00006517          	auipc	a0,0x6
    80001a6c:	8a850513          	addi	a0,a0,-1880 # 80007310 <etext+0x310>
    80001a70:	6a6030ef          	jal	80005116 <printf>
    setkilled(p);
    80001a74:	8526                	mv	a0,s1
    80001a76:	ab7ff0ef          	jal	8000152c <setkilled>
    80001a7a:	b75d                	j	80001a20 <usertrap+0x76>
    yield();
    80001a7c:	871ff0ef          	jal	800012ec <yield>
    80001a80:	bf5d                	j	80001a36 <usertrap+0x8c>

0000000080001a82 <kerneltrap>:
{
    80001a82:	7179                	addi	sp,sp,-48
    80001a84:	f406                	sd	ra,40(sp)
    80001a86:	f022                	sd	s0,32(sp)
    80001a88:	ec26                	sd	s1,24(sp)
    80001a8a:	e84a                	sd	s2,16(sp)
    80001a8c:	e44e                	sd	s3,8(sp)
    80001a8e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a90:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a94:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a98:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001a9c:	1004f793          	andi	a5,s1,256
    80001aa0:	c795                	beqz	a5,80001acc <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aa2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001aa6:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001aa8:	eb85                	bnez	a5,80001ad8 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001aaa:	e8dff0ef          	jal	80001936 <devintr>
    80001aae:	c91d                	beqz	a0,80001ae4 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001ab0:	4789                	li	a5,2
    80001ab2:	04f50a63          	beq	a0,a5,80001b06 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ab6:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001aba:	10049073          	csrw	sstatus,s1
}
    80001abe:	70a2                	ld	ra,40(sp)
    80001ac0:	7402                	ld	s0,32(sp)
    80001ac2:	64e2                	ld	s1,24(sp)
    80001ac4:	6942                	ld	s2,16(sp)
    80001ac6:	69a2                	ld	s3,8(sp)
    80001ac8:	6145                	addi	sp,sp,48
    80001aca:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001acc:	00006517          	auipc	a0,0x6
    80001ad0:	86c50513          	addi	a0,a0,-1940 # 80007338 <etext+0x338>
    80001ad4:	113030ef          	jal	800053e6 <panic>
    panic("kerneltrap: interrupts enabled");
    80001ad8:	00006517          	auipc	a0,0x6
    80001adc:	88850513          	addi	a0,a0,-1912 # 80007360 <etext+0x360>
    80001ae0:	107030ef          	jal	800053e6 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ae4:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ae8:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001aec:	85ce                	mv	a1,s3
    80001aee:	00006517          	auipc	a0,0x6
    80001af2:	89250513          	addi	a0,a0,-1902 # 80007380 <etext+0x380>
    80001af6:	620030ef          	jal	80005116 <printf>
    panic("kerneltrap");
    80001afa:	00006517          	auipc	a0,0x6
    80001afe:	8ae50513          	addi	a0,a0,-1874 # 800073a8 <etext+0x3a8>
    80001b02:	0e5030ef          	jal	800053e6 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001b06:	a44ff0ef          	jal	80000d4a <myproc>
    80001b0a:	d555                	beqz	a0,80001ab6 <kerneltrap+0x34>
    yield();
    80001b0c:	fe0ff0ef          	jal	800012ec <yield>
    80001b10:	b75d                	j	80001ab6 <kerneltrap+0x34>

0000000080001b12 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001b12:	1101                	addi	sp,sp,-32
    80001b14:	ec06                	sd	ra,24(sp)
    80001b16:	e822                	sd	s0,16(sp)
    80001b18:	e426                	sd	s1,8(sp)
    80001b1a:	1000                	addi	s0,sp,32
    80001b1c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b1e:	a2cff0ef          	jal	80000d4a <myproc>
  switch (n) {
    80001b22:	4795                	li	a5,5
    80001b24:	0497e163          	bltu	a5,s1,80001b66 <argraw+0x54>
    80001b28:	048a                	slli	s1,s1,0x2
    80001b2a:	00006717          	auipc	a4,0x6
    80001b2e:	c8670713          	addi	a4,a4,-890 # 800077b0 <states.0+0x30>
    80001b32:	94ba                	add	s1,s1,a4
    80001b34:	409c                	lw	a5,0(s1)
    80001b36:	97ba                	add	a5,a5,a4
    80001b38:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001b3a:	6d3c                	ld	a5,88(a0)
    80001b3c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001b3e:	60e2                	ld	ra,24(sp)
    80001b40:	6442                	ld	s0,16(sp)
    80001b42:	64a2                	ld	s1,8(sp)
    80001b44:	6105                	addi	sp,sp,32
    80001b46:	8082                	ret
    return p->trapframe->a1;
    80001b48:	6d3c                	ld	a5,88(a0)
    80001b4a:	7fa8                	ld	a0,120(a5)
    80001b4c:	bfcd                	j	80001b3e <argraw+0x2c>
    return p->trapframe->a2;
    80001b4e:	6d3c                	ld	a5,88(a0)
    80001b50:	63c8                	ld	a0,128(a5)
    80001b52:	b7f5                	j	80001b3e <argraw+0x2c>
    return p->trapframe->a3;
    80001b54:	6d3c                	ld	a5,88(a0)
    80001b56:	67c8                	ld	a0,136(a5)
    80001b58:	b7dd                	j	80001b3e <argraw+0x2c>
    return p->trapframe->a4;
    80001b5a:	6d3c                	ld	a5,88(a0)
    80001b5c:	6bc8                	ld	a0,144(a5)
    80001b5e:	b7c5                	j	80001b3e <argraw+0x2c>
    return p->trapframe->a5;
    80001b60:	6d3c                	ld	a5,88(a0)
    80001b62:	6fc8                	ld	a0,152(a5)
    80001b64:	bfe9                	j	80001b3e <argraw+0x2c>
  panic("argraw");
    80001b66:	00006517          	auipc	a0,0x6
    80001b6a:	85250513          	addi	a0,a0,-1966 # 800073b8 <etext+0x3b8>
    80001b6e:	079030ef          	jal	800053e6 <panic>

0000000080001b72 <fetchaddr>:
{
    80001b72:	1101                	addi	sp,sp,-32
    80001b74:	ec06                	sd	ra,24(sp)
    80001b76:	e822                	sd	s0,16(sp)
    80001b78:	e426                	sd	s1,8(sp)
    80001b7a:	e04a                	sd	s2,0(sp)
    80001b7c:	1000                	addi	s0,sp,32
    80001b7e:	84aa                	mv	s1,a0
    80001b80:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001b82:	9c8ff0ef          	jal	80000d4a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001b86:	653c                	ld	a5,72(a0)
    80001b88:	02f4f663          	bgeu	s1,a5,80001bb4 <fetchaddr+0x42>
    80001b8c:	00848713          	addi	a4,s1,8
    80001b90:	02e7e463          	bltu	a5,a4,80001bb8 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001b94:	46a1                	li	a3,8
    80001b96:	8626                	mv	a2,s1
    80001b98:	85ca                	mv	a1,s2
    80001b9a:	6928                	ld	a0,80(a0)
    80001b9c:	f07fe0ef          	jal	80000aa2 <copyin>
    80001ba0:	00a03533          	snez	a0,a0
    80001ba4:	40a0053b          	negw	a0,a0
}
    80001ba8:	60e2                	ld	ra,24(sp)
    80001baa:	6442                	ld	s0,16(sp)
    80001bac:	64a2                	ld	s1,8(sp)
    80001bae:	6902                	ld	s2,0(sp)
    80001bb0:	6105                	addi	sp,sp,32
    80001bb2:	8082                	ret
    return -1;
    80001bb4:	557d                	li	a0,-1
    80001bb6:	bfcd                	j	80001ba8 <fetchaddr+0x36>
    80001bb8:	557d                	li	a0,-1
    80001bba:	b7fd                	j	80001ba8 <fetchaddr+0x36>

0000000080001bbc <fetchstr>:
{
    80001bbc:	7179                	addi	sp,sp,-48
    80001bbe:	f406                	sd	ra,40(sp)
    80001bc0:	f022                	sd	s0,32(sp)
    80001bc2:	ec26                	sd	s1,24(sp)
    80001bc4:	e84a                	sd	s2,16(sp)
    80001bc6:	e44e                	sd	s3,8(sp)
    80001bc8:	1800                	addi	s0,sp,48
    80001bca:	892a                	mv	s2,a0
    80001bcc:	84ae                	mv	s1,a1
    80001bce:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001bd0:	97aff0ef          	jal	80000d4a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001bd4:	86ce                	mv	a3,s3
    80001bd6:	864a                	mv	a2,s2
    80001bd8:	85a6                	mv	a1,s1
    80001bda:	6928                	ld	a0,80(a0)
    80001bdc:	f4dfe0ef          	jal	80000b28 <copyinstr>
    80001be0:	00054c63          	bltz	a0,80001bf8 <fetchstr+0x3c>
  return strlen(buf);
    80001be4:	8526                	mv	a0,s1
    80001be6:	ed6fe0ef          	jal	800002bc <strlen>
}
    80001bea:	70a2                	ld	ra,40(sp)
    80001bec:	7402                	ld	s0,32(sp)
    80001bee:	64e2                	ld	s1,24(sp)
    80001bf0:	6942                	ld	s2,16(sp)
    80001bf2:	69a2                	ld	s3,8(sp)
    80001bf4:	6145                	addi	sp,sp,48
    80001bf6:	8082                	ret
    return -1;
    80001bf8:	557d                	li	a0,-1
    80001bfa:	bfc5                	j	80001bea <fetchstr+0x2e>

0000000080001bfc <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001bfc:	1101                	addi	sp,sp,-32
    80001bfe:	ec06                	sd	ra,24(sp)
    80001c00:	e822                	sd	s0,16(sp)
    80001c02:	e426                	sd	s1,8(sp)
    80001c04:	1000                	addi	s0,sp,32
    80001c06:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c08:	f0bff0ef          	jal	80001b12 <argraw>
    80001c0c:	c088                	sw	a0,0(s1)
}
    80001c0e:	60e2                	ld	ra,24(sp)
    80001c10:	6442                	ld	s0,16(sp)
    80001c12:	64a2                	ld	s1,8(sp)
    80001c14:	6105                	addi	sp,sp,32
    80001c16:	8082                	ret

0000000080001c18 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001c18:	1101                	addi	sp,sp,-32
    80001c1a:	ec06                	sd	ra,24(sp)
    80001c1c:	e822                	sd	s0,16(sp)
    80001c1e:	e426                	sd	s1,8(sp)
    80001c20:	1000                	addi	s0,sp,32
    80001c22:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c24:	eefff0ef          	jal	80001b12 <argraw>
    80001c28:	e088                	sd	a0,0(s1)
}
    80001c2a:	60e2                	ld	ra,24(sp)
    80001c2c:	6442                	ld	s0,16(sp)
    80001c2e:	64a2                	ld	s1,8(sp)
    80001c30:	6105                	addi	sp,sp,32
    80001c32:	8082                	ret

0000000080001c34 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001c34:	1101                	addi	sp,sp,-32
    80001c36:	ec06                	sd	ra,24(sp)
    80001c38:	e822                	sd	s0,16(sp)
    80001c3a:	e426                	sd	s1,8(sp)
    80001c3c:	e04a                	sd	s2,0(sp)
    80001c3e:	1000                	addi	s0,sp,32
    80001c40:	84ae                	mv	s1,a1
    80001c42:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001c44:	ecfff0ef          	jal	80001b12 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80001c48:	864a                	mv	a2,s2
    80001c4a:	85a6                	mv	a1,s1
    80001c4c:	f71ff0ef          	jal	80001bbc <fetchstr>
}
    80001c50:	60e2                	ld	ra,24(sp)
    80001c52:	6442                	ld	s0,16(sp)
    80001c54:	64a2                	ld	s1,8(sp)
    80001c56:	6902                	ld	s2,0(sp)
    80001c58:	6105                	addi	sp,sp,32
    80001c5a:	8082                	ret

0000000080001c5c <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001c5c:	1101                	addi	sp,sp,-32
    80001c5e:	ec06                	sd	ra,24(sp)
    80001c60:	e822                	sd	s0,16(sp)
    80001c62:	e426                	sd	s1,8(sp)
    80001c64:	e04a                	sd	s2,0(sp)
    80001c66:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001c68:	8e2ff0ef          	jal	80000d4a <myproc>
    80001c6c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001c6e:	05853903          	ld	s2,88(a0)
    80001c72:	0a893783          	ld	a5,168(s2)
    80001c76:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001c7a:	37fd                	addiw	a5,a5,-1
    80001c7c:	4751                	li	a4,20
    80001c7e:	00f76f63          	bltu	a4,a5,80001c9c <syscall+0x40>
    80001c82:	00369713          	slli	a4,a3,0x3
    80001c86:	00006797          	auipc	a5,0x6
    80001c8a:	b4278793          	addi	a5,a5,-1214 # 800077c8 <syscalls>
    80001c8e:	97ba                	add	a5,a5,a4
    80001c90:	639c                	ld	a5,0(a5)
    80001c92:	c789                	beqz	a5,80001c9c <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001c94:	9782                	jalr	a5
    80001c96:	06a93823          	sd	a0,112(s2)
    80001c9a:	a829                	j	80001cb4 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001c9c:	15848613          	addi	a2,s1,344
    80001ca0:	588c                	lw	a1,48(s1)
    80001ca2:	00005517          	auipc	a0,0x5
    80001ca6:	71e50513          	addi	a0,a0,1822 # 800073c0 <etext+0x3c0>
    80001caa:	46c030ef          	jal	80005116 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001cae:	6cbc                	ld	a5,88(s1)
    80001cb0:	577d                	li	a4,-1
    80001cb2:	fbb8                	sd	a4,112(a5)
  }
}
    80001cb4:	60e2                	ld	ra,24(sp)
    80001cb6:	6442                	ld	s0,16(sp)
    80001cb8:	64a2                	ld	s1,8(sp)
    80001cba:	6902                	ld	s2,0(sp)
    80001cbc:	6105                	addi	sp,sp,32
    80001cbe:	8082                	ret

0000000080001cc0 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001cc0:	1101                	addi	sp,sp,-32
    80001cc2:	ec06                	sd	ra,24(sp)
    80001cc4:	e822                	sd	s0,16(sp)
    80001cc6:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001cc8:	fec40593          	addi	a1,s0,-20
    80001ccc:	4501                	li	a0,0
    80001cce:	f2fff0ef          	jal	80001bfc <argint>
  exit(n);
    80001cd2:	fec42503          	lw	a0,-20(s0)
    80001cd6:	f4eff0ef          	jal	80001424 <exit>
  return 0;  // not reached
}
    80001cda:	4501                	li	a0,0
    80001cdc:	60e2                	ld	ra,24(sp)
    80001cde:	6442                	ld	s0,16(sp)
    80001ce0:	6105                	addi	sp,sp,32
    80001ce2:	8082                	ret

0000000080001ce4 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001ce4:	1141                	addi	sp,sp,-16
    80001ce6:	e406                	sd	ra,8(sp)
    80001ce8:	e022                	sd	s0,0(sp)
    80001cea:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001cec:	85eff0ef          	jal	80000d4a <myproc>
}
    80001cf0:	5908                	lw	a0,48(a0)
    80001cf2:	60a2                	ld	ra,8(sp)
    80001cf4:	6402                	ld	s0,0(sp)
    80001cf6:	0141                	addi	sp,sp,16
    80001cf8:	8082                	ret

0000000080001cfa <sys_fork>:

uint64
sys_fork(void)
{
    80001cfa:	1141                	addi	sp,sp,-16
    80001cfc:	e406                	sd	ra,8(sp)
    80001cfe:	e022                	sd	s0,0(sp)
    80001d00:	0800                	addi	s0,sp,16
  return fork();
    80001d02:	b6eff0ef          	jal	80001070 <fork>
}
    80001d06:	60a2                	ld	ra,8(sp)
    80001d08:	6402                	ld	s0,0(sp)
    80001d0a:	0141                	addi	sp,sp,16
    80001d0c:	8082                	ret

0000000080001d0e <sys_wait>:

uint64
sys_wait(void)
{
    80001d0e:	1101                	addi	sp,sp,-32
    80001d10:	ec06                	sd	ra,24(sp)
    80001d12:	e822                	sd	s0,16(sp)
    80001d14:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001d16:	fe840593          	addi	a1,s0,-24
    80001d1a:	4501                	li	a0,0
    80001d1c:	efdff0ef          	jal	80001c18 <argaddr>
  return wait(p);
    80001d20:	fe843503          	ld	a0,-24(s0)
    80001d24:	857ff0ef          	jal	8000157a <wait>
}
    80001d28:	60e2                	ld	ra,24(sp)
    80001d2a:	6442                	ld	s0,16(sp)
    80001d2c:	6105                	addi	sp,sp,32
    80001d2e:	8082                	ret

0000000080001d30 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001d30:	7179                	addi	sp,sp,-48
    80001d32:	f406                	sd	ra,40(sp)
    80001d34:	f022                	sd	s0,32(sp)
    80001d36:	ec26                	sd	s1,24(sp)
    80001d38:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001d3a:	fdc40593          	addi	a1,s0,-36
    80001d3e:	4501                	li	a0,0
    80001d40:	ebdff0ef          	jal	80001bfc <argint>
  addr = myproc()->sz;
    80001d44:	806ff0ef          	jal	80000d4a <myproc>
    80001d48:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001d4a:	fdc42503          	lw	a0,-36(s0)
    80001d4e:	ad2ff0ef          	jal	80001020 <growproc>
    80001d52:	00054863          	bltz	a0,80001d62 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001d56:	8526                	mv	a0,s1
    80001d58:	70a2                	ld	ra,40(sp)
    80001d5a:	7402                	ld	s0,32(sp)
    80001d5c:	64e2                	ld	s1,24(sp)
    80001d5e:	6145                	addi	sp,sp,48
    80001d60:	8082                	ret
    return -1;
    80001d62:	54fd                	li	s1,-1
    80001d64:	bfcd                	j	80001d56 <sys_sbrk+0x26>

0000000080001d66 <sys_sleep>:

uint64
sys_sleep(void)
{
    80001d66:	7139                	addi	sp,sp,-64
    80001d68:	fc06                	sd	ra,56(sp)
    80001d6a:	f822                	sd	s0,48(sp)
    80001d6c:	f04a                	sd	s2,32(sp)
    80001d6e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001d70:	fcc40593          	addi	a1,s0,-52
    80001d74:	4501                	li	a0,0
    80001d76:	e87ff0ef          	jal	80001bfc <argint>
  if(n < 0)
    80001d7a:	fcc42783          	lw	a5,-52(s0)
    80001d7e:	0607c763          	bltz	a5,80001dec <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001d82:	0000e517          	auipc	a0,0xe
    80001d86:	36e50513          	addi	a0,a0,878 # 800100f0 <tickslock>
    80001d8a:	18b030ef          	jal	80005714 <acquire>
  ticks0 = ticks;
    80001d8e:	00008917          	auipc	s2,0x8
    80001d92:	4fa92903          	lw	s2,1274(s2) # 8000a288 <ticks>
  while(ticks - ticks0 < n){
    80001d96:	fcc42783          	lw	a5,-52(s0)
    80001d9a:	cf8d                	beqz	a5,80001dd4 <sys_sleep+0x6e>
    80001d9c:	f426                	sd	s1,40(sp)
    80001d9e:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001da0:	0000e997          	auipc	s3,0xe
    80001da4:	35098993          	addi	s3,s3,848 # 800100f0 <tickslock>
    80001da8:	00008497          	auipc	s1,0x8
    80001dac:	4e048493          	addi	s1,s1,1248 # 8000a288 <ticks>
    if(killed(myproc())){
    80001db0:	f9bfe0ef          	jal	80000d4a <myproc>
    80001db4:	f9cff0ef          	jal	80001550 <killed>
    80001db8:	ed0d                	bnez	a0,80001df2 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001dba:	85ce                	mv	a1,s3
    80001dbc:	8526                	mv	a0,s1
    80001dbe:	d5aff0ef          	jal	80001318 <sleep>
  while(ticks - ticks0 < n){
    80001dc2:	409c                	lw	a5,0(s1)
    80001dc4:	412787bb          	subw	a5,a5,s2
    80001dc8:	fcc42703          	lw	a4,-52(s0)
    80001dcc:	fee7e2e3          	bltu	a5,a4,80001db0 <sys_sleep+0x4a>
    80001dd0:	74a2                	ld	s1,40(sp)
    80001dd2:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001dd4:	0000e517          	auipc	a0,0xe
    80001dd8:	31c50513          	addi	a0,a0,796 # 800100f0 <tickslock>
    80001ddc:	1cd030ef          	jal	800057a8 <release>
  return 0;
    80001de0:	4501                	li	a0,0
}
    80001de2:	70e2                	ld	ra,56(sp)
    80001de4:	7442                	ld	s0,48(sp)
    80001de6:	7902                	ld	s2,32(sp)
    80001de8:	6121                	addi	sp,sp,64
    80001dea:	8082                	ret
    n = 0;
    80001dec:	fc042623          	sw	zero,-52(s0)
    80001df0:	bf49                	j	80001d82 <sys_sleep+0x1c>
      release(&tickslock);
    80001df2:	0000e517          	auipc	a0,0xe
    80001df6:	2fe50513          	addi	a0,a0,766 # 800100f0 <tickslock>
    80001dfa:	1af030ef          	jal	800057a8 <release>
      return -1;
    80001dfe:	557d                	li	a0,-1
    80001e00:	74a2                	ld	s1,40(sp)
    80001e02:	69e2                	ld	s3,24(sp)
    80001e04:	bff9                	j	80001de2 <sys_sleep+0x7c>

0000000080001e06 <sys_kill>:

uint64
sys_kill(void)
{
    80001e06:	1101                	addi	sp,sp,-32
    80001e08:	ec06                	sd	ra,24(sp)
    80001e0a:	e822                	sd	s0,16(sp)
    80001e0c:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001e0e:	fec40593          	addi	a1,s0,-20
    80001e12:	4501                	li	a0,0
    80001e14:	de9ff0ef          	jal	80001bfc <argint>
  return kill(pid);
    80001e18:	fec42503          	lw	a0,-20(s0)
    80001e1c:	eaaff0ef          	jal	800014c6 <kill>
}
    80001e20:	60e2                	ld	ra,24(sp)
    80001e22:	6442                	ld	s0,16(sp)
    80001e24:	6105                	addi	sp,sp,32
    80001e26:	8082                	ret

0000000080001e28 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001e28:	1101                	addi	sp,sp,-32
    80001e2a:	ec06                	sd	ra,24(sp)
    80001e2c:	e822                	sd	s0,16(sp)
    80001e2e:	e426                	sd	s1,8(sp)
    80001e30:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001e32:	0000e517          	auipc	a0,0xe
    80001e36:	2be50513          	addi	a0,a0,702 # 800100f0 <tickslock>
    80001e3a:	0db030ef          	jal	80005714 <acquire>
  xticks = ticks;
    80001e3e:	00008497          	auipc	s1,0x8
    80001e42:	44a4a483          	lw	s1,1098(s1) # 8000a288 <ticks>
  release(&tickslock);
    80001e46:	0000e517          	auipc	a0,0xe
    80001e4a:	2aa50513          	addi	a0,a0,682 # 800100f0 <tickslock>
    80001e4e:	15b030ef          	jal	800057a8 <release>
  return xticks;
}
    80001e52:	02049513          	slli	a0,s1,0x20
    80001e56:	9101                	srli	a0,a0,0x20
    80001e58:	60e2                	ld	ra,24(sp)
    80001e5a:	6442                	ld	s0,16(sp)
    80001e5c:	64a2                	ld	s1,8(sp)
    80001e5e:	6105                	addi	sp,sp,32
    80001e60:	8082                	ret

0000000080001e62 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001e62:	7179                	addi	sp,sp,-48
    80001e64:	f406                	sd	ra,40(sp)
    80001e66:	f022                	sd	s0,32(sp)
    80001e68:	ec26                	sd	s1,24(sp)
    80001e6a:	e84a                	sd	s2,16(sp)
    80001e6c:	e44e                	sd	s3,8(sp)
    80001e6e:	e052                	sd	s4,0(sp)
    80001e70:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001e72:	00005597          	auipc	a1,0x5
    80001e76:	56e58593          	addi	a1,a1,1390 # 800073e0 <etext+0x3e0>
    80001e7a:	0000e517          	auipc	a0,0xe
    80001e7e:	28e50513          	addi	a0,a0,654 # 80010108 <bcache>
    80001e82:	00f030ef          	jal	80005690 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001e86:	00016797          	auipc	a5,0x16
    80001e8a:	28278793          	addi	a5,a5,642 # 80018108 <bcache+0x8000>
    80001e8e:	00016717          	auipc	a4,0x16
    80001e92:	4e270713          	addi	a4,a4,1250 # 80018370 <bcache+0x8268>
    80001e96:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001e9a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001e9e:	0000e497          	auipc	s1,0xe
    80001ea2:	28248493          	addi	s1,s1,642 # 80010120 <bcache+0x18>
    b->next = bcache.head.next;
    80001ea6:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001ea8:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001eaa:	00005a17          	auipc	s4,0x5
    80001eae:	53ea0a13          	addi	s4,s4,1342 # 800073e8 <etext+0x3e8>
    b->next = bcache.head.next;
    80001eb2:	2b893783          	ld	a5,696(s2)
    80001eb6:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001eb8:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001ebc:	85d2                	mv	a1,s4
    80001ebe:	01048513          	addi	a0,s1,16
    80001ec2:	244010ef          	jal	80003106 <initsleeplock>
    bcache.head.next->prev = b;
    80001ec6:	2b893783          	ld	a5,696(s2)
    80001eca:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001ecc:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001ed0:	45848493          	addi	s1,s1,1112
    80001ed4:	fd349fe3          	bne	s1,s3,80001eb2 <binit+0x50>
  }
}
    80001ed8:	70a2                	ld	ra,40(sp)
    80001eda:	7402                	ld	s0,32(sp)
    80001edc:	64e2                	ld	s1,24(sp)
    80001ede:	6942                	ld	s2,16(sp)
    80001ee0:	69a2                	ld	s3,8(sp)
    80001ee2:	6a02                	ld	s4,0(sp)
    80001ee4:	6145                	addi	sp,sp,48
    80001ee6:	8082                	ret

0000000080001ee8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80001ee8:	7179                	addi	sp,sp,-48
    80001eea:	f406                	sd	ra,40(sp)
    80001eec:	f022                	sd	s0,32(sp)
    80001eee:	ec26                	sd	s1,24(sp)
    80001ef0:	e84a                	sd	s2,16(sp)
    80001ef2:	e44e                	sd	s3,8(sp)
    80001ef4:	1800                	addi	s0,sp,48
    80001ef6:	892a                	mv	s2,a0
    80001ef8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80001efa:	0000e517          	auipc	a0,0xe
    80001efe:	20e50513          	addi	a0,a0,526 # 80010108 <bcache>
    80001f02:	013030ef          	jal	80005714 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80001f06:	00016497          	auipc	s1,0x16
    80001f0a:	4ba4b483          	ld	s1,1210(s1) # 800183c0 <bcache+0x82b8>
    80001f0e:	00016797          	auipc	a5,0x16
    80001f12:	46278793          	addi	a5,a5,1122 # 80018370 <bcache+0x8268>
    80001f16:	02f48b63          	beq	s1,a5,80001f4c <bread+0x64>
    80001f1a:	873e                	mv	a4,a5
    80001f1c:	a021                	j	80001f24 <bread+0x3c>
    80001f1e:	68a4                	ld	s1,80(s1)
    80001f20:	02e48663          	beq	s1,a4,80001f4c <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80001f24:	449c                	lw	a5,8(s1)
    80001f26:	ff279ce3          	bne	a5,s2,80001f1e <bread+0x36>
    80001f2a:	44dc                	lw	a5,12(s1)
    80001f2c:	ff3799e3          	bne	a5,s3,80001f1e <bread+0x36>
      b->refcnt++;
    80001f30:	40bc                	lw	a5,64(s1)
    80001f32:	2785                	addiw	a5,a5,1
    80001f34:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001f36:	0000e517          	auipc	a0,0xe
    80001f3a:	1d250513          	addi	a0,a0,466 # 80010108 <bcache>
    80001f3e:	06b030ef          	jal	800057a8 <release>
      acquiresleep(&b->lock);
    80001f42:	01048513          	addi	a0,s1,16
    80001f46:	1f6010ef          	jal	8000313c <acquiresleep>
      return b;
    80001f4a:	a889                	j	80001f9c <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001f4c:	00016497          	auipc	s1,0x16
    80001f50:	46c4b483          	ld	s1,1132(s1) # 800183b8 <bcache+0x82b0>
    80001f54:	00016797          	auipc	a5,0x16
    80001f58:	41c78793          	addi	a5,a5,1052 # 80018370 <bcache+0x8268>
    80001f5c:	00f48863          	beq	s1,a5,80001f6c <bread+0x84>
    80001f60:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80001f62:	40bc                	lw	a5,64(s1)
    80001f64:	cb91                	beqz	a5,80001f78 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001f66:	64a4                	ld	s1,72(s1)
    80001f68:	fee49de3          	bne	s1,a4,80001f62 <bread+0x7a>
  panic("bget: no buffers");
    80001f6c:	00005517          	auipc	a0,0x5
    80001f70:	48450513          	addi	a0,a0,1156 # 800073f0 <etext+0x3f0>
    80001f74:	472030ef          	jal	800053e6 <panic>
      b->dev = dev;
    80001f78:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80001f7c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80001f80:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80001f84:	4785                	li	a5,1
    80001f86:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001f88:	0000e517          	auipc	a0,0xe
    80001f8c:	18050513          	addi	a0,a0,384 # 80010108 <bcache>
    80001f90:	019030ef          	jal	800057a8 <release>
      acquiresleep(&b->lock);
    80001f94:	01048513          	addi	a0,s1,16
    80001f98:	1a4010ef          	jal	8000313c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80001f9c:	409c                	lw	a5,0(s1)
    80001f9e:	cb89                	beqz	a5,80001fb0 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80001fa0:	8526                	mv	a0,s1
    80001fa2:	70a2                	ld	ra,40(sp)
    80001fa4:	7402                	ld	s0,32(sp)
    80001fa6:	64e2                	ld	s1,24(sp)
    80001fa8:	6942                	ld	s2,16(sp)
    80001faa:	69a2                	ld	s3,8(sp)
    80001fac:	6145                	addi	sp,sp,48
    80001fae:	8082                	ret
    virtio_disk_rw(b, 0);
    80001fb0:	4581                	li	a1,0
    80001fb2:	8526                	mv	a0,s1
    80001fb4:	1fd020ef          	jal	800049b0 <virtio_disk_rw>
    b->valid = 1;
    80001fb8:	4785                	li	a5,1
    80001fba:	c09c                	sw	a5,0(s1)
  return b;
    80001fbc:	b7d5                	j	80001fa0 <bread+0xb8>

0000000080001fbe <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80001fbe:	1101                	addi	sp,sp,-32
    80001fc0:	ec06                	sd	ra,24(sp)
    80001fc2:	e822                	sd	s0,16(sp)
    80001fc4:	e426                	sd	s1,8(sp)
    80001fc6:	1000                	addi	s0,sp,32
    80001fc8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80001fca:	0541                	addi	a0,a0,16
    80001fcc:	1ee010ef          	jal	800031ba <holdingsleep>
    80001fd0:	c911                	beqz	a0,80001fe4 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80001fd2:	4585                	li	a1,1
    80001fd4:	8526                	mv	a0,s1
    80001fd6:	1db020ef          	jal	800049b0 <virtio_disk_rw>
}
    80001fda:	60e2                	ld	ra,24(sp)
    80001fdc:	6442                	ld	s0,16(sp)
    80001fde:	64a2                	ld	s1,8(sp)
    80001fe0:	6105                	addi	sp,sp,32
    80001fe2:	8082                	ret
    panic("bwrite");
    80001fe4:	00005517          	auipc	a0,0x5
    80001fe8:	42450513          	addi	a0,a0,1060 # 80007408 <etext+0x408>
    80001fec:	3fa030ef          	jal	800053e6 <panic>

0000000080001ff0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80001ff0:	1101                	addi	sp,sp,-32
    80001ff2:	ec06                	sd	ra,24(sp)
    80001ff4:	e822                	sd	s0,16(sp)
    80001ff6:	e426                	sd	s1,8(sp)
    80001ff8:	e04a                	sd	s2,0(sp)
    80001ffa:	1000                	addi	s0,sp,32
    80001ffc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80001ffe:	01050913          	addi	s2,a0,16
    80002002:	854a                	mv	a0,s2
    80002004:	1b6010ef          	jal	800031ba <holdingsleep>
    80002008:	c125                	beqz	a0,80002068 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    8000200a:	854a                	mv	a0,s2
    8000200c:	176010ef          	jal	80003182 <releasesleep>

  acquire(&bcache.lock);
    80002010:	0000e517          	auipc	a0,0xe
    80002014:	0f850513          	addi	a0,a0,248 # 80010108 <bcache>
    80002018:	6fc030ef          	jal	80005714 <acquire>
  b->refcnt--;
    8000201c:	40bc                	lw	a5,64(s1)
    8000201e:	37fd                	addiw	a5,a5,-1
    80002020:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002022:	e79d                	bnez	a5,80002050 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002024:	68b8                	ld	a4,80(s1)
    80002026:	64bc                	ld	a5,72(s1)
    80002028:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000202a:	68b8                	ld	a4,80(s1)
    8000202c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000202e:	00016797          	auipc	a5,0x16
    80002032:	0da78793          	addi	a5,a5,218 # 80018108 <bcache+0x8000>
    80002036:	2b87b703          	ld	a4,696(a5)
    8000203a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000203c:	00016717          	auipc	a4,0x16
    80002040:	33470713          	addi	a4,a4,820 # 80018370 <bcache+0x8268>
    80002044:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002046:	2b87b703          	ld	a4,696(a5)
    8000204a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000204c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002050:	0000e517          	auipc	a0,0xe
    80002054:	0b850513          	addi	a0,a0,184 # 80010108 <bcache>
    80002058:	750030ef          	jal	800057a8 <release>
}
    8000205c:	60e2                	ld	ra,24(sp)
    8000205e:	6442                	ld	s0,16(sp)
    80002060:	64a2                	ld	s1,8(sp)
    80002062:	6902                	ld	s2,0(sp)
    80002064:	6105                	addi	sp,sp,32
    80002066:	8082                	ret
    panic("brelse");
    80002068:	00005517          	auipc	a0,0x5
    8000206c:	3a850513          	addi	a0,a0,936 # 80007410 <etext+0x410>
    80002070:	376030ef          	jal	800053e6 <panic>

0000000080002074 <bpin>:

void
bpin(struct buf *b) {
    80002074:	1101                	addi	sp,sp,-32
    80002076:	ec06                	sd	ra,24(sp)
    80002078:	e822                	sd	s0,16(sp)
    8000207a:	e426                	sd	s1,8(sp)
    8000207c:	1000                	addi	s0,sp,32
    8000207e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002080:	0000e517          	auipc	a0,0xe
    80002084:	08850513          	addi	a0,a0,136 # 80010108 <bcache>
    80002088:	68c030ef          	jal	80005714 <acquire>
  b->refcnt++;
    8000208c:	40bc                	lw	a5,64(s1)
    8000208e:	2785                	addiw	a5,a5,1
    80002090:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002092:	0000e517          	auipc	a0,0xe
    80002096:	07650513          	addi	a0,a0,118 # 80010108 <bcache>
    8000209a:	70e030ef          	jal	800057a8 <release>
}
    8000209e:	60e2                	ld	ra,24(sp)
    800020a0:	6442                	ld	s0,16(sp)
    800020a2:	64a2                	ld	s1,8(sp)
    800020a4:	6105                	addi	sp,sp,32
    800020a6:	8082                	ret

00000000800020a8 <bunpin>:

void
bunpin(struct buf *b) {
    800020a8:	1101                	addi	sp,sp,-32
    800020aa:	ec06                	sd	ra,24(sp)
    800020ac:	e822                	sd	s0,16(sp)
    800020ae:	e426                	sd	s1,8(sp)
    800020b0:	1000                	addi	s0,sp,32
    800020b2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800020b4:	0000e517          	auipc	a0,0xe
    800020b8:	05450513          	addi	a0,a0,84 # 80010108 <bcache>
    800020bc:	658030ef          	jal	80005714 <acquire>
  b->refcnt--;
    800020c0:	40bc                	lw	a5,64(s1)
    800020c2:	37fd                	addiw	a5,a5,-1
    800020c4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800020c6:	0000e517          	auipc	a0,0xe
    800020ca:	04250513          	addi	a0,a0,66 # 80010108 <bcache>
    800020ce:	6da030ef          	jal	800057a8 <release>
}
    800020d2:	60e2                	ld	ra,24(sp)
    800020d4:	6442                	ld	s0,16(sp)
    800020d6:	64a2                	ld	s1,8(sp)
    800020d8:	6105                	addi	sp,sp,32
    800020da:	8082                	ret

00000000800020dc <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800020dc:	1101                	addi	sp,sp,-32
    800020de:	ec06                	sd	ra,24(sp)
    800020e0:	e822                	sd	s0,16(sp)
    800020e2:	e426                	sd	s1,8(sp)
    800020e4:	e04a                	sd	s2,0(sp)
    800020e6:	1000                	addi	s0,sp,32
    800020e8:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800020ea:	00d5d79b          	srliw	a5,a1,0xd
    800020ee:	00016597          	auipc	a1,0x16
    800020f2:	6f65a583          	lw	a1,1782(a1) # 800187e4 <sb+0x1c>
    800020f6:	9dbd                	addw	a1,a1,a5
    800020f8:	df1ff0ef          	jal	80001ee8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800020fc:	0074f713          	andi	a4,s1,7
    80002100:	4785                	li	a5,1
    80002102:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002106:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002108:	90d9                	srli	s1,s1,0x36
    8000210a:	00950733          	add	a4,a0,s1
    8000210e:	05874703          	lbu	a4,88(a4)
    80002112:	00e7f6b3          	and	a3,a5,a4
    80002116:	c29d                	beqz	a3,8000213c <bfree+0x60>
    80002118:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000211a:	94aa                	add	s1,s1,a0
    8000211c:	fff7c793          	not	a5,a5
    80002120:	8f7d                	and	a4,a4,a5
    80002122:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002126:	711000ef          	jal	80003036 <log_write>
  brelse(bp);
    8000212a:	854a                	mv	a0,s2
    8000212c:	ec5ff0ef          	jal	80001ff0 <brelse>
}
    80002130:	60e2                	ld	ra,24(sp)
    80002132:	6442                	ld	s0,16(sp)
    80002134:	64a2                	ld	s1,8(sp)
    80002136:	6902                	ld	s2,0(sp)
    80002138:	6105                	addi	sp,sp,32
    8000213a:	8082                	ret
    panic("freeing free block");
    8000213c:	00005517          	auipc	a0,0x5
    80002140:	2dc50513          	addi	a0,a0,732 # 80007418 <etext+0x418>
    80002144:	2a2030ef          	jal	800053e6 <panic>

0000000080002148 <balloc>:
{
    80002148:	715d                	addi	sp,sp,-80
    8000214a:	e486                	sd	ra,72(sp)
    8000214c:	e0a2                	sd	s0,64(sp)
    8000214e:	fc26                	sd	s1,56(sp)
    80002150:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80002152:	00016797          	auipc	a5,0x16
    80002156:	67a7a783          	lw	a5,1658(a5) # 800187cc <sb+0x4>
    8000215a:	0e078863          	beqz	a5,8000224a <balloc+0x102>
    8000215e:	f84a                	sd	s2,48(sp)
    80002160:	f44e                	sd	s3,40(sp)
    80002162:	f052                	sd	s4,32(sp)
    80002164:	ec56                	sd	s5,24(sp)
    80002166:	e85a                	sd	s6,16(sp)
    80002168:	e45e                	sd	s7,8(sp)
    8000216a:	e062                	sd	s8,0(sp)
    8000216c:	8baa                	mv	s7,a0
    8000216e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002170:	00016b17          	auipc	s6,0x16
    80002174:	658b0b13          	addi	s6,s6,1624 # 800187c8 <sb>
      m = 1 << (bi % 8);
    80002178:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000217a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000217c:	6c09                	lui	s8,0x2
    8000217e:	a09d                	j	800021e4 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002180:	97ca                	add	a5,a5,s2
    80002182:	8e55                	or	a2,a2,a3
    80002184:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002188:	854a                	mv	a0,s2
    8000218a:	6ad000ef          	jal	80003036 <log_write>
        brelse(bp);
    8000218e:	854a                	mv	a0,s2
    80002190:	e61ff0ef          	jal	80001ff0 <brelse>
  bp = bread(dev, bno);
    80002194:	85a6                	mv	a1,s1
    80002196:	855e                	mv	a0,s7
    80002198:	d51ff0ef          	jal	80001ee8 <bread>
    8000219c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000219e:	40000613          	li	a2,1024
    800021a2:	4581                	li	a1,0
    800021a4:	05850513          	addi	a0,a0,88
    800021a8:	f8dfd0ef          	jal	80000134 <memset>
  log_write(bp);
    800021ac:	854a                	mv	a0,s2
    800021ae:	689000ef          	jal	80003036 <log_write>
  brelse(bp);
    800021b2:	854a                	mv	a0,s2
    800021b4:	e3dff0ef          	jal	80001ff0 <brelse>
}
    800021b8:	7942                	ld	s2,48(sp)
    800021ba:	79a2                	ld	s3,40(sp)
    800021bc:	7a02                	ld	s4,32(sp)
    800021be:	6ae2                	ld	s5,24(sp)
    800021c0:	6b42                	ld	s6,16(sp)
    800021c2:	6ba2                	ld	s7,8(sp)
    800021c4:	6c02                	ld	s8,0(sp)
}
    800021c6:	8526                	mv	a0,s1
    800021c8:	60a6                	ld	ra,72(sp)
    800021ca:	6406                	ld	s0,64(sp)
    800021cc:	74e2                	ld	s1,56(sp)
    800021ce:	6161                	addi	sp,sp,80
    800021d0:	8082                	ret
    brelse(bp);
    800021d2:	854a                	mv	a0,s2
    800021d4:	e1dff0ef          	jal	80001ff0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800021d8:	015c0abb          	addw	s5,s8,s5
    800021dc:	004b2783          	lw	a5,4(s6)
    800021e0:	04fafe63          	bgeu	s5,a5,8000223c <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    800021e4:	41fad79b          	sraiw	a5,s5,0x1f
    800021e8:	0137d79b          	srliw	a5,a5,0x13
    800021ec:	015787bb          	addw	a5,a5,s5
    800021f0:	40d7d79b          	sraiw	a5,a5,0xd
    800021f4:	01cb2583          	lw	a1,28(s6)
    800021f8:	9dbd                	addw	a1,a1,a5
    800021fa:	855e                	mv	a0,s7
    800021fc:	cedff0ef          	jal	80001ee8 <bread>
    80002200:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002202:	004b2503          	lw	a0,4(s6)
    80002206:	84d6                	mv	s1,s5
    80002208:	4701                	li	a4,0
    8000220a:	fca4f4e3          	bgeu	s1,a0,800021d2 <balloc+0x8a>
      m = 1 << (bi % 8);
    8000220e:	00777693          	andi	a3,a4,7
    80002212:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002216:	41f7579b          	sraiw	a5,a4,0x1f
    8000221a:	01d7d79b          	srliw	a5,a5,0x1d
    8000221e:	9fb9                	addw	a5,a5,a4
    80002220:	4037d79b          	sraiw	a5,a5,0x3
    80002224:	00f90633          	add	a2,s2,a5
    80002228:	05864603          	lbu	a2,88(a2)
    8000222c:	00c6f5b3          	and	a1,a3,a2
    80002230:	d9a1                	beqz	a1,80002180 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002232:	2705                	addiw	a4,a4,1
    80002234:	2485                	addiw	s1,s1,1
    80002236:	fd471ae3          	bne	a4,s4,8000220a <balloc+0xc2>
    8000223a:	bf61                	j	800021d2 <balloc+0x8a>
    8000223c:	7942                	ld	s2,48(sp)
    8000223e:	79a2                	ld	s3,40(sp)
    80002240:	7a02                	ld	s4,32(sp)
    80002242:	6ae2                	ld	s5,24(sp)
    80002244:	6b42                	ld	s6,16(sp)
    80002246:	6ba2                	ld	s7,8(sp)
    80002248:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    8000224a:	00005517          	auipc	a0,0x5
    8000224e:	1e650513          	addi	a0,a0,486 # 80007430 <etext+0x430>
    80002252:	6c5020ef          	jal	80005116 <printf>
  return 0;
    80002256:	4481                	li	s1,0
    80002258:	b7bd                	j	800021c6 <balloc+0x7e>

000000008000225a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000225a:	7179                	addi	sp,sp,-48
    8000225c:	f406                	sd	ra,40(sp)
    8000225e:	f022                	sd	s0,32(sp)
    80002260:	ec26                	sd	s1,24(sp)
    80002262:	e84a                	sd	s2,16(sp)
    80002264:	e44e                	sd	s3,8(sp)
    80002266:	1800                	addi	s0,sp,48
    80002268:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000226a:	47ad                	li	a5,11
    8000226c:	02b7e363          	bltu	a5,a1,80002292 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    80002270:	02059793          	slli	a5,a1,0x20
    80002274:	01e7d593          	srli	a1,a5,0x1e
    80002278:	00b504b3          	add	s1,a0,a1
    8000227c:	0504a903          	lw	s2,80(s1)
    80002280:	06091363          	bnez	s2,800022e6 <bmap+0x8c>
      addr = balloc(ip->dev);
    80002284:	4108                	lw	a0,0(a0)
    80002286:	ec3ff0ef          	jal	80002148 <balloc>
    8000228a:	892a                	mv	s2,a0
      if(addr == 0)
    8000228c:	cd29                	beqz	a0,800022e6 <bmap+0x8c>
        return 0;
      ip->addrs[bn] = addr;
    8000228e:	c8a8                	sw	a0,80(s1)
    80002290:	a899                	j	800022e6 <bmap+0x8c>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002292:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    80002296:	0ff00793          	li	a5,255
    8000229a:	0697e963          	bltu	a5,s1,8000230c <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000229e:	08052903          	lw	s2,128(a0)
    800022a2:	00091b63          	bnez	s2,800022b8 <bmap+0x5e>
      addr = balloc(ip->dev);
    800022a6:	4108                	lw	a0,0(a0)
    800022a8:	ea1ff0ef          	jal	80002148 <balloc>
    800022ac:	892a                	mv	s2,a0
      if(addr == 0)
    800022ae:	cd05                	beqz	a0,800022e6 <bmap+0x8c>
    800022b0:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800022b2:	08a9a023          	sw	a0,128(s3)
    800022b6:	a011                	j	800022ba <bmap+0x60>
    800022b8:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800022ba:	85ca                	mv	a1,s2
    800022bc:	0009a503          	lw	a0,0(s3)
    800022c0:	c29ff0ef          	jal	80001ee8 <bread>
    800022c4:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800022c6:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800022ca:	02049713          	slli	a4,s1,0x20
    800022ce:	01e75593          	srli	a1,a4,0x1e
    800022d2:	00b784b3          	add	s1,a5,a1
    800022d6:	0004a903          	lw	s2,0(s1)
    800022da:	00090e63          	beqz	s2,800022f6 <bmap+0x9c>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800022de:	8552                	mv	a0,s4
    800022e0:	d11ff0ef          	jal	80001ff0 <brelse>
    return addr;
    800022e4:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800022e6:	854a                	mv	a0,s2
    800022e8:	70a2                	ld	ra,40(sp)
    800022ea:	7402                	ld	s0,32(sp)
    800022ec:	64e2                	ld	s1,24(sp)
    800022ee:	6942                	ld	s2,16(sp)
    800022f0:	69a2                	ld	s3,8(sp)
    800022f2:	6145                	addi	sp,sp,48
    800022f4:	8082                	ret
      addr = balloc(ip->dev);
    800022f6:	0009a503          	lw	a0,0(s3)
    800022fa:	e4fff0ef          	jal	80002148 <balloc>
    800022fe:	892a                	mv	s2,a0
      if(addr){
    80002300:	dd79                	beqz	a0,800022de <bmap+0x84>
        a[bn] = addr;
    80002302:	c088                	sw	a0,0(s1)
        log_write(bp);
    80002304:	8552                	mv	a0,s4
    80002306:	531000ef          	jal	80003036 <log_write>
    8000230a:	bfd1                	j	800022de <bmap+0x84>
    8000230c:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000230e:	00005517          	auipc	a0,0x5
    80002312:	13a50513          	addi	a0,a0,314 # 80007448 <etext+0x448>
    80002316:	0d0030ef          	jal	800053e6 <panic>

000000008000231a <iget>:
{
    8000231a:	7179                	addi	sp,sp,-48
    8000231c:	f406                	sd	ra,40(sp)
    8000231e:	f022                	sd	s0,32(sp)
    80002320:	ec26                	sd	s1,24(sp)
    80002322:	e84a                	sd	s2,16(sp)
    80002324:	e44e                	sd	s3,8(sp)
    80002326:	e052                	sd	s4,0(sp)
    80002328:	1800                	addi	s0,sp,48
    8000232a:	89aa                	mv	s3,a0
    8000232c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000232e:	00016517          	auipc	a0,0x16
    80002332:	4ba50513          	addi	a0,a0,1210 # 800187e8 <itable>
    80002336:	3de030ef          	jal	80005714 <acquire>
  empty = 0;
    8000233a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000233c:	00016497          	auipc	s1,0x16
    80002340:	4c448493          	addi	s1,s1,1220 # 80018800 <itable+0x18>
    80002344:	00018697          	auipc	a3,0x18
    80002348:	f4c68693          	addi	a3,a3,-180 # 8001a290 <log>
    8000234c:	a039                	j	8000235a <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000234e:	02090963          	beqz	s2,80002380 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002352:	08848493          	addi	s1,s1,136
    80002356:	02d48863          	beq	s1,a3,80002386 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000235a:	449c                	lw	a5,8(s1)
    8000235c:	fef059e3          	blez	a5,8000234e <iget+0x34>
    80002360:	4098                	lw	a4,0(s1)
    80002362:	ff3716e3          	bne	a4,s3,8000234e <iget+0x34>
    80002366:	40d8                	lw	a4,4(s1)
    80002368:	ff4713e3          	bne	a4,s4,8000234e <iget+0x34>
      ip->ref++;
    8000236c:	2785                	addiw	a5,a5,1
    8000236e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002370:	00016517          	auipc	a0,0x16
    80002374:	47850513          	addi	a0,a0,1144 # 800187e8 <itable>
    80002378:	430030ef          	jal	800057a8 <release>
      return ip;
    8000237c:	8926                	mv	s2,s1
    8000237e:	a02d                	j	800023a8 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002380:	fbe9                	bnez	a5,80002352 <iget+0x38>
      empty = ip;
    80002382:	8926                	mv	s2,s1
    80002384:	b7f9                	j	80002352 <iget+0x38>
  if(empty == 0)
    80002386:	02090a63          	beqz	s2,800023ba <iget+0xa0>
  ip->dev = dev;
    8000238a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000238e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002392:	4785                	li	a5,1
    80002394:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002398:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000239c:	00016517          	auipc	a0,0x16
    800023a0:	44c50513          	addi	a0,a0,1100 # 800187e8 <itable>
    800023a4:	404030ef          	jal	800057a8 <release>
}
    800023a8:	854a                	mv	a0,s2
    800023aa:	70a2                	ld	ra,40(sp)
    800023ac:	7402                	ld	s0,32(sp)
    800023ae:	64e2                	ld	s1,24(sp)
    800023b0:	6942                	ld	s2,16(sp)
    800023b2:	69a2                	ld	s3,8(sp)
    800023b4:	6a02                	ld	s4,0(sp)
    800023b6:	6145                	addi	sp,sp,48
    800023b8:	8082                	ret
    panic("iget: no inodes");
    800023ba:	00005517          	auipc	a0,0x5
    800023be:	0a650513          	addi	a0,a0,166 # 80007460 <etext+0x460>
    800023c2:	024030ef          	jal	800053e6 <panic>

00000000800023c6 <fsinit>:
fsinit(int dev) {
    800023c6:	7179                	addi	sp,sp,-48
    800023c8:	f406                	sd	ra,40(sp)
    800023ca:	f022                	sd	s0,32(sp)
    800023cc:	ec26                	sd	s1,24(sp)
    800023ce:	e84a                	sd	s2,16(sp)
    800023d0:	e44e                	sd	s3,8(sp)
    800023d2:	1800                	addi	s0,sp,48
    800023d4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800023d6:	4585                	li	a1,1
    800023d8:	b11ff0ef          	jal	80001ee8 <bread>
    800023dc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800023de:	00016997          	auipc	s3,0x16
    800023e2:	3ea98993          	addi	s3,s3,1002 # 800187c8 <sb>
    800023e6:	02000613          	li	a2,32
    800023ea:	05850593          	addi	a1,a0,88
    800023ee:	854e                	mv	a0,s3
    800023f0:	da9fd0ef          	jal	80000198 <memmove>
  brelse(bp);
    800023f4:	8526                	mv	a0,s1
    800023f6:	bfbff0ef          	jal	80001ff0 <brelse>
  if(sb.magic != FSMAGIC)
    800023fa:	0009a703          	lw	a4,0(s3)
    800023fe:	102037b7          	lui	a5,0x10203
    80002402:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002406:	02f71063          	bne	a4,a5,80002426 <fsinit+0x60>
  initlog(dev, &sb);
    8000240a:	00016597          	auipc	a1,0x16
    8000240e:	3be58593          	addi	a1,a1,958 # 800187c8 <sb>
    80002412:	854a                	mv	a0,s2
    80002414:	215000ef          	jal	80002e28 <initlog>
}
    80002418:	70a2                	ld	ra,40(sp)
    8000241a:	7402                	ld	s0,32(sp)
    8000241c:	64e2                	ld	s1,24(sp)
    8000241e:	6942                	ld	s2,16(sp)
    80002420:	69a2                	ld	s3,8(sp)
    80002422:	6145                	addi	sp,sp,48
    80002424:	8082                	ret
    panic("invalid file system");
    80002426:	00005517          	auipc	a0,0x5
    8000242a:	04a50513          	addi	a0,a0,74 # 80007470 <etext+0x470>
    8000242e:	7b9020ef          	jal	800053e6 <panic>

0000000080002432 <iinit>:
{
    80002432:	7179                	addi	sp,sp,-48
    80002434:	f406                	sd	ra,40(sp)
    80002436:	f022                	sd	s0,32(sp)
    80002438:	ec26                	sd	s1,24(sp)
    8000243a:	e84a                	sd	s2,16(sp)
    8000243c:	e44e                	sd	s3,8(sp)
    8000243e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002440:	00005597          	auipc	a1,0x5
    80002444:	04858593          	addi	a1,a1,72 # 80007488 <etext+0x488>
    80002448:	00016517          	auipc	a0,0x16
    8000244c:	3a050513          	addi	a0,a0,928 # 800187e8 <itable>
    80002450:	240030ef          	jal	80005690 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002454:	00016497          	auipc	s1,0x16
    80002458:	3bc48493          	addi	s1,s1,956 # 80018810 <itable+0x28>
    8000245c:	00018997          	auipc	s3,0x18
    80002460:	e4498993          	addi	s3,s3,-444 # 8001a2a0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002464:	00005917          	auipc	s2,0x5
    80002468:	02c90913          	addi	s2,s2,44 # 80007490 <etext+0x490>
    8000246c:	85ca                	mv	a1,s2
    8000246e:	8526                	mv	a0,s1
    80002470:	497000ef          	jal	80003106 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002474:	08848493          	addi	s1,s1,136
    80002478:	ff349ae3          	bne	s1,s3,8000246c <iinit+0x3a>
}
    8000247c:	70a2                	ld	ra,40(sp)
    8000247e:	7402                	ld	s0,32(sp)
    80002480:	64e2                	ld	s1,24(sp)
    80002482:	6942                	ld	s2,16(sp)
    80002484:	69a2                	ld	s3,8(sp)
    80002486:	6145                	addi	sp,sp,48
    80002488:	8082                	ret

000000008000248a <ialloc>:
{
    8000248a:	7139                	addi	sp,sp,-64
    8000248c:	fc06                	sd	ra,56(sp)
    8000248e:	f822                	sd	s0,48(sp)
    80002490:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002492:	00016717          	auipc	a4,0x16
    80002496:	34272703          	lw	a4,834(a4) # 800187d4 <sb+0xc>
    8000249a:	4785                	li	a5,1
    8000249c:	06e7f063          	bgeu	a5,a4,800024fc <ialloc+0x72>
    800024a0:	f426                	sd	s1,40(sp)
    800024a2:	f04a                	sd	s2,32(sp)
    800024a4:	ec4e                	sd	s3,24(sp)
    800024a6:	e852                	sd	s4,16(sp)
    800024a8:	e456                	sd	s5,8(sp)
    800024aa:	e05a                	sd	s6,0(sp)
    800024ac:	8aaa                	mv	s5,a0
    800024ae:	8b2e                	mv	s6,a1
    800024b0:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800024b2:	00016a17          	auipc	s4,0x16
    800024b6:	316a0a13          	addi	s4,s4,790 # 800187c8 <sb>
    800024ba:	00495593          	srli	a1,s2,0x4
    800024be:	018a2783          	lw	a5,24(s4)
    800024c2:	9dbd                	addw	a1,a1,a5
    800024c4:	8556                	mv	a0,s5
    800024c6:	a23ff0ef          	jal	80001ee8 <bread>
    800024ca:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800024cc:	05850993          	addi	s3,a0,88
    800024d0:	00f97793          	andi	a5,s2,15
    800024d4:	079a                	slli	a5,a5,0x6
    800024d6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800024d8:	00099783          	lh	a5,0(s3)
    800024dc:	cb9d                	beqz	a5,80002512 <ialloc+0x88>
    brelse(bp);
    800024de:	b13ff0ef          	jal	80001ff0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800024e2:	0905                	addi	s2,s2,1
    800024e4:	00ca2703          	lw	a4,12(s4)
    800024e8:	0009079b          	sext.w	a5,s2
    800024ec:	fce7e7e3          	bltu	a5,a4,800024ba <ialloc+0x30>
    800024f0:	74a2                	ld	s1,40(sp)
    800024f2:	7902                	ld	s2,32(sp)
    800024f4:	69e2                	ld	s3,24(sp)
    800024f6:	6a42                	ld	s4,16(sp)
    800024f8:	6aa2                	ld	s5,8(sp)
    800024fa:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800024fc:	00005517          	auipc	a0,0x5
    80002500:	f9c50513          	addi	a0,a0,-100 # 80007498 <etext+0x498>
    80002504:	413020ef          	jal	80005116 <printf>
  return 0;
    80002508:	4501                	li	a0,0
}
    8000250a:	70e2                	ld	ra,56(sp)
    8000250c:	7442                	ld	s0,48(sp)
    8000250e:	6121                	addi	sp,sp,64
    80002510:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002512:	04000613          	li	a2,64
    80002516:	4581                	li	a1,0
    80002518:	854e                	mv	a0,s3
    8000251a:	c1bfd0ef          	jal	80000134 <memset>
      dip->type = type;
    8000251e:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002522:	8526                	mv	a0,s1
    80002524:	313000ef          	jal	80003036 <log_write>
      brelse(bp);
    80002528:	8526                	mv	a0,s1
    8000252a:	ac7ff0ef          	jal	80001ff0 <brelse>
      return iget(dev, inum);
    8000252e:	0009059b          	sext.w	a1,s2
    80002532:	8556                	mv	a0,s5
    80002534:	de7ff0ef          	jal	8000231a <iget>
    80002538:	74a2                	ld	s1,40(sp)
    8000253a:	7902                	ld	s2,32(sp)
    8000253c:	69e2                	ld	s3,24(sp)
    8000253e:	6a42                	ld	s4,16(sp)
    80002540:	6aa2                	ld	s5,8(sp)
    80002542:	6b02                	ld	s6,0(sp)
    80002544:	b7d9                	j	8000250a <ialloc+0x80>

0000000080002546 <iupdate>:
{
    80002546:	1101                	addi	sp,sp,-32
    80002548:	ec06                	sd	ra,24(sp)
    8000254a:	e822                	sd	s0,16(sp)
    8000254c:	e426                	sd	s1,8(sp)
    8000254e:	e04a                	sd	s2,0(sp)
    80002550:	1000                	addi	s0,sp,32
    80002552:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002554:	415c                	lw	a5,4(a0)
    80002556:	0047d79b          	srliw	a5,a5,0x4
    8000255a:	00016597          	auipc	a1,0x16
    8000255e:	2865a583          	lw	a1,646(a1) # 800187e0 <sb+0x18>
    80002562:	9dbd                	addw	a1,a1,a5
    80002564:	4108                	lw	a0,0(a0)
    80002566:	983ff0ef          	jal	80001ee8 <bread>
    8000256a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000256c:	05850793          	addi	a5,a0,88
    80002570:	40d8                	lw	a4,4(s1)
    80002572:	8b3d                	andi	a4,a4,15
    80002574:	071a                	slli	a4,a4,0x6
    80002576:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002578:	04449703          	lh	a4,68(s1)
    8000257c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002580:	04649703          	lh	a4,70(s1)
    80002584:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002588:	04849703          	lh	a4,72(s1)
    8000258c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002590:	04a49703          	lh	a4,74(s1)
    80002594:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002598:	44f8                	lw	a4,76(s1)
    8000259a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000259c:	03400613          	li	a2,52
    800025a0:	05048593          	addi	a1,s1,80
    800025a4:	00c78513          	addi	a0,a5,12
    800025a8:	bf1fd0ef          	jal	80000198 <memmove>
  log_write(bp);
    800025ac:	854a                	mv	a0,s2
    800025ae:	289000ef          	jal	80003036 <log_write>
  brelse(bp);
    800025b2:	854a                	mv	a0,s2
    800025b4:	a3dff0ef          	jal	80001ff0 <brelse>
}
    800025b8:	60e2                	ld	ra,24(sp)
    800025ba:	6442                	ld	s0,16(sp)
    800025bc:	64a2                	ld	s1,8(sp)
    800025be:	6902                	ld	s2,0(sp)
    800025c0:	6105                	addi	sp,sp,32
    800025c2:	8082                	ret

00000000800025c4 <idup>:
{
    800025c4:	1101                	addi	sp,sp,-32
    800025c6:	ec06                	sd	ra,24(sp)
    800025c8:	e822                	sd	s0,16(sp)
    800025ca:	e426                	sd	s1,8(sp)
    800025cc:	1000                	addi	s0,sp,32
    800025ce:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800025d0:	00016517          	auipc	a0,0x16
    800025d4:	21850513          	addi	a0,a0,536 # 800187e8 <itable>
    800025d8:	13c030ef          	jal	80005714 <acquire>
  ip->ref++;
    800025dc:	449c                	lw	a5,8(s1)
    800025de:	2785                	addiw	a5,a5,1
    800025e0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800025e2:	00016517          	auipc	a0,0x16
    800025e6:	20650513          	addi	a0,a0,518 # 800187e8 <itable>
    800025ea:	1be030ef          	jal	800057a8 <release>
}
    800025ee:	8526                	mv	a0,s1
    800025f0:	60e2                	ld	ra,24(sp)
    800025f2:	6442                	ld	s0,16(sp)
    800025f4:	64a2                	ld	s1,8(sp)
    800025f6:	6105                	addi	sp,sp,32
    800025f8:	8082                	ret

00000000800025fa <ilock>:
{
    800025fa:	1101                	addi	sp,sp,-32
    800025fc:	ec06                	sd	ra,24(sp)
    800025fe:	e822                	sd	s0,16(sp)
    80002600:	e426                	sd	s1,8(sp)
    80002602:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002604:	cd19                	beqz	a0,80002622 <ilock+0x28>
    80002606:	84aa                	mv	s1,a0
    80002608:	451c                	lw	a5,8(a0)
    8000260a:	00f05c63          	blez	a5,80002622 <ilock+0x28>
  acquiresleep(&ip->lock);
    8000260e:	0541                	addi	a0,a0,16
    80002610:	32d000ef          	jal	8000313c <acquiresleep>
  if(ip->valid == 0){
    80002614:	40bc                	lw	a5,64(s1)
    80002616:	cf89                	beqz	a5,80002630 <ilock+0x36>
}
    80002618:	60e2                	ld	ra,24(sp)
    8000261a:	6442                	ld	s0,16(sp)
    8000261c:	64a2                	ld	s1,8(sp)
    8000261e:	6105                	addi	sp,sp,32
    80002620:	8082                	ret
    80002622:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002624:	00005517          	auipc	a0,0x5
    80002628:	e8c50513          	addi	a0,a0,-372 # 800074b0 <etext+0x4b0>
    8000262c:	5bb020ef          	jal	800053e6 <panic>
    80002630:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002632:	40dc                	lw	a5,4(s1)
    80002634:	0047d79b          	srliw	a5,a5,0x4
    80002638:	00016597          	auipc	a1,0x16
    8000263c:	1a85a583          	lw	a1,424(a1) # 800187e0 <sb+0x18>
    80002640:	9dbd                	addw	a1,a1,a5
    80002642:	4088                	lw	a0,0(s1)
    80002644:	8a5ff0ef          	jal	80001ee8 <bread>
    80002648:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000264a:	05850593          	addi	a1,a0,88
    8000264e:	40dc                	lw	a5,4(s1)
    80002650:	8bbd                	andi	a5,a5,15
    80002652:	079a                	slli	a5,a5,0x6
    80002654:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002656:	00059783          	lh	a5,0(a1)
    8000265a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000265e:	00259783          	lh	a5,2(a1)
    80002662:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002666:	00459783          	lh	a5,4(a1)
    8000266a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000266e:	00659783          	lh	a5,6(a1)
    80002672:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002676:	459c                	lw	a5,8(a1)
    80002678:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000267a:	03400613          	li	a2,52
    8000267e:	05b1                	addi	a1,a1,12
    80002680:	05048513          	addi	a0,s1,80
    80002684:	b15fd0ef          	jal	80000198 <memmove>
    brelse(bp);
    80002688:	854a                	mv	a0,s2
    8000268a:	967ff0ef          	jal	80001ff0 <brelse>
    ip->valid = 1;
    8000268e:	4785                	li	a5,1
    80002690:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002692:	04449783          	lh	a5,68(s1)
    80002696:	c399                	beqz	a5,8000269c <ilock+0xa2>
    80002698:	6902                	ld	s2,0(sp)
    8000269a:	bfbd                	j	80002618 <ilock+0x1e>
      panic("ilock: no type");
    8000269c:	00005517          	auipc	a0,0x5
    800026a0:	e1c50513          	addi	a0,a0,-484 # 800074b8 <etext+0x4b8>
    800026a4:	543020ef          	jal	800053e6 <panic>

00000000800026a8 <iunlock>:
{
    800026a8:	1101                	addi	sp,sp,-32
    800026aa:	ec06                	sd	ra,24(sp)
    800026ac:	e822                	sd	s0,16(sp)
    800026ae:	e426                	sd	s1,8(sp)
    800026b0:	e04a                	sd	s2,0(sp)
    800026b2:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800026b4:	c505                	beqz	a0,800026dc <iunlock+0x34>
    800026b6:	84aa                	mv	s1,a0
    800026b8:	01050913          	addi	s2,a0,16
    800026bc:	854a                	mv	a0,s2
    800026be:	2fd000ef          	jal	800031ba <holdingsleep>
    800026c2:	cd09                	beqz	a0,800026dc <iunlock+0x34>
    800026c4:	449c                	lw	a5,8(s1)
    800026c6:	00f05b63          	blez	a5,800026dc <iunlock+0x34>
  releasesleep(&ip->lock);
    800026ca:	854a                	mv	a0,s2
    800026cc:	2b7000ef          	jal	80003182 <releasesleep>
}
    800026d0:	60e2                	ld	ra,24(sp)
    800026d2:	6442                	ld	s0,16(sp)
    800026d4:	64a2                	ld	s1,8(sp)
    800026d6:	6902                	ld	s2,0(sp)
    800026d8:	6105                	addi	sp,sp,32
    800026da:	8082                	ret
    panic("iunlock");
    800026dc:	00005517          	auipc	a0,0x5
    800026e0:	dec50513          	addi	a0,a0,-532 # 800074c8 <etext+0x4c8>
    800026e4:	503020ef          	jal	800053e6 <panic>

00000000800026e8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800026e8:	7179                	addi	sp,sp,-48
    800026ea:	f406                	sd	ra,40(sp)
    800026ec:	f022                	sd	s0,32(sp)
    800026ee:	ec26                	sd	s1,24(sp)
    800026f0:	e84a                	sd	s2,16(sp)
    800026f2:	e44e                	sd	s3,8(sp)
    800026f4:	1800                	addi	s0,sp,48
    800026f6:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800026f8:	05050493          	addi	s1,a0,80
    800026fc:	08050913          	addi	s2,a0,128
    80002700:	a021                	j	80002708 <itrunc+0x20>
    80002702:	0491                	addi	s1,s1,4
    80002704:	01248b63          	beq	s1,s2,8000271a <itrunc+0x32>
    if(ip->addrs[i]){
    80002708:	408c                	lw	a1,0(s1)
    8000270a:	dde5                	beqz	a1,80002702 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000270c:	0009a503          	lw	a0,0(s3)
    80002710:	9cdff0ef          	jal	800020dc <bfree>
      ip->addrs[i] = 0;
    80002714:	0004a023          	sw	zero,0(s1)
    80002718:	b7ed                	j	80002702 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000271a:	0809a583          	lw	a1,128(s3)
    8000271e:	ed89                	bnez	a1,80002738 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002720:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002724:	854e                	mv	a0,s3
    80002726:	e21ff0ef          	jal	80002546 <iupdate>
}
    8000272a:	70a2                	ld	ra,40(sp)
    8000272c:	7402                	ld	s0,32(sp)
    8000272e:	64e2                	ld	s1,24(sp)
    80002730:	6942                	ld	s2,16(sp)
    80002732:	69a2                	ld	s3,8(sp)
    80002734:	6145                	addi	sp,sp,48
    80002736:	8082                	ret
    80002738:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000273a:	0009a503          	lw	a0,0(s3)
    8000273e:	faaff0ef          	jal	80001ee8 <bread>
    80002742:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002744:	05850493          	addi	s1,a0,88
    80002748:	45850913          	addi	s2,a0,1112
    8000274c:	a021                	j	80002754 <itrunc+0x6c>
    8000274e:	0491                	addi	s1,s1,4
    80002750:	01248963          	beq	s1,s2,80002762 <itrunc+0x7a>
      if(a[j])
    80002754:	408c                	lw	a1,0(s1)
    80002756:	dde5                	beqz	a1,8000274e <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002758:	0009a503          	lw	a0,0(s3)
    8000275c:	981ff0ef          	jal	800020dc <bfree>
    80002760:	b7fd                	j	8000274e <itrunc+0x66>
    brelse(bp);
    80002762:	8552                	mv	a0,s4
    80002764:	88dff0ef          	jal	80001ff0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002768:	0809a583          	lw	a1,128(s3)
    8000276c:	0009a503          	lw	a0,0(s3)
    80002770:	96dff0ef          	jal	800020dc <bfree>
    ip->addrs[NDIRECT] = 0;
    80002774:	0809a023          	sw	zero,128(s3)
    80002778:	6a02                	ld	s4,0(sp)
    8000277a:	b75d                	j	80002720 <itrunc+0x38>

000000008000277c <iput>:
{
    8000277c:	1101                	addi	sp,sp,-32
    8000277e:	ec06                	sd	ra,24(sp)
    80002780:	e822                	sd	s0,16(sp)
    80002782:	e426                	sd	s1,8(sp)
    80002784:	1000                	addi	s0,sp,32
    80002786:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002788:	00016517          	auipc	a0,0x16
    8000278c:	06050513          	addi	a0,a0,96 # 800187e8 <itable>
    80002790:	785020ef          	jal	80005714 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002794:	4498                	lw	a4,8(s1)
    80002796:	4785                	li	a5,1
    80002798:	02f70063          	beq	a4,a5,800027b8 <iput+0x3c>
  ip->ref--;
    8000279c:	449c                	lw	a5,8(s1)
    8000279e:	37fd                	addiw	a5,a5,-1
    800027a0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800027a2:	00016517          	auipc	a0,0x16
    800027a6:	04650513          	addi	a0,a0,70 # 800187e8 <itable>
    800027aa:	7ff020ef          	jal	800057a8 <release>
}
    800027ae:	60e2                	ld	ra,24(sp)
    800027b0:	6442                	ld	s0,16(sp)
    800027b2:	64a2                	ld	s1,8(sp)
    800027b4:	6105                	addi	sp,sp,32
    800027b6:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800027b8:	40bc                	lw	a5,64(s1)
    800027ba:	d3ed                	beqz	a5,8000279c <iput+0x20>
    800027bc:	04a49783          	lh	a5,74(s1)
    800027c0:	fff1                	bnez	a5,8000279c <iput+0x20>
    800027c2:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800027c4:	01048913          	addi	s2,s1,16
    800027c8:	854a                	mv	a0,s2
    800027ca:	173000ef          	jal	8000313c <acquiresleep>
    release(&itable.lock);
    800027ce:	00016517          	auipc	a0,0x16
    800027d2:	01a50513          	addi	a0,a0,26 # 800187e8 <itable>
    800027d6:	7d3020ef          	jal	800057a8 <release>
    itrunc(ip);
    800027da:	8526                	mv	a0,s1
    800027dc:	f0dff0ef          	jal	800026e8 <itrunc>
    ip->type = 0;
    800027e0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800027e4:	8526                	mv	a0,s1
    800027e6:	d61ff0ef          	jal	80002546 <iupdate>
    ip->valid = 0;
    800027ea:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800027ee:	854a                	mv	a0,s2
    800027f0:	193000ef          	jal	80003182 <releasesleep>
    acquire(&itable.lock);
    800027f4:	00016517          	auipc	a0,0x16
    800027f8:	ff450513          	addi	a0,a0,-12 # 800187e8 <itable>
    800027fc:	719020ef          	jal	80005714 <acquire>
    80002800:	6902                	ld	s2,0(sp)
    80002802:	bf69                	j	8000279c <iput+0x20>

0000000080002804 <iunlockput>:
{
    80002804:	1101                	addi	sp,sp,-32
    80002806:	ec06                	sd	ra,24(sp)
    80002808:	e822                	sd	s0,16(sp)
    8000280a:	e426                	sd	s1,8(sp)
    8000280c:	1000                	addi	s0,sp,32
    8000280e:	84aa                	mv	s1,a0
  iunlock(ip);
    80002810:	e99ff0ef          	jal	800026a8 <iunlock>
  iput(ip);
    80002814:	8526                	mv	a0,s1
    80002816:	f67ff0ef          	jal	8000277c <iput>
}
    8000281a:	60e2                	ld	ra,24(sp)
    8000281c:	6442                	ld	s0,16(sp)
    8000281e:	64a2                	ld	s1,8(sp)
    80002820:	6105                	addi	sp,sp,32
    80002822:	8082                	ret

0000000080002824 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002824:	1141                	addi	sp,sp,-16
    80002826:	e406                	sd	ra,8(sp)
    80002828:	e022                	sd	s0,0(sp)
    8000282a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000282c:	411c                	lw	a5,0(a0)
    8000282e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002830:	415c                	lw	a5,4(a0)
    80002832:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002834:	04451783          	lh	a5,68(a0)
    80002838:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000283c:	04a51783          	lh	a5,74(a0)
    80002840:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002844:	04c56783          	lwu	a5,76(a0)
    80002848:	e99c                	sd	a5,16(a1)
}
    8000284a:	60a2                	ld	ra,8(sp)
    8000284c:	6402                	ld	s0,0(sp)
    8000284e:	0141                	addi	sp,sp,16
    80002850:	8082                	ret

0000000080002852 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002852:	457c                	lw	a5,76(a0)
    80002854:	0ed7e663          	bltu	a5,a3,80002940 <readi+0xee>
{
    80002858:	7159                	addi	sp,sp,-112
    8000285a:	f486                	sd	ra,104(sp)
    8000285c:	f0a2                	sd	s0,96(sp)
    8000285e:	eca6                	sd	s1,88(sp)
    80002860:	e0d2                	sd	s4,64(sp)
    80002862:	fc56                	sd	s5,56(sp)
    80002864:	f85a                	sd	s6,48(sp)
    80002866:	f45e                	sd	s7,40(sp)
    80002868:	1880                	addi	s0,sp,112
    8000286a:	8b2a                	mv	s6,a0
    8000286c:	8bae                	mv	s7,a1
    8000286e:	8a32                	mv	s4,a2
    80002870:	84b6                	mv	s1,a3
    80002872:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002874:	9f35                	addw	a4,a4,a3
    return 0;
    80002876:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002878:	0ad76b63          	bltu	a4,a3,8000292e <readi+0xdc>
    8000287c:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8000287e:	00e7f463          	bgeu	a5,a4,80002886 <readi+0x34>
    n = ip->size - off;
    80002882:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002886:	080a8b63          	beqz	s5,8000291c <readi+0xca>
    8000288a:	e8ca                	sd	s2,80(sp)
    8000288c:	f062                	sd	s8,32(sp)
    8000288e:	ec66                	sd	s9,24(sp)
    80002890:	e86a                	sd	s10,16(sp)
    80002892:	e46e                	sd	s11,8(sp)
    80002894:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002896:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000289a:	5c7d                	li	s8,-1
    8000289c:	a80d                	j	800028ce <readi+0x7c>
    8000289e:	020d1d93          	slli	s11,s10,0x20
    800028a2:	020ddd93          	srli	s11,s11,0x20
    800028a6:	05890613          	addi	a2,s2,88
    800028aa:	86ee                	mv	a3,s11
    800028ac:	963e                	add	a2,a2,a5
    800028ae:	85d2                	mv	a1,s4
    800028b0:	855e                	mv	a0,s7
    800028b2:	dbdfe0ef          	jal	8000166e <either_copyout>
    800028b6:	05850363          	beq	a0,s8,800028fc <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800028ba:	854a                	mv	a0,s2
    800028bc:	f34ff0ef          	jal	80001ff0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800028c0:	013d09bb          	addw	s3,s10,s3
    800028c4:	009d04bb          	addw	s1,s10,s1
    800028c8:	9a6e                	add	s4,s4,s11
    800028ca:	0559f363          	bgeu	s3,s5,80002910 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800028ce:	00a4d59b          	srliw	a1,s1,0xa
    800028d2:	855a                	mv	a0,s6
    800028d4:	987ff0ef          	jal	8000225a <bmap>
    800028d8:	85aa                	mv	a1,a0
    if(addr == 0)
    800028da:	c139                	beqz	a0,80002920 <readi+0xce>
    bp = bread(ip->dev, addr);
    800028dc:	000b2503          	lw	a0,0(s6)
    800028e0:	e08ff0ef          	jal	80001ee8 <bread>
    800028e4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800028e6:	3ff4f793          	andi	a5,s1,1023
    800028ea:	40fc873b          	subw	a4,s9,a5
    800028ee:	413a86bb          	subw	a3,s5,s3
    800028f2:	8d3a                	mv	s10,a4
    800028f4:	fae6f5e3          	bgeu	a3,a4,8000289e <readi+0x4c>
    800028f8:	8d36                	mv	s10,a3
    800028fa:	b755                	j	8000289e <readi+0x4c>
      brelse(bp);
    800028fc:	854a                	mv	a0,s2
    800028fe:	ef2ff0ef          	jal	80001ff0 <brelse>
      tot = -1;
    80002902:	59fd                	li	s3,-1
      break;
    80002904:	6946                	ld	s2,80(sp)
    80002906:	7c02                	ld	s8,32(sp)
    80002908:	6ce2                	ld	s9,24(sp)
    8000290a:	6d42                	ld	s10,16(sp)
    8000290c:	6da2                	ld	s11,8(sp)
    8000290e:	a831                	j	8000292a <readi+0xd8>
    80002910:	6946                	ld	s2,80(sp)
    80002912:	7c02                	ld	s8,32(sp)
    80002914:	6ce2                	ld	s9,24(sp)
    80002916:	6d42                	ld	s10,16(sp)
    80002918:	6da2                	ld	s11,8(sp)
    8000291a:	a801                	j	8000292a <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000291c:	89d6                	mv	s3,s5
    8000291e:	a031                	j	8000292a <readi+0xd8>
    80002920:	6946                	ld	s2,80(sp)
    80002922:	7c02                	ld	s8,32(sp)
    80002924:	6ce2                	ld	s9,24(sp)
    80002926:	6d42                	ld	s10,16(sp)
    80002928:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000292a:	854e                	mv	a0,s3
    8000292c:	69a6                	ld	s3,72(sp)
}
    8000292e:	70a6                	ld	ra,104(sp)
    80002930:	7406                	ld	s0,96(sp)
    80002932:	64e6                	ld	s1,88(sp)
    80002934:	6a06                	ld	s4,64(sp)
    80002936:	7ae2                	ld	s5,56(sp)
    80002938:	7b42                	ld	s6,48(sp)
    8000293a:	7ba2                	ld	s7,40(sp)
    8000293c:	6165                	addi	sp,sp,112
    8000293e:	8082                	ret
    return 0;
    80002940:	4501                	li	a0,0
}
    80002942:	8082                	ret

0000000080002944 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002944:	457c                	lw	a5,76(a0)
    80002946:	0ed7eb63          	bltu	a5,a3,80002a3c <writei+0xf8>
{
    8000294a:	7159                	addi	sp,sp,-112
    8000294c:	f486                	sd	ra,104(sp)
    8000294e:	f0a2                	sd	s0,96(sp)
    80002950:	e8ca                	sd	s2,80(sp)
    80002952:	e0d2                	sd	s4,64(sp)
    80002954:	fc56                	sd	s5,56(sp)
    80002956:	f85a                	sd	s6,48(sp)
    80002958:	f45e                	sd	s7,40(sp)
    8000295a:	1880                	addi	s0,sp,112
    8000295c:	8aaa                	mv	s5,a0
    8000295e:	8bae                	mv	s7,a1
    80002960:	8a32                	mv	s4,a2
    80002962:	8936                	mv	s2,a3
    80002964:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002966:	00e687bb          	addw	a5,a3,a4
    8000296a:	0cd7eb63          	bltu	a5,a3,80002a40 <writei+0xfc>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000296e:	00043737          	lui	a4,0x43
    80002972:	0cf76963          	bltu	a4,a5,80002a44 <writei+0x100>
    80002976:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002978:	0a0b0a63          	beqz	s6,80002a2c <writei+0xe8>
    8000297c:	eca6                	sd	s1,88(sp)
    8000297e:	f062                	sd	s8,32(sp)
    80002980:	ec66                	sd	s9,24(sp)
    80002982:	e86a                	sd	s10,16(sp)
    80002984:	e46e                	sd	s11,8(sp)
    80002986:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002988:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000298c:	5c7d                	li	s8,-1
    8000298e:	a825                	j	800029c6 <writei+0x82>
    80002990:	020d1d93          	slli	s11,s10,0x20
    80002994:	020ddd93          	srli	s11,s11,0x20
    80002998:	05848513          	addi	a0,s1,88
    8000299c:	86ee                	mv	a3,s11
    8000299e:	8652                	mv	a2,s4
    800029a0:	85de                	mv	a1,s7
    800029a2:	953e                	add	a0,a0,a5
    800029a4:	d15fe0ef          	jal	800016b8 <either_copyin>
    800029a8:	05850663          	beq	a0,s8,800029f4 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    800029ac:	8526                	mv	a0,s1
    800029ae:	688000ef          	jal	80003036 <log_write>
    brelse(bp);
    800029b2:	8526                	mv	a0,s1
    800029b4:	e3cff0ef          	jal	80001ff0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800029b8:	013d09bb          	addw	s3,s10,s3
    800029bc:	012d093b          	addw	s2,s10,s2
    800029c0:	9a6e                	add	s4,s4,s11
    800029c2:	0369fc63          	bgeu	s3,s6,800029fa <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    800029c6:	00a9559b          	srliw	a1,s2,0xa
    800029ca:	8556                	mv	a0,s5
    800029cc:	88fff0ef          	jal	8000225a <bmap>
    800029d0:	85aa                	mv	a1,a0
    if(addr == 0)
    800029d2:	c505                	beqz	a0,800029fa <writei+0xb6>
    bp = bread(ip->dev, addr);
    800029d4:	000aa503          	lw	a0,0(s5)
    800029d8:	d10ff0ef          	jal	80001ee8 <bread>
    800029dc:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800029de:	3ff97793          	andi	a5,s2,1023
    800029e2:	40fc873b          	subw	a4,s9,a5
    800029e6:	413b06bb          	subw	a3,s6,s3
    800029ea:	8d3a                	mv	s10,a4
    800029ec:	fae6f2e3          	bgeu	a3,a4,80002990 <writei+0x4c>
    800029f0:	8d36                	mv	s10,a3
    800029f2:	bf79                	j	80002990 <writei+0x4c>
      brelse(bp);
    800029f4:	8526                	mv	a0,s1
    800029f6:	dfaff0ef          	jal	80001ff0 <brelse>
  }

  if(off > ip->size)
    800029fa:	04caa783          	lw	a5,76(s5)
    800029fe:	0327f963          	bgeu	a5,s2,80002a30 <writei+0xec>
    ip->size = off;
    80002a02:	052aa623          	sw	s2,76(s5)
    80002a06:	64e6                	ld	s1,88(sp)
    80002a08:	7c02                	ld	s8,32(sp)
    80002a0a:	6ce2                	ld	s9,24(sp)
    80002a0c:	6d42                	ld	s10,16(sp)
    80002a0e:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002a10:	8556                	mv	a0,s5
    80002a12:	b35ff0ef          	jal	80002546 <iupdate>

  return tot;
    80002a16:	854e                	mv	a0,s3
    80002a18:	69a6                	ld	s3,72(sp)
}
    80002a1a:	70a6                	ld	ra,104(sp)
    80002a1c:	7406                	ld	s0,96(sp)
    80002a1e:	6946                	ld	s2,80(sp)
    80002a20:	6a06                	ld	s4,64(sp)
    80002a22:	7ae2                	ld	s5,56(sp)
    80002a24:	7b42                	ld	s6,48(sp)
    80002a26:	7ba2                	ld	s7,40(sp)
    80002a28:	6165                	addi	sp,sp,112
    80002a2a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002a2c:	89da                	mv	s3,s6
    80002a2e:	b7cd                	j	80002a10 <writei+0xcc>
    80002a30:	64e6                	ld	s1,88(sp)
    80002a32:	7c02                	ld	s8,32(sp)
    80002a34:	6ce2                	ld	s9,24(sp)
    80002a36:	6d42                	ld	s10,16(sp)
    80002a38:	6da2                	ld	s11,8(sp)
    80002a3a:	bfd9                	j	80002a10 <writei+0xcc>
    return -1;
    80002a3c:	557d                	li	a0,-1
}
    80002a3e:	8082                	ret
    return -1;
    80002a40:	557d                	li	a0,-1
    80002a42:	bfe1                	j	80002a1a <writei+0xd6>
    return -1;
    80002a44:	557d                	li	a0,-1
    80002a46:	bfd1                	j	80002a1a <writei+0xd6>

0000000080002a48 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002a48:	1141                	addi	sp,sp,-16
    80002a4a:	e406                	sd	ra,8(sp)
    80002a4c:	e022                	sd	s0,0(sp)
    80002a4e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002a50:	4639                	li	a2,14
    80002a52:	fbafd0ef          	jal	8000020c <strncmp>
}
    80002a56:	60a2                	ld	ra,8(sp)
    80002a58:	6402                	ld	s0,0(sp)
    80002a5a:	0141                	addi	sp,sp,16
    80002a5c:	8082                	ret

0000000080002a5e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002a5e:	711d                	addi	sp,sp,-96
    80002a60:	ec86                	sd	ra,88(sp)
    80002a62:	e8a2                	sd	s0,80(sp)
    80002a64:	e4a6                	sd	s1,72(sp)
    80002a66:	e0ca                	sd	s2,64(sp)
    80002a68:	fc4e                	sd	s3,56(sp)
    80002a6a:	f852                	sd	s4,48(sp)
    80002a6c:	f456                	sd	s5,40(sp)
    80002a6e:	f05a                	sd	s6,32(sp)
    80002a70:	ec5e                	sd	s7,24(sp)
    80002a72:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002a74:	04451703          	lh	a4,68(a0)
    80002a78:	4785                	li	a5,1
    80002a7a:	00f71f63          	bne	a4,a5,80002a98 <dirlookup+0x3a>
    80002a7e:	892a                	mv	s2,a0
    80002a80:	8aae                	mv	s5,a1
    80002a82:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002a84:	457c                	lw	a5,76(a0)
    80002a86:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002a88:	fa040a13          	addi	s4,s0,-96
    80002a8c:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002a8e:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002a92:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002a94:	e39d                	bnez	a5,80002aba <dirlookup+0x5c>
    80002a96:	a8b9                	j	80002af4 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002a98:	00005517          	auipc	a0,0x5
    80002a9c:	a3850513          	addi	a0,a0,-1480 # 800074d0 <etext+0x4d0>
    80002aa0:	147020ef          	jal	800053e6 <panic>
      panic("dirlookup read");
    80002aa4:	00005517          	auipc	a0,0x5
    80002aa8:	a4450513          	addi	a0,a0,-1468 # 800074e8 <etext+0x4e8>
    80002aac:	13b020ef          	jal	800053e6 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ab0:	24c1                	addiw	s1,s1,16
    80002ab2:	04c92783          	lw	a5,76(s2)
    80002ab6:	02f4fe63          	bgeu	s1,a5,80002af2 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002aba:	874e                	mv	a4,s3
    80002abc:	86a6                	mv	a3,s1
    80002abe:	8652                	mv	a2,s4
    80002ac0:	4581                	li	a1,0
    80002ac2:	854a                	mv	a0,s2
    80002ac4:	d8fff0ef          	jal	80002852 <readi>
    80002ac8:	fd351ee3          	bne	a0,s3,80002aa4 <dirlookup+0x46>
    if(de.inum == 0)
    80002acc:	fa045783          	lhu	a5,-96(s0)
    80002ad0:	d3e5                	beqz	a5,80002ab0 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80002ad2:	85da                	mv	a1,s6
    80002ad4:	8556                	mv	a0,s5
    80002ad6:	f73ff0ef          	jal	80002a48 <namecmp>
    80002ada:	f979                	bnez	a0,80002ab0 <dirlookup+0x52>
      if(poff)
    80002adc:	000b8463          	beqz	s7,80002ae4 <dirlookup+0x86>
        *poff = off;
    80002ae0:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80002ae4:	fa045583          	lhu	a1,-96(s0)
    80002ae8:	00092503          	lw	a0,0(s2)
    80002aec:	82fff0ef          	jal	8000231a <iget>
    80002af0:	a011                	j	80002af4 <dirlookup+0x96>
  return 0;
    80002af2:	4501                	li	a0,0
}
    80002af4:	60e6                	ld	ra,88(sp)
    80002af6:	6446                	ld	s0,80(sp)
    80002af8:	64a6                	ld	s1,72(sp)
    80002afa:	6906                	ld	s2,64(sp)
    80002afc:	79e2                	ld	s3,56(sp)
    80002afe:	7a42                	ld	s4,48(sp)
    80002b00:	7aa2                	ld	s5,40(sp)
    80002b02:	7b02                	ld	s6,32(sp)
    80002b04:	6be2                	ld	s7,24(sp)
    80002b06:	6125                	addi	sp,sp,96
    80002b08:	8082                	ret

0000000080002b0a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002b0a:	711d                	addi	sp,sp,-96
    80002b0c:	ec86                	sd	ra,88(sp)
    80002b0e:	e8a2                	sd	s0,80(sp)
    80002b10:	e4a6                	sd	s1,72(sp)
    80002b12:	e0ca                	sd	s2,64(sp)
    80002b14:	fc4e                	sd	s3,56(sp)
    80002b16:	f852                	sd	s4,48(sp)
    80002b18:	f456                	sd	s5,40(sp)
    80002b1a:	f05a                	sd	s6,32(sp)
    80002b1c:	ec5e                	sd	s7,24(sp)
    80002b1e:	e862                	sd	s8,16(sp)
    80002b20:	e466                	sd	s9,8(sp)
    80002b22:	e06a                	sd	s10,0(sp)
    80002b24:	1080                	addi	s0,sp,96
    80002b26:	84aa                	mv	s1,a0
    80002b28:	8b2e                	mv	s6,a1
    80002b2a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002b2c:	00054703          	lbu	a4,0(a0)
    80002b30:	02f00793          	li	a5,47
    80002b34:	00f70f63          	beq	a4,a5,80002b52 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002b38:	a12fe0ef          	jal	80000d4a <myproc>
    80002b3c:	15053503          	ld	a0,336(a0)
    80002b40:	a85ff0ef          	jal	800025c4 <idup>
    80002b44:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002b46:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002b4a:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002b4c:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002b4e:	4b85                	li	s7,1
    80002b50:	a879                	j	80002bee <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002b52:	4585                	li	a1,1
    80002b54:	852e                	mv	a0,a1
    80002b56:	fc4ff0ef          	jal	8000231a <iget>
    80002b5a:	8a2a                	mv	s4,a0
    80002b5c:	b7ed                	j	80002b46 <namex+0x3c>
      iunlockput(ip);
    80002b5e:	8552                	mv	a0,s4
    80002b60:	ca5ff0ef          	jal	80002804 <iunlockput>
      return 0;
    80002b64:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002b66:	8552                	mv	a0,s4
    80002b68:	60e6                	ld	ra,88(sp)
    80002b6a:	6446                	ld	s0,80(sp)
    80002b6c:	64a6                	ld	s1,72(sp)
    80002b6e:	6906                	ld	s2,64(sp)
    80002b70:	79e2                	ld	s3,56(sp)
    80002b72:	7a42                	ld	s4,48(sp)
    80002b74:	7aa2                	ld	s5,40(sp)
    80002b76:	7b02                	ld	s6,32(sp)
    80002b78:	6be2                	ld	s7,24(sp)
    80002b7a:	6c42                	ld	s8,16(sp)
    80002b7c:	6ca2                	ld	s9,8(sp)
    80002b7e:	6d02                	ld	s10,0(sp)
    80002b80:	6125                	addi	sp,sp,96
    80002b82:	8082                	ret
      iunlock(ip);
    80002b84:	8552                	mv	a0,s4
    80002b86:	b23ff0ef          	jal	800026a8 <iunlock>
      return ip;
    80002b8a:	bff1                	j	80002b66 <namex+0x5c>
      iunlockput(ip);
    80002b8c:	8552                	mv	a0,s4
    80002b8e:	c77ff0ef          	jal	80002804 <iunlockput>
      return 0;
    80002b92:	8a4e                	mv	s4,s3
    80002b94:	bfc9                	j	80002b66 <namex+0x5c>
  len = path - s;
    80002b96:	40998633          	sub	a2,s3,s1
    80002b9a:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002b9e:	09ac5063          	bge	s8,s10,80002c1e <namex+0x114>
    memmove(name, s, DIRSIZ);
    80002ba2:	8666                	mv	a2,s9
    80002ba4:	85a6                	mv	a1,s1
    80002ba6:	8556                	mv	a0,s5
    80002ba8:	df0fd0ef          	jal	80000198 <memmove>
    80002bac:	84ce                	mv	s1,s3
  while(*path == '/')
    80002bae:	0004c783          	lbu	a5,0(s1)
    80002bb2:	01279763          	bne	a5,s2,80002bc0 <namex+0xb6>
    path++;
    80002bb6:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002bb8:	0004c783          	lbu	a5,0(s1)
    80002bbc:	ff278de3          	beq	a5,s2,80002bb6 <namex+0xac>
    ilock(ip);
    80002bc0:	8552                	mv	a0,s4
    80002bc2:	a39ff0ef          	jal	800025fa <ilock>
    if(ip->type != T_DIR){
    80002bc6:	044a1783          	lh	a5,68(s4)
    80002bca:	f9779ae3          	bne	a5,s7,80002b5e <namex+0x54>
    if(nameiparent && *path == '\0'){
    80002bce:	000b0563          	beqz	s6,80002bd8 <namex+0xce>
    80002bd2:	0004c783          	lbu	a5,0(s1)
    80002bd6:	d7dd                	beqz	a5,80002b84 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002bd8:	4601                	li	a2,0
    80002bda:	85d6                	mv	a1,s5
    80002bdc:	8552                	mv	a0,s4
    80002bde:	e81ff0ef          	jal	80002a5e <dirlookup>
    80002be2:	89aa                	mv	s3,a0
    80002be4:	d545                	beqz	a0,80002b8c <namex+0x82>
    iunlockput(ip);
    80002be6:	8552                	mv	a0,s4
    80002be8:	c1dff0ef          	jal	80002804 <iunlockput>
    ip = next;
    80002bec:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002bee:	0004c783          	lbu	a5,0(s1)
    80002bf2:	01279763          	bne	a5,s2,80002c00 <namex+0xf6>
    path++;
    80002bf6:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002bf8:	0004c783          	lbu	a5,0(s1)
    80002bfc:	ff278de3          	beq	a5,s2,80002bf6 <namex+0xec>
  if(*path == 0)
    80002c00:	cb8d                	beqz	a5,80002c32 <namex+0x128>
  while(*path != '/' && *path != 0)
    80002c02:	0004c783          	lbu	a5,0(s1)
    80002c06:	89a6                	mv	s3,s1
  len = path - s;
    80002c08:	4d01                	li	s10,0
    80002c0a:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002c0c:	01278963          	beq	a5,s2,80002c1e <namex+0x114>
    80002c10:	d3d9                	beqz	a5,80002b96 <namex+0x8c>
    path++;
    80002c12:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002c14:	0009c783          	lbu	a5,0(s3)
    80002c18:	ff279ce3          	bne	a5,s2,80002c10 <namex+0x106>
    80002c1c:	bfad                	j	80002b96 <namex+0x8c>
    memmove(name, s, len);
    80002c1e:	2601                	sext.w	a2,a2
    80002c20:	85a6                	mv	a1,s1
    80002c22:	8556                	mv	a0,s5
    80002c24:	d74fd0ef          	jal	80000198 <memmove>
    name[len] = 0;
    80002c28:	9d56                	add	s10,s10,s5
    80002c2a:	000d0023          	sb	zero,0(s10)
    80002c2e:	84ce                	mv	s1,s3
    80002c30:	bfbd                	j	80002bae <namex+0xa4>
  if(nameiparent){
    80002c32:	f20b0ae3          	beqz	s6,80002b66 <namex+0x5c>
    iput(ip);
    80002c36:	8552                	mv	a0,s4
    80002c38:	b45ff0ef          	jal	8000277c <iput>
    return 0;
    80002c3c:	4a01                	li	s4,0
    80002c3e:	b725                	j	80002b66 <namex+0x5c>

0000000080002c40 <dirlink>:
{
    80002c40:	715d                	addi	sp,sp,-80
    80002c42:	e486                	sd	ra,72(sp)
    80002c44:	e0a2                	sd	s0,64(sp)
    80002c46:	f84a                	sd	s2,48(sp)
    80002c48:	ec56                	sd	s5,24(sp)
    80002c4a:	e85a                	sd	s6,16(sp)
    80002c4c:	0880                	addi	s0,sp,80
    80002c4e:	892a                	mv	s2,a0
    80002c50:	8aae                	mv	s5,a1
    80002c52:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002c54:	4601                	li	a2,0
    80002c56:	e09ff0ef          	jal	80002a5e <dirlookup>
    80002c5a:	ed1d                	bnez	a0,80002c98 <dirlink+0x58>
    80002c5c:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c5e:	04c92483          	lw	s1,76(s2)
    80002c62:	c4b9                	beqz	s1,80002cb0 <dirlink+0x70>
    80002c64:	f44e                	sd	s3,40(sp)
    80002c66:	f052                	sd	s4,32(sp)
    80002c68:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c6a:	fb040a13          	addi	s4,s0,-80
    80002c6e:	49c1                	li	s3,16
    80002c70:	874e                	mv	a4,s3
    80002c72:	86a6                	mv	a3,s1
    80002c74:	8652                	mv	a2,s4
    80002c76:	4581                	li	a1,0
    80002c78:	854a                	mv	a0,s2
    80002c7a:	bd9ff0ef          	jal	80002852 <readi>
    80002c7e:	03351163          	bne	a0,s3,80002ca0 <dirlink+0x60>
    if(de.inum == 0)
    80002c82:	fb045783          	lhu	a5,-80(s0)
    80002c86:	c39d                	beqz	a5,80002cac <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c88:	24c1                	addiw	s1,s1,16
    80002c8a:	04c92783          	lw	a5,76(s2)
    80002c8e:	fef4e1e3          	bltu	s1,a5,80002c70 <dirlink+0x30>
    80002c92:	79a2                	ld	s3,40(sp)
    80002c94:	7a02                	ld	s4,32(sp)
    80002c96:	a829                	j	80002cb0 <dirlink+0x70>
    iput(ip);
    80002c98:	ae5ff0ef          	jal	8000277c <iput>
    return -1;
    80002c9c:	557d                	li	a0,-1
    80002c9e:	a83d                	j	80002cdc <dirlink+0x9c>
      panic("dirlink read");
    80002ca0:	00005517          	auipc	a0,0x5
    80002ca4:	85850513          	addi	a0,a0,-1960 # 800074f8 <etext+0x4f8>
    80002ca8:	73e020ef          	jal	800053e6 <panic>
    80002cac:	79a2                	ld	s3,40(sp)
    80002cae:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80002cb0:	4639                	li	a2,14
    80002cb2:	85d6                	mv	a1,s5
    80002cb4:	fb240513          	addi	a0,s0,-78
    80002cb8:	d8efd0ef          	jal	80000246 <strncpy>
  de.inum = inum;
    80002cbc:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002cc0:	4741                	li	a4,16
    80002cc2:	86a6                	mv	a3,s1
    80002cc4:	fb040613          	addi	a2,s0,-80
    80002cc8:	4581                	li	a1,0
    80002cca:	854a                	mv	a0,s2
    80002ccc:	c79ff0ef          	jal	80002944 <writei>
    80002cd0:	1541                	addi	a0,a0,-16
    80002cd2:	00a03533          	snez	a0,a0
    80002cd6:	40a0053b          	negw	a0,a0
    80002cda:	74e2                	ld	s1,56(sp)
}
    80002cdc:	60a6                	ld	ra,72(sp)
    80002cde:	6406                	ld	s0,64(sp)
    80002ce0:	7942                	ld	s2,48(sp)
    80002ce2:	6ae2                	ld	s5,24(sp)
    80002ce4:	6b42                	ld	s6,16(sp)
    80002ce6:	6161                	addi	sp,sp,80
    80002ce8:	8082                	ret

0000000080002cea <namei>:

struct inode*
namei(char *path)
{
    80002cea:	1101                	addi	sp,sp,-32
    80002cec:	ec06                	sd	ra,24(sp)
    80002cee:	e822                	sd	s0,16(sp)
    80002cf0:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002cf2:	fe040613          	addi	a2,s0,-32
    80002cf6:	4581                	li	a1,0
    80002cf8:	e13ff0ef          	jal	80002b0a <namex>
}
    80002cfc:	60e2                	ld	ra,24(sp)
    80002cfe:	6442                	ld	s0,16(sp)
    80002d00:	6105                	addi	sp,sp,32
    80002d02:	8082                	ret

0000000080002d04 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002d04:	1141                	addi	sp,sp,-16
    80002d06:	e406                	sd	ra,8(sp)
    80002d08:	e022                	sd	s0,0(sp)
    80002d0a:	0800                	addi	s0,sp,16
    80002d0c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002d0e:	4585                	li	a1,1
    80002d10:	dfbff0ef          	jal	80002b0a <namex>
}
    80002d14:	60a2                	ld	ra,8(sp)
    80002d16:	6402                	ld	s0,0(sp)
    80002d18:	0141                	addi	sp,sp,16
    80002d1a:	8082                	ret

0000000080002d1c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002d1c:	1101                	addi	sp,sp,-32
    80002d1e:	ec06                	sd	ra,24(sp)
    80002d20:	e822                	sd	s0,16(sp)
    80002d22:	e426                	sd	s1,8(sp)
    80002d24:	e04a                	sd	s2,0(sp)
    80002d26:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002d28:	00017917          	auipc	s2,0x17
    80002d2c:	56890913          	addi	s2,s2,1384 # 8001a290 <log>
    80002d30:	01892583          	lw	a1,24(s2)
    80002d34:	02892503          	lw	a0,40(s2)
    80002d38:	9b0ff0ef          	jal	80001ee8 <bread>
    80002d3c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002d3e:	02c92603          	lw	a2,44(s2)
    80002d42:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002d44:	00c05f63          	blez	a2,80002d62 <write_head+0x46>
    80002d48:	00017717          	auipc	a4,0x17
    80002d4c:	57870713          	addi	a4,a4,1400 # 8001a2c0 <log+0x30>
    80002d50:	87aa                	mv	a5,a0
    80002d52:	060a                	slli	a2,a2,0x2
    80002d54:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002d56:	4314                	lw	a3,0(a4)
    80002d58:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002d5a:	0711                	addi	a4,a4,4
    80002d5c:	0791                	addi	a5,a5,4
    80002d5e:	fec79ce3          	bne	a5,a2,80002d56 <write_head+0x3a>
  }
  bwrite(buf);
    80002d62:	8526                	mv	a0,s1
    80002d64:	a5aff0ef          	jal	80001fbe <bwrite>
  brelse(buf);
    80002d68:	8526                	mv	a0,s1
    80002d6a:	a86ff0ef          	jal	80001ff0 <brelse>
}
    80002d6e:	60e2                	ld	ra,24(sp)
    80002d70:	6442                	ld	s0,16(sp)
    80002d72:	64a2                	ld	s1,8(sp)
    80002d74:	6902                	ld	s2,0(sp)
    80002d76:	6105                	addi	sp,sp,32
    80002d78:	8082                	ret

0000000080002d7a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002d7a:	00017797          	auipc	a5,0x17
    80002d7e:	5427a783          	lw	a5,1346(a5) # 8001a2bc <log+0x2c>
    80002d82:	0af05263          	blez	a5,80002e26 <install_trans+0xac>
{
    80002d86:	715d                	addi	sp,sp,-80
    80002d88:	e486                	sd	ra,72(sp)
    80002d8a:	e0a2                	sd	s0,64(sp)
    80002d8c:	fc26                	sd	s1,56(sp)
    80002d8e:	f84a                	sd	s2,48(sp)
    80002d90:	f44e                	sd	s3,40(sp)
    80002d92:	f052                	sd	s4,32(sp)
    80002d94:	ec56                	sd	s5,24(sp)
    80002d96:	e85a                	sd	s6,16(sp)
    80002d98:	e45e                	sd	s7,8(sp)
    80002d9a:	0880                	addi	s0,sp,80
    80002d9c:	8b2a                	mv	s6,a0
    80002d9e:	00017a97          	auipc	s5,0x17
    80002da2:	522a8a93          	addi	s5,s5,1314 # 8001a2c0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002da6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002da8:	00017997          	auipc	s3,0x17
    80002dac:	4e898993          	addi	s3,s3,1256 # 8001a290 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002db0:	40000b93          	li	s7,1024
    80002db4:	a829                	j	80002dce <install_trans+0x54>
    brelse(lbuf);
    80002db6:	854a                	mv	a0,s2
    80002db8:	a38ff0ef          	jal	80001ff0 <brelse>
    brelse(dbuf);
    80002dbc:	8526                	mv	a0,s1
    80002dbe:	a32ff0ef          	jal	80001ff0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002dc2:	2a05                	addiw	s4,s4,1
    80002dc4:	0a91                	addi	s5,s5,4
    80002dc6:	02c9a783          	lw	a5,44(s3)
    80002dca:	04fa5363          	bge	s4,a5,80002e10 <install_trans+0x96>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002dce:	0189a583          	lw	a1,24(s3)
    80002dd2:	014585bb          	addw	a1,a1,s4
    80002dd6:	2585                	addiw	a1,a1,1
    80002dd8:	0289a503          	lw	a0,40(s3)
    80002ddc:	90cff0ef          	jal	80001ee8 <bread>
    80002de0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002de2:	000aa583          	lw	a1,0(s5)
    80002de6:	0289a503          	lw	a0,40(s3)
    80002dea:	8feff0ef          	jal	80001ee8 <bread>
    80002dee:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002df0:	865e                	mv	a2,s7
    80002df2:	05890593          	addi	a1,s2,88
    80002df6:	05850513          	addi	a0,a0,88
    80002dfa:	b9efd0ef          	jal	80000198 <memmove>
    bwrite(dbuf);  // write dst to disk
    80002dfe:	8526                	mv	a0,s1
    80002e00:	9beff0ef          	jal	80001fbe <bwrite>
    if(recovering == 0)
    80002e04:	fa0b19e3          	bnez	s6,80002db6 <install_trans+0x3c>
      bunpin(dbuf);
    80002e08:	8526                	mv	a0,s1
    80002e0a:	a9eff0ef          	jal	800020a8 <bunpin>
    80002e0e:	b765                	j	80002db6 <install_trans+0x3c>
}
    80002e10:	60a6                	ld	ra,72(sp)
    80002e12:	6406                	ld	s0,64(sp)
    80002e14:	74e2                	ld	s1,56(sp)
    80002e16:	7942                	ld	s2,48(sp)
    80002e18:	79a2                	ld	s3,40(sp)
    80002e1a:	7a02                	ld	s4,32(sp)
    80002e1c:	6ae2                	ld	s5,24(sp)
    80002e1e:	6b42                	ld	s6,16(sp)
    80002e20:	6ba2                	ld	s7,8(sp)
    80002e22:	6161                	addi	sp,sp,80
    80002e24:	8082                	ret
    80002e26:	8082                	ret

0000000080002e28 <initlog>:
{
    80002e28:	7179                	addi	sp,sp,-48
    80002e2a:	f406                	sd	ra,40(sp)
    80002e2c:	f022                	sd	s0,32(sp)
    80002e2e:	ec26                	sd	s1,24(sp)
    80002e30:	e84a                	sd	s2,16(sp)
    80002e32:	e44e                	sd	s3,8(sp)
    80002e34:	1800                	addi	s0,sp,48
    80002e36:	892a                	mv	s2,a0
    80002e38:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002e3a:	00017497          	auipc	s1,0x17
    80002e3e:	45648493          	addi	s1,s1,1110 # 8001a290 <log>
    80002e42:	00004597          	auipc	a1,0x4
    80002e46:	6c658593          	addi	a1,a1,1734 # 80007508 <etext+0x508>
    80002e4a:	8526                	mv	a0,s1
    80002e4c:	045020ef          	jal	80005690 <initlock>
  log.start = sb->logstart;
    80002e50:	0149a583          	lw	a1,20(s3)
    80002e54:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002e56:	0109a783          	lw	a5,16(s3)
    80002e5a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002e5c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002e60:	854a                	mv	a0,s2
    80002e62:	886ff0ef          	jal	80001ee8 <bread>
  log.lh.n = lh->n;
    80002e66:	4d30                	lw	a2,88(a0)
    80002e68:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002e6a:	00c05f63          	blez	a2,80002e88 <initlog+0x60>
    80002e6e:	87aa                	mv	a5,a0
    80002e70:	00017717          	auipc	a4,0x17
    80002e74:	45070713          	addi	a4,a4,1104 # 8001a2c0 <log+0x30>
    80002e78:	060a                	slli	a2,a2,0x2
    80002e7a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80002e7c:	4ff4                	lw	a3,92(a5)
    80002e7e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002e80:	0791                	addi	a5,a5,4
    80002e82:	0711                	addi	a4,a4,4
    80002e84:	fec79ce3          	bne	a5,a2,80002e7c <initlog+0x54>
  brelse(buf);
    80002e88:	968ff0ef          	jal	80001ff0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002e8c:	4505                	li	a0,1
    80002e8e:	eedff0ef          	jal	80002d7a <install_trans>
  log.lh.n = 0;
    80002e92:	00017797          	auipc	a5,0x17
    80002e96:	4207a523          	sw	zero,1066(a5) # 8001a2bc <log+0x2c>
  write_head(); // clear the log
    80002e9a:	e83ff0ef          	jal	80002d1c <write_head>
}
    80002e9e:	70a2                	ld	ra,40(sp)
    80002ea0:	7402                	ld	s0,32(sp)
    80002ea2:	64e2                	ld	s1,24(sp)
    80002ea4:	6942                	ld	s2,16(sp)
    80002ea6:	69a2                	ld	s3,8(sp)
    80002ea8:	6145                	addi	sp,sp,48
    80002eaa:	8082                	ret

0000000080002eac <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80002eac:	1101                	addi	sp,sp,-32
    80002eae:	ec06                	sd	ra,24(sp)
    80002eb0:	e822                	sd	s0,16(sp)
    80002eb2:	e426                	sd	s1,8(sp)
    80002eb4:	e04a                	sd	s2,0(sp)
    80002eb6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80002eb8:	00017517          	auipc	a0,0x17
    80002ebc:	3d850513          	addi	a0,a0,984 # 8001a290 <log>
    80002ec0:	055020ef          	jal	80005714 <acquire>
  while(1){
    if(log.committing){
    80002ec4:	00017497          	auipc	s1,0x17
    80002ec8:	3cc48493          	addi	s1,s1,972 # 8001a290 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002ecc:	4979                	li	s2,30
    80002ece:	a029                	j	80002ed8 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80002ed0:	85a6                	mv	a1,s1
    80002ed2:	8526                	mv	a0,s1
    80002ed4:	c44fe0ef          	jal	80001318 <sleep>
    if(log.committing){
    80002ed8:	50dc                	lw	a5,36(s1)
    80002eda:	fbfd                	bnez	a5,80002ed0 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002edc:	5098                	lw	a4,32(s1)
    80002ede:	2705                	addiw	a4,a4,1
    80002ee0:	0027179b          	slliw	a5,a4,0x2
    80002ee4:	9fb9                	addw	a5,a5,a4
    80002ee6:	0017979b          	slliw	a5,a5,0x1
    80002eea:	54d4                	lw	a3,44(s1)
    80002eec:	9fb5                	addw	a5,a5,a3
    80002eee:	00f95763          	bge	s2,a5,80002efc <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80002ef2:	85a6                	mv	a1,s1
    80002ef4:	8526                	mv	a0,s1
    80002ef6:	c22fe0ef          	jal	80001318 <sleep>
    80002efa:	bff9                	j	80002ed8 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80002efc:	00017517          	auipc	a0,0x17
    80002f00:	39450513          	addi	a0,a0,916 # 8001a290 <log>
    80002f04:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80002f06:	0a3020ef          	jal	800057a8 <release>
      break;
    }
  }
}
    80002f0a:	60e2                	ld	ra,24(sp)
    80002f0c:	6442                	ld	s0,16(sp)
    80002f0e:	64a2                	ld	s1,8(sp)
    80002f10:	6902                	ld	s2,0(sp)
    80002f12:	6105                	addi	sp,sp,32
    80002f14:	8082                	ret

0000000080002f16 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80002f16:	7139                	addi	sp,sp,-64
    80002f18:	fc06                	sd	ra,56(sp)
    80002f1a:	f822                	sd	s0,48(sp)
    80002f1c:	f426                	sd	s1,40(sp)
    80002f1e:	f04a                	sd	s2,32(sp)
    80002f20:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80002f22:	00017497          	auipc	s1,0x17
    80002f26:	36e48493          	addi	s1,s1,878 # 8001a290 <log>
    80002f2a:	8526                	mv	a0,s1
    80002f2c:	7e8020ef          	jal	80005714 <acquire>
  log.outstanding -= 1;
    80002f30:	509c                	lw	a5,32(s1)
    80002f32:	37fd                	addiw	a5,a5,-1
    80002f34:	893e                	mv	s2,a5
    80002f36:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80002f38:	50dc                	lw	a5,36(s1)
    80002f3a:	ef9d                	bnez	a5,80002f78 <end_op+0x62>
    panic("log.committing");
  if(log.outstanding == 0){
    80002f3c:	04091863          	bnez	s2,80002f8c <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80002f40:	00017497          	auipc	s1,0x17
    80002f44:	35048493          	addi	s1,s1,848 # 8001a290 <log>
    80002f48:	4785                	li	a5,1
    80002f4a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80002f4c:	8526                	mv	a0,s1
    80002f4e:	05b020ef          	jal	800057a8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80002f52:	54dc                	lw	a5,44(s1)
    80002f54:	04f04c63          	bgtz	a5,80002fac <end_op+0x96>
    acquire(&log.lock);
    80002f58:	00017497          	auipc	s1,0x17
    80002f5c:	33848493          	addi	s1,s1,824 # 8001a290 <log>
    80002f60:	8526                	mv	a0,s1
    80002f62:	7b2020ef          	jal	80005714 <acquire>
    log.committing = 0;
    80002f66:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80002f6a:	8526                	mv	a0,s1
    80002f6c:	bf8fe0ef          	jal	80001364 <wakeup>
    release(&log.lock);
    80002f70:	8526                	mv	a0,s1
    80002f72:	037020ef          	jal	800057a8 <release>
}
    80002f76:	a02d                	j	80002fa0 <end_op+0x8a>
    80002f78:	ec4e                	sd	s3,24(sp)
    80002f7a:	e852                	sd	s4,16(sp)
    80002f7c:	e456                	sd	s5,8(sp)
    80002f7e:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    80002f80:	00004517          	auipc	a0,0x4
    80002f84:	59050513          	addi	a0,a0,1424 # 80007510 <etext+0x510>
    80002f88:	45e020ef          	jal	800053e6 <panic>
    wakeup(&log);
    80002f8c:	00017497          	auipc	s1,0x17
    80002f90:	30448493          	addi	s1,s1,772 # 8001a290 <log>
    80002f94:	8526                	mv	a0,s1
    80002f96:	bcefe0ef          	jal	80001364 <wakeup>
  release(&log.lock);
    80002f9a:	8526                	mv	a0,s1
    80002f9c:	00d020ef          	jal	800057a8 <release>
}
    80002fa0:	70e2                	ld	ra,56(sp)
    80002fa2:	7442                	ld	s0,48(sp)
    80002fa4:	74a2                	ld	s1,40(sp)
    80002fa6:	7902                	ld	s2,32(sp)
    80002fa8:	6121                	addi	sp,sp,64
    80002faa:	8082                	ret
    80002fac:	ec4e                	sd	s3,24(sp)
    80002fae:	e852                	sd	s4,16(sp)
    80002fb0:	e456                	sd	s5,8(sp)
    80002fb2:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fb4:	00017a97          	auipc	s5,0x17
    80002fb8:	30ca8a93          	addi	s5,s5,780 # 8001a2c0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80002fbc:	00017a17          	auipc	s4,0x17
    80002fc0:	2d4a0a13          	addi	s4,s4,724 # 8001a290 <log>
    memmove(to->data, from->data, BSIZE);
    80002fc4:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80002fc8:	018a2583          	lw	a1,24(s4)
    80002fcc:	012585bb          	addw	a1,a1,s2
    80002fd0:	2585                	addiw	a1,a1,1
    80002fd2:	028a2503          	lw	a0,40(s4)
    80002fd6:	f13fe0ef          	jal	80001ee8 <bread>
    80002fda:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80002fdc:	000aa583          	lw	a1,0(s5)
    80002fe0:	028a2503          	lw	a0,40(s4)
    80002fe4:	f05fe0ef          	jal	80001ee8 <bread>
    80002fe8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80002fea:	865a                	mv	a2,s6
    80002fec:	05850593          	addi	a1,a0,88
    80002ff0:	05848513          	addi	a0,s1,88
    80002ff4:	9a4fd0ef          	jal	80000198 <memmove>
    bwrite(to);  // write the log
    80002ff8:	8526                	mv	a0,s1
    80002ffa:	fc5fe0ef          	jal	80001fbe <bwrite>
    brelse(from);
    80002ffe:	854e                	mv	a0,s3
    80003000:	ff1fe0ef          	jal	80001ff0 <brelse>
    brelse(to);
    80003004:	8526                	mv	a0,s1
    80003006:	febfe0ef          	jal	80001ff0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000300a:	2905                	addiw	s2,s2,1
    8000300c:	0a91                	addi	s5,s5,4
    8000300e:	02ca2783          	lw	a5,44(s4)
    80003012:	faf94be3          	blt	s2,a5,80002fc8 <end_op+0xb2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003016:	d07ff0ef          	jal	80002d1c <write_head>
    install_trans(0); // Now install writes to home locations
    8000301a:	4501                	li	a0,0
    8000301c:	d5fff0ef          	jal	80002d7a <install_trans>
    log.lh.n = 0;
    80003020:	00017797          	auipc	a5,0x17
    80003024:	2807ae23          	sw	zero,668(a5) # 8001a2bc <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003028:	cf5ff0ef          	jal	80002d1c <write_head>
    8000302c:	69e2                	ld	s3,24(sp)
    8000302e:	6a42                	ld	s4,16(sp)
    80003030:	6aa2                	ld	s5,8(sp)
    80003032:	6b02                	ld	s6,0(sp)
    80003034:	b715                	j	80002f58 <end_op+0x42>

0000000080003036 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003036:	1101                	addi	sp,sp,-32
    80003038:	ec06                	sd	ra,24(sp)
    8000303a:	e822                	sd	s0,16(sp)
    8000303c:	e426                	sd	s1,8(sp)
    8000303e:	e04a                	sd	s2,0(sp)
    80003040:	1000                	addi	s0,sp,32
    80003042:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003044:	00017917          	auipc	s2,0x17
    80003048:	24c90913          	addi	s2,s2,588 # 8001a290 <log>
    8000304c:	854a                	mv	a0,s2
    8000304e:	6c6020ef          	jal	80005714 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003052:	02c92603          	lw	a2,44(s2)
    80003056:	47f5                	li	a5,29
    80003058:	06c7c363          	blt	a5,a2,800030be <log_write+0x88>
    8000305c:	00017797          	auipc	a5,0x17
    80003060:	2507a783          	lw	a5,592(a5) # 8001a2ac <log+0x1c>
    80003064:	37fd                	addiw	a5,a5,-1
    80003066:	04f65c63          	bge	a2,a5,800030be <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000306a:	00017797          	auipc	a5,0x17
    8000306e:	2467a783          	lw	a5,582(a5) # 8001a2b0 <log+0x20>
    80003072:	04f05c63          	blez	a5,800030ca <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003076:	4781                	li	a5,0
    80003078:	04c05f63          	blez	a2,800030d6 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000307c:	44cc                	lw	a1,12(s1)
    8000307e:	00017717          	auipc	a4,0x17
    80003082:	24270713          	addi	a4,a4,578 # 8001a2c0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003086:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003088:	4314                	lw	a3,0(a4)
    8000308a:	04b68663          	beq	a3,a1,800030d6 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    8000308e:	2785                	addiw	a5,a5,1
    80003090:	0711                	addi	a4,a4,4
    80003092:	fef61be3          	bne	a2,a5,80003088 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003096:	0621                	addi	a2,a2,8
    80003098:	060a                	slli	a2,a2,0x2
    8000309a:	00017797          	auipc	a5,0x17
    8000309e:	1f678793          	addi	a5,a5,502 # 8001a290 <log>
    800030a2:	97b2                	add	a5,a5,a2
    800030a4:	44d8                	lw	a4,12(s1)
    800030a6:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800030a8:	8526                	mv	a0,s1
    800030aa:	fcbfe0ef          	jal	80002074 <bpin>
    log.lh.n++;
    800030ae:	00017717          	auipc	a4,0x17
    800030b2:	1e270713          	addi	a4,a4,482 # 8001a290 <log>
    800030b6:	575c                	lw	a5,44(a4)
    800030b8:	2785                	addiw	a5,a5,1
    800030ba:	d75c                	sw	a5,44(a4)
    800030bc:	a80d                	j	800030ee <log_write+0xb8>
    panic("too big a transaction");
    800030be:	00004517          	auipc	a0,0x4
    800030c2:	46250513          	addi	a0,a0,1122 # 80007520 <etext+0x520>
    800030c6:	320020ef          	jal	800053e6 <panic>
    panic("log_write outside of trans");
    800030ca:	00004517          	auipc	a0,0x4
    800030ce:	46e50513          	addi	a0,a0,1134 # 80007538 <etext+0x538>
    800030d2:	314020ef          	jal	800053e6 <panic>
  log.lh.block[i] = b->blockno;
    800030d6:	00878693          	addi	a3,a5,8
    800030da:	068a                	slli	a3,a3,0x2
    800030dc:	00017717          	auipc	a4,0x17
    800030e0:	1b470713          	addi	a4,a4,436 # 8001a290 <log>
    800030e4:	9736                	add	a4,a4,a3
    800030e6:	44d4                	lw	a3,12(s1)
    800030e8:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800030ea:	faf60fe3          	beq	a2,a5,800030a8 <log_write+0x72>
  }
  release(&log.lock);
    800030ee:	00017517          	auipc	a0,0x17
    800030f2:	1a250513          	addi	a0,a0,418 # 8001a290 <log>
    800030f6:	6b2020ef          	jal	800057a8 <release>
}
    800030fa:	60e2                	ld	ra,24(sp)
    800030fc:	6442                	ld	s0,16(sp)
    800030fe:	64a2                	ld	s1,8(sp)
    80003100:	6902                	ld	s2,0(sp)
    80003102:	6105                	addi	sp,sp,32
    80003104:	8082                	ret

0000000080003106 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003106:	1101                	addi	sp,sp,-32
    80003108:	ec06                	sd	ra,24(sp)
    8000310a:	e822                	sd	s0,16(sp)
    8000310c:	e426                	sd	s1,8(sp)
    8000310e:	e04a                	sd	s2,0(sp)
    80003110:	1000                	addi	s0,sp,32
    80003112:	84aa                	mv	s1,a0
    80003114:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003116:	00004597          	auipc	a1,0x4
    8000311a:	44258593          	addi	a1,a1,1090 # 80007558 <etext+0x558>
    8000311e:	0521                	addi	a0,a0,8
    80003120:	570020ef          	jal	80005690 <initlock>
  lk->name = name;
    80003124:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003128:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000312c:	0204a423          	sw	zero,40(s1)
}
    80003130:	60e2                	ld	ra,24(sp)
    80003132:	6442                	ld	s0,16(sp)
    80003134:	64a2                	ld	s1,8(sp)
    80003136:	6902                	ld	s2,0(sp)
    80003138:	6105                	addi	sp,sp,32
    8000313a:	8082                	ret

000000008000313c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000313c:	1101                	addi	sp,sp,-32
    8000313e:	ec06                	sd	ra,24(sp)
    80003140:	e822                	sd	s0,16(sp)
    80003142:	e426                	sd	s1,8(sp)
    80003144:	e04a                	sd	s2,0(sp)
    80003146:	1000                	addi	s0,sp,32
    80003148:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000314a:	00850913          	addi	s2,a0,8
    8000314e:	854a                	mv	a0,s2
    80003150:	5c4020ef          	jal	80005714 <acquire>
  while (lk->locked) {
    80003154:	409c                	lw	a5,0(s1)
    80003156:	c799                	beqz	a5,80003164 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003158:	85ca                	mv	a1,s2
    8000315a:	8526                	mv	a0,s1
    8000315c:	9bcfe0ef          	jal	80001318 <sleep>
  while (lk->locked) {
    80003160:	409c                	lw	a5,0(s1)
    80003162:	fbfd                	bnez	a5,80003158 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003164:	4785                	li	a5,1
    80003166:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003168:	be3fd0ef          	jal	80000d4a <myproc>
    8000316c:	591c                	lw	a5,48(a0)
    8000316e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003170:	854a                	mv	a0,s2
    80003172:	636020ef          	jal	800057a8 <release>
}
    80003176:	60e2                	ld	ra,24(sp)
    80003178:	6442                	ld	s0,16(sp)
    8000317a:	64a2                	ld	s1,8(sp)
    8000317c:	6902                	ld	s2,0(sp)
    8000317e:	6105                	addi	sp,sp,32
    80003180:	8082                	ret

0000000080003182 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003182:	1101                	addi	sp,sp,-32
    80003184:	ec06                	sd	ra,24(sp)
    80003186:	e822                	sd	s0,16(sp)
    80003188:	e426                	sd	s1,8(sp)
    8000318a:	e04a                	sd	s2,0(sp)
    8000318c:	1000                	addi	s0,sp,32
    8000318e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003190:	00850913          	addi	s2,a0,8
    80003194:	854a                	mv	a0,s2
    80003196:	57e020ef          	jal	80005714 <acquire>
  lk->locked = 0;
    8000319a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000319e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800031a2:	8526                	mv	a0,s1
    800031a4:	9c0fe0ef          	jal	80001364 <wakeup>
  release(&lk->lk);
    800031a8:	854a                	mv	a0,s2
    800031aa:	5fe020ef          	jal	800057a8 <release>
}
    800031ae:	60e2                	ld	ra,24(sp)
    800031b0:	6442                	ld	s0,16(sp)
    800031b2:	64a2                	ld	s1,8(sp)
    800031b4:	6902                	ld	s2,0(sp)
    800031b6:	6105                	addi	sp,sp,32
    800031b8:	8082                	ret

00000000800031ba <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800031ba:	7179                	addi	sp,sp,-48
    800031bc:	f406                	sd	ra,40(sp)
    800031be:	f022                	sd	s0,32(sp)
    800031c0:	ec26                	sd	s1,24(sp)
    800031c2:	e84a                	sd	s2,16(sp)
    800031c4:	1800                	addi	s0,sp,48
    800031c6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800031c8:	00850913          	addi	s2,a0,8
    800031cc:	854a                	mv	a0,s2
    800031ce:	546020ef          	jal	80005714 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800031d2:	409c                	lw	a5,0(s1)
    800031d4:	ef81                	bnez	a5,800031ec <holdingsleep+0x32>
    800031d6:	4481                	li	s1,0
  release(&lk->lk);
    800031d8:	854a                	mv	a0,s2
    800031da:	5ce020ef          	jal	800057a8 <release>
  return r;
}
    800031de:	8526                	mv	a0,s1
    800031e0:	70a2                	ld	ra,40(sp)
    800031e2:	7402                	ld	s0,32(sp)
    800031e4:	64e2                	ld	s1,24(sp)
    800031e6:	6942                	ld	s2,16(sp)
    800031e8:	6145                	addi	sp,sp,48
    800031ea:	8082                	ret
    800031ec:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800031ee:	0284a983          	lw	s3,40(s1)
    800031f2:	b59fd0ef          	jal	80000d4a <myproc>
    800031f6:	5904                	lw	s1,48(a0)
    800031f8:	413484b3          	sub	s1,s1,s3
    800031fc:	0014b493          	seqz	s1,s1
    80003200:	69a2                	ld	s3,8(sp)
    80003202:	bfd9                	j	800031d8 <holdingsleep+0x1e>

0000000080003204 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003204:	1141                	addi	sp,sp,-16
    80003206:	e406                	sd	ra,8(sp)
    80003208:	e022                	sd	s0,0(sp)
    8000320a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000320c:	00004597          	auipc	a1,0x4
    80003210:	35c58593          	addi	a1,a1,860 # 80007568 <etext+0x568>
    80003214:	00017517          	auipc	a0,0x17
    80003218:	1c450513          	addi	a0,a0,452 # 8001a3d8 <ftable>
    8000321c:	474020ef          	jal	80005690 <initlock>
}
    80003220:	60a2                	ld	ra,8(sp)
    80003222:	6402                	ld	s0,0(sp)
    80003224:	0141                	addi	sp,sp,16
    80003226:	8082                	ret

0000000080003228 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003228:	1101                	addi	sp,sp,-32
    8000322a:	ec06                	sd	ra,24(sp)
    8000322c:	e822                	sd	s0,16(sp)
    8000322e:	e426                	sd	s1,8(sp)
    80003230:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003232:	00017517          	auipc	a0,0x17
    80003236:	1a650513          	addi	a0,a0,422 # 8001a3d8 <ftable>
    8000323a:	4da020ef          	jal	80005714 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000323e:	00017497          	auipc	s1,0x17
    80003242:	1b248493          	addi	s1,s1,434 # 8001a3f0 <ftable+0x18>
    80003246:	00018717          	auipc	a4,0x18
    8000324a:	14a70713          	addi	a4,a4,330 # 8001b390 <disk>
    if(f->ref == 0){
    8000324e:	40dc                	lw	a5,4(s1)
    80003250:	cf89                	beqz	a5,8000326a <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003252:	02848493          	addi	s1,s1,40
    80003256:	fee49ce3          	bne	s1,a4,8000324e <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000325a:	00017517          	auipc	a0,0x17
    8000325e:	17e50513          	addi	a0,a0,382 # 8001a3d8 <ftable>
    80003262:	546020ef          	jal	800057a8 <release>
  return 0;
    80003266:	4481                	li	s1,0
    80003268:	a809                	j	8000327a <filealloc+0x52>
      f->ref = 1;
    8000326a:	4785                	li	a5,1
    8000326c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000326e:	00017517          	auipc	a0,0x17
    80003272:	16a50513          	addi	a0,a0,362 # 8001a3d8 <ftable>
    80003276:	532020ef          	jal	800057a8 <release>
}
    8000327a:	8526                	mv	a0,s1
    8000327c:	60e2                	ld	ra,24(sp)
    8000327e:	6442                	ld	s0,16(sp)
    80003280:	64a2                	ld	s1,8(sp)
    80003282:	6105                	addi	sp,sp,32
    80003284:	8082                	ret

0000000080003286 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003286:	1101                	addi	sp,sp,-32
    80003288:	ec06                	sd	ra,24(sp)
    8000328a:	e822                	sd	s0,16(sp)
    8000328c:	e426                	sd	s1,8(sp)
    8000328e:	1000                	addi	s0,sp,32
    80003290:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003292:	00017517          	auipc	a0,0x17
    80003296:	14650513          	addi	a0,a0,326 # 8001a3d8 <ftable>
    8000329a:	47a020ef          	jal	80005714 <acquire>
  if(f->ref < 1)
    8000329e:	40dc                	lw	a5,4(s1)
    800032a0:	02f05063          	blez	a5,800032c0 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800032a4:	2785                	addiw	a5,a5,1
    800032a6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800032a8:	00017517          	auipc	a0,0x17
    800032ac:	13050513          	addi	a0,a0,304 # 8001a3d8 <ftable>
    800032b0:	4f8020ef          	jal	800057a8 <release>
  return f;
}
    800032b4:	8526                	mv	a0,s1
    800032b6:	60e2                	ld	ra,24(sp)
    800032b8:	6442                	ld	s0,16(sp)
    800032ba:	64a2                	ld	s1,8(sp)
    800032bc:	6105                	addi	sp,sp,32
    800032be:	8082                	ret
    panic("filedup");
    800032c0:	00004517          	auipc	a0,0x4
    800032c4:	2b050513          	addi	a0,a0,688 # 80007570 <etext+0x570>
    800032c8:	11e020ef          	jal	800053e6 <panic>

00000000800032cc <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800032cc:	7139                	addi	sp,sp,-64
    800032ce:	fc06                	sd	ra,56(sp)
    800032d0:	f822                	sd	s0,48(sp)
    800032d2:	f426                	sd	s1,40(sp)
    800032d4:	0080                	addi	s0,sp,64
    800032d6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800032d8:	00017517          	auipc	a0,0x17
    800032dc:	10050513          	addi	a0,a0,256 # 8001a3d8 <ftable>
    800032e0:	434020ef          	jal	80005714 <acquire>
  if(f->ref < 1)
    800032e4:	40dc                	lw	a5,4(s1)
    800032e6:	04f05863          	blez	a5,80003336 <fileclose+0x6a>
    panic("fileclose");
  if(--f->ref > 0){
    800032ea:	37fd                	addiw	a5,a5,-1
    800032ec:	c0dc                	sw	a5,4(s1)
    800032ee:	04f04e63          	bgtz	a5,8000334a <fileclose+0x7e>
    800032f2:	f04a                	sd	s2,32(sp)
    800032f4:	ec4e                	sd	s3,24(sp)
    800032f6:	e852                	sd	s4,16(sp)
    800032f8:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800032fa:	0004a903          	lw	s2,0(s1)
    800032fe:	0094ca83          	lbu	s5,9(s1)
    80003302:	0104ba03          	ld	s4,16(s1)
    80003306:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000330a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000330e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003312:	00017517          	auipc	a0,0x17
    80003316:	0c650513          	addi	a0,a0,198 # 8001a3d8 <ftable>
    8000331a:	48e020ef          	jal	800057a8 <release>

  if(ff.type == FD_PIPE){
    8000331e:	4785                	li	a5,1
    80003320:	04f90063          	beq	s2,a5,80003360 <fileclose+0x94>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003324:	3979                	addiw	s2,s2,-2
    80003326:	4785                	li	a5,1
    80003328:	0527f563          	bgeu	a5,s2,80003372 <fileclose+0xa6>
    8000332c:	7902                	ld	s2,32(sp)
    8000332e:	69e2                	ld	s3,24(sp)
    80003330:	6a42                	ld	s4,16(sp)
    80003332:	6aa2                	ld	s5,8(sp)
    80003334:	a00d                	j	80003356 <fileclose+0x8a>
    80003336:	f04a                	sd	s2,32(sp)
    80003338:	ec4e                	sd	s3,24(sp)
    8000333a:	e852                	sd	s4,16(sp)
    8000333c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000333e:	00004517          	auipc	a0,0x4
    80003342:	23a50513          	addi	a0,a0,570 # 80007578 <etext+0x578>
    80003346:	0a0020ef          	jal	800053e6 <panic>
    release(&ftable.lock);
    8000334a:	00017517          	auipc	a0,0x17
    8000334e:	08e50513          	addi	a0,a0,142 # 8001a3d8 <ftable>
    80003352:	456020ef          	jal	800057a8 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003356:	70e2                	ld	ra,56(sp)
    80003358:	7442                	ld	s0,48(sp)
    8000335a:	74a2                	ld	s1,40(sp)
    8000335c:	6121                	addi	sp,sp,64
    8000335e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003360:	85d6                	mv	a1,s5
    80003362:	8552                	mv	a0,s4
    80003364:	340000ef          	jal	800036a4 <pipeclose>
    80003368:	7902                	ld	s2,32(sp)
    8000336a:	69e2                	ld	s3,24(sp)
    8000336c:	6a42                	ld	s4,16(sp)
    8000336e:	6aa2                	ld	s5,8(sp)
    80003370:	b7dd                	j	80003356 <fileclose+0x8a>
    begin_op();
    80003372:	b3bff0ef          	jal	80002eac <begin_op>
    iput(ff.ip);
    80003376:	854e                	mv	a0,s3
    80003378:	c04ff0ef          	jal	8000277c <iput>
    end_op();
    8000337c:	b9bff0ef          	jal	80002f16 <end_op>
    80003380:	7902                	ld	s2,32(sp)
    80003382:	69e2                	ld	s3,24(sp)
    80003384:	6a42                	ld	s4,16(sp)
    80003386:	6aa2                	ld	s5,8(sp)
    80003388:	b7f9                	j	80003356 <fileclose+0x8a>

000000008000338a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000338a:	715d                	addi	sp,sp,-80
    8000338c:	e486                	sd	ra,72(sp)
    8000338e:	e0a2                	sd	s0,64(sp)
    80003390:	fc26                	sd	s1,56(sp)
    80003392:	f44e                	sd	s3,40(sp)
    80003394:	0880                	addi	s0,sp,80
    80003396:	84aa                	mv	s1,a0
    80003398:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000339a:	9b1fd0ef          	jal	80000d4a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000339e:	409c                	lw	a5,0(s1)
    800033a0:	37f9                	addiw	a5,a5,-2
    800033a2:	4705                	li	a4,1
    800033a4:	04f76263          	bltu	a4,a5,800033e8 <filestat+0x5e>
    800033a8:	f84a                	sd	s2,48(sp)
    800033aa:	f052                	sd	s4,32(sp)
    800033ac:	892a                	mv	s2,a0
    ilock(f->ip);
    800033ae:	6c88                	ld	a0,24(s1)
    800033b0:	a4aff0ef          	jal	800025fa <ilock>
    stati(f->ip, &st);
    800033b4:	fb840a13          	addi	s4,s0,-72
    800033b8:	85d2                	mv	a1,s4
    800033ba:	6c88                	ld	a0,24(s1)
    800033bc:	c68ff0ef          	jal	80002824 <stati>
    iunlock(f->ip);
    800033c0:	6c88                	ld	a0,24(s1)
    800033c2:	ae6ff0ef          	jal	800026a8 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800033c6:	46e1                	li	a3,24
    800033c8:	8652                	mv	a2,s4
    800033ca:	85ce                	mv	a1,s3
    800033cc:	05093503          	ld	a0,80(s2)
    800033d0:	e22fd0ef          	jal	800009f2 <copyout>
    800033d4:	41f5551b          	sraiw	a0,a0,0x1f
    800033d8:	7942                	ld	s2,48(sp)
    800033da:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800033dc:	60a6                	ld	ra,72(sp)
    800033de:	6406                	ld	s0,64(sp)
    800033e0:	74e2                	ld	s1,56(sp)
    800033e2:	79a2                	ld	s3,40(sp)
    800033e4:	6161                	addi	sp,sp,80
    800033e6:	8082                	ret
  return -1;
    800033e8:	557d                	li	a0,-1
    800033ea:	bfcd                	j	800033dc <filestat+0x52>

00000000800033ec <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800033ec:	7179                	addi	sp,sp,-48
    800033ee:	f406                	sd	ra,40(sp)
    800033f0:	f022                	sd	s0,32(sp)
    800033f2:	e84a                	sd	s2,16(sp)
    800033f4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800033f6:	00854783          	lbu	a5,8(a0)
    800033fa:	cfd1                	beqz	a5,80003496 <fileread+0xaa>
    800033fc:	ec26                	sd	s1,24(sp)
    800033fe:	e44e                	sd	s3,8(sp)
    80003400:	84aa                	mv	s1,a0
    80003402:	89ae                	mv	s3,a1
    80003404:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003406:	411c                	lw	a5,0(a0)
    80003408:	4705                	li	a4,1
    8000340a:	04e78363          	beq	a5,a4,80003450 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000340e:	470d                	li	a4,3
    80003410:	04e78763          	beq	a5,a4,8000345e <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003414:	4709                	li	a4,2
    80003416:	06e79a63          	bne	a5,a4,8000348a <fileread+0x9e>
    ilock(f->ip);
    8000341a:	6d08                	ld	a0,24(a0)
    8000341c:	9deff0ef          	jal	800025fa <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003420:	874a                	mv	a4,s2
    80003422:	5094                	lw	a3,32(s1)
    80003424:	864e                	mv	a2,s3
    80003426:	4585                	li	a1,1
    80003428:	6c88                	ld	a0,24(s1)
    8000342a:	c28ff0ef          	jal	80002852 <readi>
    8000342e:	892a                	mv	s2,a0
    80003430:	00a05563          	blez	a0,8000343a <fileread+0x4e>
      f->off += r;
    80003434:	509c                	lw	a5,32(s1)
    80003436:	9fa9                	addw	a5,a5,a0
    80003438:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000343a:	6c88                	ld	a0,24(s1)
    8000343c:	a6cff0ef          	jal	800026a8 <iunlock>
    80003440:	64e2                	ld	s1,24(sp)
    80003442:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003444:	854a                	mv	a0,s2
    80003446:	70a2                	ld	ra,40(sp)
    80003448:	7402                	ld	s0,32(sp)
    8000344a:	6942                	ld	s2,16(sp)
    8000344c:	6145                	addi	sp,sp,48
    8000344e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003450:	6908                	ld	a0,16(a0)
    80003452:	3a2000ef          	jal	800037f4 <piperead>
    80003456:	892a                	mv	s2,a0
    80003458:	64e2                	ld	s1,24(sp)
    8000345a:	69a2                	ld	s3,8(sp)
    8000345c:	b7e5                	j	80003444 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000345e:	02451783          	lh	a5,36(a0)
    80003462:	03079693          	slli	a3,a5,0x30
    80003466:	92c1                	srli	a3,a3,0x30
    80003468:	4725                	li	a4,9
    8000346a:	02d76863          	bltu	a4,a3,8000349a <fileread+0xae>
    8000346e:	0792                	slli	a5,a5,0x4
    80003470:	00017717          	auipc	a4,0x17
    80003474:	ec870713          	addi	a4,a4,-312 # 8001a338 <devsw>
    80003478:	97ba                	add	a5,a5,a4
    8000347a:	639c                	ld	a5,0(a5)
    8000347c:	c39d                	beqz	a5,800034a2 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    8000347e:	4505                	li	a0,1
    80003480:	9782                	jalr	a5
    80003482:	892a                	mv	s2,a0
    80003484:	64e2                	ld	s1,24(sp)
    80003486:	69a2                	ld	s3,8(sp)
    80003488:	bf75                	j	80003444 <fileread+0x58>
    panic("fileread");
    8000348a:	00004517          	auipc	a0,0x4
    8000348e:	0fe50513          	addi	a0,a0,254 # 80007588 <etext+0x588>
    80003492:	755010ef          	jal	800053e6 <panic>
    return -1;
    80003496:	597d                	li	s2,-1
    80003498:	b775                	j	80003444 <fileread+0x58>
      return -1;
    8000349a:	597d                	li	s2,-1
    8000349c:	64e2                	ld	s1,24(sp)
    8000349e:	69a2                	ld	s3,8(sp)
    800034a0:	b755                	j	80003444 <fileread+0x58>
    800034a2:	597d                	li	s2,-1
    800034a4:	64e2                	ld	s1,24(sp)
    800034a6:	69a2                	ld	s3,8(sp)
    800034a8:	bf71                	j	80003444 <fileread+0x58>

00000000800034aa <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800034aa:	00954783          	lbu	a5,9(a0)
    800034ae:	10078e63          	beqz	a5,800035ca <filewrite+0x120>
{
    800034b2:	711d                	addi	sp,sp,-96
    800034b4:	ec86                	sd	ra,88(sp)
    800034b6:	e8a2                	sd	s0,80(sp)
    800034b8:	e0ca                	sd	s2,64(sp)
    800034ba:	f456                	sd	s5,40(sp)
    800034bc:	f05a                	sd	s6,32(sp)
    800034be:	1080                	addi	s0,sp,96
    800034c0:	892a                	mv	s2,a0
    800034c2:	8b2e                	mv	s6,a1
    800034c4:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    800034c6:	411c                	lw	a5,0(a0)
    800034c8:	4705                	li	a4,1
    800034ca:	02e78963          	beq	a5,a4,800034fc <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800034ce:	470d                	li	a4,3
    800034d0:	02e78a63          	beq	a5,a4,80003504 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800034d4:	4709                	li	a4,2
    800034d6:	0ce79e63          	bne	a5,a4,800035b2 <filewrite+0x108>
    800034da:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800034dc:	0ac05963          	blez	a2,8000358e <filewrite+0xe4>
    800034e0:	e4a6                	sd	s1,72(sp)
    800034e2:	fc4e                	sd	s3,56(sp)
    800034e4:	ec5e                	sd	s7,24(sp)
    800034e6:	e862                	sd	s8,16(sp)
    800034e8:	e466                	sd	s9,8(sp)
    int i = 0;
    800034ea:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    800034ec:	6b85                	lui	s7,0x1
    800034ee:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800034f2:	6c85                	lui	s9,0x1
    800034f4:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800034f8:	4c05                	li	s8,1
    800034fa:	a8ad                	j	80003574 <filewrite+0xca>
    ret = pipewrite(f->pipe, addr, n);
    800034fc:	6908                	ld	a0,16(a0)
    800034fe:	1fe000ef          	jal	800036fc <pipewrite>
    80003502:	a04d                	j	800035a4 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003504:	02451783          	lh	a5,36(a0)
    80003508:	03079693          	slli	a3,a5,0x30
    8000350c:	92c1                	srli	a3,a3,0x30
    8000350e:	4725                	li	a4,9
    80003510:	0ad76f63          	bltu	a4,a3,800035ce <filewrite+0x124>
    80003514:	0792                	slli	a5,a5,0x4
    80003516:	00017717          	auipc	a4,0x17
    8000351a:	e2270713          	addi	a4,a4,-478 # 8001a338 <devsw>
    8000351e:	97ba                	add	a5,a5,a4
    80003520:	679c                	ld	a5,8(a5)
    80003522:	cbc5                	beqz	a5,800035d2 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003524:	4505                	li	a0,1
    80003526:	9782                	jalr	a5
    80003528:	a8b5                	j	800035a4 <filewrite+0xfa>
      if(n1 > max)
    8000352a:	2981                	sext.w	s3,s3
      begin_op();
    8000352c:	981ff0ef          	jal	80002eac <begin_op>
      ilock(f->ip);
    80003530:	01893503          	ld	a0,24(s2)
    80003534:	8c6ff0ef          	jal	800025fa <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003538:	874e                	mv	a4,s3
    8000353a:	02092683          	lw	a3,32(s2)
    8000353e:	016a0633          	add	a2,s4,s6
    80003542:	85e2                	mv	a1,s8
    80003544:	01893503          	ld	a0,24(s2)
    80003548:	bfcff0ef          	jal	80002944 <writei>
    8000354c:	84aa                	mv	s1,a0
    8000354e:	00a05763          	blez	a0,8000355c <filewrite+0xb2>
        f->off += r;
    80003552:	02092783          	lw	a5,32(s2)
    80003556:	9fa9                	addw	a5,a5,a0
    80003558:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000355c:	01893503          	ld	a0,24(s2)
    80003560:	948ff0ef          	jal	800026a8 <iunlock>
      end_op();
    80003564:	9b3ff0ef          	jal	80002f16 <end_op>

      if(r != n1){
    80003568:	02999563          	bne	s3,s1,80003592 <filewrite+0xe8>
        // error from writei
        break;
      }
      i += r;
    8000356c:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003570:	015a5963          	bge	s4,s5,80003582 <filewrite+0xd8>
      int n1 = n - i;
    80003574:	414a87bb          	subw	a5,s5,s4
    80003578:	89be                	mv	s3,a5
      if(n1 > max)
    8000357a:	fafbd8e3          	bge	s7,a5,8000352a <filewrite+0x80>
    8000357e:	89e6                	mv	s3,s9
    80003580:	b76d                	j	8000352a <filewrite+0x80>
    80003582:	64a6                	ld	s1,72(sp)
    80003584:	79e2                	ld	s3,56(sp)
    80003586:	6be2                	ld	s7,24(sp)
    80003588:	6c42                	ld	s8,16(sp)
    8000358a:	6ca2                	ld	s9,8(sp)
    8000358c:	a801                	j	8000359c <filewrite+0xf2>
    int i = 0;
    8000358e:	4a01                	li	s4,0
    80003590:	a031                	j	8000359c <filewrite+0xf2>
    80003592:	64a6                	ld	s1,72(sp)
    80003594:	79e2                	ld	s3,56(sp)
    80003596:	6be2                	ld	s7,24(sp)
    80003598:	6c42                	ld	s8,16(sp)
    8000359a:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    8000359c:	034a9d63          	bne	s5,s4,800035d6 <filewrite+0x12c>
    800035a0:	8556                	mv	a0,s5
    800035a2:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800035a4:	60e6                	ld	ra,88(sp)
    800035a6:	6446                	ld	s0,80(sp)
    800035a8:	6906                	ld	s2,64(sp)
    800035aa:	7aa2                	ld	s5,40(sp)
    800035ac:	7b02                	ld	s6,32(sp)
    800035ae:	6125                	addi	sp,sp,96
    800035b0:	8082                	ret
    800035b2:	e4a6                	sd	s1,72(sp)
    800035b4:	fc4e                	sd	s3,56(sp)
    800035b6:	f852                	sd	s4,48(sp)
    800035b8:	ec5e                	sd	s7,24(sp)
    800035ba:	e862                	sd	s8,16(sp)
    800035bc:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800035be:	00004517          	auipc	a0,0x4
    800035c2:	fda50513          	addi	a0,a0,-38 # 80007598 <etext+0x598>
    800035c6:	621010ef          	jal	800053e6 <panic>
    return -1;
    800035ca:	557d                	li	a0,-1
}
    800035cc:	8082                	ret
      return -1;
    800035ce:	557d                	li	a0,-1
    800035d0:	bfd1                	j	800035a4 <filewrite+0xfa>
    800035d2:	557d                	li	a0,-1
    800035d4:	bfc1                	j	800035a4 <filewrite+0xfa>
    ret = (i == n ? n : -1);
    800035d6:	557d                	li	a0,-1
    800035d8:	7a42                	ld	s4,48(sp)
    800035da:	b7e9                	j	800035a4 <filewrite+0xfa>

00000000800035dc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800035dc:	7179                	addi	sp,sp,-48
    800035de:	f406                	sd	ra,40(sp)
    800035e0:	f022                	sd	s0,32(sp)
    800035e2:	ec26                	sd	s1,24(sp)
    800035e4:	e052                	sd	s4,0(sp)
    800035e6:	1800                	addi	s0,sp,48
    800035e8:	84aa                	mv	s1,a0
    800035ea:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800035ec:	0005b023          	sd	zero,0(a1)
    800035f0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800035f4:	c35ff0ef          	jal	80003228 <filealloc>
    800035f8:	e088                	sd	a0,0(s1)
    800035fa:	c549                	beqz	a0,80003684 <pipealloc+0xa8>
    800035fc:	c2dff0ef          	jal	80003228 <filealloc>
    80003600:	00aa3023          	sd	a0,0(s4)
    80003604:	cd25                	beqz	a0,8000367c <pipealloc+0xa0>
    80003606:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003608:	aeffc0ef          	jal	800000f6 <kalloc>
    8000360c:	892a                	mv	s2,a0
    8000360e:	c12d                	beqz	a0,80003670 <pipealloc+0x94>
    80003610:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003612:	4985                	li	s3,1
    80003614:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003618:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000361c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003620:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003624:	00004597          	auipc	a1,0x4
    80003628:	f8458593          	addi	a1,a1,-124 # 800075a8 <etext+0x5a8>
    8000362c:	064020ef          	jal	80005690 <initlock>
  (*f0)->type = FD_PIPE;
    80003630:	609c                	ld	a5,0(s1)
    80003632:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003636:	609c                	ld	a5,0(s1)
    80003638:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000363c:	609c                	ld	a5,0(s1)
    8000363e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003642:	609c                	ld	a5,0(s1)
    80003644:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003648:	000a3783          	ld	a5,0(s4)
    8000364c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003650:	000a3783          	ld	a5,0(s4)
    80003654:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003658:	000a3783          	ld	a5,0(s4)
    8000365c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003660:	000a3783          	ld	a5,0(s4)
    80003664:	0127b823          	sd	s2,16(a5)
  return 0;
    80003668:	4501                	li	a0,0
    8000366a:	6942                	ld	s2,16(sp)
    8000366c:	69a2                	ld	s3,8(sp)
    8000366e:	a01d                	j	80003694 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003670:	6088                	ld	a0,0(s1)
    80003672:	c119                	beqz	a0,80003678 <pipealloc+0x9c>
    80003674:	6942                	ld	s2,16(sp)
    80003676:	a029                	j	80003680 <pipealloc+0xa4>
    80003678:	6942                	ld	s2,16(sp)
    8000367a:	a029                	j	80003684 <pipealloc+0xa8>
    8000367c:	6088                	ld	a0,0(s1)
    8000367e:	c10d                	beqz	a0,800036a0 <pipealloc+0xc4>
    fileclose(*f0);
    80003680:	c4dff0ef          	jal	800032cc <fileclose>
  if(*f1)
    80003684:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003688:	557d                	li	a0,-1
  if(*f1)
    8000368a:	c789                	beqz	a5,80003694 <pipealloc+0xb8>
    fileclose(*f1);
    8000368c:	853e                	mv	a0,a5
    8000368e:	c3fff0ef          	jal	800032cc <fileclose>
  return -1;
    80003692:	557d                	li	a0,-1
}
    80003694:	70a2                	ld	ra,40(sp)
    80003696:	7402                	ld	s0,32(sp)
    80003698:	64e2                	ld	s1,24(sp)
    8000369a:	6a02                	ld	s4,0(sp)
    8000369c:	6145                	addi	sp,sp,48
    8000369e:	8082                	ret
  return -1;
    800036a0:	557d                	li	a0,-1
    800036a2:	bfcd                	j	80003694 <pipealloc+0xb8>

00000000800036a4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800036a4:	1101                	addi	sp,sp,-32
    800036a6:	ec06                	sd	ra,24(sp)
    800036a8:	e822                	sd	s0,16(sp)
    800036aa:	e426                	sd	s1,8(sp)
    800036ac:	e04a                	sd	s2,0(sp)
    800036ae:	1000                	addi	s0,sp,32
    800036b0:	84aa                	mv	s1,a0
    800036b2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800036b4:	060020ef          	jal	80005714 <acquire>
  if(writable){
    800036b8:	02090763          	beqz	s2,800036e6 <pipeclose+0x42>
    pi->writeopen = 0;
    800036bc:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800036c0:	21848513          	addi	a0,s1,536
    800036c4:	ca1fd0ef          	jal	80001364 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800036c8:	2204b783          	ld	a5,544(s1)
    800036cc:	e785                	bnez	a5,800036f4 <pipeclose+0x50>
    release(&pi->lock);
    800036ce:	8526                	mv	a0,s1
    800036d0:	0d8020ef          	jal	800057a8 <release>
    kfree((char*)pi);
    800036d4:	8526                	mv	a0,s1
    800036d6:	947fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    800036da:	60e2                	ld	ra,24(sp)
    800036dc:	6442                	ld	s0,16(sp)
    800036de:	64a2                	ld	s1,8(sp)
    800036e0:	6902                	ld	s2,0(sp)
    800036e2:	6105                	addi	sp,sp,32
    800036e4:	8082                	ret
    pi->readopen = 0;
    800036e6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800036ea:	21c48513          	addi	a0,s1,540
    800036ee:	c77fd0ef          	jal	80001364 <wakeup>
    800036f2:	bfd9                	j	800036c8 <pipeclose+0x24>
    release(&pi->lock);
    800036f4:	8526                	mv	a0,s1
    800036f6:	0b2020ef          	jal	800057a8 <release>
}
    800036fa:	b7c5                	j	800036da <pipeclose+0x36>

00000000800036fc <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800036fc:	7159                	addi	sp,sp,-112
    800036fe:	f486                	sd	ra,104(sp)
    80003700:	f0a2                	sd	s0,96(sp)
    80003702:	eca6                	sd	s1,88(sp)
    80003704:	e8ca                	sd	s2,80(sp)
    80003706:	e4ce                	sd	s3,72(sp)
    80003708:	e0d2                	sd	s4,64(sp)
    8000370a:	fc56                	sd	s5,56(sp)
    8000370c:	1880                	addi	s0,sp,112
    8000370e:	84aa                	mv	s1,a0
    80003710:	8aae                	mv	s5,a1
    80003712:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003714:	e36fd0ef          	jal	80000d4a <myproc>
    80003718:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000371a:	8526                	mv	a0,s1
    8000371c:	7f9010ef          	jal	80005714 <acquire>
  while(i < n){
    80003720:	0d405263          	blez	s4,800037e4 <pipewrite+0xe8>
    80003724:	f85a                	sd	s6,48(sp)
    80003726:	f45e                	sd	s7,40(sp)
    80003728:	f062                	sd	s8,32(sp)
    8000372a:	ec66                	sd	s9,24(sp)
    8000372c:	e86a                	sd	s10,16(sp)
  int i = 0;
    8000372e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003730:	f9f40c13          	addi	s8,s0,-97
    80003734:	4b85                	li	s7,1
    80003736:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003738:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000373c:	21c48c93          	addi	s9,s1,540
    80003740:	a82d                	j	8000377a <pipewrite+0x7e>
      release(&pi->lock);
    80003742:	8526                	mv	a0,s1
    80003744:	064020ef          	jal	800057a8 <release>
      return -1;
    80003748:	597d                	li	s2,-1
    8000374a:	7b42                	ld	s6,48(sp)
    8000374c:	7ba2                	ld	s7,40(sp)
    8000374e:	7c02                	ld	s8,32(sp)
    80003750:	6ce2                	ld	s9,24(sp)
    80003752:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003754:	854a                	mv	a0,s2
    80003756:	70a6                	ld	ra,104(sp)
    80003758:	7406                	ld	s0,96(sp)
    8000375a:	64e6                	ld	s1,88(sp)
    8000375c:	6946                	ld	s2,80(sp)
    8000375e:	69a6                	ld	s3,72(sp)
    80003760:	6a06                	ld	s4,64(sp)
    80003762:	7ae2                	ld	s5,56(sp)
    80003764:	6165                	addi	sp,sp,112
    80003766:	8082                	ret
      wakeup(&pi->nread);
    80003768:	856a                	mv	a0,s10
    8000376a:	bfbfd0ef          	jal	80001364 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000376e:	85a6                	mv	a1,s1
    80003770:	8566                	mv	a0,s9
    80003772:	ba7fd0ef          	jal	80001318 <sleep>
  while(i < n){
    80003776:	05495a63          	bge	s2,s4,800037ca <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    8000377a:	2204a783          	lw	a5,544(s1)
    8000377e:	d3f1                	beqz	a5,80003742 <pipewrite+0x46>
    80003780:	854e                	mv	a0,s3
    80003782:	dcffd0ef          	jal	80001550 <killed>
    80003786:	fd55                	bnez	a0,80003742 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003788:	2184a783          	lw	a5,536(s1)
    8000378c:	21c4a703          	lw	a4,540(s1)
    80003790:	2007879b          	addiw	a5,a5,512
    80003794:	fcf70ae3          	beq	a4,a5,80003768 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003798:	86de                	mv	a3,s7
    8000379a:	01590633          	add	a2,s2,s5
    8000379e:	85e2                	mv	a1,s8
    800037a0:	0509b503          	ld	a0,80(s3)
    800037a4:	afefd0ef          	jal	80000aa2 <copyin>
    800037a8:	05650063          	beq	a0,s6,800037e8 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800037ac:	21c4a783          	lw	a5,540(s1)
    800037b0:	0017871b          	addiw	a4,a5,1
    800037b4:	20e4ae23          	sw	a4,540(s1)
    800037b8:	1ff7f793          	andi	a5,a5,511
    800037bc:	97a6                	add	a5,a5,s1
    800037be:	f9f44703          	lbu	a4,-97(s0)
    800037c2:	00e78c23          	sb	a4,24(a5)
      i++;
    800037c6:	2905                	addiw	s2,s2,1
    800037c8:	b77d                	j	80003776 <pipewrite+0x7a>
    800037ca:	7b42                	ld	s6,48(sp)
    800037cc:	7ba2                	ld	s7,40(sp)
    800037ce:	7c02                	ld	s8,32(sp)
    800037d0:	6ce2                	ld	s9,24(sp)
    800037d2:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    800037d4:	21848513          	addi	a0,s1,536
    800037d8:	b8dfd0ef          	jal	80001364 <wakeup>
  release(&pi->lock);
    800037dc:	8526                	mv	a0,s1
    800037de:	7cb010ef          	jal	800057a8 <release>
  return i;
    800037e2:	bf8d                	j	80003754 <pipewrite+0x58>
  int i = 0;
    800037e4:	4901                	li	s2,0
    800037e6:	b7fd                	j	800037d4 <pipewrite+0xd8>
    800037e8:	7b42                	ld	s6,48(sp)
    800037ea:	7ba2                	ld	s7,40(sp)
    800037ec:	7c02                	ld	s8,32(sp)
    800037ee:	6ce2                	ld	s9,24(sp)
    800037f0:	6d42                	ld	s10,16(sp)
    800037f2:	b7cd                	j	800037d4 <pipewrite+0xd8>

00000000800037f4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800037f4:	711d                	addi	sp,sp,-96
    800037f6:	ec86                	sd	ra,88(sp)
    800037f8:	e8a2                	sd	s0,80(sp)
    800037fa:	e4a6                	sd	s1,72(sp)
    800037fc:	e0ca                	sd	s2,64(sp)
    800037fe:	fc4e                	sd	s3,56(sp)
    80003800:	f852                	sd	s4,48(sp)
    80003802:	f456                	sd	s5,40(sp)
    80003804:	1080                	addi	s0,sp,96
    80003806:	84aa                	mv	s1,a0
    80003808:	892e                	mv	s2,a1
    8000380a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000380c:	d3efd0ef          	jal	80000d4a <myproc>
    80003810:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003812:	8526                	mv	a0,s1
    80003814:	701010ef          	jal	80005714 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003818:	2184a703          	lw	a4,536(s1)
    8000381c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003820:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003824:	02f71763          	bne	a4,a5,80003852 <piperead+0x5e>
    80003828:	2244a783          	lw	a5,548(s1)
    8000382c:	cf85                	beqz	a5,80003864 <piperead+0x70>
    if(killed(pr)){
    8000382e:	8552                	mv	a0,s4
    80003830:	d21fd0ef          	jal	80001550 <killed>
    80003834:	e11d                	bnez	a0,8000385a <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003836:	85a6                	mv	a1,s1
    80003838:	854e                	mv	a0,s3
    8000383a:	adffd0ef          	jal	80001318 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000383e:	2184a703          	lw	a4,536(s1)
    80003842:	21c4a783          	lw	a5,540(s1)
    80003846:	fef701e3          	beq	a4,a5,80003828 <piperead+0x34>
    8000384a:	f05a                	sd	s6,32(sp)
    8000384c:	ec5e                	sd	s7,24(sp)
    8000384e:	e862                	sd	s8,16(sp)
    80003850:	a829                	j	8000386a <piperead+0x76>
    80003852:	f05a                	sd	s6,32(sp)
    80003854:	ec5e                	sd	s7,24(sp)
    80003856:	e862                	sd	s8,16(sp)
    80003858:	a809                	j	8000386a <piperead+0x76>
      release(&pi->lock);
    8000385a:	8526                	mv	a0,s1
    8000385c:	74d010ef          	jal	800057a8 <release>
      return -1;
    80003860:	59fd                	li	s3,-1
    80003862:	a0a5                	j	800038ca <piperead+0xd6>
    80003864:	f05a                	sd	s6,32(sp)
    80003866:	ec5e                	sd	s7,24(sp)
    80003868:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000386a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000386c:	faf40c13          	addi	s8,s0,-81
    80003870:	4b85                	li	s7,1
    80003872:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003874:	05505163          	blez	s5,800038b6 <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    80003878:	2184a783          	lw	a5,536(s1)
    8000387c:	21c4a703          	lw	a4,540(s1)
    80003880:	02f70b63          	beq	a4,a5,800038b6 <piperead+0xc2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003884:	0017871b          	addiw	a4,a5,1
    80003888:	20e4ac23          	sw	a4,536(s1)
    8000388c:	1ff7f793          	andi	a5,a5,511
    80003890:	97a6                	add	a5,a5,s1
    80003892:	0187c783          	lbu	a5,24(a5)
    80003896:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000389a:	86de                	mv	a3,s7
    8000389c:	8662                	mv	a2,s8
    8000389e:	85ca                	mv	a1,s2
    800038a0:	050a3503          	ld	a0,80(s4)
    800038a4:	94efd0ef          	jal	800009f2 <copyout>
    800038a8:	01650763          	beq	a0,s6,800038b6 <piperead+0xc2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800038ac:	2985                	addiw	s3,s3,1
    800038ae:	0905                	addi	s2,s2,1
    800038b0:	fd3a94e3          	bne	s5,s3,80003878 <piperead+0x84>
    800038b4:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800038b6:	21c48513          	addi	a0,s1,540
    800038ba:	aabfd0ef          	jal	80001364 <wakeup>
  release(&pi->lock);
    800038be:	8526                	mv	a0,s1
    800038c0:	6e9010ef          	jal	800057a8 <release>
    800038c4:	7b02                	ld	s6,32(sp)
    800038c6:	6be2                	ld	s7,24(sp)
    800038c8:	6c42                	ld	s8,16(sp)
  return i;
}
    800038ca:	854e                	mv	a0,s3
    800038cc:	60e6                	ld	ra,88(sp)
    800038ce:	6446                	ld	s0,80(sp)
    800038d0:	64a6                	ld	s1,72(sp)
    800038d2:	6906                	ld	s2,64(sp)
    800038d4:	79e2                	ld	s3,56(sp)
    800038d6:	7a42                	ld	s4,48(sp)
    800038d8:	7aa2                	ld	s5,40(sp)
    800038da:	6125                	addi	sp,sp,96
    800038dc:	8082                	ret

00000000800038de <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800038de:	1141                	addi	sp,sp,-16
    800038e0:	e406                	sd	ra,8(sp)
    800038e2:	e022                	sd	s0,0(sp)
    800038e4:	0800                	addi	s0,sp,16
    800038e6:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800038e8:	0035151b          	slliw	a0,a0,0x3
    800038ec:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    800038ee:	8b89                	andi	a5,a5,2
    800038f0:	c399                	beqz	a5,800038f6 <flags2perm+0x18>
      perm |= PTE_W;
    800038f2:	00456513          	ori	a0,a0,4
    return perm;
}
    800038f6:	60a2                	ld	ra,8(sp)
    800038f8:	6402                	ld	s0,0(sp)
    800038fa:	0141                	addi	sp,sp,16
    800038fc:	8082                	ret

00000000800038fe <exec>:

int
exec(char *path, char **argv)
{
    800038fe:	de010113          	addi	sp,sp,-544
    80003902:	20113c23          	sd	ra,536(sp)
    80003906:	20813823          	sd	s0,528(sp)
    8000390a:	20913423          	sd	s1,520(sp)
    8000390e:	21213023          	sd	s2,512(sp)
    80003912:	1400                	addi	s0,sp,544
    80003914:	892a                	mv	s2,a0
    80003916:	dea43823          	sd	a0,-528(s0)
    8000391a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000391e:	c2cfd0ef          	jal	80000d4a <myproc>
    80003922:	84aa                	mv	s1,a0

  begin_op();
    80003924:	d88ff0ef          	jal	80002eac <begin_op>

  if((ip = namei(path)) == 0){
    80003928:	854a                	mv	a0,s2
    8000392a:	bc0ff0ef          	jal	80002cea <namei>
    8000392e:	cd21                	beqz	a0,80003986 <exec+0x88>
    80003930:	fbd2                	sd	s4,496(sp)
    80003932:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003934:	cc7fe0ef          	jal	800025fa <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003938:	04000713          	li	a4,64
    8000393c:	4681                	li	a3,0
    8000393e:	e5040613          	addi	a2,s0,-432
    80003942:	4581                	li	a1,0
    80003944:	8552                	mv	a0,s4
    80003946:	f0dfe0ef          	jal	80002852 <readi>
    8000394a:	04000793          	li	a5,64
    8000394e:	00f51a63          	bne	a0,a5,80003962 <exec+0x64>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003952:	e5042703          	lw	a4,-432(s0)
    80003956:	464c47b7          	lui	a5,0x464c4
    8000395a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000395e:	02f70863          	beq	a4,a5,8000398e <exec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003962:	8552                	mv	a0,s4
    80003964:	ea1fe0ef          	jal	80002804 <iunlockput>
    end_op();
    80003968:	daeff0ef          	jal	80002f16 <end_op>
  }
  return -1;
    8000396c:	557d                	li	a0,-1
    8000396e:	7a5e                	ld	s4,496(sp)
}
    80003970:	21813083          	ld	ra,536(sp)
    80003974:	21013403          	ld	s0,528(sp)
    80003978:	20813483          	ld	s1,520(sp)
    8000397c:	20013903          	ld	s2,512(sp)
    80003980:	22010113          	addi	sp,sp,544
    80003984:	8082                	ret
    end_op();
    80003986:	d90ff0ef          	jal	80002f16 <end_op>
    return -1;
    8000398a:	557d                	li	a0,-1
    8000398c:	b7d5                	j	80003970 <exec+0x72>
    8000398e:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003990:	8526                	mv	a0,s1
    80003992:	c60fd0ef          	jal	80000df2 <proc_pagetable>
    80003996:	8b2a                	mv	s6,a0
    80003998:	26050d63          	beqz	a0,80003c12 <exec+0x314>
    8000399c:	ffce                	sd	s3,504(sp)
    8000399e:	f7d6                	sd	s5,488(sp)
    800039a0:	efde                	sd	s7,472(sp)
    800039a2:	ebe2                	sd	s8,464(sp)
    800039a4:	e7e6                	sd	s9,456(sp)
    800039a6:	e3ea                	sd	s10,448(sp)
    800039a8:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800039aa:	e7042683          	lw	a3,-400(s0)
    800039ae:	e8845783          	lhu	a5,-376(s0)
    800039b2:	0e078763          	beqz	a5,80003aa0 <exec+0x1a2>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800039b6:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800039b8:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800039ba:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    800039be:	6c85                	lui	s9,0x1
    800039c0:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800039c4:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800039c8:	6a85                	lui	s5,0x1
    800039ca:	a085                	j	80003a2a <exec+0x12c>
      panic("loadseg: address should exist");
    800039cc:	00004517          	auipc	a0,0x4
    800039d0:	be450513          	addi	a0,a0,-1052 # 800075b0 <etext+0x5b0>
    800039d4:	213010ef          	jal	800053e6 <panic>
    if(sz - i < PGSIZE)
    800039d8:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800039da:	874a                	mv	a4,s2
    800039dc:	009c06bb          	addw	a3,s8,s1
    800039e0:	4581                	li	a1,0
    800039e2:	8552                	mv	a0,s4
    800039e4:	e6ffe0ef          	jal	80002852 <readi>
    800039e8:	22a91963          	bne	s2,a0,80003c1a <exec+0x31c>
  for(i = 0; i < sz; i += PGSIZE){
    800039ec:	009a84bb          	addw	s1,s5,s1
    800039f0:	0334f263          	bgeu	s1,s3,80003a14 <exec+0x116>
    pa = walkaddr(pagetable, va + i);
    800039f4:	02049593          	slli	a1,s1,0x20
    800039f8:	9181                	srli	a1,a1,0x20
    800039fa:	95de                	add	a1,a1,s7
    800039fc:	855a                	mv	a0,s6
    800039fe:	a65fc0ef          	jal	80000462 <walkaddr>
    80003a02:	862a                	mv	a2,a0
    if(pa == 0)
    80003a04:	d561                	beqz	a0,800039cc <exec+0xce>
    if(sz - i < PGSIZE)
    80003a06:	409987bb          	subw	a5,s3,s1
    80003a0a:	893e                	mv	s2,a5
    80003a0c:	fcfcf6e3          	bgeu	s9,a5,800039d8 <exec+0xda>
    80003a10:	8956                	mv	s2,s5
    80003a12:	b7d9                	j	800039d8 <exec+0xda>
    sz = sz1;
    80003a14:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003a18:	2d05                	addiw	s10,s10,1
    80003a1a:	e0843783          	ld	a5,-504(s0)
    80003a1e:	0387869b          	addiw	a3,a5,56
    80003a22:	e8845783          	lhu	a5,-376(s0)
    80003a26:	06fd5e63          	bge	s10,a5,80003aa2 <exec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003a2a:	e0d43423          	sd	a3,-504(s0)
    80003a2e:	876e                	mv	a4,s11
    80003a30:	e1840613          	addi	a2,s0,-488
    80003a34:	4581                	li	a1,0
    80003a36:	8552                	mv	a0,s4
    80003a38:	e1bfe0ef          	jal	80002852 <readi>
    80003a3c:	1db51d63          	bne	a0,s11,80003c16 <exec+0x318>
    if(ph.type != ELF_PROG_LOAD)
    80003a40:	e1842783          	lw	a5,-488(s0)
    80003a44:	4705                	li	a4,1
    80003a46:	fce799e3          	bne	a5,a4,80003a18 <exec+0x11a>
    if(ph.memsz < ph.filesz)
    80003a4a:	e4043483          	ld	s1,-448(s0)
    80003a4e:	e3843783          	ld	a5,-456(s0)
    80003a52:	1ef4e263          	bltu	s1,a5,80003c36 <exec+0x338>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003a56:	e2843783          	ld	a5,-472(s0)
    80003a5a:	94be                	add	s1,s1,a5
    80003a5c:	1ef4e063          	bltu	s1,a5,80003c3c <exec+0x33e>
    if(ph.vaddr % PGSIZE != 0)
    80003a60:	de843703          	ld	a4,-536(s0)
    80003a64:	8ff9                	and	a5,a5,a4
    80003a66:	1c079e63          	bnez	a5,80003c42 <exec+0x344>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003a6a:	e1c42503          	lw	a0,-484(s0)
    80003a6e:	e71ff0ef          	jal	800038de <flags2perm>
    80003a72:	86aa                	mv	a3,a0
    80003a74:	8626                	mv	a2,s1
    80003a76:	85ca                	mv	a1,s2
    80003a78:	855a                	mv	a0,s6
    80003a7a:	d61fc0ef          	jal	800007da <uvmalloc>
    80003a7e:	dea43c23          	sd	a0,-520(s0)
    80003a82:	1c050363          	beqz	a0,80003c48 <exec+0x34a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003a86:	e2843b83          	ld	s7,-472(s0)
    80003a8a:	e2042c03          	lw	s8,-480(s0)
    80003a8e:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003a92:	00098463          	beqz	s3,80003a9a <exec+0x19c>
    80003a96:	4481                	li	s1,0
    80003a98:	bfb1                	j	800039f4 <exec+0xf6>
    sz = sz1;
    80003a9a:	df843903          	ld	s2,-520(s0)
    80003a9e:	bfad                	j	80003a18 <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003aa0:	4901                	li	s2,0
  iunlockput(ip);
    80003aa2:	8552                	mv	a0,s4
    80003aa4:	d61fe0ef          	jal	80002804 <iunlockput>
  end_op();
    80003aa8:	c6eff0ef          	jal	80002f16 <end_op>
  p = myproc();
    80003aac:	a9efd0ef          	jal	80000d4a <myproc>
    80003ab0:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003ab2:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003ab6:	6985                	lui	s3,0x1
    80003ab8:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003aba:	99ca                	add	s3,s3,s2
    80003abc:	77fd                	lui	a5,0xfffff
    80003abe:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003ac2:	4691                	li	a3,4
    80003ac4:	6609                	lui	a2,0x2
    80003ac6:	964e                	add	a2,a2,s3
    80003ac8:	85ce                	mv	a1,s3
    80003aca:	855a                	mv	a0,s6
    80003acc:	d0ffc0ef          	jal	800007da <uvmalloc>
    80003ad0:	8a2a                	mv	s4,a0
    80003ad2:	e105                	bnez	a0,80003af2 <exec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003ad4:	85ce                	mv	a1,s3
    80003ad6:	855a                	mv	a0,s6
    80003ad8:	b9efd0ef          	jal	80000e76 <proc_freepagetable>
  return -1;
    80003adc:	557d                	li	a0,-1
    80003ade:	79fe                	ld	s3,504(sp)
    80003ae0:	7a5e                	ld	s4,496(sp)
    80003ae2:	7abe                	ld	s5,488(sp)
    80003ae4:	7b1e                	ld	s6,480(sp)
    80003ae6:	6bfe                	ld	s7,472(sp)
    80003ae8:	6c5e                	ld	s8,464(sp)
    80003aea:	6cbe                	ld	s9,456(sp)
    80003aec:	6d1e                	ld	s10,448(sp)
    80003aee:	7dfa                	ld	s11,440(sp)
    80003af0:	b541                	j	80003970 <exec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003af2:	75f9                	lui	a1,0xffffe
    80003af4:	95aa                	add	a1,a1,a0
    80003af6:	855a                	mv	a0,s6
    80003af8:	ed1fc0ef          	jal	800009c8 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003afc:	7bfd                	lui	s7,0xfffff
    80003afe:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80003b00:	e0043783          	ld	a5,-512(s0)
    80003b04:	6388                	ld	a0,0(a5)
  sp = sz;
    80003b06:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003b08:	4481                	li	s1,0
    ustack[argc] = sp;
    80003b0a:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003b0e:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003b12:	cd21                	beqz	a0,80003b6a <exec+0x26c>
    sp -= strlen(argv[argc]) + 1;
    80003b14:	fa8fc0ef          	jal	800002bc <strlen>
    80003b18:	0015079b          	addiw	a5,a0,1
    80003b1c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003b20:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003b24:	13796563          	bltu	s2,s7,80003c4e <exec+0x350>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003b28:	e0043d83          	ld	s11,-512(s0)
    80003b2c:	000db983          	ld	s3,0(s11)
    80003b30:	854e                	mv	a0,s3
    80003b32:	f8afc0ef          	jal	800002bc <strlen>
    80003b36:	0015069b          	addiw	a3,a0,1
    80003b3a:	864e                	mv	a2,s3
    80003b3c:	85ca                	mv	a1,s2
    80003b3e:	855a                	mv	a0,s6
    80003b40:	eb3fc0ef          	jal	800009f2 <copyout>
    80003b44:	10054763          	bltz	a0,80003c52 <exec+0x354>
    ustack[argc] = sp;
    80003b48:	00349793          	slli	a5,s1,0x3
    80003b4c:	97e6                	add	a5,a5,s9
    80003b4e:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdba30>
  for(argc = 0; argv[argc]; argc++) {
    80003b52:	0485                	addi	s1,s1,1
    80003b54:	008d8793          	addi	a5,s11,8
    80003b58:	e0f43023          	sd	a5,-512(s0)
    80003b5c:	008db503          	ld	a0,8(s11)
    80003b60:	c509                	beqz	a0,80003b6a <exec+0x26c>
    if(argc >= MAXARG)
    80003b62:	fb8499e3          	bne	s1,s8,80003b14 <exec+0x216>
  sz = sz1;
    80003b66:	89d2                	mv	s3,s4
    80003b68:	b7b5                	j	80003ad4 <exec+0x1d6>
  ustack[argc] = 0;
    80003b6a:	00349793          	slli	a5,s1,0x3
    80003b6e:	f9078793          	addi	a5,a5,-112
    80003b72:	97a2                	add	a5,a5,s0
    80003b74:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003b78:	00148693          	addi	a3,s1,1
    80003b7c:	068e                	slli	a3,a3,0x3
    80003b7e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003b82:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003b86:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80003b88:	f57966e3          	bltu	s2,s7,80003ad4 <exec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003b8c:	e9040613          	addi	a2,s0,-368
    80003b90:	85ca                	mv	a1,s2
    80003b92:	855a                	mv	a0,s6
    80003b94:	e5ffc0ef          	jal	800009f2 <copyout>
    80003b98:	f2054ee3          	bltz	a0,80003ad4 <exec+0x1d6>
  p->trapframe->a1 = sp;
    80003b9c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003ba0:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003ba4:	df043783          	ld	a5,-528(s0)
    80003ba8:	0007c703          	lbu	a4,0(a5)
    80003bac:	cf11                	beqz	a4,80003bc8 <exec+0x2ca>
    80003bae:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003bb0:	02f00693          	li	a3,47
    80003bb4:	a029                	j	80003bbe <exec+0x2c0>
  for(last=s=path; *s; s++)
    80003bb6:	0785                	addi	a5,a5,1
    80003bb8:	fff7c703          	lbu	a4,-1(a5)
    80003bbc:	c711                	beqz	a4,80003bc8 <exec+0x2ca>
    if(*s == '/')
    80003bbe:	fed71ce3          	bne	a4,a3,80003bb6 <exec+0x2b8>
      last = s+1;
    80003bc2:	def43823          	sd	a5,-528(s0)
    80003bc6:	bfc5                	j	80003bb6 <exec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    80003bc8:	4641                	li	a2,16
    80003bca:	df043583          	ld	a1,-528(s0)
    80003bce:	158a8513          	addi	a0,s5,344
    80003bd2:	eb4fc0ef          	jal	80000286 <safestrcpy>
  oldpagetable = p->pagetable;
    80003bd6:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003bda:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003bde:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003be2:	058ab783          	ld	a5,88(s5)
    80003be6:	e6843703          	ld	a4,-408(s0)
    80003bea:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003bec:	058ab783          	ld	a5,88(s5)
    80003bf0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003bf4:	85ea                	mv	a1,s10
    80003bf6:	a80fd0ef          	jal	80000e76 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003bfa:	0004851b          	sext.w	a0,s1
    80003bfe:	79fe                	ld	s3,504(sp)
    80003c00:	7a5e                	ld	s4,496(sp)
    80003c02:	7abe                	ld	s5,488(sp)
    80003c04:	7b1e                	ld	s6,480(sp)
    80003c06:	6bfe                	ld	s7,472(sp)
    80003c08:	6c5e                	ld	s8,464(sp)
    80003c0a:	6cbe                	ld	s9,456(sp)
    80003c0c:	6d1e                	ld	s10,448(sp)
    80003c0e:	7dfa                	ld	s11,440(sp)
    80003c10:	b385                	j	80003970 <exec+0x72>
    80003c12:	7b1e                	ld	s6,480(sp)
    80003c14:	b3b9                	j	80003962 <exec+0x64>
    80003c16:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003c1a:	df843583          	ld	a1,-520(s0)
    80003c1e:	855a                	mv	a0,s6
    80003c20:	a56fd0ef          	jal	80000e76 <proc_freepagetable>
  if(ip){
    80003c24:	79fe                	ld	s3,504(sp)
    80003c26:	7abe                	ld	s5,488(sp)
    80003c28:	7b1e                	ld	s6,480(sp)
    80003c2a:	6bfe                	ld	s7,472(sp)
    80003c2c:	6c5e                	ld	s8,464(sp)
    80003c2e:	6cbe                	ld	s9,456(sp)
    80003c30:	6d1e                	ld	s10,448(sp)
    80003c32:	7dfa                	ld	s11,440(sp)
    80003c34:	b33d                	j	80003962 <exec+0x64>
    80003c36:	df243c23          	sd	s2,-520(s0)
    80003c3a:	b7c5                	j	80003c1a <exec+0x31c>
    80003c3c:	df243c23          	sd	s2,-520(s0)
    80003c40:	bfe9                	j	80003c1a <exec+0x31c>
    80003c42:	df243c23          	sd	s2,-520(s0)
    80003c46:	bfd1                	j	80003c1a <exec+0x31c>
    80003c48:	df243c23          	sd	s2,-520(s0)
    80003c4c:	b7f9                	j	80003c1a <exec+0x31c>
  sz = sz1;
    80003c4e:	89d2                	mv	s3,s4
    80003c50:	b551                	j	80003ad4 <exec+0x1d6>
    80003c52:	89d2                	mv	s3,s4
    80003c54:	b541                	j	80003ad4 <exec+0x1d6>

0000000080003c56 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003c56:	7179                	addi	sp,sp,-48
    80003c58:	f406                	sd	ra,40(sp)
    80003c5a:	f022                	sd	s0,32(sp)
    80003c5c:	ec26                	sd	s1,24(sp)
    80003c5e:	e84a                	sd	s2,16(sp)
    80003c60:	1800                	addi	s0,sp,48
    80003c62:	892e                	mv	s2,a1
    80003c64:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003c66:	fdc40593          	addi	a1,s0,-36
    80003c6a:	f93fd0ef          	jal	80001bfc <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003c6e:	fdc42703          	lw	a4,-36(s0)
    80003c72:	47bd                	li	a5,15
    80003c74:	02e7e963          	bltu	a5,a4,80003ca6 <argfd+0x50>
    80003c78:	8d2fd0ef          	jal	80000d4a <myproc>
    80003c7c:	fdc42703          	lw	a4,-36(s0)
    80003c80:	01a70793          	addi	a5,a4,26
    80003c84:	078e                	slli	a5,a5,0x3
    80003c86:	953e                	add	a0,a0,a5
    80003c88:	611c                	ld	a5,0(a0)
    80003c8a:	c385                	beqz	a5,80003caa <argfd+0x54>
    return -1;
  if(pfd)
    80003c8c:	00090463          	beqz	s2,80003c94 <argfd+0x3e>
    *pfd = fd;
    80003c90:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003c94:	4501                	li	a0,0
  if(pf)
    80003c96:	c091                	beqz	s1,80003c9a <argfd+0x44>
    *pf = f;
    80003c98:	e09c                	sd	a5,0(s1)
}
    80003c9a:	70a2                	ld	ra,40(sp)
    80003c9c:	7402                	ld	s0,32(sp)
    80003c9e:	64e2                	ld	s1,24(sp)
    80003ca0:	6942                	ld	s2,16(sp)
    80003ca2:	6145                	addi	sp,sp,48
    80003ca4:	8082                	ret
    return -1;
    80003ca6:	557d                	li	a0,-1
    80003ca8:	bfcd                	j	80003c9a <argfd+0x44>
    80003caa:	557d                	li	a0,-1
    80003cac:	b7fd                	j	80003c9a <argfd+0x44>

0000000080003cae <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003cae:	1101                	addi	sp,sp,-32
    80003cb0:	ec06                	sd	ra,24(sp)
    80003cb2:	e822                	sd	s0,16(sp)
    80003cb4:	e426                	sd	s1,8(sp)
    80003cb6:	1000                	addi	s0,sp,32
    80003cb8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003cba:	890fd0ef          	jal	80000d4a <myproc>
    80003cbe:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003cc0:	0d050793          	addi	a5,a0,208
    80003cc4:	4501                	li	a0,0
    80003cc6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003cc8:	6398                	ld	a4,0(a5)
    80003cca:	cb19                	beqz	a4,80003ce0 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003ccc:	2505                	addiw	a0,a0,1
    80003cce:	07a1                	addi	a5,a5,8
    80003cd0:	fed51ce3          	bne	a0,a3,80003cc8 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003cd4:	557d                	li	a0,-1
}
    80003cd6:	60e2                	ld	ra,24(sp)
    80003cd8:	6442                	ld	s0,16(sp)
    80003cda:	64a2                	ld	s1,8(sp)
    80003cdc:	6105                	addi	sp,sp,32
    80003cde:	8082                	ret
      p->ofile[fd] = f;
    80003ce0:	01a50793          	addi	a5,a0,26
    80003ce4:	078e                	slli	a5,a5,0x3
    80003ce6:	963e                	add	a2,a2,a5
    80003ce8:	e204                	sd	s1,0(a2)
      return fd;
    80003cea:	b7f5                	j	80003cd6 <fdalloc+0x28>

0000000080003cec <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003cec:	715d                	addi	sp,sp,-80
    80003cee:	e486                	sd	ra,72(sp)
    80003cf0:	e0a2                	sd	s0,64(sp)
    80003cf2:	fc26                	sd	s1,56(sp)
    80003cf4:	f84a                	sd	s2,48(sp)
    80003cf6:	f44e                	sd	s3,40(sp)
    80003cf8:	ec56                	sd	s5,24(sp)
    80003cfa:	e85a                	sd	s6,16(sp)
    80003cfc:	0880                	addi	s0,sp,80
    80003cfe:	8b2e                	mv	s6,a1
    80003d00:	89b2                	mv	s3,a2
    80003d02:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003d04:	fb040593          	addi	a1,s0,-80
    80003d08:	ffdfe0ef          	jal	80002d04 <nameiparent>
    80003d0c:	84aa                	mv	s1,a0
    80003d0e:	10050a63          	beqz	a0,80003e22 <create+0x136>
    return 0;

  ilock(dp);
    80003d12:	8e9fe0ef          	jal	800025fa <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003d16:	4601                	li	a2,0
    80003d18:	fb040593          	addi	a1,s0,-80
    80003d1c:	8526                	mv	a0,s1
    80003d1e:	d41fe0ef          	jal	80002a5e <dirlookup>
    80003d22:	8aaa                	mv	s5,a0
    80003d24:	c129                	beqz	a0,80003d66 <create+0x7a>
    iunlockput(dp);
    80003d26:	8526                	mv	a0,s1
    80003d28:	addfe0ef          	jal	80002804 <iunlockput>
    ilock(ip);
    80003d2c:	8556                	mv	a0,s5
    80003d2e:	8cdfe0ef          	jal	800025fa <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003d32:	4789                	li	a5,2
    80003d34:	02fb1463          	bne	s6,a5,80003d5c <create+0x70>
    80003d38:	044ad783          	lhu	a5,68(s5)
    80003d3c:	37f9                	addiw	a5,a5,-2
    80003d3e:	17c2                	slli	a5,a5,0x30
    80003d40:	93c1                	srli	a5,a5,0x30
    80003d42:	4705                	li	a4,1
    80003d44:	00f76c63          	bltu	a4,a5,80003d5c <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003d48:	8556                	mv	a0,s5
    80003d4a:	60a6                	ld	ra,72(sp)
    80003d4c:	6406                	ld	s0,64(sp)
    80003d4e:	74e2                	ld	s1,56(sp)
    80003d50:	7942                	ld	s2,48(sp)
    80003d52:	79a2                	ld	s3,40(sp)
    80003d54:	6ae2                	ld	s5,24(sp)
    80003d56:	6b42                	ld	s6,16(sp)
    80003d58:	6161                	addi	sp,sp,80
    80003d5a:	8082                	ret
    iunlockput(ip);
    80003d5c:	8556                	mv	a0,s5
    80003d5e:	aa7fe0ef          	jal	80002804 <iunlockput>
    return 0;
    80003d62:	4a81                	li	s5,0
    80003d64:	b7d5                	j	80003d48 <create+0x5c>
    80003d66:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003d68:	85da                	mv	a1,s6
    80003d6a:	4088                	lw	a0,0(s1)
    80003d6c:	f1efe0ef          	jal	8000248a <ialloc>
    80003d70:	8a2a                	mv	s4,a0
    80003d72:	cd15                	beqz	a0,80003dae <create+0xc2>
  ilock(ip);
    80003d74:	887fe0ef          	jal	800025fa <ilock>
  ip->major = major;
    80003d78:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003d7c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003d80:	4905                	li	s2,1
    80003d82:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003d86:	8552                	mv	a0,s4
    80003d88:	fbefe0ef          	jal	80002546 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003d8c:	032b0763          	beq	s6,s2,80003dba <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003d90:	004a2603          	lw	a2,4(s4)
    80003d94:	fb040593          	addi	a1,s0,-80
    80003d98:	8526                	mv	a0,s1
    80003d9a:	ea7fe0ef          	jal	80002c40 <dirlink>
    80003d9e:	06054563          	bltz	a0,80003e08 <create+0x11c>
  iunlockput(dp);
    80003da2:	8526                	mv	a0,s1
    80003da4:	a61fe0ef          	jal	80002804 <iunlockput>
  return ip;
    80003da8:	8ad2                	mv	s5,s4
    80003daa:	7a02                	ld	s4,32(sp)
    80003dac:	bf71                	j	80003d48 <create+0x5c>
    iunlockput(dp);
    80003dae:	8526                	mv	a0,s1
    80003db0:	a55fe0ef          	jal	80002804 <iunlockput>
    return 0;
    80003db4:	8ad2                	mv	s5,s4
    80003db6:	7a02                	ld	s4,32(sp)
    80003db8:	bf41                	j	80003d48 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003dba:	004a2603          	lw	a2,4(s4)
    80003dbe:	00004597          	auipc	a1,0x4
    80003dc2:	81258593          	addi	a1,a1,-2030 # 800075d0 <etext+0x5d0>
    80003dc6:	8552                	mv	a0,s4
    80003dc8:	e79fe0ef          	jal	80002c40 <dirlink>
    80003dcc:	02054e63          	bltz	a0,80003e08 <create+0x11c>
    80003dd0:	40d0                	lw	a2,4(s1)
    80003dd2:	00004597          	auipc	a1,0x4
    80003dd6:	80658593          	addi	a1,a1,-2042 # 800075d8 <etext+0x5d8>
    80003dda:	8552                	mv	a0,s4
    80003ddc:	e65fe0ef          	jal	80002c40 <dirlink>
    80003de0:	02054463          	bltz	a0,80003e08 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003de4:	004a2603          	lw	a2,4(s4)
    80003de8:	fb040593          	addi	a1,s0,-80
    80003dec:	8526                	mv	a0,s1
    80003dee:	e53fe0ef          	jal	80002c40 <dirlink>
    80003df2:	00054b63          	bltz	a0,80003e08 <create+0x11c>
    dp->nlink++;  // for ".."
    80003df6:	04a4d783          	lhu	a5,74(s1)
    80003dfa:	2785                	addiw	a5,a5,1
    80003dfc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003e00:	8526                	mv	a0,s1
    80003e02:	f44fe0ef          	jal	80002546 <iupdate>
    80003e06:	bf71                	j	80003da2 <create+0xb6>
  ip->nlink = 0;
    80003e08:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003e0c:	8552                	mv	a0,s4
    80003e0e:	f38fe0ef          	jal	80002546 <iupdate>
  iunlockput(ip);
    80003e12:	8552                	mv	a0,s4
    80003e14:	9f1fe0ef          	jal	80002804 <iunlockput>
  iunlockput(dp);
    80003e18:	8526                	mv	a0,s1
    80003e1a:	9ebfe0ef          	jal	80002804 <iunlockput>
  return 0;
    80003e1e:	7a02                	ld	s4,32(sp)
    80003e20:	b725                	j	80003d48 <create+0x5c>
    return 0;
    80003e22:	8aaa                	mv	s5,a0
    80003e24:	b715                	j	80003d48 <create+0x5c>

0000000080003e26 <sys_dup>:
{
    80003e26:	7179                	addi	sp,sp,-48
    80003e28:	f406                	sd	ra,40(sp)
    80003e2a:	f022                	sd	s0,32(sp)
    80003e2c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003e2e:	fd840613          	addi	a2,s0,-40
    80003e32:	4581                	li	a1,0
    80003e34:	4501                	li	a0,0
    80003e36:	e21ff0ef          	jal	80003c56 <argfd>
    return -1;
    80003e3a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003e3c:	02054363          	bltz	a0,80003e62 <sys_dup+0x3c>
    80003e40:	ec26                	sd	s1,24(sp)
    80003e42:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003e44:	fd843903          	ld	s2,-40(s0)
    80003e48:	854a                	mv	a0,s2
    80003e4a:	e65ff0ef          	jal	80003cae <fdalloc>
    80003e4e:	84aa                	mv	s1,a0
    return -1;
    80003e50:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003e52:	00054d63          	bltz	a0,80003e6c <sys_dup+0x46>
  filedup(f);
    80003e56:	854a                	mv	a0,s2
    80003e58:	c2eff0ef          	jal	80003286 <filedup>
  return fd;
    80003e5c:	87a6                	mv	a5,s1
    80003e5e:	64e2                	ld	s1,24(sp)
    80003e60:	6942                	ld	s2,16(sp)
}
    80003e62:	853e                	mv	a0,a5
    80003e64:	70a2                	ld	ra,40(sp)
    80003e66:	7402                	ld	s0,32(sp)
    80003e68:	6145                	addi	sp,sp,48
    80003e6a:	8082                	ret
    80003e6c:	64e2                	ld	s1,24(sp)
    80003e6e:	6942                	ld	s2,16(sp)
    80003e70:	bfcd                	j	80003e62 <sys_dup+0x3c>

0000000080003e72 <sys_read>:
{
    80003e72:	7179                	addi	sp,sp,-48
    80003e74:	f406                	sd	ra,40(sp)
    80003e76:	f022                	sd	s0,32(sp)
    80003e78:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003e7a:	fd840593          	addi	a1,s0,-40
    80003e7e:	4505                	li	a0,1
    80003e80:	d99fd0ef          	jal	80001c18 <argaddr>
  argint(2, &n);
    80003e84:	fe440593          	addi	a1,s0,-28
    80003e88:	4509                	li	a0,2
    80003e8a:	d73fd0ef          	jal	80001bfc <argint>
  if(argfd(0, 0, &f) < 0)
    80003e8e:	fe840613          	addi	a2,s0,-24
    80003e92:	4581                	li	a1,0
    80003e94:	4501                	li	a0,0
    80003e96:	dc1ff0ef          	jal	80003c56 <argfd>
    80003e9a:	87aa                	mv	a5,a0
    return -1;
    80003e9c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003e9e:	0007ca63          	bltz	a5,80003eb2 <sys_read+0x40>
  return fileread(f, p, n);
    80003ea2:	fe442603          	lw	a2,-28(s0)
    80003ea6:	fd843583          	ld	a1,-40(s0)
    80003eaa:	fe843503          	ld	a0,-24(s0)
    80003eae:	d3eff0ef          	jal	800033ec <fileread>
}
    80003eb2:	70a2                	ld	ra,40(sp)
    80003eb4:	7402                	ld	s0,32(sp)
    80003eb6:	6145                	addi	sp,sp,48
    80003eb8:	8082                	ret

0000000080003eba <sys_write>:
{
    80003eba:	7179                	addi	sp,sp,-48
    80003ebc:	f406                	sd	ra,40(sp)
    80003ebe:	f022                	sd	s0,32(sp)
    80003ec0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003ec2:	fd840593          	addi	a1,s0,-40
    80003ec6:	4505                	li	a0,1
    80003ec8:	d51fd0ef          	jal	80001c18 <argaddr>
  argint(2, &n);
    80003ecc:	fe440593          	addi	a1,s0,-28
    80003ed0:	4509                	li	a0,2
    80003ed2:	d2bfd0ef          	jal	80001bfc <argint>
  if(argfd(0, 0, &f) < 0)
    80003ed6:	fe840613          	addi	a2,s0,-24
    80003eda:	4581                	li	a1,0
    80003edc:	4501                	li	a0,0
    80003ede:	d79ff0ef          	jal	80003c56 <argfd>
    80003ee2:	87aa                	mv	a5,a0
    return -1;
    80003ee4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003ee6:	0007ca63          	bltz	a5,80003efa <sys_write+0x40>
  return filewrite(f, p, n);
    80003eea:	fe442603          	lw	a2,-28(s0)
    80003eee:	fd843583          	ld	a1,-40(s0)
    80003ef2:	fe843503          	ld	a0,-24(s0)
    80003ef6:	db4ff0ef          	jal	800034aa <filewrite>
}
    80003efa:	70a2                	ld	ra,40(sp)
    80003efc:	7402                	ld	s0,32(sp)
    80003efe:	6145                	addi	sp,sp,48
    80003f00:	8082                	ret

0000000080003f02 <sys_close>:
{
    80003f02:	1101                	addi	sp,sp,-32
    80003f04:	ec06                	sd	ra,24(sp)
    80003f06:	e822                	sd	s0,16(sp)
    80003f08:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80003f0a:	fe040613          	addi	a2,s0,-32
    80003f0e:	fec40593          	addi	a1,s0,-20
    80003f12:	4501                	li	a0,0
    80003f14:	d43ff0ef          	jal	80003c56 <argfd>
    return -1;
    80003f18:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80003f1a:	02054063          	bltz	a0,80003f3a <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80003f1e:	e2dfc0ef          	jal	80000d4a <myproc>
    80003f22:	fec42783          	lw	a5,-20(s0)
    80003f26:	07e9                	addi	a5,a5,26
    80003f28:	078e                	slli	a5,a5,0x3
    80003f2a:	953e                	add	a0,a0,a5
    80003f2c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80003f30:	fe043503          	ld	a0,-32(s0)
    80003f34:	b98ff0ef          	jal	800032cc <fileclose>
  return 0;
    80003f38:	4781                	li	a5,0
}
    80003f3a:	853e                	mv	a0,a5
    80003f3c:	60e2                	ld	ra,24(sp)
    80003f3e:	6442                	ld	s0,16(sp)
    80003f40:	6105                	addi	sp,sp,32
    80003f42:	8082                	ret

0000000080003f44 <sys_fstat>:
{
    80003f44:	1101                	addi	sp,sp,-32
    80003f46:	ec06                	sd	ra,24(sp)
    80003f48:	e822                	sd	s0,16(sp)
    80003f4a:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80003f4c:	fe040593          	addi	a1,s0,-32
    80003f50:	4505                	li	a0,1
    80003f52:	cc7fd0ef          	jal	80001c18 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80003f56:	fe840613          	addi	a2,s0,-24
    80003f5a:	4581                	li	a1,0
    80003f5c:	4501                	li	a0,0
    80003f5e:	cf9ff0ef          	jal	80003c56 <argfd>
    80003f62:	87aa                	mv	a5,a0
    return -1;
    80003f64:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003f66:	0007c863          	bltz	a5,80003f76 <sys_fstat+0x32>
  return filestat(f, st);
    80003f6a:	fe043583          	ld	a1,-32(s0)
    80003f6e:	fe843503          	ld	a0,-24(s0)
    80003f72:	c18ff0ef          	jal	8000338a <filestat>
}
    80003f76:	60e2                	ld	ra,24(sp)
    80003f78:	6442                	ld	s0,16(sp)
    80003f7a:	6105                	addi	sp,sp,32
    80003f7c:	8082                	ret

0000000080003f7e <sys_link>:
{
    80003f7e:	7169                	addi	sp,sp,-304
    80003f80:	f606                	sd	ra,296(sp)
    80003f82:	f222                	sd	s0,288(sp)
    80003f84:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003f86:	08000613          	li	a2,128
    80003f8a:	ed040593          	addi	a1,s0,-304
    80003f8e:	4501                	li	a0,0
    80003f90:	ca5fd0ef          	jal	80001c34 <argstr>
    return -1;
    80003f94:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003f96:	0c054e63          	bltz	a0,80004072 <sys_link+0xf4>
    80003f9a:	08000613          	li	a2,128
    80003f9e:	f5040593          	addi	a1,s0,-176
    80003fa2:	4505                	li	a0,1
    80003fa4:	c91fd0ef          	jal	80001c34 <argstr>
    return -1;
    80003fa8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003faa:	0c054463          	bltz	a0,80004072 <sys_link+0xf4>
    80003fae:	ee26                	sd	s1,280(sp)
  begin_op();
    80003fb0:	efdfe0ef          	jal	80002eac <begin_op>
  if((ip = namei(old)) == 0){
    80003fb4:	ed040513          	addi	a0,s0,-304
    80003fb8:	d33fe0ef          	jal	80002cea <namei>
    80003fbc:	84aa                	mv	s1,a0
    80003fbe:	c53d                	beqz	a0,8000402c <sys_link+0xae>
  ilock(ip);
    80003fc0:	e3afe0ef          	jal	800025fa <ilock>
  if(ip->type == T_DIR){
    80003fc4:	04449703          	lh	a4,68(s1)
    80003fc8:	4785                	li	a5,1
    80003fca:	06f70663          	beq	a4,a5,80004036 <sys_link+0xb8>
    80003fce:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80003fd0:	04a4d783          	lhu	a5,74(s1)
    80003fd4:	2785                	addiw	a5,a5,1
    80003fd6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80003fda:	8526                	mv	a0,s1
    80003fdc:	d6afe0ef          	jal	80002546 <iupdate>
  iunlock(ip);
    80003fe0:	8526                	mv	a0,s1
    80003fe2:	ec6fe0ef          	jal	800026a8 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80003fe6:	fd040593          	addi	a1,s0,-48
    80003fea:	f5040513          	addi	a0,s0,-176
    80003fee:	d17fe0ef          	jal	80002d04 <nameiparent>
    80003ff2:	892a                	mv	s2,a0
    80003ff4:	cd21                	beqz	a0,8000404c <sys_link+0xce>
  ilock(dp);
    80003ff6:	e04fe0ef          	jal	800025fa <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80003ffa:	00092703          	lw	a4,0(s2)
    80003ffe:	409c                	lw	a5,0(s1)
    80004000:	04f71363          	bne	a4,a5,80004046 <sys_link+0xc8>
    80004004:	40d0                	lw	a2,4(s1)
    80004006:	fd040593          	addi	a1,s0,-48
    8000400a:	854a                	mv	a0,s2
    8000400c:	c35fe0ef          	jal	80002c40 <dirlink>
    80004010:	02054b63          	bltz	a0,80004046 <sys_link+0xc8>
  iunlockput(dp);
    80004014:	854a                	mv	a0,s2
    80004016:	feefe0ef          	jal	80002804 <iunlockput>
  iput(ip);
    8000401a:	8526                	mv	a0,s1
    8000401c:	f60fe0ef          	jal	8000277c <iput>
  end_op();
    80004020:	ef7fe0ef          	jal	80002f16 <end_op>
  return 0;
    80004024:	4781                	li	a5,0
    80004026:	64f2                	ld	s1,280(sp)
    80004028:	6952                	ld	s2,272(sp)
    8000402a:	a0a1                	j	80004072 <sys_link+0xf4>
    end_op();
    8000402c:	eebfe0ef          	jal	80002f16 <end_op>
    return -1;
    80004030:	57fd                	li	a5,-1
    80004032:	64f2                	ld	s1,280(sp)
    80004034:	a83d                	j	80004072 <sys_link+0xf4>
    iunlockput(ip);
    80004036:	8526                	mv	a0,s1
    80004038:	fccfe0ef          	jal	80002804 <iunlockput>
    end_op();
    8000403c:	edbfe0ef          	jal	80002f16 <end_op>
    return -1;
    80004040:	57fd                	li	a5,-1
    80004042:	64f2                	ld	s1,280(sp)
    80004044:	a03d                	j	80004072 <sys_link+0xf4>
    iunlockput(dp);
    80004046:	854a                	mv	a0,s2
    80004048:	fbcfe0ef          	jal	80002804 <iunlockput>
  ilock(ip);
    8000404c:	8526                	mv	a0,s1
    8000404e:	dacfe0ef          	jal	800025fa <ilock>
  ip->nlink--;
    80004052:	04a4d783          	lhu	a5,74(s1)
    80004056:	37fd                	addiw	a5,a5,-1
    80004058:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000405c:	8526                	mv	a0,s1
    8000405e:	ce8fe0ef          	jal	80002546 <iupdate>
  iunlockput(ip);
    80004062:	8526                	mv	a0,s1
    80004064:	fa0fe0ef          	jal	80002804 <iunlockput>
  end_op();
    80004068:	eaffe0ef          	jal	80002f16 <end_op>
  return -1;
    8000406c:	57fd                	li	a5,-1
    8000406e:	64f2                	ld	s1,280(sp)
    80004070:	6952                	ld	s2,272(sp)
}
    80004072:	853e                	mv	a0,a5
    80004074:	70b2                	ld	ra,296(sp)
    80004076:	7412                	ld	s0,288(sp)
    80004078:	6155                	addi	sp,sp,304
    8000407a:	8082                	ret

000000008000407c <sys_unlink>:
{
    8000407c:	7111                	addi	sp,sp,-256
    8000407e:	fd86                	sd	ra,248(sp)
    80004080:	f9a2                	sd	s0,240(sp)
    80004082:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    80004084:	08000613          	li	a2,128
    80004088:	f2040593          	addi	a1,s0,-224
    8000408c:	4501                	li	a0,0
    8000408e:	ba7fd0ef          	jal	80001c34 <argstr>
    80004092:	16054663          	bltz	a0,800041fe <sys_unlink+0x182>
    80004096:	f5a6                	sd	s1,232(sp)
  begin_op();
    80004098:	e15fe0ef          	jal	80002eac <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000409c:	fa040593          	addi	a1,s0,-96
    800040a0:	f2040513          	addi	a0,s0,-224
    800040a4:	c61fe0ef          	jal	80002d04 <nameiparent>
    800040a8:	84aa                	mv	s1,a0
    800040aa:	c955                	beqz	a0,8000415e <sys_unlink+0xe2>
  ilock(dp);
    800040ac:	d4efe0ef          	jal	800025fa <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800040b0:	00003597          	auipc	a1,0x3
    800040b4:	52058593          	addi	a1,a1,1312 # 800075d0 <etext+0x5d0>
    800040b8:	fa040513          	addi	a0,s0,-96
    800040bc:	98dfe0ef          	jal	80002a48 <namecmp>
    800040c0:	12050463          	beqz	a0,800041e8 <sys_unlink+0x16c>
    800040c4:	00003597          	auipc	a1,0x3
    800040c8:	51458593          	addi	a1,a1,1300 # 800075d8 <etext+0x5d8>
    800040cc:	fa040513          	addi	a0,s0,-96
    800040d0:	979fe0ef          	jal	80002a48 <namecmp>
    800040d4:	10050a63          	beqz	a0,800041e8 <sys_unlink+0x16c>
    800040d8:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800040da:	f1c40613          	addi	a2,s0,-228
    800040de:	fa040593          	addi	a1,s0,-96
    800040e2:	8526                	mv	a0,s1
    800040e4:	97bfe0ef          	jal	80002a5e <dirlookup>
    800040e8:	892a                	mv	s2,a0
    800040ea:	0e050e63          	beqz	a0,800041e6 <sys_unlink+0x16a>
    800040ee:	edce                	sd	s3,216(sp)
  ilock(ip);
    800040f0:	d0afe0ef          	jal	800025fa <ilock>
  if(ip->nlink < 1)
    800040f4:	04a91783          	lh	a5,74(s2)
    800040f8:	06f05863          	blez	a5,80004168 <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800040fc:	04491703          	lh	a4,68(s2)
    80004100:	4785                	li	a5,1
    80004102:	06f70b63          	beq	a4,a5,80004178 <sys_unlink+0xfc>
  memset(&de, 0, sizeof(de));
    80004106:	fb040993          	addi	s3,s0,-80
    8000410a:	4641                	li	a2,16
    8000410c:	4581                	li	a1,0
    8000410e:	854e                	mv	a0,s3
    80004110:	824fc0ef          	jal	80000134 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004114:	4741                	li	a4,16
    80004116:	f1c42683          	lw	a3,-228(s0)
    8000411a:	864e                	mv	a2,s3
    8000411c:	4581                	li	a1,0
    8000411e:	8526                	mv	a0,s1
    80004120:	825fe0ef          	jal	80002944 <writei>
    80004124:	47c1                	li	a5,16
    80004126:	08f51f63          	bne	a0,a5,800041c4 <sys_unlink+0x148>
  if(ip->type == T_DIR){
    8000412a:	04491703          	lh	a4,68(s2)
    8000412e:	4785                	li	a5,1
    80004130:	0af70263          	beq	a4,a5,800041d4 <sys_unlink+0x158>
  iunlockput(dp);
    80004134:	8526                	mv	a0,s1
    80004136:	ecefe0ef          	jal	80002804 <iunlockput>
  ip->nlink--;
    8000413a:	04a95783          	lhu	a5,74(s2)
    8000413e:	37fd                	addiw	a5,a5,-1
    80004140:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004144:	854a                	mv	a0,s2
    80004146:	c00fe0ef          	jal	80002546 <iupdate>
  iunlockput(ip);
    8000414a:	854a                	mv	a0,s2
    8000414c:	eb8fe0ef          	jal	80002804 <iunlockput>
  end_op();
    80004150:	dc7fe0ef          	jal	80002f16 <end_op>
  return 0;
    80004154:	4501                	li	a0,0
    80004156:	74ae                	ld	s1,232(sp)
    80004158:	790e                	ld	s2,224(sp)
    8000415a:	69ee                	ld	s3,216(sp)
    8000415c:	a869                	j	800041f6 <sys_unlink+0x17a>
    end_op();
    8000415e:	db9fe0ef          	jal	80002f16 <end_op>
    return -1;
    80004162:	557d                	li	a0,-1
    80004164:	74ae                	ld	s1,232(sp)
    80004166:	a841                	j	800041f6 <sys_unlink+0x17a>
    80004168:	e9d2                	sd	s4,208(sp)
    8000416a:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    8000416c:	00003517          	auipc	a0,0x3
    80004170:	47450513          	addi	a0,a0,1140 # 800075e0 <etext+0x5e0>
    80004174:	272010ef          	jal	800053e6 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004178:	04c92703          	lw	a4,76(s2)
    8000417c:	02000793          	li	a5,32
    80004180:	f8e7f3e3          	bgeu	a5,a4,80004106 <sys_unlink+0x8a>
    80004184:	e9d2                	sd	s4,208(sp)
    80004186:	e5d6                	sd	s5,200(sp)
    80004188:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000418a:	f0840a93          	addi	s5,s0,-248
    8000418e:	4a41                	li	s4,16
    80004190:	8752                	mv	a4,s4
    80004192:	86ce                	mv	a3,s3
    80004194:	8656                	mv	a2,s5
    80004196:	4581                	li	a1,0
    80004198:	854a                	mv	a0,s2
    8000419a:	eb8fe0ef          	jal	80002852 <readi>
    8000419e:	01451d63          	bne	a0,s4,800041b8 <sys_unlink+0x13c>
    if(de.inum != 0)
    800041a2:	f0845783          	lhu	a5,-248(s0)
    800041a6:	efb1                	bnez	a5,80004202 <sys_unlink+0x186>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800041a8:	29c1                	addiw	s3,s3,16
    800041aa:	04c92783          	lw	a5,76(s2)
    800041ae:	fef9e1e3          	bltu	s3,a5,80004190 <sys_unlink+0x114>
    800041b2:	6a4e                	ld	s4,208(sp)
    800041b4:	6aae                	ld	s5,200(sp)
    800041b6:	bf81                	j	80004106 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800041b8:	00003517          	auipc	a0,0x3
    800041bc:	44050513          	addi	a0,a0,1088 # 800075f8 <etext+0x5f8>
    800041c0:	226010ef          	jal	800053e6 <panic>
    800041c4:	e9d2                	sd	s4,208(sp)
    800041c6:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    800041c8:	00003517          	auipc	a0,0x3
    800041cc:	44850513          	addi	a0,a0,1096 # 80007610 <etext+0x610>
    800041d0:	216010ef          	jal	800053e6 <panic>
    dp->nlink--;
    800041d4:	04a4d783          	lhu	a5,74(s1)
    800041d8:	37fd                	addiw	a5,a5,-1
    800041da:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800041de:	8526                	mv	a0,s1
    800041e0:	b66fe0ef          	jal	80002546 <iupdate>
    800041e4:	bf81                	j	80004134 <sys_unlink+0xb8>
    800041e6:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    800041e8:	8526                	mv	a0,s1
    800041ea:	e1afe0ef          	jal	80002804 <iunlockput>
  end_op();
    800041ee:	d29fe0ef          	jal	80002f16 <end_op>
  return -1;
    800041f2:	557d                	li	a0,-1
    800041f4:	74ae                	ld	s1,232(sp)
}
    800041f6:	70ee                	ld	ra,248(sp)
    800041f8:	744e                	ld	s0,240(sp)
    800041fa:	6111                	addi	sp,sp,256
    800041fc:	8082                	ret
    return -1;
    800041fe:	557d                	li	a0,-1
    80004200:	bfdd                	j	800041f6 <sys_unlink+0x17a>
    iunlockput(ip);
    80004202:	854a                	mv	a0,s2
    80004204:	e00fe0ef          	jal	80002804 <iunlockput>
    goto bad;
    80004208:	790e                	ld	s2,224(sp)
    8000420a:	69ee                	ld	s3,216(sp)
    8000420c:	6a4e                	ld	s4,208(sp)
    8000420e:	6aae                	ld	s5,200(sp)
    80004210:	bfe1                	j	800041e8 <sys_unlink+0x16c>

0000000080004212 <sys_open>:

uint64
sys_open(void)
{
    80004212:	7131                	addi	sp,sp,-192
    80004214:	fd06                	sd	ra,184(sp)
    80004216:	f922                	sd	s0,176(sp)
    80004218:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000421a:	f4c40593          	addi	a1,s0,-180
    8000421e:	4505                	li	a0,1
    80004220:	9ddfd0ef          	jal	80001bfc <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004224:	08000613          	li	a2,128
    80004228:	f5040593          	addi	a1,s0,-176
    8000422c:	4501                	li	a0,0
    8000422e:	a07fd0ef          	jal	80001c34 <argstr>
    80004232:	87aa                	mv	a5,a0
    return -1;
    80004234:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004236:	0a07c363          	bltz	a5,800042dc <sys_open+0xca>
    8000423a:	f526                	sd	s1,168(sp)

  begin_op();
    8000423c:	c71fe0ef          	jal	80002eac <begin_op>

  if(omode & O_CREATE){
    80004240:	f4c42783          	lw	a5,-180(s0)
    80004244:	2007f793          	andi	a5,a5,512
    80004248:	c3dd                	beqz	a5,800042ee <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    8000424a:	4681                	li	a3,0
    8000424c:	4601                	li	a2,0
    8000424e:	4589                	li	a1,2
    80004250:	f5040513          	addi	a0,s0,-176
    80004254:	a99ff0ef          	jal	80003cec <create>
    80004258:	84aa                	mv	s1,a0
    if(ip == 0){
    8000425a:	c549                	beqz	a0,800042e4 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000425c:	04449703          	lh	a4,68(s1)
    80004260:	478d                	li	a5,3
    80004262:	00f71763          	bne	a4,a5,80004270 <sys_open+0x5e>
    80004266:	0464d703          	lhu	a4,70(s1)
    8000426a:	47a5                	li	a5,9
    8000426c:	0ae7ee63          	bltu	a5,a4,80004328 <sys_open+0x116>
    80004270:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004272:	fb7fe0ef          	jal	80003228 <filealloc>
    80004276:	892a                	mv	s2,a0
    80004278:	c561                	beqz	a0,80004340 <sys_open+0x12e>
    8000427a:	ed4e                	sd	s3,152(sp)
    8000427c:	a33ff0ef          	jal	80003cae <fdalloc>
    80004280:	89aa                	mv	s3,a0
    80004282:	0a054b63          	bltz	a0,80004338 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004286:	04449703          	lh	a4,68(s1)
    8000428a:	478d                	li	a5,3
    8000428c:	0cf70363          	beq	a4,a5,80004352 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004290:	4789                	li	a5,2
    80004292:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004296:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000429a:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000429e:	f4c42783          	lw	a5,-180(s0)
    800042a2:	0017f713          	andi	a4,a5,1
    800042a6:	00174713          	xori	a4,a4,1
    800042aa:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800042ae:	0037f713          	andi	a4,a5,3
    800042b2:	00e03733          	snez	a4,a4
    800042b6:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800042ba:	4007f793          	andi	a5,a5,1024
    800042be:	c791                	beqz	a5,800042ca <sys_open+0xb8>
    800042c0:	04449703          	lh	a4,68(s1)
    800042c4:	4789                	li	a5,2
    800042c6:	08f70d63          	beq	a4,a5,80004360 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    800042ca:	8526                	mv	a0,s1
    800042cc:	bdcfe0ef          	jal	800026a8 <iunlock>
  end_op();
    800042d0:	c47fe0ef          	jal	80002f16 <end_op>

  return fd;
    800042d4:	854e                	mv	a0,s3
    800042d6:	74aa                	ld	s1,168(sp)
    800042d8:	790a                	ld	s2,160(sp)
    800042da:	69ea                	ld	s3,152(sp)
}
    800042dc:	70ea                	ld	ra,184(sp)
    800042de:	744a                	ld	s0,176(sp)
    800042e0:	6129                	addi	sp,sp,192
    800042e2:	8082                	ret
      end_op();
    800042e4:	c33fe0ef          	jal	80002f16 <end_op>
      return -1;
    800042e8:	557d                	li	a0,-1
    800042ea:	74aa                	ld	s1,168(sp)
    800042ec:	bfc5                	j	800042dc <sys_open+0xca>
    if((ip = namei(path)) == 0){
    800042ee:	f5040513          	addi	a0,s0,-176
    800042f2:	9f9fe0ef          	jal	80002cea <namei>
    800042f6:	84aa                	mv	s1,a0
    800042f8:	c11d                	beqz	a0,8000431e <sys_open+0x10c>
    ilock(ip);
    800042fa:	b00fe0ef          	jal	800025fa <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800042fe:	04449703          	lh	a4,68(s1)
    80004302:	4785                	li	a5,1
    80004304:	f4f71ce3          	bne	a4,a5,8000425c <sys_open+0x4a>
    80004308:	f4c42783          	lw	a5,-180(s0)
    8000430c:	d3b5                	beqz	a5,80004270 <sys_open+0x5e>
      iunlockput(ip);
    8000430e:	8526                	mv	a0,s1
    80004310:	cf4fe0ef          	jal	80002804 <iunlockput>
      end_op();
    80004314:	c03fe0ef          	jal	80002f16 <end_op>
      return -1;
    80004318:	557d                	li	a0,-1
    8000431a:	74aa                	ld	s1,168(sp)
    8000431c:	b7c1                	j	800042dc <sys_open+0xca>
      end_op();
    8000431e:	bf9fe0ef          	jal	80002f16 <end_op>
      return -1;
    80004322:	557d                	li	a0,-1
    80004324:	74aa                	ld	s1,168(sp)
    80004326:	bf5d                	j	800042dc <sys_open+0xca>
    iunlockput(ip);
    80004328:	8526                	mv	a0,s1
    8000432a:	cdafe0ef          	jal	80002804 <iunlockput>
    end_op();
    8000432e:	be9fe0ef          	jal	80002f16 <end_op>
    return -1;
    80004332:	557d                	li	a0,-1
    80004334:	74aa                	ld	s1,168(sp)
    80004336:	b75d                	j	800042dc <sys_open+0xca>
      fileclose(f);
    80004338:	854a                	mv	a0,s2
    8000433a:	f93fe0ef          	jal	800032cc <fileclose>
    8000433e:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004340:	8526                	mv	a0,s1
    80004342:	cc2fe0ef          	jal	80002804 <iunlockput>
    end_op();
    80004346:	bd1fe0ef          	jal	80002f16 <end_op>
    return -1;
    8000434a:	557d                	li	a0,-1
    8000434c:	74aa                	ld	s1,168(sp)
    8000434e:	790a                	ld	s2,160(sp)
    80004350:	b771                	j	800042dc <sys_open+0xca>
    f->type = FD_DEVICE;
    80004352:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004356:	04649783          	lh	a5,70(s1)
    8000435a:	02f91223          	sh	a5,36(s2)
    8000435e:	bf35                	j	8000429a <sys_open+0x88>
    itrunc(ip);
    80004360:	8526                	mv	a0,s1
    80004362:	b86fe0ef          	jal	800026e8 <itrunc>
    80004366:	b795                	j	800042ca <sys_open+0xb8>

0000000080004368 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004368:	7175                	addi	sp,sp,-144
    8000436a:	e506                	sd	ra,136(sp)
    8000436c:	e122                	sd	s0,128(sp)
    8000436e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004370:	b3dfe0ef          	jal	80002eac <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004374:	08000613          	li	a2,128
    80004378:	f7040593          	addi	a1,s0,-144
    8000437c:	4501                	li	a0,0
    8000437e:	8b7fd0ef          	jal	80001c34 <argstr>
    80004382:	02054363          	bltz	a0,800043a8 <sys_mkdir+0x40>
    80004386:	4681                	li	a3,0
    80004388:	4601                	li	a2,0
    8000438a:	4585                	li	a1,1
    8000438c:	f7040513          	addi	a0,s0,-144
    80004390:	95dff0ef          	jal	80003cec <create>
    80004394:	c911                	beqz	a0,800043a8 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004396:	c6efe0ef          	jal	80002804 <iunlockput>
  end_op();
    8000439a:	b7dfe0ef          	jal	80002f16 <end_op>
  return 0;
    8000439e:	4501                	li	a0,0
}
    800043a0:	60aa                	ld	ra,136(sp)
    800043a2:	640a                	ld	s0,128(sp)
    800043a4:	6149                	addi	sp,sp,144
    800043a6:	8082                	ret
    end_op();
    800043a8:	b6ffe0ef          	jal	80002f16 <end_op>
    return -1;
    800043ac:	557d                	li	a0,-1
    800043ae:	bfcd                	j	800043a0 <sys_mkdir+0x38>

00000000800043b0 <sys_mknod>:

uint64
sys_mknod(void)
{
    800043b0:	7135                	addi	sp,sp,-160
    800043b2:	ed06                	sd	ra,152(sp)
    800043b4:	e922                	sd	s0,144(sp)
    800043b6:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800043b8:	af5fe0ef          	jal	80002eac <begin_op>
  argint(1, &major);
    800043bc:	f6c40593          	addi	a1,s0,-148
    800043c0:	4505                	li	a0,1
    800043c2:	83bfd0ef          	jal	80001bfc <argint>
  argint(2, &minor);
    800043c6:	f6840593          	addi	a1,s0,-152
    800043ca:	4509                	li	a0,2
    800043cc:	831fd0ef          	jal	80001bfc <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800043d0:	08000613          	li	a2,128
    800043d4:	f7040593          	addi	a1,s0,-144
    800043d8:	4501                	li	a0,0
    800043da:	85bfd0ef          	jal	80001c34 <argstr>
    800043de:	02054563          	bltz	a0,80004408 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800043e2:	f6841683          	lh	a3,-152(s0)
    800043e6:	f6c41603          	lh	a2,-148(s0)
    800043ea:	458d                	li	a1,3
    800043ec:	f7040513          	addi	a0,s0,-144
    800043f0:	8fdff0ef          	jal	80003cec <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800043f4:	c911                	beqz	a0,80004408 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800043f6:	c0efe0ef          	jal	80002804 <iunlockput>
  end_op();
    800043fa:	b1dfe0ef          	jal	80002f16 <end_op>
  return 0;
    800043fe:	4501                	li	a0,0
}
    80004400:	60ea                	ld	ra,152(sp)
    80004402:	644a                	ld	s0,144(sp)
    80004404:	610d                	addi	sp,sp,160
    80004406:	8082                	ret
    end_op();
    80004408:	b0ffe0ef          	jal	80002f16 <end_op>
    return -1;
    8000440c:	557d                	li	a0,-1
    8000440e:	bfcd                	j	80004400 <sys_mknod+0x50>

0000000080004410 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004410:	7135                	addi	sp,sp,-160
    80004412:	ed06                	sd	ra,152(sp)
    80004414:	e922                	sd	s0,144(sp)
    80004416:	e14a                	sd	s2,128(sp)
    80004418:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000441a:	931fc0ef          	jal	80000d4a <myproc>
    8000441e:	892a                	mv	s2,a0
  
  begin_op();
    80004420:	a8dfe0ef          	jal	80002eac <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004424:	08000613          	li	a2,128
    80004428:	f6040593          	addi	a1,s0,-160
    8000442c:	4501                	li	a0,0
    8000442e:	807fd0ef          	jal	80001c34 <argstr>
    80004432:	04054363          	bltz	a0,80004478 <sys_chdir+0x68>
    80004436:	e526                	sd	s1,136(sp)
    80004438:	f6040513          	addi	a0,s0,-160
    8000443c:	8affe0ef          	jal	80002cea <namei>
    80004440:	84aa                	mv	s1,a0
    80004442:	c915                	beqz	a0,80004476 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004444:	9b6fe0ef          	jal	800025fa <ilock>
  if(ip->type != T_DIR){
    80004448:	04449703          	lh	a4,68(s1)
    8000444c:	4785                	li	a5,1
    8000444e:	02f71963          	bne	a4,a5,80004480 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004452:	8526                	mv	a0,s1
    80004454:	a54fe0ef          	jal	800026a8 <iunlock>
  iput(p->cwd);
    80004458:	15093503          	ld	a0,336(s2)
    8000445c:	b20fe0ef          	jal	8000277c <iput>
  end_op();
    80004460:	ab7fe0ef          	jal	80002f16 <end_op>
  p->cwd = ip;
    80004464:	14993823          	sd	s1,336(s2)
  return 0;
    80004468:	4501                	li	a0,0
    8000446a:	64aa                	ld	s1,136(sp)
}
    8000446c:	60ea                	ld	ra,152(sp)
    8000446e:	644a                	ld	s0,144(sp)
    80004470:	690a                	ld	s2,128(sp)
    80004472:	610d                	addi	sp,sp,160
    80004474:	8082                	ret
    80004476:	64aa                	ld	s1,136(sp)
    end_op();
    80004478:	a9ffe0ef          	jal	80002f16 <end_op>
    return -1;
    8000447c:	557d                	li	a0,-1
    8000447e:	b7fd                	j	8000446c <sys_chdir+0x5c>
    iunlockput(ip);
    80004480:	8526                	mv	a0,s1
    80004482:	b82fe0ef          	jal	80002804 <iunlockput>
    end_op();
    80004486:	a91fe0ef          	jal	80002f16 <end_op>
    return -1;
    8000448a:	557d                	li	a0,-1
    8000448c:	64aa                	ld	s1,136(sp)
    8000448e:	bff9                	j	8000446c <sys_chdir+0x5c>

0000000080004490 <sys_exec>:

uint64
sys_exec(void)
{
    80004490:	7105                	addi	sp,sp,-480
    80004492:	ef86                	sd	ra,472(sp)
    80004494:	eba2                	sd	s0,464(sp)
    80004496:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004498:	e2840593          	addi	a1,s0,-472
    8000449c:	4505                	li	a0,1
    8000449e:	f7afd0ef          	jal	80001c18 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800044a2:	08000613          	li	a2,128
    800044a6:	f3040593          	addi	a1,s0,-208
    800044aa:	4501                	li	a0,0
    800044ac:	f88fd0ef          	jal	80001c34 <argstr>
    800044b0:	87aa                	mv	a5,a0
    return -1;
    800044b2:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800044b4:	0e07c063          	bltz	a5,80004594 <sys_exec+0x104>
    800044b8:	e7a6                	sd	s1,456(sp)
    800044ba:	e3ca                	sd	s2,448(sp)
    800044bc:	ff4e                	sd	s3,440(sp)
    800044be:	fb52                	sd	s4,432(sp)
    800044c0:	f756                	sd	s5,424(sp)
    800044c2:	f35a                	sd	s6,416(sp)
    800044c4:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800044c6:	e3040a13          	addi	s4,s0,-464
    800044ca:	10000613          	li	a2,256
    800044ce:	4581                	li	a1,0
    800044d0:	8552                	mv	a0,s4
    800044d2:	c63fb0ef          	jal	80000134 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800044d6:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800044d8:	89d2                	mv	s3,s4
    800044da:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800044dc:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800044e0:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800044e2:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800044e6:	00391513          	slli	a0,s2,0x3
    800044ea:	85d6                	mv	a1,s5
    800044ec:	e2843783          	ld	a5,-472(s0)
    800044f0:	953e                	add	a0,a0,a5
    800044f2:	e80fd0ef          	jal	80001b72 <fetchaddr>
    800044f6:	02054663          	bltz	a0,80004522 <sys_exec+0x92>
    if(uarg == 0){
    800044fa:	e2043783          	ld	a5,-480(s0)
    800044fe:	c7a1                	beqz	a5,80004546 <sys_exec+0xb6>
    argv[i] = kalloc();
    80004500:	bf7fb0ef          	jal	800000f6 <kalloc>
    80004504:	85aa                	mv	a1,a0
    80004506:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000450a:	cd01                	beqz	a0,80004522 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000450c:	865a                	mv	a2,s6
    8000450e:	e2043503          	ld	a0,-480(s0)
    80004512:	eaafd0ef          	jal	80001bbc <fetchstr>
    80004516:	00054663          	bltz	a0,80004522 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    8000451a:	0905                	addi	s2,s2,1
    8000451c:	09a1                	addi	s3,s3,8
    8000451e:	fd7914e3          	bne	s2,s7,800044e6 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004522:	100a0a13          	addi	s4,s4,256
    80004526:	6088                	ld	a0,0(s1)
    80004528:	cd31                	beqz	a0,80004584 <sys_exec+0xf4>
    kfree(argv[i]);
    8000452a:	af3fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000452e:	04a1                	addi	s1,s1,8
    80004530:	ff449be3          	bne	s1,s4,80004526 <sys_exec+0x96>
  return -1;
    80004534:	557d                	li	a0,-1
    80004536:	64be                	ld	s1,456(sp)
    80004538:	691e                	ld	s2,448(sp)
    8000453a:	79fa                	ld	s3,440(sp)
    8000453c:	7a5a                	ld	s4,432(sp)
    8000453e:	7aba                	ld	s5,424(sp)
    80004540:	7b1a                	ld	s6,416(sp)
    80004542:	6bfa                	ld	s7,408(sp)
    80004544:	a881                	j	80004594 <sys_exec+0x104>
      argv[i] = 0;
    80004546:	0009079b          	sext.w	a5,s2
    8000454a:	e3040593          	addi	a1,s0,-464
    8000454e:	078e                	slli	a5,a5,0x3
    80004550:	97ae                	add	a5,a5,a1
    80004552:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80004556:	f3040513          	addi	a0,s0,-208
    8000455a:	ba4ff0ef          	jal	800038fe <exec>
    8000455e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004560:	100a0a13          	addi	s4,s4,256
    80004564:	6088                	ld	a0,0(s1)
    80004566:	c511                	beqz	a0,80004572 <sys_exec+0xe2>
    kfree(argv[i]);
    80004568:	ab5fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000456c:	04a1                	addi	s1,s1,8
    8000456e:	ff449be3          	bne	s1,s4,80004564 <sys_exec+0xd4>
  return ret;
    80004572:	854a                	mv	a0,s2
    80004574:	64be                	ld	s1,456(sp)
    80004576:	691e                	ld	s2,448(sp)
    80004578:	79fa                	ld	s3,440(sp)
    8000457a:	7a5a                	ld	s4,432(sp)
    8000457c:	7aba                	ld	s5,424(sp)
    8000457e:	7b1a                	ld	s6,416(sp)
    80004580:	6bfa                	ld	s7,408(sp)
    80004582:	a809                	j	80004594 <sys_exec+0x104>
  return -1;
    80004584:	557d                	li	a0,-1
    80004586:	64be                	ld	s1,456(sp)
    80004588:	691e                	ld	s2,448(sp)
    8000458a:	79fa                	ld	s3,440(sp)
    8000458c:	7a5a                	ld	s4,432(sp)
    8000458e:	7aba                	ld	s5,424(sp)
    80004590:	7b1a                	ld	s6,416(sp)
    80004592:	6bfa                	ld	s7,408(sp)
}
    80004594:	60fe                	ld	ra,472(sp)
    80004596:	645e                	ld	s0,464(sp)
    80004598:	613d                	addi	sp,sp,480
    8000459a:	8082                	ret

000000008000459c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000459c:	7139                	addi	sp,sp,-64
    8000459e:	fc06                	sd	ra,56(sp)
    800045a0:	f822                	sd	s0,48(sp)
    800045a2:	f426                	sd	s1,40(sp)
    800045a4:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800045a6:	fa4fc0ef          	jal	80000d4a <myproc>
    800045aa:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800045ac:	fd840593          	addi	a1,s0,-40
    800045b0:	4501                	li	a0,0
    800045b2:	e66fd0ef          	jal	80001c18 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800045b6:	fc840593          	addi	a1,s0,-56
    800045ba:	fd040513          	addi	a0,s0,-48
    800045be:	81eff0ef          	jal	800035dc <pipealloc>
    return -1;
    800045c2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800045c4:	0a054463          	bltz	a0,8000466c <sys_pipe+0xd0>
  fd0 = -1;
    800045c8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800045cc:	fd043503          	ld	a0,-48(s0)
    800045d0:	edeff0ef          	jal	80003cae <fdalloc>
    800045d4:	fca42223          	sw	a0,-60(s0)
    800045d8:	08054163          	bltz	a0,8000465a <sys_pipe+0xbe>
    800045dc:	fc843503          	ld	a0,-56(s0)
    800045e0:	eceff0ef          	jal	80003cae <fdalloc>
    800045e4:	fca42023          	sw	a0,-64(s0)
    800045e8:	06054063          	bltz	a0,80004648 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800045ec:	4691                	li	a3,4
    800045ee:	fc440613          	addi	a2,s0,-60
    800045f2:	fd843583          	ld	a1,-40(s0)
    800045f6:	68a8                	ld	a0,80(s1)
    800045f8:	bfafc0ef          	jal	800009f2 <copyout>
    800045fc:	00054e63          	bltz	a0,80004618 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004600:	4691                	li	a3,4
    80004602:	fc040613          	addi	a2,s0,-64
    80004606:	fd843583          	ld	a1,-40(s0)
    8000460a:	95b6                	add	a1,a1,a3
    8000460c:	68a8                	ld	a0,80(s1)
    8000460e:	be4fc0ef          	jal	800009f2 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004612:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004614:	04055c63          	bgez	a0,8000466c <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004618:	fc442783          	lw	a5,-60(s0)
    8000461c:	07e9                	addi	a5,a5,26
    8000461e:	078e                	slli	a5,a5,0x3
    80004620:	97a6                	add	a5,a5,s1
    80004622:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004626:	fc042783          	lw	a5,-64(s0)
    8000462a:	07e9                	addi	a5,a5,26
    8000462c:	078e                	slli	a5,a5,0x3
    8000462e:	94be                	add	s1,s1,a5
    80004630:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004634:	fd043503          	ld	a0,-48(s0)
    80004638:	c95fe0ef          	jal	800032cc <fileclose>
    fileclose(wf);
    8000463c:	fc843503          	ld	a0,-56(s0)
    80004640:	c8dfe0ef          	jal	800032cc <fileclose>
    return -1;
    80004644:	57fd                	li	a5,-1
    80004646:	a01d                	j	8000466c <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004648:	fc442783          	lw	a5,-60(s0)
    8000464c:	0007c763          	bltz	a5,8000465a <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004650:	07e9                	addi	a5,a5,26
    80004652:	078e                	slli	a5,a5,0x3
    80004654:	97a6                	add	a5,a5,s1
    80004656:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000465a:	fd043503          	ld	a0,-48(s0)
    8000465e:	c6ffe0ef          	jal	800032cc <fileclose>
    fileclose(wf);
    80004662:	fc843503          	ld	a0,-56(s0)
    80004666:	c67fe0ef          	jal	800032cc <fileclose>
    return -1;
    8000466a:	57fd                	li	a5,-1
}
    8000466c:	853e                	mv	a0,a5
    8000466e:	70e2                	ld	ra,56(sp)
    80004670:	7442                	ld	s0,48(sp)
    80004672:	74a2                	ld	s1,40(sp)
    80004674:	6121                	addi	sp,sp,64
    80004676:	8082                	ret
	...

0000000080004680 <kernelvec>:
    80004680:	7111                	addi	sp,sp,-256
    80004682:	e006                	sd	ra,0(sp)
    80004684:	e40a                	sd	sp,8(sp)
    80004686:	e80e                	sd	gp,16(sp)
    80004688:	ec12                	sd	tp,24(sp)
    8000468a:	f016                	sd	t0,32(sp)
    8000468c:	f41a                	sd	t1,40(sp)
    8000468e:	f81e                	sd	t2,48(sp)
    80004690:	e4aa                	sd	a0,72(sp)
    80004692:	e8ae                	sd	a1,80(sp)
    80004694:	ecb2                	sd	a2,88(sp)
    80004696:	f0b6                	sd	a3,96(sp)
    80004698:	f4ba                	sd	a4,104(sp)
    8000469a:	f8be                	sd	a5,112(sp)
    8000469c:	fcc2                	sd	a6,120(sp)
    8000469e:	e146                	sd	a7,128(sp)
    800046a0:	edf2                	sd	t3,216(sp)
    800046a2:	f1f6                	sd	t4,224(sp)
    800046a4:	f5fa                	sd	t5,232(sp)
    800046a6:	f9fe                	sd	t6,240(sp)
    800046a8:	bdafd0ef          	jal	80001a82 <kerneltrap>
    800046ac:	6082                	ld	ra,0(sp)
    800046ae:	6122                	ld	sp,8(sp)
    800046b0:	61c2                	ld	gp,16(sp)
    800046b2:	7282                	ld	t0,32(sp)
    800046b4:	7322                	ld	t1,40(sp)
    800046b6:	73c2                	ld	t2,48(sp)
    800046b8:	6526                	ld	a0,72(sp)
    800046ba:	65c6                	ld	a1,80(sp)
    800046bc:	6666                	ld	a2,88(sp)
    800046be:	7686                	ld	a3,96(sp)
    800046c0:	7726                	ld	a4,104(sp)
    800046c2:	77c6                	ld	a5,112(sp)
    800046c4:	7866                	ld	a6,120(sp)
    800046c6:	688a                	ld	a7,128(sp)
    800046c8:	6e6e                	ld	t3,216(sp)
    800046ca:	7e8e                	ld	t4,224(sp)
    800046cc:	7f2e                	ld	t5,232(sp)
    800046ce:	7fce                	ld	t6,240(sp)
    800046d0:	6111                	addi	sp,sp,256
    800046d2:	10200073          	sret
	...

00000000800046de <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800046de:	1141                	addi	sp,sp,-16
    800046e0:	e406                	sd	ra,8(sp)
    800046e2:	e022                	sd	s0,0(sp)
    800046e4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800046e6:	0c000737          	lui	a4,0xc000
    800046ea:	4785                	li	a5,1
    800046ec:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800046ee:	c35c                	sw	a5,4(a4)
}
    800046f0:	60a2                	ld	ra,8(sp)
    800046f2:	6402                	ld	s0,0(sp)
    800046f4:	0141                	addi	sp,sp,16
    800046f6:	8082                	ret

00000000800046f8 <plicinithart>:

void
plicinithart(void)
{
    800046f8:	1141                	addi	sp,sp,-16
    800046fa:	e406                	sd	ra,8(sp)
    800046fc:	e022                	sd	s0,0(sp)
    800046fe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004700:	e16fc0ef          	jal	80000d16 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004704:	0085171b          	slliw	a4,a0,0x8
    80004708:	0c0027b7          	lui	a5,0xc002
    8000470c:	97ba                	add	a5,a5,a4
    8000470e:	40200713          	li	a4,1026
    80004712:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004716:	00d5151b          	slliw	a0,a0,0xd
    8000471a:	0c2017b7          	lui	a5,0xc201
    8000471e:	97aa                	add	a5,a5,a0
    80004720:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004724:	60a2                	ld	ra,8(sp)
    80004726:	6402                	ld	s0,0(sp)
    80004728:	0141                	addi	sp,sp,16
    8000472a:	8082                	ret

000000008000472c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000472c:	1141                	addi	sp,sp,-16
    8000472e:	e406                	sd	ra,8(sp)
    80004730:	e022                	sd	s0,0(sp)
    80004732:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004734:	de2fc0ef          	jal	80000d16 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004738:	00d5151b          	slliw	a0,a0,0xd
    8000473c:	0c2017b7          	lui	a5,0xc201
    80004740:	97aa                	add	a5,a5,a0
  return irq;
}
    80004742:	43c8                	lw	a0,4(a5)
    80004744:	60a2                	ld	ra,8(sp)
    80004746:	6402                	ld	s0,0(sp)
    80004748:	0141                	addi	sp,sp,16
    8000474a:	8082                	ret

000000008000474c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000474c:	1101                	addi	sp,sp,-32
    8000474e:	ec06                	sd	ra,24(sp)
    80004750:	e822                	sd	s0,16(sp)
    80004752:	e426                	sd	s1,8(sp)
    80004754:	1000                	addi	s0,sp,32
    80004756:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004758:	dbefc0ef          	jal	80000d16 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000475c:	00d5179b          	slliw	a5,a0,0xd
    80004760:	0c201737          	lui	a4,0xc201
    80004764:	97ba                	add	a5,a5,a4
    80004766:	c3c4                	sw	s1,4(a5)
}
    80004768:	60e2                	ld	ra,24(sp)
    8000476a:	6442                	ld	s0,16(sp)
    8000476c:	64a2                	ld	s1,8(sp)
    8000476e:	6105                	addi	sp,sp,32
    80004770:	8082                	ret

0000000080004772 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004772:	1141                	addi	sp,sp,-16
    80004774:	e406                	sd	ra,8(sp)
    80004776:	e022                	sd	s0,0(sp)
    80004778:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000477a:	479d                	li	a5,7
    8000477c:	04a7ca63          	blt	a5,a0,800047d0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004780:	00017797          	auipc	a5,0x17
    80004784:	c1078793          	addi	a5,a5,-1008 # 8001b390 <disk>
    80004788:	97aa                	add	a5,a5,a0
    8000478a:	0187c783          	lbu	a5,24(a5)
    8000478e:	e7b9                	bnez	a5,800047dc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004790:	00451693          	slli	a3,a0,0x4
    80004794:	00017797          	auipc	a5,0x17
    80004798:	bfc78793          	addi	a5,a5,-1028 # 8001b390 <disk>
    8000479c:	6398                	ld	a4,0(a5)
    8000479e:	9736                	add	a4,a4,a3
    800047a0:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    800047a4:	6398                	ld	a4,0(a5)
    800047a6:	9736                	add	a4,a4,a3
    800047a8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800047ac:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800047b0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800047b4:	97aa                	add	a5,a5,a0
    800047b6:	4705                	li	a4,1
    800047b8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800047bc:	00017517          	auipc	a0,0x17
    800047c0:	bec50513          	addi	a0,a0,-1044 # 8001b3a8 <disk+0x18>
    800047c4:	ba1fc0ef          	jal	80001364 <wakeup>
}
    800047c8:	60a2                	ld	ra,8(sp)
    800047ca:	6402                	ld	s0,0(sp)
    800047cc:	0141                	addi	sp,sp,16
    800047ce:	8082                	ret
    panic("free_desc 1");
    800047d0:	00003517          	auipc	a0,0x3
    800047d4:	e5050513          	addi	a0,a0,-432 # 80007620 <etext+0x620>
    800047d8:	40f000ef          	jal	800053e6 <panic>
    panic("free_desc 2");
    800047dc:	00003517          	auipc	a0,0x3
    800047e0:	e5450513          	addi	a0,a0,-428 # 80007630 <etext+0x630>
    800047e4:	403000ef          	jal	800053e6 <panic>

00000000800047e8 <virtio_disk_init>:
{
    800047e8:	1101                	addi	sp,sp,-32
    800047ea:	ec06                	sd	ra,24(sp)
    800047ec:	e822                	sd	s0,16(sp)
    800047ee:	e426                	sd	s1,8(sp)
    800047f0:	e04a                	sd	s2,0(sp)
    800047f2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800047f4:	00003597          	auipc	a1,0x3
    800047f8:	e4c58593          	addi	a1,a1,-436 # 80007640 <etext+0x640>
    800047fc:	00017517          	auipc	a0,0x17
    80004800:	cbc50513          	addi	a0,a0,-836 # 8001b4b8 <disk+0x128>
    80004804:	68d000ef          	jal	80005690 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004808:	100017b7          	lui	a5,0x10001
    8000480c:	4398                	lw	a4,0(a5)
    8000480e:	2701                	sext.w	a4,a4
    80004810:	747277b7          	lui	a5,0x74727
    80004814:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004818:	14f71863          	bne	a4,a5,80004968 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000481c:	100017b7          	lui	a5,0x10001
    80004820:	43dc                	lw	a5,4(a5)
    80004822:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004824:	4709                	li	a4,2
    80004826:	14e79163          	bne	a5,a4,80004968 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000482a:	100017b7          	lui	a5,0x10001
    8000482e:	479c                	lw	a5,8(a5)
    80004830:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004832:	12e79b63          	bne	a5,a4,80004968 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004836:	100017b7          	lui	a5,0x10001
    8000483a:	47d8                	lw	a4,12(a5)
    8000483c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000483e:	554d47b7          	lui	a5,0x554d4
    80004842:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004846:	12f71163          	bne	a4,a5,80004968 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000484a:	100017b7          	lui	a5,0x10001
    8000484e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004852:	4705                	li	a4,1
    80004854:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004856:	470d                	li	a4,3
    80004858:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000485a:	10001737          	lui	a4,0x10001
    8000485e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004860:	c7ffe6b7          	lui	a3,0xc7ffe
    80004864:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb18f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004868:	8f75                	and	a4,a4,a3
    8000486a:	100016b7          	lui	a3,0x10001
    8000486e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004870:	472d                	li	a4,11
    80004872:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004874:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004878:	439c                	lw	a5,0(a5)
    8000487a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000487e:	8ba1                	andi	a5,a5,8
    80004880:	0e078a63          	beqz	a5,80004974 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004884:	100017b7          	lui	a5,0x10001
    80004888:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000488c:	43fc                	lw	a5,68(a5)
    8000488e:	2781                	sext.w	a5,a5
    80004890:	0e079863          	bnez	a5,80004980 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004894:	100017b7          	lui	a5,0x10001
    80004898:	5bdc                	lw	a5,52(a5)
    8000489a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000489c:	0e078863          	beqz	a5,8000498c <virtio_disk_init+0x1a4>
  if(max < NUM)
    800048a0:	471d                	li	a4,7
    800048a2:	0ef77b63          	bgeu	a4,a5,80004998 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    800048a6:	851fb0ef          	jal	800000f6 <kalloc>
    800048aa:	00017497          	auipc	s1,0x17
    800048ae:	ae648493          	addi	s1,s1,-1306 # 8001b390 <disk>
    800048b2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800048b4:	843fb0ef          	jal	800000f6 <kalloc>
    800048b8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800048ba:	83dfb0ef          	jal	800000f6 <kalloc>
    800048be:	87aa                	mv	a5,a0
    800048c0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800048c2:	6088                	ld	a0,0(s1)
    800048c4:	0e050063          	beqz	a0,800049a4 <virtio_disk_init+0x1bc>
    800048c8:	00017717          	auipc	a4,0x17
    800048cc:	ad073703          	ld	a4,-1328(a4) # 8001b398 <disk+0x8>
    800048d0:	cb71                	beqz	a4,800049a4 <virtio_disk_init+0x1bc>
    800048d2:	cbe9                	beqz	a5,800049a4 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    800048d4:	6605                	lui	a2,0x1
    800048d6:	4581                	li	a1,0
    800048d8:	85dfb0ef          	jal	80000134 <memset>
  memset(disk.avail, 0, PGSIZE);
    800048dc:	00017497          	auipc	s1,0x17
    800048e0:	ab448493          	addi	s1,s1,-1356 # 8001b390 <disk>
    800048e4:	6605                	lui	a2,0x1
    800048e6:	4581                	li	a1,0
    800048e8:	6488                	ld	a0,8(s1)
    800048ea:	84bfb0ef          	jal	80000134 <memset>
  memset(disk.used, 0, PGSIZE);
    800048ee:	6605                	lui	a2,0x1
    800048f0:	4581                	li	a1,0
    800048f2:	6888                	ld	a0,16(s1)
    800048f4:	841fb0ef          	jal	80000134 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800048f8:	100017b7          	lui	a5,0x10001
    800048fc:	4721                	li	a4,8
    800048fe:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004900:	4098                	lw	a4,0(s1)
    80004902:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004906:	40d8                	lw	a4,4(s1)
    80004908:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000490c:	649c                	ld	a5,8(s1)
    8000490e:	0007869b          	sext.w	a3,a5
    80004912:	10001737          	lui	a4,0x10001
    80004916:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000491a:	9781                	srai	a5,a5,0x20
    8000491c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004920:	689c                	ld	a5,16(s1)
    80004922:	0007869b          	sext.w	a3,a5
    80004926:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000492a:	9781                	srai	a5,a5,0x20
    8000492c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004930:	4785                	li	a5,1
    80004932:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004934:	00f48c23          	sb	a5,24(s1)
    80004938:	00f48ca3          	sb	a5,25(s1)
    8000493c:	00f48d23          	sb	a5,26(s1)
    80004940:	00f48da3          	sb	a5,27(s1)
    80004944:	00f48e23          	sb	a5,28(s1)
    80004948:	00f48ea3          	sb	a5,29(s1)
    8000494c:	00f48f23          	sb	a5,30(s1)
    80004950:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004954:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004958:	07272823          	sw	s2,112(a4)
}
    8000495c:	60e2                	ld	ra,24(sp)
    8000495e:	6442                	ld	s0,16(sp)
    80004960:	64a2                	ld	s1,8(sp)
    80004962:	6902                	ld	s2,0(sp)
    80004964:	6105                	addi	sp,sp,32
    80004966:	8082                	ret
    panic("could not find virtio disk");
    80004968:	00003517          	auipc	a0,0x3
    8000496c:	ce850513          	addi	a0,a0,-792 # 80007650 <etext+0x650>
    80004970:	277000ef          	jal	800053e6 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004974:	00003517          	auipc	a0,0x3
    80004978:	cfc50513          	addi	a0,a0,-772 # 80007670 <etext+0x670>
    8000497c:	26b000ef          	jal	800053e6 <panic>
    panic("virtio disk should not be ready");
    80004980:	00003517          	auipc	a0,0x3
    80004984:	d1050513          	addi	a0,a0,-752 # 80007690 <etext+0x690>
    80004988:	25f000ef          	jal	800053e6 <panic>
    panic("virtio disk has no queue 0");
    8000498c:	00003517          	auipc	a0,0x3
    80004990:	d2450513          	addi	a0,a0,-732 # 800076b0 <etext+0x6b0>
    80004994:	253000ef          	jal	800053e6 <panic>
    panic("virtio disk max queue too short");
    80004998:	00003517          	auipc	a0,0x3
    8000499c:	d3850513          	addi	a0,a0,-712 # 800076d0 <etext+0x6d0>
    800049a0:	247000ef          	jal	800053e6 <panic>
    panic("virtio disk kalloc");
    800049a4:	00003517          	auipc	a0,0x3
    800049a8:	d4c50513          	addi	a0,a0,-692 # 800076f0 <etext+0x6f0>
    800049ac:	23b000ef          	jal	800053e6 <panic>

00000000800049b0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800049b0:	711d                	addi	sp,sp,-96
    800049b2:	ec86                	sd	ra,88(sp)
    800049b4:	e8a2                	sd	s0,80(sp)
    800049b6:	e4a6                	sd	s1,72(sp)
    800049b8:	e0ca                	sd	s2,64(sp)
    800049ba:	fc4e                	sd	s3,56(sp)
    800049bc:	f852                	sd	s4,48(sp)
    800049be:	f456                	sd	s5,40(sp)
    800049c0:	f05a                	sd	s6,32(sp)
    800049c2:	ec5e                	sd	s7,24(sp)
    800049c4:	e862                	sd	s8,16(sp)
    800049c6:	1080                	addi	s0,sp,96
    800049c8:	89aa                	mv	s3,a0
    800049ca:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800049cc:	00c52b83          	lw	s7,12(a0)
    800049d0:	001b9b9b          	slliw	s7,s7,0x1
    800049d4:	1b82                	slli	s7,s7,0x20
    800049d6:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    800049da:	00017517          	auipc	a0,0x17
    800049de:	ade50513          	addi	a0,a0,-1314 # 8001b4b8 <disk+0x128>
    800049e2:	533000ef          	jal	80005714 <acquire>
  for(int i = 0; i < NUM; i++){
    800049e6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800049e8:	00017a97          	auipc	s5,0x17
    800049ec:	9a8a8a93          	addi	s5,s5,-1624 # 8001b390 <disk>
  for(int i = 0; i < 3; i++){
    800049f0:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    800049f2:	5c7d                	li	s8,-1
    800049f4:	a095                	j	80004a58 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    800049f6:	00fa8733          	add	a4,s5,a5
    800049fa:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800049fe:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004a00:	0207c563          	bltz	a5,80004a2a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80004a04:	2905                	addiw	s2,s2,1
    80004a06:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004a08:	05490c63          	beq	s2,s4,80004a60 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80004a0c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004a0e:	00017717          	auipc	a4,0x17
    80004a12:	98270713          	addi	a4,a4,-1662 # 8001b390 <disk>
    80004a16:	4781                	li	a5,0
    if(disk.free[i]){
    80004a18:	01874683          	lbu	a3,24(a4)
    80004a1c:	fee9                	bnez	a3,800049f6 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80004a1e:	2785                	addiw	a5,a5,1
    80004a20:	0705                	addi	a4,a4,1
    80004a22:	fe979be3          	bne	a5,s1,80004a18 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80004a26:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80004a2a:	01205d63          	blez	s2,80004a44 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004a2e:	fa042503          	lw	a0,-96(s0)
    80004a32:	d41ff0ef          	jal	80004772 <free_desc>
      for(int j = 0; j < i; j++)
    80004a36:	4785                	li	a5,1
    80004a38:	0127d663          	bge	a5,s2,80004a44 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004a3c:	fa442503          	lw	a0,-92(s0)
    80004a40:	d33ff0ef          	jal	80004772 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004a44:	00017597          	auipc	a1,0x17
    80004a48:	a7458593          	addi	a1,a1,-1420 # 8001b4b8 <disk+0x128>
    80004a4c:	00017517          	auipc	a0,0x17
    80004a50:	95c50513          	addi	a0,a0,-1700 # 8001b3a8 <disk+0x18>
    80004a54:	8c5fc0ef          	jal	80001318 <sleep>
  for(int i = 0; i < 3; i++){
    80004a58:	fa040613          	addi	a2,s0,-96
    80004a5c:	4901                	li	s2,0
    80004a5e:	b77d                	j	80004a0c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004a60:	fa042503          	lw	a0,-96(s0)
    80004a64:	00451693          	slli	a3,a0,0x4

  if(write)
    80004a68:	00017797          	auipc	a5,0x17
    80004a6c:	92878793          	addi	a5,a5,-1752 # 8001b390 <disk>
    80004a70:	00a50713          	addi	a4,a0,10
    80004a74:	0712                	slli	a4,a4,0x4
    80004a76:	973e                	add	a4,a4,a5
    80004a78:	01603633          	snez	a2,s6
    80004a7c:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004a7e:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004a82:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004a86:	6398                	ld	a4,0(a5)
    80004a88:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004a8a:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80004a8e:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004a90:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004a92:	6390                	ld	a2,0(a5)
    80004a94:	00d605b3          	add	a1,a2,a3
    80004a98:	4741                	li	a4,16
    80004a9a:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004a9c:	4805                	li	a6,1
    80004a9e:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004aa2:	fa442703          	lw	a4,-92(s0)
    80004aa6:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004aaa:	0712                	slli	a4,a4,0x4
    80004aac:	963a                	add	a2,a2,a4
    80004aae:	05898593          	addi	a1,s3,88
    80004ab2:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004ab4:	0007b883          	ld	a7,0(a5)
    80004ab8:	9746                	add	a4,a4,a7
    80004aba:	40000613          	li	a2,1024
    80004abe:	c710                	sw	a2,8(a4)
  if(write)
    80004ac0:	001b3613          	seqz	a2,s6
    80004ac4:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004ac8:	01066633          	or	a2,a2,a6
    80004acc:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004ad0:	fa842583          	lw	a1,-88(s0)
    80004ad4:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004ad8:	00250613          	addi	a2,a0,2
    80004adc:	0612                	slli	a2,a2,0x4
    80004ade:	963e                	add	a2,a2,a5
    80004ae0:	577d                	li	a4,-1
    80004ae2:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004ae6:	0592                	slli	a1,a1,0x4
    80004ae8:	98ae                	add	a7,a7,a1
    80004aea:	03068713          	addi	a4,a3,48
    80004aee:	973e                	add	a4,a4,a5
    80004af0:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004af4:	6398                	ld	a4,0(a5)
    80004af6:	972e                	add	a4,a4,a1
    80004af8:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004afc:	4689                	li	a3,2
    80004afe:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004b02:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004b06:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80004b0a:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004b0e:	6794                	ld	a3,8(a5)
    80004b10:	0026d703          	lhu	a4,2(a3)
    80004b14:	8b1d                	andi	a4,a4,7
    80004b16:	0706                	slli	a4,a4,0x1
    80004b18:	96ba                	add	a3,a3,a4
    80004b1a:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004b1e:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004b22:	6798                	ld	a4,8(a5)
    80004b24:	00275783          	lhu	a5,2(a4)
    80004b28:	2785                	addiw	a5,a5,1
    80004b2a:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004b2e:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004b32:	100017b7          	lui	a5,0x10001
    80004b36:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004b3a:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80004b3e:	00017917          	auipc	s2,0x17
    80004b42:	97a90913          	addi	s2,s2,-1670 # 8001b4b8 <disk+0x128>
  while(b->disk == 1) {
    80004b46:	84c2                	mv	s1,a6
    80004b48:	01079a63          	bne	a5,a6,80004b5c <virtio_disk_rw+0x1ac>
    sleep(b, &disk.vdisk_lock);
    80004b4c:	85ca                	mv	a1,s2
    80004b4e:	854e                	mv	a0,s3
    80004b50:	fc8fc0ef          	jal	80001318 <sleep>
  while(b->disk == 1) {
    80004b54:	0049a783          	lw	a5,4(s3)
    80004b58:	fe978ae3          	beq	a5,s1,80004b4c <virtio_disk_rw+0x19c>
  }

  disk.info[idx[0]].b = 0;
    80004b5c:	fa042903          	lw	s2,-96(s0)
    80004b60:	00290713          	addi	a4,s2,2
    80004b64:	0712                	slli	a4,a4,0x4
    80004b66:	00017797          	auipc	a5,0x17
    80004b6a:	82a78793          	addi	a5,a5,-2006 # 8001b390 <disk>
    80004b6e:	97ba                	add	a5,a5,a4
    80004b70:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004b74:	00017997          	auipc	s3,0x17
    80004b78:	81c98993          	addi	s3,s3,-2020 # 8001b390 <disk>
    80004b7c:	00491713          	slli	a4,s2,0x4
    80004b80:	0009b783          	ld	a5,0(s3)
    80004b84:	97ba                	add	a5,a5,a4
    80004b86:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004b8a:	854a                	mv	a0,s2
    80004b8c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004b90:	be3ff0ef          	jal	80004772 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004b94:	8885                	andi	s1,s1,1
    80004b96:	f0fd                	bnez	s1,80004b7c <virtio_disk_rw+0x1cc>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004b98:	00017517          	auipc	a0,0x17
    80004b9c:	92050513          	addi	a0,a0,-1760 # 8001b4b8 <disk+0x128>
    80004ba0:	409000ef          	jal	800057a8 <release>
}
    80004ba4:	60e6                	ld	ra,88(sp)
    80004ba6:	6446                	ld	s0,80(sp)
    80004ba8:	64a6                	ld	s1,72(sp)
    80004baa:	6906                	ld	s2,64(sp)
    80004bac:	79e2                	ld	s3,56(sp)
    80004bae:	7a42                	ld	s4,48(sp)
    80004bb0:	7aa2                	ld	s5,40(sp)
    80004bb2:	7b02                	ld	s6,32(sp)
    80004bb4:	6be2                	ld	s7,24(sp)
    80004bb6:	6c42                	ld	s8,16(sp)
    80004bb8:	6125                	addi	sp,sp,96
    80004bba:	8082                	ret

0000000080004bbc <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004bbc:	1101                	addi	sp,sp,-32
    80004bbe:	ec06                	sd	ra,24(sp)
    80004bc0:	e822                	sd	s0,16(sp)
    80004bc2:	e426                	sd	s1,8(sp)
    80004bc4:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004bc6:	00016497          	auipc	s1,0x16
    80004bca:	7ca48493          	addi	s1,s1,1994 # 8001b390 <disk>
    80004bce:	00017517          	auipc	a0,0x17
    80004bd2:	8ea50513          	addi	a0,a0,-1814 # 8001b4b8 <disk+0x128>
    80004bd6:	33f000ef          	jal	80005714 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004bda:	100017b7          	lui	a5,0x10001
    80004bde:	53bc                	lw	a5,96(a5)
    80004be0:	8b8d                	andi	a5,a5,3
    80004be2:	10001737          	lui	a4,0x10001
    80004be6:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004be8:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004bec:	689c                	ld	a5,16(s1)
    80004bee:	0204d703          	lhu	a4,32(s1)
    80004bf2:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004bf6:	04f70663          	beq	a4,a5,80004c42 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004bfa:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004bfe:	6898                	ld	a4,16(s1)
    80004c00:	0204d783          	lhu	a5,32(s1)
    80004c04:	8b9d                	andi	a5,a5,7
    80004c06:	078e                	slli	a5,a5,0x3
    80004c08:	97ba                	add	a5,a5,a4
    80004c0a:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004c0c:	00278713          	addi	a4,a5,2
    80004c10:	0712                	slli	a4,a4,0x4
    80004c12:	9726                	add	a4,a4,s1
    80004c14:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80004c18:	e321                	bnez	a4,80004c58 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004c1a:	0789                	addi	a5,a5,2
    80004c1c:	0792                	slli	a5,a5,0x4
    80004c1e:	97a6                	add	a5,a5,s1
    80004c20:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004c22:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004c26:	f3efc0ef          	jal	80001364 <wakeup>

    disk.used_idx += 1;
    80004c2a:	0204d783          	lhu	a5,32(s1)
    80004c2e:	2785                	addiw	a5,a5,1
    80004c30:	17c2                	slli	a5,a5,0x30
    80004c32:	93c1                	srli	a5,a5,0x30
    80004c34:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004c38:	6898                	ld	a4,16(s1)
    80004c3a:	00275703          	lhu	a4,2(a4)
    80004c3e:	faf71ee3          	bne	a4,a5,80004bfa <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004c42:	00017517          	auipc	a0,0x17
    80004c46:	87650513          	addi	a0,a0,-1930 # 8001b4b8 <disk+0x128>
    80004c4a:	35f000ef          	jal	800057a8 <release>
}
    80004c4e:	60e2                	ld	ra,24(sp)
    80004c50:	6442                	ld	s0,16(sp)
    80004c52:	64a2                	ld	s1,8(sp)
    80004c54:	6105                	addi	sp,sp,32
    80004c56:	8082                	ret
      panic("virtio_disk_intr status");
    80004c58:	00003517          	auipc	a0,0x3
    80004c5c:	ab050513          	addi	a0,a0,-1360 # 80007708 <etext+0x708>
    80004c60:	786000ef          	jal	800053e6 <panic>

0000000080004c64 <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004c64:	1141                	addi	sp,sp,-16
    80004c66:	e406                	sd	ra,8(sp)
    80004c68:	e022                	sd	s0,0(sp)
    80004c6a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004c6c:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004c70:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004c74:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004c78:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004c7c:	577d                	li	a4,-1
    80004c7e:	177e                	slli	a4,a4,0x3f
    80004c80:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004c82:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004c86:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004c8a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004c8e:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004c92:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004c96:	000f4737          	lui	a4,0xf4
    80004c9a:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004c9e:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004ca0:	14d79073          	csrw	stimecmp,a5
}
    80004ca4:	60a2                	ld	ra,8(sp)
    80004ca6:	6402                	ld	s0,0(sp)
    80004ca8:	0141                	addi	sp,sp,16
    80004caa:	8082                	ret

0000000080004cac <start>:
{
    80004cac:	1141                	addi	sp,sp,-16
    80004cae:	e406                	sd	ra,8(sp)
    80004cb0:	e022                	sd	s0,0(sp)
    80004cb2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004cb4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004cb8:	7779                	lui	a4,0xffffe
    80004cba:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb22f>
    80004cbe:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004cc0:	6705                	lui	a4,0x1
    80004cc2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004cc6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004cc8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004ccc:	ffffb797          	auipc	a5,0xffffb
    80004cd0:	61e78793          	addi	a5,a5,1566 # 800002ea <main>
    80004cd4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004cd8:	4781                	li	a5,0
    80004cda:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004cde:	67c1                	lui	a5,0x10
    80004ce0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004ce2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004ce6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004cea:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004cee:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004cf2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004cf6:	57fd                	li	a5,-1
    80004cf8:	83a9                	srli	a5,a5,0xa
    80004cfa:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004cfe:	47bd                	li	a5,15
    80004d00:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004d04:	f61ff0ef          	jal	80004c64 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004d08:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004d0c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004d0e:	823e                	mv	tp,a5
  asm volatile("mret");
    80004d10:	30200073          	mret
}
    80004d14:	60a2                	ld	ra,8(sp)
    80004d16:	6402                	ld	s0,0(sp)
    80004d18:	0141                	addi	sp,sp,16
    80004d1a:	8082                	ret

0000000080004d1c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004d1c:	711d                	addi	sp,sp,-96
    80004d1e:	ec86                	sd	ra,88(sp)
    80004d20:	e8a2                	sd	s0,80(sp)
    80004d22:	e0ca                	sd	s2,64(sp)
    80004d24:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    80004d26:	04c05863          	blez	a2,80004d76 <consolewrite+0x5a>
    80004d2a:	e4a6                	sd	s1,72(sp)
    80004d2c:	fc4e                	sd	s3,56(sp)
    80004d2e:	f852                	sd	s4,48(sp)
    80004d30:	f456                	sd	s5,40(sp)
    80004d32:	f05a                	sd	s6,32(sp)
    80004d34:	ec5e                	sd	s7,24(sp)
    80004d36:	8a2a                	mv	s4,a0
    80004d38:	84ae                	mv	s1,a1
    80004d3a:	89b2                	mv	s3,a2
    80004d3c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004d3e:	faf40b93          	addi	s7,s0,-81
    80004d42:	4b05                	li	s6,1
    80004d44:	5afd                	li	s5,-1
    80004d46:	86da                	mv	a3,s6
    80004d48:	8626                	mv	a2,s1
    80004d4a:	85d2                	mv	a1,s4
    80004d4c:	855e                	mv	a0,s7
    80004d4e:	96bfc0ef          	jal	800016b8 <either_copyin>
    80004d52:	03550463          	beq	a0,s5,80004d7a <consolewrite+0x5e>
      break;
    uartputc(c);
    80004d56:	faf44503          	lbu	a0,-81(s0)
    80004d5a:	02d000ef          	jal	80005586 <uartputc>
  for(i = 0; i < n; i++){
    80004d5e:	2905                	addiw	s2,s2,1
    80004d60:	0485                	addi	s1,s1,1
    80004d62:	ff2992e3          	bne	s3,s2,80004d46 <consolewrite+0x2a>
    80004d66:	894e                	mv	s2,s3
    80004d68:	64a6                	ld	s1,72(sp)
    80004d6a:	79e2                	ld	s3,56(sp)
    80004d6c:	7a42                	ld	s4,48(sp)
    80004d6e:	7aa2                	ld	s5,40(sp)
    80004d70:	7b02                	ld	s6,32(sp)
    80004d72:	6be2                	ld	s7,24(sp)
    80004d74:	a809                	j	80004d86 <consolewrite+0x6a>
    80004d76:	4901                	li	s2,0
    80004d78:	a039                	j	80004d86 <consolewrite+0x6a>
    80004d7a:	64a6                	ld	s1,72(sp)
    80004d7c:	79e2                	ld	s3,56(sp)
    80004d7e:	7a42                	ld	s4,48(sp)
    80004d80:	7aa2                	ld	s5,40(sp)
    80004d82:	7b02                	ld	s6,32(sp)
    80004d84:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    80004d86:	854a                	mv	a0,s2
    80004d88:	60e6                	ld	ra,88(sp)
    80004d8a:	6446                	ld	s0,80(sp)
    80004d8c:	6906                	ld	s2,64(sp)
    80004d8e:	6125                	addi	sp,sp,96
    80004d90:	8082                	ret

0000000080004d92 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004d92:	711d                	addi	sp,sp,-96
    80004d94:	ec86                	sd	ra,88(sp)
    80004d96:	e8a2                	sd	s0,80(sp)
    80004d98:	e4a6                	sd	s1,72(sp)
    80004d9a:	e0ca                	sd	s2,64(sp)
    80004d9c:	fc4e                	sd	s3,56(sp)
    80004d9e:	f852                	sd	s4,48(sp)
    80004da0:	f456                	sd	s5,40(sp)
    80004da2:	f05a                	sd	s6,32(sp)
    80004da4:	1080                	addi	s0,sp,96
    80004da6:	8aaa                	mv	s5,a0
    80004da8:	8a2e                	mv	s4,a1
    80004daa:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004dac:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    80004dae:	0001e517          	auipc	a0,0x1e
    80004db2:	72250513          	addi	a0,a0,1826 # 800234d0 <cons>
    80004db6:	15f000ef          	jal	80005714 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004dba:	0001e497          	auipc	s1,0x1e
    80004dbe:	71648493          	addi	s1,s1,1814 # 800234d0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004dc2:	0001e917          	auipc	s2,0x1e
    80004dc6:	7a690913          	addi	s2,s2,1958 # 80023568 <cons+0x98>
  while(n > 0){
    80004dca:	0b305b63          	blez	s3,80004e80 <consoleread+0xee>
    while(cons.r == cons.w){
    80004dce:	0984a783          	lw	a5,152(s1)
    80004dd2:	09c4a703          	lw	a4,156(s1)
    80004dd6:	0af71063          	bne	a4,a5,80004e76 <consoleread+0xe4>
      if(killed(myproc())){
    80004dda:	f71fb0ef          	jal	80000d4a <myproc>
    80004dde:	f72fc0ef          	jal	80001550 <killed>
    80004de2:	e12d                	bnez	a0,80004e44 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    80004de4:	85a6                	mv	a1,s1
    80004de6:	854a                	mv	a0,s2
    80004de8:	d30fc0ef          	jal	80001318 <sleep>
    while(cons.r == cons.w){
    80004dec:	0984a783          	lw	a5,152(s1)
    80004df0:	09c4a703          	lw	a4,156(s1)
    80004df4:	fef703e3          	beq	a4,a5,80004dda <consoleread+0x48>
    80004df8:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004dfa:	0001e717          	auipc	a4,0x1e
    80004dfe:	6d670713          	addi	a4,a4,1750 # 800234d0 <cons>
    80004e02:	0017869b          	addiw	a3,a5,1
    80004e06:	08d72c23          	sw	a3,152(a4)
    80004e0a:	07f7f693          	andi	a3,a5,127
    80004e0e:	9736                	add	a4,a4,a3
    80004e10:	01874703          	lbu	a4,24(a4)
    80004e14:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80004e18:	4691                	li	a3,4
    80004e1a:	04db8663          	beq	s7,a3,80004e66 <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80004e1e:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004e22:	4685                	li	a3,1
    80004e24:	faf40613          	addi	a2,s0,-81
    80004e28:	85d2                	mv	a1,s4
    80004e2a:	8556                	mv	a0,s5
    80004e2c:	843fc0ef          	jal	8000166e <either_copyout>
    80004e30:	57fd                	li	a5,-1
    80004e32:	04f50663          	beq	a0,a5,80004e7e <consoleread+0xec>
      break;

    dst++;
    80004e36:	0a05                	addi	s4,s4,1
    --n;
    80004e38:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80004e3a:	47a9                	li	a5,10
    80004e3c:	04fb8b63          	beq	s7,a5,80004e92 <consoleread+0x100>
    80004e40:	6be2                	ld	s7,24(sp)
    80004e42:	b761                	j	80004dca <consoleread+0x38>
        release(&cons.lock);
    80004e44:	0001e517          	auipc	a0,0x1e
    80004e48:	68c50513          	addi	a0,a0,1676 # 800234d0 <cons>
    80004e4c:	15d000ef          	jal	800057a8 <release>
        return -1;
    80004e50:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80004e52:	60e6                	ld	ra,88(sp)
    80004e54:	6446                	ld	s0,80(sp)
    80004e56:	64a6                	ld	s1,72(sp)
    80004e58:	6906                	ld	s2,64(sp)
    80004e5a:	79e2                	ld	s3,56(sp)
    80004e5c:	7a42                	ld	s4,48(sp)
    80004e5e:	7aa2                	ld	s5,40(sp)
    80004e60:	7b02                	ld	s6,32(sp)
    80004e62:	6125                	addi	sp,sp,96
    80004e64:	8082                	ret
      if(n < target){
    80004e66:	0169fa63          	bgeu	s3,s6,80004e7a <consoleread+0xe8>
        cons.r--;
    80004e6a:	0001e717          	auipc	a4,0x1e
    80004e6e:	6ef72f23          	sw	a5,1790(a4) # 80023568 <cons+0x98>
    80004e72:	6be2                	ld	s7,24(sp)
    80004e74:	a031                	j	80004e80 <consoleread+0xee>
    80004e76:	ec5e                	sd	s7,24(sp)
    80004e78:	b749                	j	80004dfa <consoleread+0x68>
    80004e7a:	6be2                	ld	s7,24(sp)
    80004e7c:	a011                	j	80004e80 <consoleread+0xee>
    80004e7e:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80004e80:	0001e517          	auipc	a0,0x1e
    80004e84:	65050513          	addi	a0,a0,1616 # 800234d0 <cons>
    80004e88:	121000ef          	jal	800057a8 <release>
  return target - n;
    80004e8c:	413b053b          	subw	a0,s6,s3
    80004e90:	b7c9                	j	80004e52 <consoleread+0xc0>
    80004e92:	6be2                	ld	s7,24(sp)
    80004e94:	b7f5                	j	80004e80 <consoleread+0xee>

0000000080004e96 <consputc>:
{
    80004e96:	1141                	addi	sp,sp,-16
    80004e98:	e406                	sd	ra,8(sp)
    80004e9a:	e022                	sd	s0,0(sp)
    80004e9c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80004e9e:	10000793          	li	a5,256
    80004ea2:	00f50863          	beq	a0,a5,80004eb2 <consputc+0x1c>
    uartputc_sync(c);
    80004ea6:	5fe000ef          	jal	800054a4 <uartputc_sync>
}
    80004eaa:	60a2                	ld	ra,8(sp)
    80004eac:	6402                	ld	s0,0(sp)
    80004eae:	0141                	addi	sp,sp,16
    80004eb0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80004eb2:	4521                	li	a0,8
    80004eb4:	5f0000ef          	jal	800054a4 <uartputc_sync>
    80004eb8:	02000513          	li	a0,32
    80004ebc:	5e8000ef          	jal	800054a4 <uartputc_sync>
    80004ec0:	4521                	li	a0,8
    80004ec2:	5e2000ef          	jal	800054a4 <uartputc_sync>
    80004ec6:	b7d5                	j	80004eaa <consputc+0x14>

0000000080004ec8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80004ec8:	7179                	addi	sp,sp,-48
    80004eca:	f406                	sd	ra,40(sp)
    80004ecc:	f022                	sd	s0,32(sp)
    80004ece:	ec26                	sd	s1,24(sp)
    80004ed0:	1800                	addi	s0,sp,48
    80004ed2:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80004ed4:	0001e517          	auipc	a0,0x1e
    80004ed8:	5fc50513          	addi	a0,a0,1532 # 800234d0 <cons>
    80004edc:	039000ef          	jal	80005714 <acquire>

  switch(c){
    80004ee0:	47d5                	li	a5,21
    80004ee2:	08f48e63          	beq	s1,a5,80004f7e <consoleintr+0xb6>
    80004ee6:	0297c563          	blt	a5,s1,80004f10 <consoleintr+0x48>
    80004eea:	47a1                	li	a5,8
    80004eec:	0ef48863          	beq	s1,a5,80004fdc <consoleintr+0x114>
    80004ef0:	47c1                	li	a5,16
    80004ef2:	10f49963          	bne	s1,a5,80005004 <consoleintr+0x13c>
  case C('P'):  // Print process list.
    procdump();
    80004ef6:	80dfc0ef          	jal	80001702 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80004efa:	0001e517          	auipc	a0,0x1e
    80004efe:	5d650513          	addi	a0,a0,1494 # 800234d0 <cons>
    80004f02:	0a7000ef          	jal	800057a8 <release>
}
    80004f06:	70a2                	ld	ra,40(sp)
    80004f08:	7402                	ld	s0,32(sp)
    80004f0a:	64e2                	ld	s1,24(sp)
    80004f0c:	6145                	addi	sp,sp,48
    80004f0e:	8082                	ret
  switch(c){
    80004f10:	07f00793          	li	a5,127
    80004f14:	0cf48463          	beq	s1,a5,80004fdc <consoleintr+0x114>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80004f18:	0001e717          	auipc	a4,0x1e
    80004f1c:	5b870713          	addi	a4,a4,1464 # 800234d0 <cons>
    80004f20:	0a072783          	lw	a5,160(a4)
    80004f24:	09872703          	lw	a4,152(a4)
    80004f28:	9f99                	subw	a5,a5,a4
    80004f2a:	07f00713          	li	a4,127
    80004f2e:	fcf766e3          	bltu	a4,a5,80004efa <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80004f32:	47b5                	li	a5,13
    80004f34:	0cf48b63          	beq	s1,a5,8000500a <consoleintr+0x142>
      consputc(c);
    80004f38:	8526                	mv	a0,s1
    80004f3a:	f5dff0ef          	jal	80004e96 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80004f3e:	0001e797          	auipc	a5,0x1e
    80004f42:	59278793          	addi	a5,a5,1426 # 800234d0 <cons>
    80004f46:	0a07a683          	lw	a3,160(a5)
    80004f4a:	0016871b          	addiw	a4,a3,1
    80004f4e:	863a                	mv	a2,a4
    80004f50:	0ae7a023          	sw	a4,160(a5)
    80004f54:	07f6f693          	andi	a3,a3,127
    80004f58:	97b6                	add	a5,a5,a3
    80004f5a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80004f5e:	47a9                	li	a5,10
    80004f60:	0cf48963          	beq	s1,a5,80005032 <consoleintr+0x16a>
    80004f64:	4791                	li	a5,4
    80004f66:	0cf48663          	beq	s1,a5,80005032 <consoleintr+0x16a>
    80004f6a:	0001e797          	auipc	a5,0x1e
    80004f6e:	5fe7a783          	lw	a5,1534(a5) # 80023568 <cons+0x98>
    80004f72:	9f1d                	subw	a4,a4,a5
    80004f74:	08000793          	li	a5,128
    80004f78:	f8f711e3          	bne	a4,a5,80004efa <consoleintr+0x32>
    80004f7c:	a85d                	j	80005032 <consoleintr+0x16a>
    80004f7e:	e84a                	sd	s2,16(sp)
    80004f80:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    80004f82:	0001e717          	auipc	a4,0x1e
    80004f86:	54e70713          	addi	a4,a4,1358 # 800234d0 <cons>
    80004f8a:	0a072783          	lw	a5,160(a4)
    80004f8e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80004f92:	0001e497          	auipc	s1,0x1e
    80004f96:	53e48493          	addi	s1,s1,1342 # 800234d0 <cons>
    while(cons.e != cons.w &&
    80004f9a:	4929                	li	s2,10
      consputc(BACKSPACE);
    80004f9c:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    80004fa0:	02f70863          	beq	a4,a5,80004fd0 <consoleintr+0x108>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80004fa4:	37fd                	addiw	a5,a5,-1
    80004fa6:	07f7f713          	andi	a4,a5,127
    80004faa:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80004fac:	01874703          	lbu	a4,24(a4)
    80004fb0:	03270363          	beq	a4,s2,80004fd6 <consoleintr+0x10e>
      cons.e--;
    80004fb4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80004fb8:	854e                	mv	a0,s3
    80004fba:	eddff0ef          	jal	80004e96 <consputc>
    while(cons.e != cons.w &&
    80004fbe:	0a04a783          	lw	a5,160(s1)
    80004fc2:	09c4a703          	lw	a4,156(s1)
    80004fc6:	fcf71fe3          	bne	a4,a5,80004fa4 <consoleintr+0xdc>
    80004fca:	6942                	ld	s2,16(sp)
    80004fcc:	69a2                	ld	s3,8(sp)
    80004fce:	b735                	j	80004efa <consoleintr+0x32>
    80004fd0:	6942                	ld	s2,16(sp)
    80004fd2:	69a2                	ld	s3,8(sp)
    80004fd4:	b71d                	j	80004efa <consoleintr+0x32>
    80004fd6:	6942                	ld	s2,16(sp)
    80004fd8:	69a2                	ld	s3,8(sp)
    80004fda:	b705                	j	80004efa <consoleintr+0x32>
    if(cons.e != cons.w){
    80004fdc:	0001e717          	auipc	a4,0x1e
    80004fe0:	4f470713          	addi	a4,a4,1268 # 800234d0 <cons>
    80004fe4:	0a072783          	lw	a5,160(a4)
    80004fe8:	09c72703          	lw	a4,156(a4)
    80004fec:	f0f707e3          	beq	a4,a5,80004efa <consoleintr+0x32>
      cons.e--;
    80004ff0:	37fd                	addiw	a5,a5,-1
    80004ff2:	0001e717          	auipc	a4,0x1e
    80004ff6:	56f72f23          	sw	a5,1406(a4) # 80023570 <cons+0xa0>
      consputc(BACKSPACE);
    80004ffa:	10000513          	li	a0,256
    80004ffe:	e99ff0ef          	jal	80004e96 <consputc>
    80005002:	bde5                	j	80004efa <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005004:	ee048be3          	beqz	s1,80004efa <consoleintr+0x32>
    80005008:	bf01                	j	80004f18 <consoleintr+0x50>
      consputc(c);
    8000500a:	4529                	li	a0,10
    8000500c:	e8bff0ef          	jal	80004e96 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005010:	0001e797          	auipc	a5,0x1e
    80005014:	4c078793          	addi	a5,a5,1216 # 800234d0 <cons>
    80005018:	0a07a703          	lw	a4,160(a5)
    8000501c:	0017069b          	addiw	a3,a4,1
    80005020:	8636                	mv	a2,a3
    80005022:	0ad7a023          	sw	a3,160(a5)
    80005026:	07f77713          	andi	a4,a4,127
    8000502a:	97ba                	add	a5,a5,a4
    8000502c:	4729                	li	a4,10
    8000502e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005032:	0001e797          	auipc	a5,0x1e
    80005036:	52c7ad23          	sw	a2,1338(a5) # 8002356c <cons+0x9c>
        wakeup(&cons.r);
    8000503a:	0001e517          	auipc	a0,0x1e
    8000503e:	52e50513          	addi	a0,a0,1326 # 80023568 <cons+0x98>
    80005042:	b22fc0ef          	jal	80001364 <wakeup>
    80005046:	bd55                	j	80004efa <consoleintr+0x32>

0000000080005048 <consoleinit>:

void
consoleinit(void)
{
    80005048:	1141                	addi	sp,sp,-16
    8000504a:	e406                	sd	ra,8(sp)
    8000504c:	e022                	sd	s0,0(sp)
    8000504e:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005050:	00002597          	auipc	a1,0x2
    80005054:	6d058593          	addi	a1,a1,1744 # 80007720 <etext+0x720>
    80005058:	0001e517          	auipc	a0,0x1e
    8000505c:	47850513          	addi	a0,a0,1144 # 800234d0 <cons>
    80005060:	630000ef          	jal	80005690 <initlock>

  uartinit();
    80005064:	3ea000ef          	jal	8000544e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005068:	00015797          	auipc	a5,0x15
    8000506c:	2d078793          	addi	a5,a5,720 # 8001a338 <devsw>
    80005070:	00000717          	auipc	a4,0x0
    80005074:	d2270713          	addi	a4,a4,-734 # 80004d92 <consoleread>
    80005078:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000507a:	00000717          	auipc	a4,0x0
    8000507e:	ca270713          	addi	a4,a4,-862 # 80004d1c <consolewrite>
    80005082:	ef98                	sd	a4,24(a5)
}
    80005084:	60a2                	ld	ra,8(sp)
    80005086:	6402                	ld	s0,0(sp)
    80005088:	0141                	addi	sp,sp,16
    8000508a:	8082                	ret

000000008000508c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000508c:	7179                	addi	sp,sp,-48
    8000508e:	f406                	sd	ra,40(sp)
    80005090:	f022                	sd	s0,32(sp)
    80005092:	ec26                	sd	s1,24(sp)
    80005094:	e84a                	sd	s2,16(sp)
    80005096:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005098:	c219                	beqz	a2,8000509e <printint+0x12>
    8000509a:	06054a63          	bltz	a0,8000510e <printint+0x82>
    x = -xx;
  else
    x = xx;
    8000509e:	4e01                	li	t3,0

  i = 0;
    800050a0:	fd040313          	addi	t1,s0,-48
    x = xx;
    800050a4:	869a                	mv	a3,t1
  i = 0;
    800050a6:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800050a8:	00002817          	auipc	a6,0x2
    800050ac:	7d080813          	addi	a6,a6,2000 # 80007878 <digits>
    800050b0:	88be                	mv	a7,a5
    800050b2:	0017861b          	addiw	a2,a5,1
    800050b6:	87b2                	mv	a5,a2
    800050b8:	02b57733          	remu	a4,a0,a1
    800050bc:	9742                	add	a4,a4,a6
    800050be:	00074703          	lbu	a4,0(a4)
    800050c2:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800050c6:	872a                	mv	a4,a0
    800050c8:	02b55533          	divu	a0,a0,a1
    800050cc:	0685                	addi	a3,a3,1
    800050ce:	feb771e3          	bgeu	a4,a1,800050b0 <printint+0x24>

  if(sign)
    800050d2:	000e0c63          	beqz	t3,800050ea <printint+0x5e>
    buf[i++] = '-';
    800050d6:	fe060793          	addi	a5,a2,-32
    800050da:	00878633          	add	a2,a5,s0
    800050de:	02d00793          	li	a5,45
    800050e2:	fef60823          	sb	a5,-16(a2)
    800050e6:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    800050ea:	fff7891b          	addiw	s2,a5,-1
    800050ee:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    800050f2:	fff4c503          	lbu	a0,-1(s1)
    800050f6:	da1ff0ef          	jal	80004e96 <consputc>
  while(--i >= 0)
    800050fa:	397d                	addiw	s2,s2,-1
    800050fc:	14fd                	addi	s1,s1,-1
    800050fe:	fe095ae3          	bgez	s2,800050f2 <printint+0x66>
}
    80005102:	70a2                	ld	ra,40(sp)
    80005104:	7402                	ld	s0,32(sp)
    80005106:	64e2                	ld	s1,24(sp)
    80005108:	6942                	ld	s2,16(sp)
    8000510a:	6145                	addi	sp,sp,48
    8000510c:	8082                	ret
    x = -xx;
    8000510e:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005112:	4e05                	li	t3,1
    x = -xx;
    80005114:	b771                	j	800050a0 <printint+0x14>

0000000080005116 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005116:	7155                	addi	sp,sp,-208
    80005118:	e506                	sd	ra,136(sp)
    8000511a:	e122                	sd	s0,128(sp)
    8000511c:	f0d2                	sd	s4,96(sp)
    8000511e:	0900                	addi	s0,sp,144
    80005120:	8a2a                	mv	s4,a0
    80005122:	e40c                	sd	a1,8(s0)
    80005124:	e810                	sd	a2,16(s0)
    80005126:	ec14                	sd	a3,24(s0)
    80005128:	f018                	sd	a4,32(s0)
    8000512a:	f41c                	sd	a5,40(s0)
    8000512c:	03043823          	sd	a6,48(s0)
    80005130:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    80005134:	0001e797          	auipc	a5,0x1e
    80005138:	45c7a783          	lw	a5,1116(a5) # 80023590 <pr+0x18>
    8000513c:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    80005140:	e3a1                	bnez	a5,80005180 <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005142:	00840793          	addi	a5,s0,8
    80005146:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000514a:	00054503          	lbu	a0,0(a0)
    8000514e:	26050663          	beqz	a0,800053ba <printf+0x2a4>
    80005152:	fca6                	sd	s1,120(sp)
    80005154:	f8ca                	sd	s2,112(sp)
    80005156:	f4ce                	sd	s3,104(sp)
    80005158:	ecd6                	sd	s5,88(sp)
    8000515a:	e8da                	sd	s6,80(sp)
    8000515c:	e0e2                	sd	s8,64(sp)
    8000515e:	fc66                	sd	s9,56(sp)
    80005160:	f86a                	sd	s10,48(sp)
    80005162:	f46e                	sd	s11,40(sp)
    80005164:	4981                	li	s3,0
    if(cx != '%'){
    80005166:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    8000516a:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000516e:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80005172:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005176:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    8000517a:	07000d93          	li	s11,112
    8000517e:	a80d                	j	800051b0 <printf+0x9a>
    acquire(&pr.lock);
    80005180:	0001e517          	auipc	a0,0x1e
    80005184:	3f850513          	addi	a0,a0,1016 # 80023578 <pr>
    80005188:	58c000ef          	jal	80005714 <acquire>
  va_start(ap, fmt);
    8000518c:	00840793          	addi	a5,s0,8
    80005190:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005194:	000a4503          	lbu	a0,0(s4)
    80005198:	fd4d                	bnez	a0,80005152 <printf+0x3c>
    8000519a:	ac3d                	j	800053d8 <printf+0x2c2>
      consputc(cx);
    8000519c:	cfbff0ef          	jal	80004e96 <consputc>
      continue;
    800051a0:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800051a2:	2485                	addiw	s1,s1,1
    800051a4:	89a6                	mv	s3,s1
    800051a6:	94d2                	add	s1,s1,s4
    800051a8:	0004c503          	lbu	a0,0(s1)
    800051ac:	1e050b63          	beqz	a0,800053a2 <printf+0x28c>
    if(cx != '%'){
    800051b0:	ff5516e3          	bne	a0,s5,8000519c <printf+0x86>
    i++;
    800051b4:	0019879b          	addiw	a5,s3,1
    800051b8:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    800051ba:	00fa0733          	add	a4,s4,a5
    800051be:	00074903          	lbu	s2,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    800051c2:	1e090063          	beqz	s2,800053a2 <printf+0x28c>
    800051c6:	00174703          	lbu	a4,1(a4)
    c1 = c2 = 0;
    800051ca:	86ba                	mv	a3,a4
    if(c1) c2 = fmt[i+2] & 0xff;
    800051cc:	c701                	beqz	a4,800051d4 <printf+0xbe>
    800051ce:	97d2                	add	a5,a5,s4
    800051d0:	0027c683          	lbu	a3,2(a5)
    if(c0 == 'd'){
    800051d4:	03690763          	beq	s2,s6,80005202 <printf+0xec>
    } else if(c0 == 'l' && c1 == 'd'){
    800051d8:	05890163          	beq	s2,s8,8000521a <printf+0x104>
    } else if(c0 == 'u'){
    800051dc:	0d990b63          	beq	s2,s9,800052b2 <printf+0x19c>
    } else if(c0 == 'x'){
    800051e0:	13a90163          	beq	s2,s10,80005302 <printf+0x1ec>
    } else if(c0 == 'p'){
    800051e4:	13b90b63          	beq	s2,s11,8000531a <printf+0x204>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800051e8:	07300793          	li	a5,115
    800051ec:	16f90a63          	beq	s2,a5,80005360 <printf+0x24a>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800051f0:	1b590463          	beq	s2,s5,80005398 <printf+0x282>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800051f4:	8556                	mv	a0,s5
    800051f6:	ca1ff0ef          	jal	80004e96 <consputc>
      consputc(c0);
    800051fa:	854a                	mv	a0,s2
    800051fc:	c9bff0ef          	jal	80004e96 <consputc>
    80005200:	b74d                	j	800051a2 <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    80005202:	f8843783          	ld	a5,-120(s0)
    80005206:	00878713          	addi	a4,a5,8
    8000520a:	f8e43423          	sd	a4,-120(s0)
    8000520e:	4605                	li	a2,1
    80005210:	45a9                	li	a1,10
    80005212:	4388                	lw	a0,0(a5)
    80005214:	e79ff0ef          	jal	8000508c <printint>
    80005218:	b769                	j	800051a2 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    8000521a:	03670663          	beq	a4,s6,80005246 <printf+0x130>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000521e:	05870263          	beq	a4,s8,80005262 <printf+0x14c>
    } else if(c0 == 'l' && c1 == 'u'){
    80005222:	0b970463          	beq	a4,s9,800052ca <printf+0x1b4>
    } else if(c0 == 'l' && c1 == 'x'){
    80005226:	fda717e3          	bne	a4,s10,800051f4 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    8000522a:	f8843783          	ld	a5,-120(s0)
    8000522e:	00878713          	addi	a4,a5,8
    80005232:	f8e43423          	sd	a4,-120(s0)
    80005236:	4601                	li	a2,0
    80005238:	45c1                	li	a1,16
    8000523a:	6388                	ld	a0,0(a5)
    8000523c:	e51ff0ef          	jal	8000508c <printint>
      i += 1;
    80005240:	0029849b          	addiw	s1,s3,2
    80005244:	bfb9                	j	800051a2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005246:	f8843783          	ld	a5,-120(s0)
    8000524a:	00878713          	addi	a4,a5,8
    8000524e:	f8e43423          	sd	a4,-120(s0)
    80005252:	4605                	li	a2,1
    80005254:	45a9                	li	a1,10
    80005256:	6388                	ld	a0,0(a5)
    80005258:	e35ff0ef          	jal	8000508c <printint>
      i += 1;
    8000525c:	0029849b          	addiw	s1,s3,2
    80005260:	b789                	j	800051a2 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005262:	06400793          	li	a5,100
    80005266:	02f68863          	beq	a3,a5,80005296 <printf+0x180>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    8000526a:	07500793          	li	a5,117
    8000526e:	06f68c63          	beq	a3,a5,800052e6 <printf+0x1d0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80005272:	07800793          	li	a5,120
    80005276:	f6f69fe3          	bne	a3,a5,800051f4 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    8000527a:	f8843783          	ld	a5,-120(s0)
    8000527e:	00878713          	addi	a4,a5,8
    80005282:	f8e43423          	sd	a4,-120(s0)
    80005286:	4601                	li	a2,0
    80005288:	45c1                	li	a1,16
    8000528a:	6388                	ld	a0,0(a5)
    8000528c:	e01ff0ef          	jal	8000508c <printint>
      i += 2;
    80005290:	0039849b          	addiw	s1,s3,3
    80005294:	b739                	j	800051a2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005296:	f8843783          	ld	a5,-120(s0)
    8000529a:	00878713          	addi	a4,a5,8
    8000529e:	f8e43423          	sd	a4,-120(s0)
    800052a2:	4605                	li	a2,1
    800052a4:	45a9                	li	a1,10
    800052a6:	6388                	ld	a0,0(a5)
    800052a8:	de5ff0ef          	jal	8000508c <printint>
      i += 2;
    800052ac:	0039849b          	addiw	s1,s3,3
    800052b0:	bdcd                	j	800051a2 <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    800052b2:	f8843783          	ld	a5,-120(s0)
    800052b6:	00878713          	addi	a4,a5,8
    800052ba:	f8e43423          	sd	a4,-120(s0)
    800052be:	4601                	li	a2,0
    800052c0:	45a9                	li	a1,10
    800052c2:	4388                	lw	a0,0(a5)
    800052c4:	dc9ff0ef          	jal	8000508c <printint>
    800052c8:	bde9                	j	800051a2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800052ca:	f8843783          	ld	a5,-120(s0)
    800052ce:	00878713          	addi	a4,a5,8
    800052d2:	f8e43423          	sd	a4,-120(s0)
    800052d6:	4601                	li	a2,0
    800052d8:	45a9                	li	a1,10
    800052da:	6388                	ld	a0,0(a5)
    800052dc:	db1ff0ef          	jal	8000508c <printint>
      i += 1;
    800052e0:	0029849b          	addiw	s1,s3,2
    800052e4:	bd7d                	j	800051a2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800052e6:	f8843783          	ld	a5,-120(s0)
    800052ea:	00878713          	addi	a4,a5,8
    800052ee:	f8e43423          	sd	a4,-120(s0)
    800052f2:	4601                	li	a2,0
    800052f4:	45a9                	li	a1,10
    800052f6:	6388                	ld	a0,0(a5)
    800052f8:	d95ff0ef          	jal	8000508c <printint>
      i += 2;
    800052fc:	0039849b          	addiw	s1,s3,3
    80005300:	b54d                	j	800051a2 <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    80005302:	f8843783          	ld	a5,-120(s0)
    80005306:	00878713          	addi	a4,a5,8
    8000530a:	f8e43423          	sd	a4,-120(s0)
    8000530e:	4601                	li	a2,0
    80005310:	45c1                	li	a1,16
    80005312:	4388                	lw	a0,0(a5)
    80005314:	d79ff0ef          	jal	8000508c <printint>
    80005318:	b569                	j	800051a2 <printf+0x8c>
    8000531a:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    8000531c:	f8843783          	ld	a5,-120(s0)
    80005320:	00878713          	addi	a4,a5,8
    80005324:	f8e43423          	sd	a4,-120(s0)
    80005328:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000532c:	03000513          	li	a0,48
    80005330:	b67ff0ef          	jal	80004e96 <consputc>
  consputc('x');
    80005334:	07800513          	li	a0,120
    80005338:	b5fff0ef          	jal	80004e96 <consputc>
    8000533c:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000533e:	00002b97          	auipc	s7,0x2
    80005342:	53ab8b93          	addi	s7,s7,1338 # 80007878 <digits>
    80005346:	03c9d793          	srli	a5,s3,0x3c
    8000534a:	97de                	add	a5,a5,s7
    8000534c:	0007c503          	lbu	a0,0(a5)
    80005350:	b47ff0ef          	jal	80004e96 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005354:	0992                	slli	s3,s3,0x4
    80005356:	397d                	addiw	s2,s2,-1
    80005358:	fe0917e3          	bnez	s2,80005346 <printf+0x230>
    8000535c:	6ba6                	ld	s7,72(sp)
    8000535e:	b591                	j	800051a2 <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    80005360:	f8843783          	ld	a5,-120(s0)
    80005364:	00878713          	addi	a4,a5,8
    80005368:	f8e43423          	sd	a4,-120(s0)
    8000536c:	0007b903          	ld	s2,0(a5)
    80005370:	00090d63          	beqz	s2,8000538a <printf+0x274>
      for(; *s; s++)
    80005374:	00094503          	lbu	a0,0(s2)
    80005378:	e20505e3          	beqz	a0,800051a2 <printf+0x8c>
        consputc(*s);
    8000537c:	b1bff0ef          	jal	80004e96 <consputc>
      for(; *s; s++)
    80005380:	0905                	addi	s2,s2,1
    80005382:	00094503          	lbu	a0,0(s2)
    80005386:	f97d                	bnez	a0,8000537c <printf+0x266>
    80005388:	bd29                	j	800051a2 <printf+0x8c>
        s = "(null)";
    8000538a:	00002917          	auipc	s2,0x2
    8000538e:	39e90913          	addi	s2,s2,926 # 80007728 <etext+0x728>
      for(; *s; s++)
    80005392:	02800513          	li	a0,40
    80005396:	b7dd                	j	8000537c <printf+0x266>
      consputc('%');
    80005398:	02500513          	li	a0,37
    8000539c:	afbff0ef          	jal	80004e96 <consputc>
    800053a0:	b509                	j	800051a2 <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    800053a2:	f7843783          	ld	a5,-136(s0)
    800053a6:	e385                	bnez	a5,800053c6 <printf+0x2b0>
    800053a8:	74e6                	ld	s1,120(sp)
    800053aa:	7946                	ld	s2,112(sp)
    800053ac:	79a6                	ld	s3,104(sp)
    800053ae:	6ae6                	ld	s5,88(sp)
    800053b0:	6b46                	ld	s6,80(sp)
    800053b2:	6c06                	ld	s8,64(sp)
    800053b4:	7ce2                	ld	s9,56(sp)
    800053b6:	7d42                	ld	s10,48(sp)
    800053b8:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    800053ba:	4501                	li	a0,0
    800053bc:	60aa                	ld	ra,136(sp)
    800053be:	640a                	ld	s0,128(sp)
    800053c0:	7a06                	ld	s4,96(sp)
    800053c2:	6169                	addi	sp,sp,208
    800053c4:	8082                	ret
    800053c6:	74e6                	ld	s1,120(sp)
    800053c8:	7946                	ld	s2,112(sp)
    800053ca:	79a6                	ld	s3,104(sp)
    800053cc:	6ae6                	ld	s5,88(sp)
    800053ce:	6b46                	ld	s6,80(sp)
    800053d0:	6c06                	ld	s8,64(sp)
    800053d2:	7ce2                	ld	s9,56(sp)
    800053d4:	7d42                	ld	s10,48(sp)
    800053d6:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    800053d8:	0001e517          	auipc	a0,0x1e
    800053dc:	1a050513          	addi	a0,a0,416 # 80023578 <pr>
    800053e0:	3c8000ef          	jal	800057a8 <release>
    800053e4:	bfd9                	j	800053ba <printf+0x2a4>

00000000800053e6 <panic>:

void
panic(char *s)
{
    800053e6:	1101                	addi	sp,sp,-32
    800053e8:	ec06                	sd	ra,24(sp)
    800053ea:	e822                	sd	s0,16(sp)
    800053ec:	e426                	sd	s1,8(sp)
    800053ee:	1000                	addi	s0,sp,32
    800053f0:	84aa                	mv	s1,a0
  pr.locking = 0;
    800053f2:	0001e797          	auipc	a5,0x1e
    800053f6:	1807af23          	sw	zero,414(a5) # 80023590 <pr+0x18>
  printf("panic: ");
    800053fa:	00002517          	auipc	a0,0x2
    800053fe:	33650513          	addi	a0,a0,822 # 80007730 <etext+0x730>
    80005402:	d15ff0ef          	jal	80005116 <printf>
  printf("%s\n", s);
    80005406:	85a6                	mv	a1,s1
    80005408:	00002517          	auipc	a0,0x2
    8000540c:	33050513          	addi	a0,a0,816 # 80007738 <etext+0x738>
    80005410:	d07ff0ef          	jal	80005116 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005414:	4785                	li	a5,1
    80005416:	00005717          	auipc	a4,0x5
    8000541a:	e6f72b23          	sw	a5,-394(a4) # 8000a28c <panicked>
  for(;;)
    8000541e:	a001                	j	8000541e <panic+0x38>

0000000080005420 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005420:	1101                	addi	sp,sp,-32
    80005422:	ec06                	sd	ra,24(sp)
    80005424:	e822                	sd	s0,16(sp)
    80005426:	e426                	sd	s1,8(sp)
    80005428:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000542a:	0001e497          	auipc	s1,0x1e
    8000542e:	14e48493          	addi	s1,s1,334 # 80023578 <pr>
    80005432:	00002597          	auipc	a1,0x2
    80005436:	30e58593          	addi	a1,a1,782 # 80007740 <etext+0x740>
    8000543a:	8526                	mv	a0,s1
    8000543c:	254000ef          	jal	80005690 <initlock>
  pr.locking = 1;
    80005440:	4785                	li	a5,1
    80005442:	cc9c                	sw	a5,24(s1)
}
    80005444:	60e2                	ld	ra,24(sp)
    80005446:	6442                	ld	s0,16(sp)
    80005448:	64a2                	ld	s1,8(sp)
    8000544a:	6105                	addi	sp,sp,32
    8000544c:	8082                	ret

000000008000544e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000544e:	1141                	addi	sp,sp,-16
    80005450:	e406                	sd	ra,8(sp)
    80005452:	e022                	sd	s0,0(sp)
    80005454:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005456:	100007b7          	lui	a5,0x10000
    8000545a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000545e:	10000737          	lui	a4,0x10000
    80005462:	f8000693          	li	a3,-128
    80005466:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000546a:	468d                	li	a3,3
    8000546c:	10000637          	lui	a2,0x10000
    80005470:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005474:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005478:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000547c:	8732                	mv	a4,a2
    8000547e:	461d                	li	a2,7
    80005480:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005484:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005488:	00002597          	auipc	a1,0x2
    8000548c:	2c058593          	addi	a1,a1,704 # 80007748 <etext+0x748>
    80005490:	0001e517          	auipc	a0,0x1e
    80005494:	10850513          	addi	a0,a0,264 # 80023598 <uart_tx_lock>
    80005498:	1f8000ef          	jal	80005690 <initlock>
}
    8000549c:	60a2                	ld	ra,8(sp)
    8000549e:	6402                	ld	s0,0(sp)
    800054a0:	0141                	addi	sp,sp,16
    800054a2:	8082                	ret

00000000800054a4 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800054a4:	1101                	addi	sp,sp,-32
    800054a6:	ec06                	sd	ra,24(sp)
    800054a8:	e822                	sd	s0,16(sp)
    800054aa:	e426                	sd	s1,8(sp)
    800054ac:	1000                	addi	s0,sp,32
    800054ae:	84aa                	mv	s1,a0
  push_off();
    800054b0:	224000ef          	jal	800056d4 <push_off>

  if(panicked){
    800054b4:	00005797          	auipc	a5,0x5
    800054b8:	dd87a783          	lw	a5,-552(a5) # 8000a28c <panicked>
    800054bc:	e795                	bnez	a5,800054e8 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800054be:	10000737          	lui	a4,0x10000
    800054c2:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800054c4:	00074783          	lbu	a5,0(a4)
    800054c8:	0207f793          	andi	a5,a5,32
    800054cc:	dfe5                	beqz	a5,800054c4 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800054ce:	0ff4f513          	zext.b	a0,s1
    800054d2:	100007b7          	lui	a5,0x10000
    800054d6:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800054da:	27e000ef          	jal	80005758 <pop_off>
}
    800054de:	60e2                	ld	ra,24(sp)
    800054e0:	6442                	ld	s0,16(sp)
    800054e2:	64a2                	ld	s1,8(sp)
    800054e4:	6105                	addi	sp,sp,32
    800054e6:	8082                	ret
    for(;;)
    800054e8:	a001                	j	800054e8 <uartputc_sync+0x44>

00000000800054ea <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800054ea:	00005797          	auipc	a5,0x5
    800054ee:	da67b783          	ld	a5,-602(a5) # 8000a290 <uart_tx_r>
    800054f2:	00005717          	auipc	a4,0x5
    800054f6:	da673703          	ld	a4,-602(a4) # 8000a298 <uart_tx_w>
    800054fa:	08f70163          	beq	a4,a5,8000557c <uartstart+0x92>
{
    800054fe:	7139                	addi	sp,sp,-64
    80005500:	fc06                	sd	ra,56(sp)
    80005502:	f822                	sd	s0,48(sp)
    80005504:	f426                	sd	s1,40(sp)
    80005506:	f04a                	sd	s2,32(sp)
    80005508:	ec4e                	sd	s3,24(sp)
    8000550a:	e852                	sd	s4,16(sp)
    8000550c:	e456                	sd	s5,8(sp)
    8000550e:	e05a                	sd	s6,0(sp)
    80005510:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005512:	10000937          	lui	s2,0x10000
    80005516:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005518:	0001ea97          	auipc	s5,0x1e
    8000551c:	080a8a93          	addi	s5,s5,128 # 80023598 <uart_tx_lock>
    uart_tx_r += 1;
    80005520:	00005497          	auipc	s1,0x5
    80005524:	d7048493          	addi	s1,s1,-656 # 8000a290 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005528:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000552c:	00005997          	auipc	s3,0x5
    80005530:	d6c98993          	addi	s3,s3,-660 # 8000a298 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005534:	00094703          	lbu	a4,0(s2)
    80005538:	02077713          	andi	a4,a4,32
    8000553c:	c715                	beqz	a4,80005568 <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000553e:	01f7f713          	andi	a4,a5,31
    80005542:	9756                	add	a4,a4,s5
    80005544:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005548:	0785                	addi	a5,a5,1
    8000554a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000554c:	8526                	mv	a0,s1
    8000554e:	e17fb0ef          	jal	80001364 <wakeup>
    WriteReg(THR, c);
    80005552:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005556:	609c                	ld	a5,0(s1)
    80005558:	0009b703          	ld	a4,0(s3)
    8000555c:	fcf71ce3          	bne	a4,a5,80005534 <uartstart+0x4a>
      ReadReg(ISR);
    80005560:	100007b7          	lui	a5,0x10000
    80005564:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    80005568:	70e2                	ld	ra,56(sp)
    8000556a:	7442                	ld	s0,48(sp)
    8000556c:	74a2                	ld	s1,40(sp)
    8000556e:	7902                	ld	s2,32(sp)
    80005570:	69e2                	ld	s3,24(sp)
    80005572:	6a42                	ld	s4,16(sp)
    80005574:	6aa2                	ld	s5,8(sp)
    80005576:	6b02                	ld	s6,0(sp)
    80005578:	6121                	addi	sp,sp,64
    8000557a:	8082                	ret
      ReadReg(ISR);
    8000557c:	100007b7          	lui	a5,0x10000
    80005580:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    80005584:	8082                	ret

0000000080005586 <uartputc>:
{
    80005586:	7179                	addi	sp,sp,-48
    80005588:	f406                	sd	ra,40(sp)
    8000558a:	f022                	sd	s0,32(sp)
    8000558c:	ec26                	sd	s1,24(sp)
    8000558e:	e84a                	sd	s2,16(sp)
    80005590:	e44e                	sd	s3,8(sp)
    80005592:	e052                	sd	s4,0(sp)
    80005594:	1800                	addi	s0,sp,48
    80005596:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005598:	0001e517          	auipc	a0,0x1e
    8000559c:	00050513          	mv	a0,a0
    800055a0:	174000ef          	jal	80005714 <acquire>
  if(panicked){
    800055a4:	00005797          	auipc	a5,0x5
    800055a8:	ce87a783          	lw	a5,-792(a5) # 8000a28c <panicked>
    800055ac:	efbd                	bnez	a5,8000562a <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800055ae:	00005717          	auipc	a4,0x5
    800055b2:	cea73703          	ld	a4,-790(a4) # 8000a298 <uart_tx_w>
    800055b6:	00005797          	auipc	a5,0x5
    800055ba:	cda7b783          	ld	a5,-806(a5) # 8000a290 <uart_tx_r>
    800055be:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800055c2:	0001e997          	auipc	s3,0x1e
    800055c6:	fd698993          	addi	s3,s3,-42 # 80023598 <uart_tx_lock>
    800055ca:	00005497          	auipc	s1,0x5
    800055ce:	cc648493          	addi	s1,s1,-826 # 8000a290 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800055d2:	00005917          	auipc	s2,0x5
    800055d6:	cc690913          	addi	s2,s2,-826 # 8000a298 <uart_tx_w>
    800055da:	00e79d63          	bne	a5,a4,800055f4 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800055de:	85ce                	mv	a1,s3
    800055e0:	8526                	mv	a0,s1
    800055e2:	d37fb0ef          	jal	80001318 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800055e6:	00093703          	ld	a4,0(s2)
    800055ea:	609c                	ld	a5,0(s1)
    800055ec:	02078793          	addi	a5,a5,32
    800055f0:	fee787e3          	beq	a5,a4,800055de <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800055f4:	0001e497          	auipc	s1,0x1e
    800055f8:	fa448493          	addi	s1,s1,-92 # 80023598 <uart_tx_lock>
    800055fc:	01f77793          	andi	a5,a4,31
    80005600:	97a6                	add	a5,a5,s1
    80005602:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005606:	0705                	addi	a4,a4,1
    80005608:	00005797          	auipc	a5,0x5
    8000560c:	c8e7b823          	sd	a4,-880(a5) # 8000a298 <uart_tx_w>
  uartstart();
    80005610:	edbff0ef          	jal	800054ea <uartstart>
  release(&uart_tx_lock);
    80005614:	8526                	mv	a0,s1
    80005616:	192000ef          	jal	800057a8 <release>
}
    8000561a:	70a2                	ld	ra,40(sp)
    8000561c:	7402                	ld	s0,32(sp)
    8000561e:	64e2                	ld	s1,24(sp)
    80005620:	6942                	ld	s2,16(sp)
    80005622:	69a2                	ld	s3,8(sp)
    80005624:	6a02                	ld	s4,0(sp)
    80005626:	6145                	addi	sp,sp,48
    80005628:	8082                	ret
    for(;;)
    8000562a:	a001                	j	8000562a <uartputc+0xa4>

000000008000562c <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000562c:	1141                	addi	sp,sp,-16
    8000562e:	e406                	sd	ra,8(sp)
    80005630:	e022                	sd	s0,0(sp)
    80005632:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005634:	100007b7          	lui	a5,0x10000
    80005638:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000563c:	8b85                	andi	a5,a5,1
    8000563e:	cb89                	beqz	a5,80005650 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005640:	100007b7          	lui	a5,0x10000
    80005644:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005648:	60a2                	ld	ra,8(sp)
    8000564a:	6402                	ld	s0,0(sp)
    8000564c:	0141                	addi	sp,sp,16
    8000564e:	8082                	ret
    return -1;
    80005650:	557d                	li	a0,-1
    80005652:	bfdd                	j	80005648 <uartgetc+0x1c>

0000000080005654 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005654:	1101                	addi	sp,sp,-32
    80005656:	ec06                	sd	ra,24(sp)
    80005658:	e822                	sd	s0,16(sp)
    8000565a:	e426                	sd	s1,8(sp)
    8000565c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000565e:	54fd                	li	s1,-1
    int c = uartgetc();
    80005660:	fcdff0ef          	jal	8000562c <uartgetc>
    if(c == -1)
    80005664:	00950563          	beq	a0,s1,8000566e <uartintr+0x1a>
      break;
    consoleintr(c);
    80005668:	861ff0ef          	jal	80004ec8 <consoleintr>
  while(1){
    8000566c:	bfd5                	j	80005660 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000566e:	0001e497          	auipc	s1,0x1e
    80005672:	f2a48493          	addi	s1,s1,-214 # 80023598 <uart_tx_lock>
    80005676:	8526                	mv	a0,s1
    80005678:	09c000ef          	jal	80005714 <acquire>
  uartstart();
    8000567c:	e6fff0ef          	jal	800054ea <uartstart>
  release(&uart_tx_lock);
    80005680:	8526                	mv	a0,s1
    80005682:	126000ef          	jal	800057a8 <release>
}
    80005686:	60e2                	ld	ra,24(sp)
    80005688:	6442                	ld	s0,16(sp)
    8000568a:	64a2                	ld	s1,8(sp)
    8000568c:	6105                	addi	sp,sp,32
    8000568e:	8082                	ret

0000000080005690 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005690:	1141                	addi	sp,sp,-16
    80005692:	e406                	sd	ra,8(sp)
    80005694:	e022                	sd	s0,0(sp)
    80005696:	0800                	addi	s0,sp,16
  lk->name = name;
    80005698:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000569a:	00052023          	sw	zero,0(a0) # 80023598 <uart_tx_lock>
  lk->cpu = 0;
    8000569e:	00053823          	sd	zero,16(a0)
}
    800056a2:	60a2                	ld	ra,8(sp)
    800056a4:	6402                	ld	s0,0(sp)
    800056a6:	0141                	addi	sp,sp,16
    800056a8:	8082                	ret

00000000800056aa <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800056aa:	411c                	lw	a5,0(a0)
    800056ac:	e399                	bnez	a5,800056b2 <holding+0x8>
    800056ae:	4501                	li	a0,0
  return r;
}
    800056b0:	8082                	ret
{
    800056b2:	1101                	addi	sp,sp,-32
    800056b4:	ec06                	sd	ra,24(sp)
    800056b6:	e822                	sd	s0,16(sp)
    800056b8:	e426                	sd	s1,8(sp)
    800056ba:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800056bc:	6904                	ld	s1,16(a0)
    800056be:	e6cfb0ef          	jal	80000d2a <mycpu>
    800056c2:	40a48533          	sub	a0,s1,a0
    800056c6:	00153513          	seqz	a0,a0
}
    800056ca:	60e2                	ld	ra,24(sp)
    800056cc:	6442                	ld	s0,16(sp)
    800056ce:	64a2                	ld	s1,8(sp)
    800056d0:	6105                	addi	sp,sp,32
    800056d2:	8082                	ret

00000000800056d4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800056d4:	1101                	addi	sp,sp,-32
    800056d6:	ec06                	sd	ra,24(sp)
    800056d8:	e822                	sd	s0,16(sp)
    800056da:	e426                	sd	s1,8(sp)
    800056dc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800056de:	100024f3          	csrr	s1,sstatus
    800056e2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800056e6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800056e8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800056ec:	e3efb0ef          	jal	80000d2a <mycpu>
    800056f0:	5d3c                	lw	a5,120(a0)
    800056f2:	cb99                	beqz	a5,80005708 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800056f4:	e36fb0ef          	jal	80000d2a <mycpu>
    800056f8:	5d3c                	lw	a5,120(a0)
    800056fa:	2785                	addiw	a5,a5,1
    800056fc:	dd3c                	sw	a5,120(a0)
}
    800056fe:	60e2                	ld	ra,24(sp)
    80005700:	6442                	ld	s0,16(sp)
    80005702:	64a2                	ld	s1,8(sp)
    80005704:	6105                	addi	sp,sp,32
    80005706:	8082                	ret
    mycpu()->intena = old;
    80005708:	e22fb0ef          	jal	80000d2a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000570c:	8085                	srli	s1,s1,0x1
    8000570e:	8885                	andi	s1,s1,1
    80005710:	dd64                	sw	s1,124(a0)
    80005712:	b7cd                	j	800056f4 <push_off+0x20>

0000000080005714 <acquire>:
{
    80005714:	1101                	addi	sp,sp,-32
    80005716:	ec06                	sd	ra,24(sp)
    80005718:	e822                	sd	s0,16(sp)
    8000571a:	e426                	sd	s1,8(sp)
    8000571c:	1000                	addi	s0,sp,32
    8000571e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005720:	fb5ff0ef          	jal	800056d4 <push_off>
  if(holding(lk))
    80005724:	8526                	mv	a0,s1
    80005726:	f85ff0ef          	jal	800056aa <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000572a:	4705                	li	a4,1
  if(holding(lk))
    8000572c:	e105                	bnez	a0,8000574c <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000572e:	87ba                	mv	a5,a4
    80005730:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005734:	2781                	sext.w	a5,a5
    80005736:	ffe5                	bnez	a5,8000572e <acquire+0x1a>
  __sync_synchronize();
    80005738:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    8000573c:	deefb0ef          	jal	80000d2a <mycpu>
    80005740:	e888                	sd	a0,16(s1)
}
    80005742:	60e2                	ld	ra,24(sp)
    80005744:	6442                	ld	s0,16(sp)
    80005746:	64a2                	ld	s1,8(sp)
    80005748:	6105                	addi	sp,sp,32
    8000574a:	8082                	ret
    panic("acquire");
    8000574c:	00002517          	auipc	a0,0x2
    80005750:	00450513          	addi	a0,a0,4 # 80007750 <etext+0x750>
    80005754:	c93ff0ef          	jal	800053e6 <panic>

0000000080005758 <pop_off>:

void
pop_off(void)
{
    80005758:	1141                	addi	sp,sp,-16
    8000575a:	e406                	sd	ra,8(sp)
    8000575c:	e022                	sd	s0,0(sp)
    8000575e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005760:	dcafb0ef          	jal	80000d2a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005764:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005768:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000576a:	e39d                	bnez	a5,80005790 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000576c:	5d3c                	lw	a5,120(a0)
    8000576e:	02f05763          	blez	a5,8000579c <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80005772:	37fd                	addiw	a5,a5,-1
    80005774:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005776:	eb89                	bnez	a5,80005788 <pop_off+0x30>
    80005778:	5d7c                	lw	a5,124(a0)
    8000577a:	c799                	beqz	a5,80005788 <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000577c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005780:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005784:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005788:	60a2                	ld	ra,8(sp)
    8000578a:	6402                	ld	s0,0(sp)
    8000578c:	0141                	addi	sp,sp,16
    8000578e:	8082                	ret
    panic("pop_off - interruptible");
    80005790:	00002517          	auipc	a0,0x2
    80005794:	fc850513          	addi	a0,a0,-56 # 80007758 <etext+0x758>
    80005798:	c4fff0ef          	jal	800053e6 <panic>
    panic("pop_off");
    8000579c:	00002517          	auipc	a0,0x2
    800057a0:	fd450513          	addi	a0,a0,-44 # 80007770 <etext+0x770>
    800057a4:	c43ff0ef          	jal	800053e6 <panic>

00000000800057a8 <release>:
{
    800057a8:	1101                	addi	sp,sp,-32
    800057aa:	ec06                	sd	ra,24(sp)
    800057ac:	e822                	sd	s0,16(sp)
    800057ae:	e426                	sd	s1,8(sp)
    800057b0:	1000                	addi	s0,sp,32
    800057b2:	84aa                	mv	s1,a0
  if(!holding(lk))
    800057b4:	ef7ff0ef          	jal	800056aa <holding>
    800057b8:	c105                	beqz	a0,800057d8 <release+0x30>
  lk->cpu = 0;
    800057ba:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800057be:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800057c2:	0310000f          	fence	rw,w
    800057c6:	0004a023          	sw	zero,0(s1)
  pop_off();
    800057ca:	f8fff0ef          	jal	80005758 <pop_off>
}
    800057ce:	60e2                	ld	ra,24(sp)
    800057d0:	6442                	ld	s0,16(sp)
    800057d2:	64a2                	ld	s1,8(sp)
    800057d4:	6105                	addi	sp,sp,32
    800057d6:	8082                	ret
    panic("release");
    800057d8:	00002517          	auipc	a0,0x2
    800057dc:	fa050513          	addi	a0,a0,-96 # 80007778 <etext+0x778>
    800057e0:	c07ff0ef          	jal	800053e6 <panic>
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
