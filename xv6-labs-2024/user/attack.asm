
user/_attack:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"
#include "kernel/riscv.h"

int
main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  // your code here.  you should write the secret to fd 2 using write
  // (e.g., write(2, secret, 8)

  exit(1);
   8:	4505                	li	a0,1
   a:	2a2000ef          	jal	2ac <exit>

000000000000000e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
   e:	1141                	addi	sp,sp,-16
  10:	e406                	sd	ra,8(sp)
  12:	e022                	sd	s0,0(sp)
  14:	0800                	addi	s0,sp,16
  extern int main();
  main();
  16:	febff0ef          	jal	0 <main>
  exit(0);
  1a:	4501                	li	a0,0
  1c:	290000ef          	jal	2ac <exit>

0000000000000020 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  20:	1141                	addi	sp,sp,-16
  22:	e406                	sd	ra,8(sp)
  24:	e022                	sd	s0,0(sp)
  26:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  28:	87aa                	mv	a5,a0
  2a:	0585                	addi	a1,a1,1
  2c:	0785                	addi	a5,a5,1
  2e:	fff5c703          	lbu	a4,-1(a1)
  32:	fee78fa3          	sb	a4,-1(a5)
  36:	fb75                	bnez	a4,2a <strcpy+0xa>
    ;
  return os;
}
  38:	60a2                	ld	ra,8(sp)
  3a:	6402                	ld	s0,0(sp)
  3c:	0141                	addi	sp,sp,16
  3e:	8082                	ret

0000000000000040 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  40:	1141                	addi	sp,sp,-16
  42:	e406                	sd	ra,8(sp)
  44:	e022                	sd	s0,0(sp)
  46:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  48:	00054783          	lbu	a5,0(a0)
  4c:	cb91                	beqz	a5,60 <strcmp+0x20>
  4e:	0005c703          	lbu	a4,0(a1)
  52:	00f71763          	bne	a4,a5,60 <strcmp+0x20>
    p++, q++;
  56:	0505                	addi	a0,a0,1
  58:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  5a:	00054783          	lbu	a5,0(a0)
  5e:	fbe5                	bnez	a5,4e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  60:	0005c503          	lbu	a0,0(a1)
}
  64:	40a7853b          	subw	a0,a5,a0
  68:	60a2                	ld	ra,8(sp)
  6a:	6402                	ld	s0,0(sp)
  6c:	0141                	addi	sp,sp,16
  6e:	8082                	ret

0000000000000070 <strlen>:

uint
strlen(const char *s)
{
  70:	1141                	addi	sp,sp,-16
  72:	e406                	sd	ra,8(sp)
  74:	e022                	sd	s0,0(sp)
  76:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  78:	00054783          	lbu	a5,0(a0)
  7c:	cf99                	beqz	a5,9a <strlen+0x2a>
  7e:	0505                	addi	a0,a0,1
  80:	87aa                	mv	a5,a0
  82:	86be                	mv	a3,a5
  84:	0785                	addi	a5,a5,1
  86:	fff7c703          	lbu	a4,-1(a5)
  8a:	ff65                	bnez	a4,82 <strlen+0x12>
  8c:	40a6853b          	subw	a0,a3,a0
  90:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  92:	60a2                	ld	ra,8(sp)
  94:	6402                	ld	s0,0(sp)
  96:	0141                	addi	sp,sp,16
  98:	8082                	ret
  for(n = 0; s[n]; n++)
  9a:	4501                	li	a0,0
  9c:	bfdd                	j	92 <strlen+0x22>

000000000000009e <memset>:

void*
memset(void *dst, int c, uint n)
{
  9e:	1141                	addi	sp,sp,-16
  a0:	e406                	sd	ra,8(sp)
  a2:	e022                	sd	s0,0(sp)
  a4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a6:	ca19                	beqz	a2,bc <memset+0x1e>
  a8:	87aa                	mv	a5,a0
  aa:	1602                	slli	a2,a2,0x20
  ac:	9201                	srli	a2,a2,0x20
  ae:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b6:	0785                	addi	a5,a5,1
  b8:	fee79de3          	bne	a5,a4,b2 <memset+0x14>
  }
  return dst;
}
  bc:	60a2                	ld	ra,8(sp)
  be:	6402                	ld	s0,0(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strchr>:

char*
strchr(const char *s, char c)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e406                	sd	ra,8(sp)
  c8:	e022                	sd	s0,0(sp)
  ca:	0800                	addi	s0,sp,16
  for(; *s; s++)
  cc:	00054783          	lbu	a5,0(a0)
  d0:	cf81                	beqz	a5,e8 <strchr+0x24>
    if(*s == c)
  d2:	00f58763          	beq	a1,a5,e0 <strchr+0x1c>
  for(; *s; s++)
  d6:	0505                	addi	a0,a0,1
  d8:	00054783          	lbu	a5,0(a0)
  dc:	fbfd                	bnez	a5,d2 <strchr+0xe>
      return (char*)s;
  return 0;
  de:	4501                	li	a0,0
}
  e0:	60a2                	ld	ra,8(sp)
  e2:	6402                	ld	s0,0(sp)
  e4:	0141                	addi	sp,sp,16
  e6:	8082                	ret
  return 0;
  e8:	4501                	li	a0,0
  ea:	bfdd                	j	e0 <strchr+0x1c>

00000000000000ec <gets>:

char*
gets(char *buf, int max)
{
  ec:	7159                	addi	sp,sp,-112
  ee:	f486                	sd	ra,104(sp)
  f0:	f0a2                	sd	s0,96(sp)
  f2:	eca6                	sd	s1,88(sp)
  f4:	e8ca                	sd	s2,80(sp)
  f6:	e4ce                	sd	s3,72(sp)
  f8:	e0d2                	sd	s4,64(sp)
  fa:	fc56                	sd	s5,56(sp)
  fc:	f85a                	sd	s6,48(sp)
  fe:	f45e                	sd	s7,40(sp)
 100:	f062                	sd	s8,32(sp)
 102:	ec66                	sd	s9,24(sp)
 104:	e86a                	sd	s10,16(sp)
 106:	1880                	addi	s0,sp,112
 108:	8caa                	mv	s9,a0
 10a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 10c:	892a                	mv	s2,a0
 10e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 110:	f9f40b13          	addi	s6,s0,-97
 114:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 116:	4ba9                	li	s7,10
 118:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 11a:	8d26                	mv	s10,s1
 11c:	0014899b          	addiw	s3,s1,1
 120:	84ce                	mv	s1,s3
 122:	0349d563          	bge	s3,s4,14c <gets+0x60>
    cc = read(0, &c, 1);
 126:	8656                	mv	a2,s5
 128:	85da                	mv	a1,s6
 12a:	4501                	li	a0,0
 12c:	198000ef          	jal	2c4 <read>
    if(cc < 1)
 130:	00a05e63          	blez	a0,14c <gets+0x60>
    buf[i++] = c;
 134:	f9f44783          	lbu	a5,-97(s0)
 138:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 13c:	01778763          	beq	a5,s7,14a <gets+0x5e>
 140:	0905                	addi	s2,s2,1
 142:	fd879ce3          	bne	a5,s8,11a <gets+0x2e>
    buf[i++] = c;
 146:	8d4e                	mv	s10,s3
 148:	a011                	j	14c <gets+0x60>
 14a:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 14c:	9d66                	add	s10,s10,s9
 14e:	000d0023          	sb	zero,0(s10)
  return buf;
}
 152:	8566                	mv	a0,s9
 154:	70a6                	ld	ra,104(sp)
 156:	7406                	ld	s0,96(sp)
 158:	64e6                	ld	s1,88(sp)
 15a:	6946                	ld	s2,80(sp)
 15c:	69a6                	ld	s3,72(sp)
 15e:	6a06                	ld	s4,64(sp)
 160:	7ae2                	ld	s5,56(sp)
 162:	7b42                	ld	s6,48(sp)
 164:	7ba2                	ld	s7,40(sp)
 166:	7c02                	ld	s8,32(sp)
 168:	6ce2                	ld	s9,24(sp)
 16a:	6d42                	ld	s10,16(sp)
 16c:	6165                	addi	sp,sp,112
 16e:	8082                	ret

0000000000000170 <stat>:

int
stat(const char *n, struct stat *st)
{
 170:	1101                	addi	sp,sp,-32
 172:	ec06                	sd	ra,24(sp)
 174:	e822                	sd	s0,16(sp)
 176:	e04a                	sd	s2,0(sp)
 178:	1000                	addi	s0,sp,32
 17a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17c:	4581                	li	a1,0
 17e:	16e000ef          	jal	2ec <open>
  if(fd < 0)
 182:	02054263          	bltz	a0,1a6 <stat+0x36>
 186:	e426                	sd	s1,8(sp)
 188:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 18a:	85ca                	mv	a1,s2
 18c:	178000ef          	jal	304 <fstat>
 190:	892a                	mv	s2,a0
  close(fd);
 192:	8526                	mv	a0,s1
 194:	140000ef          	jal	2d4 <close>
  return r;
 198:	64a2                	ld	s1,8(sp)
}
 19a:	854a                	mv	a0,s2
 19c:	60e2                	ld	ra,24(sp)
 19e:	6442                	ld	s0,16(sp)
 1a0:	6902                	ld	s2,0(sp)
 1a2:	6105                	addi	sp,sp,32
 1a4:	8082                	ret
    return -1;
 1a6:	597d                	li	s2,-1
 1a8:	bfcd                	j	19a <stat+0x2a>

00000000000001aa <atoi>:

int
atoi(const char *s)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e406                	sd	ra,8(sp)
 1ae:	e022                	sd	s0,0(sp)
 1b0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b2:	00054683          	lbu	a3,0(a0)
 1b6:	fd06879b          	addiw	a5,a3,-48
 1ba:	0ff7f793          	zext.b	a5,a5
 1be:	4625                	li	a2,9
 1c0:	02f66963          	bltu	a2,a5,1f2 <atoi+0x48>
 1c4:	872a                	mv	a4,a0
  n = 0;
 1c6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1c8:	0705                	addi	a4,a4,1
 1ca:	0025179b          	slliw	a5,a0,0x2
 1ce:	9fa9                	addw	a5,a5,a0
 1d0:	0017979b          	slliw	a5,a5,0x1
 1d4:	9fb5                	addw	a5,a5,a3
 1d6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1da:	00074683          	lbu	a3,0(a4)
 1de:	fd06879b          	addiw	a5,a3,-48
 1e2:	0ff7f793          	zext.b	a5,a5
 1e6:	fef671e3          	bgeu	a2,a5,1c8 <atoi+0x1e>
  return n;
}
 1ea:	60a2                	ld	ra,8(sp)
 1ec:	6402                	ld	s0,0(sp)
 1ee:	0141                	addi	sp,sp,16
 1f0:	8082                	ret
  n = 0;
 1f2:	4501                	li	a0,0
 1f4:	bfdd                	j	1ea <atoi+0x40>

00000000000001f6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f6:	1141                	addi	sp,sp,-16
 1f8:	e406                	sd	ra,8(sp)
 1fa:	e022                	sd	s0,0(sp)
 1fc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1fe:	02b57563          	bgeu	a0,a1,228 <memmove+0x32>
    while(n-- > 0)
 202:	00c05f63          	blez	a2,220 <memmove+0x2a>
 206:	1602                	slli	a2,a2,0x20
 208:	9201                	srli	a2,a2,0x20
 20a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 20e:	872a                	mv	a4,a0
      *dst++ = *src++;
 210:	0585                	addi	a1,a1,1
 212:	0705                	addi	a4,a4,1
 214:	fff5c683          	lbu	a3,-1(a1)
 218:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 21c:	fee79ae3          	bne	a5,a4,210 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 220:	60a2                	ld	ra,8(sp)
 222:	6402                	ld	s0,0(sp)
 224:	0141                	addi	sp,sp,16
 226:	8082                	ret
    dst += n;
 228:	00c50733          	add	a4,a0,a2
    src += n;
 22c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 22e:	fec059e3          	blez	a2,220 <memmove+0x2a>
 232:	fff6079b          	addiw	a5,a2,-1
 236:	1782                	slli	a5,a5,0x20
 238:	9381                	srli	a5,a5,0x20
 23a:	fff7c793          	not	a5,a5
 23e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 240:	15fd                	addi	a1,a1,-1
 242:	177d                	addi	a4,a4,-1
 244:	0005c683          	lbu	a3,0(a1)
 248:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 24c:	fef71ae3          	bne	a4,a5,240 <memmove+0x4a>
 250:	bfc1                	j	220 <memmove+0x2a>

0000000000000252 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 252:	1141                	addi	sp,sp,-16
 254:	e406                	sd	ra,8(sp)
 256:	e022                	sd	s0,0(sp)
 258:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 25a:	ca0d                	beqz	a2,28c <memcmp+0x3a>
 25c:	fff6069b          	addiw	a3,a2,-1
 260:	1682                	slli	a3,a3,0x20
 262:	9281                	srli	a3,a3,0x20
 264:	0685                	addi	a3,a3,1
 266:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 268:	00054783          	lbu	a5,0(a0)
 26c:	0005c703          	lbu	a4,0(a1)
 270:	00e79863          	bne	a5,a4,280 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 274:	0505                	addi	a0,a0,1
    p2++;
 276:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 278:	fed518e3          	bne	a0,a3,268 <memcmp+0x16>
  }
  return 0;
 27c:	4501                	li	a0,0
 27e:	a019                	j	284 <memcmp+0x32>
      return *p1 - *p2;
 280:	40e7853b          	subw	a0,a5,a4
}
 284:	60a2                	ld	ra,8(sp)
 286:	6402                	ld	s0,0(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret
  return 0;
 28c:	4501                	li	a0,0
 28e:	bfdd                	j	284 <memcmp+0x32>

0000000000000290 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 290:	1141                	addi	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 298:	f5fff0ef          	jal	1f6 <memmove>
}
 29c:	60a2                	ld	ra,8(sp)
 29e:	6402                	ld	s0,0(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret

00000000000002a4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2a4:	4885                	li	a7,1
 ecall
 2a6:	00000073          	ecall
 ret
 2aa:	8082                	ret

00000000000002ac <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ac:	4889                	li	a7,2
 ecall
 2ae:	00000073          	ecall
 ret
 2b2:	8082                	ret

00000000000002b4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2b4:	488d                	li	a7,3
 ecall
 2b6:	00000073          	ecall
 ret
 2ba:	8082                	ret

00000000000002bc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2bc:	4891                	li	a7,4
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <read>:
.global read
read:
 li a7, SYS_read
 2c4:	4895                	li	a7,5
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <write>:
.global write
write:
 li a7, SYS_write
 2cc:	48c1                	li	a7,16
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <close>:
.global close
close:
 li a7, SYS_close
 2d4:	48d5                	li	a7,21
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <kill>:
.global kill
kill:
 li a7, SYS_kill
 2dc:	4899                	li	a7,6
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2e4:	489d                	li	a7,7
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <open>:
.global open
open:
 li a7, SYS_open
 2ec:	48bd                	li	a7,15
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2f4:	48c5                	li	a7,17
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2fc:	48c9                	li	a7,18
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 304:	48a1                	li	a7,8
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <link>:
.global link
link:
 li a7, SYS_link
 30c:	48cd                	li	a7,19
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 314:	48d1                	li	a7,20
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 31c:	48a5                	li	a7,9
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <dup>:
.global dup
dup:
 li a7, SYS_dup
 324:	48a9                	li	a7,10
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 32c:	48ad                	li	a7,11
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 334:	48b1                	li	a7,12
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 33c:	48b5                	li	a7,13
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 344:	48b9                	li	a7,14
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 34c:	1101                	addi	sp,sp,-32
 34e:	ec06                	sd	ra,24(sp)
 350:	e822                	sd	s0,16(sp)
 352:	1000                	addi	s0,sp,32
 354:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 358:	4605                	li	a2,1
 35a:	fef40593          	addi	a1,s0,-17
 35e:	f6fff0ef          	jal	2cc <write>
}
 362:	60e2                	ld	ra,24(sp)
 364:	6442                	ld	s0,16(sp)
 366:	6105                	addi	sp,sp,32
 368:	8082                	ret

000000000000036a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 36a:	7139                	addi	sp,sp,-64
 36c:	fc06                	sd	ra,56(sp)
 36e:	f822                	sd	s0,48(sp)
 370:	f426                	sd	s1,40(sp)
 372:	f04a                	sd	s2,32(sp)
 374:	ec4e                	sd	s3,24(sp)
 376:	0080                	addi	s0,sp,64
 378:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 37a:	c299                	beqz	a3,380 <printint+0x16>
 37c:	0605ce63          	bltz	a1,3f8 <printint+0x8e>
  neg = 0;
 380:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 382:	fc040313          	addi	t1,s0,-64
  neg = 0;
 386:	869a                	mv	a3,t1
  i = 0;
 388:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 38a:	00000817          	auipc	a6,0x0
 38e:	4de80813          	addi	a6,a6,1246 # 868 <digits>
 392:	88be                	mv	a7,a5
 394:	0017851b          	addiw	a0,a5,1
 398:	87aa                	mv	a5,a0
 39a:	02c5f73b          	remuw	a4,a1,a2
 39e:	1702                	slli	a4,a4,0x20
 3a0:	9301                	srli	a4,a4,0x20
 3a2:	9742                	add	a4,a4,a6
 3a4:	00074703          	lbu	a4,0(a4)
 3a8:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 3ac:	872e                	mv	a4,a1
 3ae:	02c5d5bb          	divuw	a1,a1,a2
 3b2:	0685                	addi	a3,a3,1
 3b4:	fcc77fe3          	bgeu	a4,a2,392 <printint+0x28>
  if(neg)
 3b8:	000e0c63          	beqz	t3,3d0 <printint+0x66>
    buf[i++] = '-';
 3bc:	fd050793          	addi	a5,a0,-48
 3c0:	00878533          	add	a0,a5,s0
 3c4:	02d00793          	li	a5,45
 3c8:	fef50823          	sb	a5,-16(a0)
 3cc:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 3d0:	fff7899b          	addiw	s3,a5,-1
 3d4:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 3d8:	fff4c583          	lbu	a1,-1(s1)
 3dc:	854a                	mv	a0,s2
 3de:	f6fff0ef          	jal	34c <putc>
  while(--i >= 0)
 3e2:	39fd                	addiw	s3,s3,-1
 3e4:	14fd                	addi	s1,s1,-1
 3e6:	fe09d9e3          	bgez	s3,3d8 <printint+0x6e>
}
 3ea:	70e2                	ld	ra,56(sp)
 3ec:	7442                	ld	s0,48(sp)
 3ee:	74a2                	ld	s1,40(sp)
 3f0:	7902                	ld	s2,32(sp)
 3f2:	69e2                	ld	s3,24(sp)
 3f4:	6121                	addi	sp,sp,64
 3f6:	8082                	ret
    x = -xx;
 3f8:	40b005bb          	negw	a1,a1
    neg = 1;
 3fc:	4e05                	li	t3,1
    x = -xx;
 3fe:	b751                	j	382 <printint+0x18>

0000000000000400 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 400:	711d                	addi	sp,sp,-96
 402:	ec86                	sd	ra,88(sp)
 404:	e8a2                	sd	s0,80(sp)
 406:	e4a6                	sd	s1,72(sp)
 408:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 40a:	0005c483          	lbu	s1,0(a1)
 40e:	26048663          	beqz	s1,67a <vprintf+0x27a>
 412:	e0ca                	sd	s2,64(sp)
 414:	fc4e                	sd	s3,56(sp)
 416:	f852                	sd	s4,48(sp)
 418:	f456                	sd	s5,40(sp)
 41a:	f05a                	sd	s6,32(sp)
 41c:	ec5e                	sd	s7,24(sp)
 41e:	e862                	sd	s8,16(sp)
 420:	e466                	sd	s9,8(sp)
 422:	8b2a                	mv	s6,a0
 424:	8a2e                	mv	s4,a1
 426:	8bb2                	mv	s7,a2
  state = 0;
 428:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 42a:	4901                	li	s2,0
 42c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 42e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 432:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 436:	06c00c93          	li	s9,108
 43a:	a00d                	j	45c <vprintf+0x5c>
        putc(fd, c0);
 43c:	85a6                	mv	a1,s1
 43e:	855a                	mv	a0,s6
 440:	f0dff0ef          	jal	34c <putc>
 444:	a019                	j	44a <vprintf+0x4a>
    } else if(state == '%'){
 446:	03598363          	beq	s3,s5,46c <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 44a:	0019079b          	addiw	a5,s2,1
 44e:	893e                	mv	s2,a5
 450:	873e                	mv	a4,a5
 452:	97d2                	add	a5,a5,s4
 454:	0007c483          	lbu	s1,0(a5)
 458:	20048963          	beqz	s1,66a <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 45c:	0004879b          	sext.w	a5,s1
    if(state == 0){
 460:	fe0993e3          	bnez	s3,446 <vprintf+0x46>
      if(c0 == '%'){
 464:	fd579ce3          	bne	a5,s5,43c <vprintf+0x3c>
        state = '%';
 468:	89be                	mv	s3,a5
 46a:	b7c5                	j	44a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 46c:	00ea06b3          	add	a3,s4,a4
 470:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 474:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 476:	c681                	beqz	a3,47e <vprintf+0x7e>
 478:	9752                	add	a4,a4,s4
 47a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 47e:	03878e63          	beq	a5,s8,4ba <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 482:	05978863          	beq	a5,s9,4d2 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 486:	07500713          	li	a4,117
 48a:	0ee78263          	beq	a5,a4,56e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 48e:	07800713          	li	a4,120
 492:	12e78463          	beq	a5,a4,5ba <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 496:	07000713          	li	a4,112
 49a:	14e78963          	beq	a5,a4,5ec <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 49e:	07300713          	li	a4,115
 4a2:	18e78863          	beq	a5,a4,632 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4a6:	02500713          	li	a4,37
 4aa:	04e79463          	bne	a5,a4,4f2 <vprintf+0xf2>
        putc(fd, '%');
 4ae:	85ba                	mv	a1,a4
 4b0:	855a                	mv	a0,s6
 4b2:	e9bff0ef          	jal	34c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4b6:	4981                	li	s3,0
 4b8:	bf49                	j	44a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4ba:	008b8493          	addi	s1,s7,8
 4be:	4685                	li	a3,1
 4c0:	4629                	li	a2,10
 4c2:	000ba583          	lw	a1,0(s7)
 4c6:	855a                	mv	a0,s6
 4c8:	ea3ff0ef          	jal	36a <printint>
 4cc:	8ba6                	mv	s7,s1
      state = 0;
 4ce:	4981                	li	s3,0
 4d0:	bfad                	j	44a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4d2:	06400793          	li	a5,100
 4d6:	02f68963          	beq	a3,a5,508 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4da:	06c00793          	li	a5,108
 4de:	04f68263          	beq	a3,a5,522 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 4e2:	07500793          	li	a5,117
 4e6:	0af68063          	beq	a3,a5,586 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 4ea:	07800793          	li	a5,120
 4ee:	0ef68263          	beq	a3,a5,5d2 <vprintf+0x1d2>
        putc(fd, '%');
 4f2:	02500593          	li	a1,37
 4f6:	855a                	mv	a0,s6
 4f8:	e55ff0ef          	jal	34c <putc>
        putc(fd, c0);
 4fc:	85a6                	mv	a1,s1
 4fe:	855a                	mv	a0,s6
 500:	e4dff0ef          	jal	34c <putc>
      state = 0;
 504:	4981                	li	s3,0
 506:	b791                	j	44a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 508:	008b8493          	addi	s1,s7,8
 50c:	4685                	li	a3,1
 50e:	4629                	li	a2,10
 510:	000ba583          	lw	a1,0(s7)
 514:	855a                	mv	a0,s6
 516:	e55ff0ef          	jal	36a <printint>
        i += 1;
 51a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 51c:	8ba6                	mv	s7,s1
      state = 0;
 51e:	4981                	li	s3,0
        i += 1;
 520:	b72d                	j	44a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 522:	06400793          	li	a5,100
 526:	02f60763          	beq	a2,a5,554 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 52a:	07500793          	li	a5,117
 52e:	06f60963          	beq	a2,a5,5a0 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 532:	07800793          	li	a5,120
 536:	faf61ee3          	bne	a2,a5,4f2 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 53a:	008b8493          	addi	s1,s7,8
 53e:	4681                	li	a3,0
 540:	4641                	li	a2,16
 542:	000ba583          	lw	a1,0(s7)
 546:	855a                	mv	a0,s6
 548:	e23ff0ef          	jal	36a <printint>
        i += 2;
 54c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 54e:	8ba6                	mv	s7,s1
      state = 0;
 550:	4981                	li	s3,0
        i += 2;
 552:	bde5                	j	44a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 554:	008b8493          	addi	s1,s7,8
 558:	4685                	li	a3,1
 55a:	4629                	li	a2,10
 55c:	000ba583          	lw	a1,0(s7)
 560:	855a                	mv	a0,s6
 562:	e09ff0ef          	jal	36a <printint>
        i += 2;
 566:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 568:	8ba6                	mv	s7,s1
      state = 0;
 56a:	4981                	li	s3,0
        i += 2;
 56c:	bdf9                	j	44a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 56e:	008b8493          	addi	s1,s7,8
 572:	4681                	li	a3,0
 574:	4629                	li	a2,10
 576:	000ba583          	lw	a1,0(s7)
 57a:	855a                	mv	a0,s6
 57c:	defff0ef          	jal	36a <printint>
 580:	8ba6                	mv	s7,s1
      state = 0;
 582:	4981                	li	s3,0
 584:	b5d9                	j	44a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 586:	008b8493          	addi	s1,s7,8
 58a:	4681                	li	a3,0
 58c:	4629                	li	a2,10
 58e:	000ba583          	lw	a1,0(s7)
 592:	855a                	mv	a0,s6
 594:	dd7ff0ef          	jal	36a <printint>
        i += 1;
 598:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 59a:	8ba6                	mv	s7,s1
      state = 0;
 59c:	4981                	li	s3,0
        i += 1;
 59e:	b575                	j	44a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a0:	008b8493          	addi	s1,s7,8
 5a4:	4681                	li	a3,0
 5a6:	4629                	li	a2,10
 5a8:	000ba583          	lw	a1,0(s7)
 5ac:	855a                	mv	a0,s6
 5ae:	dbdff0ef          	jal	36a <printint>
        i += 2;
 5b2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b4:	8ba6                	mv	s7,s1
      state = 0;
 5b6:	4981                	li	s3,0
        i += 2;
 5b8:	bd49                	j	44a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5ba:	008b8493          	addi	s1,s7,8
 5be:	4681                	li	a3,0
 5c0:	4641                	li	a2,16
 5c2:	000ba583          	lw	a1,0(s7)
 5c6:	855a                	mv	a0,s6
 5c8:	da3ff0ef          	jal	36a <printint>
 5cc:	8ba6                	mv	s7,s1
      state = 0;
 5ce:	4981                	li	s3,0
 5d0:	bdad                	j	44a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d2:	008b8493          	addi	s1,s7,8
 5d6:	4681                	li	a3,0
 5d8:	4641                	li	a2,16
 5da:	000ba583          	lw	a1,0(s7)
 5de:	855a                	mv	a0,s6
 5e0:	d8bff0ef          	jal	36a <printint>
        i += 1;
 5e4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e6:	8ba6                	mv	s7,s1
      state = 0;
 5e8:	4981                	li	s3,0
        i += 1;
 5ea:	b585                	j	44a <vprintf+0x4a>
 5ec:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5ee:	008b8d13          	addi	s10,s7,8
 5f2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5f6:	03000593          	li	a1,48
 5fa:	855a                	mv	a0,s6
 5fc:	d51ff0ef          	jal	34c <putc>
  putc(fd, 'x');
 600:	07800593          	li	a1,120
 604:	855a                	mv	a0,s6
 606:	d47ff0ef          	jal	34c <putc>
 60a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 60c:	00000b97          	auipc	s7,0x0
 610:	25cb8b93          	addi	s7,s7,604 # 868 <digits>
 614:	03c9d793          	srli	a5,s3,0x3c
 618:	97de                	add	a5,a5,s7
 61a:	0007c583          	lbu	a1,0(a5)
 61e:	855a                	mv	a0,s6
 620:	d2dff0ef          	jal	34c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 624:	0992                	slli	s3,s3,0x4
 626:	34fd                	addiw	s1,s1,-1
 628:	f4f5                	bnez	s1,614 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 62a:	8bea                	mv	s7,s10
      state = 0;
 62c:	4981                	li	s3,0
 62e:	6d02                	ld	s10,0(sp)
 630:	bd29                	j	44a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 632:	008b8993          	addi	s3,s7,8
 636:	000bb483          	ld	s1,0(s7)
 63a:	cc91                	beqz	s1,656 <vprintf+0x256>
        for(; *s; s++)
 63c:	0004c583          	lbu	a1,0(s1)
 640:	c195                	beqz	a1,664 <vprintf+0x264>
          putc(fd, *s);
 642:	855a                	mv	a0,s6
 644:	d09ff0ef          	jal	34c <putc>
        for(; *s; s++)
 648:	0485                	addi	s1,s1,1
 64a:	0004c583          	lbu	a1,0(s1)
 64e:	f9f5                	bnez	a1,642 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 650:	8bce                	mv	s7,s3
      state = 0;
 652:	4981                	li	s3,0
 654:	bbdd                	j	44a <vprintf+0x4a>
          s = "(null)";
 656:	00000497          	auipc	s1,0x0
 65a:	20a48493          	addi	s1,s1,522 # 860 <malloc+0xfa>
        for(; *s; s++)
 65e:	02800593          	li	a1,40
 662:	b7c5                	j	642 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 664:	8bce                	mv	s7,s3
      state = 0;
 666:	4981                	li	s3,0
 668:	b3cd                	j	44a <vprintf+0x4a>
 66a:	6906                	ld	s2,64(sp)
 66c:	79e2                	ld	s3,56(sp)
 66e:	7a42                	ld	s4,48(sp)
 670:	7aa2                	ld	s5,40(sp)
 672:	7b02                	ld	s6,32(sp)
 674:	6be2                	ld	s7,24(sp)
 676:	6c42                	ld	s8,16(sp)
 678:	6ca2                	ld	s9,8(sp)
    }
  }
}
 67a:	60e6                	ld	ra,88(sp)
 67c:	6446                	ld	s0,80(sp)
 67e:	64a6                	ld	s1,72(sp)
 680:	6125                	addi	sp,sp,96
 682:	8082                	ret

0000000000000684 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 684:	715d                	addi	sp,sp,-80
 686:	ec06                	sd	ra,24(sp)
 688:	e822                	sd	s0,16(sp)
 68a:	1000                	addi	s0,sp,32
 68c:	e010                	sd	a2,0(s0)
 68e:	e414                	sd	a3,8(s0)
 690:	e818                	sd	a4,16(s0)
 692:	ec1c                	sd	a5,24(s0)
 694:	03043023          	sd	a6,32(s0)
 698:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 69c:	8622                	mv	a2,s0
 69e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6a2:	d5fff0ef          	jal	400 <vprintf>
}
 6a6:	60e2                	ld	ra,24(sp)
 6a8:	6442                	ld	s0,16(sp)
 6aa:	6161                	addi	sp,sp,80
 6ac:	8082                	ret

00000000000006ae <printf>:

void
printf(const char *fmt, ...)
{
 6ae:	711d                	addi	sp,sp,-96
 6b0:	ec06                	sd	ra,24(sp)
 6b2:	e822                	sd	s0,16(sp)
 6b4:	1000                	addi	s0,sp,32
 6b6:	e40c                	sd	a1,8(s0)
 6b8:	e810                	sd	a2,16(s0)
 6ba:	ec14                	sd	a3,24(s0)
 6bc:	f018                	sd	a4,32(s0)
 6be:	f41c                	sd	a5,40(s0)
 6c0:	03043823          	sd	a6,48(s0)
 6c4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6c8:	00840613          	addi	a2,s0,8
 6cc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6d0:	85aa                	mv	a1,a0
 6d2:	4505                	li	a0,1
 6d4:	d2dff0ef          	jal	400 <vprintf>
}
 6d8:	60e2                	ld	ra,24(sp)
 6da:	6442                	ld	s0,16(sp)
 6dc:	6125                	addi	sp,sp,96
 6de:	8082                	ret

00000000000006e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e0:	1141                	addi	sp,sp,-16
 6e2:	e406                	sd	ra,8(sp)
 6e4:	e022                	sd	s0,0(sp)
 6e6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ec:	00001797          	auipc	a5,0x1
 6f0:	9147b783          	ld	a5,-1772(a5) # 1000 <freep>
 6f4:	a02d                	j	71e <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6f6:	4618                	lw	a4,8(a2)
 6f8:	9f2d                	addw	a4,a4,a1
 6fa:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6fe:	6398                	ld	a4,0(a5)
 700:	6310                	ld	a2,0(a4)
 702:	a83d                	j	740 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 704:	ff852703          	lw	a4,-8(a0)
 708:	9f31                	addw	a4,a4,a2
 70a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 70c:	ff053683          	ld	a3,-16(a0)
 710:	a091                	j	754 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 712:	6398                	ld	a4,0(a5)
 714:	00e7e463          	bltu	a5,a4,71c <free+0x3c>
 718:	00e6ea63          	bltu	a3,a4,72c <free+0x4c>
{
 71c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71e:	fed7fae3          	bgeu	a5,a3,712 <free+0x32>
 722:	6398                	ld	a4,0(a5)
 724:	00e6e463          	bltu	a3,a4,72c <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 728:	fee7eae3          	bltu	a5,a4,71c <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 72c:	ff852583          	lw	a1,-8(a0)
 730:	6390                	ld	a2,0(a5)
 732:	02059813          	slli	a6,a1,0x20
 736:	01c85713          	srli	a4,a6,0x1c
 73a:	9736                	add	a4,a4,a3
 73c:	fae60de3          	beq	a2,a4,6f6 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 740:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 744:	4790                	lw	a2,8(a5)
 746:	02061593          	slli	a1,a2,0x20
 74a:	01c5d713          	srli	a4,a1,0x1c
 74e:	973e                	add	a4,a4,a5
 750:	fae68ae3          	beq	a3,a4,704 <free+0x24>
    p->s.ptr = bp->s.ptr;
 754:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 756:	00001717          	auipc	a4,0x1
 75a:	8af73523          	sd	a5,-1878(a4) # 1000 <freep>
}
 75e:	60a2                	ld	ra,8(sp)
 760:	6402                	ld	s0,0(sp)
 762:	0141                	addi	sp,sp,16
 764:	8082                	ret

0000000000000766 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 766:	7139                	addi	sp,sp,-64
 768:	fc06                	sd	ra,56(sp)
 76a:	f822                	sd	s0,48(sp)
 76c:	f04a                	sd	s2,32(sp)
 76e:	ec4e                	sd	s3,24(sp)
 770:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 772:	02051993          	slli	s3,a0,0x20
 776:	0209d993          	srli	s3,s3,0x20
 77a:	09bd                	addi	s3,s3,15
 77c:	0049d993          	srli	s3,s3,0x4
 780:	2985                	addiw	s3,s3,1
 782:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 784:	00001517          	auipc	a0,0x1
 788:	87c53503          	ld	a0,-1924(a0) # 1000 <freep>
 78c:	c905                	beqz	a0,7bc <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 790:	4798                	lw	a4,8(a5)
 792:	09377663          	bgeu	a4,s3,81e <malloc+0xb8>
 796:	f426                	sd	s1,40(sp)
 798:	e852                	sd	s4,16(sp)
 79a:	e456                	sd	s5,8(sp)
 79c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 79e:	8a4e                	mv	s4,s3
 7a0:	6705                	lui	a4,0x1
 7a2:	00e9f363          	bgeu	s3,a4,7a8 <malloc+0x42>
 7a6:	6a05                	lui	s4,0x1
 7a8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7ac:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7b0:	00001497          	auipc	s1,0x1
 7b4:	85048493          	addi	s1,s1,-1968 # 1000 <freep>
  if(p == (char*)-1)
 7b8:	5afd                	li	s5,-1
 7ba:	a83d                	j	7f8 <malloc+0x92>
 7bc:	f426                	sd	s1,40(sp)
 7be:	e852                	sd	s4,16(sp)
 7c0:	e456                	sd	s5,8(sp)
 7c2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7c4:	00001797          	auipc	a5,0x1
 7c8:	84c78793          	addi	a5,a5,-1972 # 1010 <base>
 7cc:	00001717          	auipc	a4,0x1
 7d0:	82f73a23          	sd	a5,-1996(a4) # 1000 <freep>
 7d4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7d6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7da:	b7d1                	j	79e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7dc:	6398                	ld	a4,0(a5)
 7de:	e118                	sd	a4,0(a0)
 7e0:	a899                	j	836 <malloc+0xd0>
  hp->s.size = nu;
 7e2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7e6:	0541                	addi	a0,a0,16
 7e8:	ef9ff0ef          	jal	6e0 <free>
  return freep;
 7ec:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 7ee:	c125                	beqz	a0,84e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f2:	4798                	lw	a4,8(a5)
 7f4:	03277163          	bgeu	a4,s2,816 <malloc+0xb0>
    if(p == freep)
 7f8:	6098                	ld	a4,0(s1)
 7fa:	853e                	mv	a0,a5
 7fc:	fef71ae3          	bne	a4,a5,7f0 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 800:	8552                	mv	a0,s4
 802:	b33ff0ef          	jal	334 <sbrk>
  if(p == (char*)-1)
 806:	fd551ee3          	bne	a0,s5,7e2 <malloc+0x7c>
        return 0;
 80a:	4501                	li	a0,0
 80c:	74a2                	ld	s1,40(sp)
 80e:	6a42                	ld	s4,16(sp)
 810:	6aa2                	ld	s5,8(sp)
 812:	6b02                	ld	s6,0(sp)
 814:	a03d                	j	842 <malloc+0xdc>
 816:	74a2                	ld	s1,40(sp)
 818:	6a42                	ld	s4,16(sp)
 81a:	6aa2                	ld	s5,8(sp)
 81c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 81e:	fae90fe3          	beq	s2,a4,7dc <malloc+0x76>
        p->s.size -= nunits;
 822:	4137073b          	subw	a4,a4,s3
 826:	c798                	sw	a4,8(a5)
        p += p->s.size;
 828:	02071693          	slli	a3,a4,0x20
 82c:	01c6d713          	srli	a4,a3,0x1c
 830:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 832:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 836:	00000717          	auipc	a4,0x0
 83a:	7ca73523          	sd	a0,1994(a4) # 1000 <freep>
      return (void*)(p + 1);
 83e:	01078513          	addi	a0,a5,16
  }
}
 842:	70e2                	ld	ra,56(sp)
 844:	7442                	ld	s0,48(sp)
 846:	7902                	ld	s2,32(sp)
 848:	69e2                	ld	s3,24(sp)
 84a:	6121                	addi	sp,sp,64
 84c:	8082                	ret
 84e:	74a2                	ld	s1,40(sp)
 850:	6a42                	ld	s4,16(sp)
 852:	6aa2                	ld	s5,8(sp)
 854:	6b02                	ld	s6,0(sp)
 856:	b7f5                	j	842 <malloc+0xdc>
