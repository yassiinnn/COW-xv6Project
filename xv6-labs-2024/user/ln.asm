
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  if(argc != 3){
   8:	478d                	li	a5,3
   a:	00f50d63          	beq	a0,a5,24 <main+0x24>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	8b058593          	addi	a1,a1,-1872 # 8c0 <malloc+0xfe>
  18:	4509                	li	a0,2
  1a:	6c6000ef          	jal	6e0 <fprintf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	2cc000ef          	jal	2ec <exit>
  24:	e426                	sd	s1,8(sp)
  26:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  28:	698c                	ld	a1,16(a1)
  2a:	6488                	ld	a0,8(s1)
  2c:	320000ef          	jal	34c <link>
  30:	00054563          	bltz	a0,3a <main+0x3a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  34:	4501                	li	a0,0
  36:	2b6000ef          	jal	2ec <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  3a:	6894                	ld	a3,16(s1)
  3c:	6490                	ld	a2,8(s1)
  3e:	00001597          	auipc	a1,0x1
  42:	89a58593          	addi	a1,a1,-1894 # 8d8 <malloc+0x116>
  46:	4509                	li	a0,2
  48:	698000ef          	jal	6e0 <fprintf>
  4c:	b7e5                	j	34 <main+0x34>

000000000000004e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  4e:	1141                	addi	sp,sp,-16
  50:	e406                	sd	ra,8(sp)
  52:	e022                	sd	s0,0(sp)
  54:	0800                	addi	s0,sp,16
  extern int main();
  main();
  56:	fabff0ef          	jal	0 <main>
  exit(0);
  5a:	4501                	li	a0,0
  5c:	290000ef          	jal	2ec <exit>

0000000000000060 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  60:	1141                	addi	sp,sp,-16
  62:	e406                	sd	ra,8(sp)
  64:	e022                	sd	s0,0(sp)
  66:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  68:	87aa                	mv	a5,a0
  6a:	0585                	addi	a1,a1,1
  6c:	0785                	addi	a5,a5,1
  6e:	fff5c703          	lbu	a4,-1(a1)
  72:	fee78fa3          	sb	a4,-1(a5)
  76:	fb75                	bnez	a4,6a <strcpy+0xa>
    ;
  return os;
}
  78:	60a2                	ld	ra,8(sp)
  7a:	6402                	ld	s0,0(sp)
  7c:	0141                	addi	sp,sp,16
  7e:	8082                	ret

0000000000000080 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80:	1141                	addi	sp,sp,-16
  82:	e406                	sd	ra,8(sp)
  84:	e022                	sd	s0,0(sp)
  86:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  88:	00054783          	lbu	a5,0(a0)
  8c:	cb91                	beqz	a5,a0 <strcmp+0x20>
  8e:	0005c703          	lbu	a4,0(a1)
  92:	00f71763          	bne	a4,a5,a0 <strcmp+0x20>
    p++, q++;
  96:	0505                	addi	a0,a0,1
  98:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  9a:	00054783          	lbu	a5,0(a0)
  9e:	fbe5                	bnez	a5,8e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  a0:	0005c503          	lbu	a0,0(a1)
}
  a4:	40a7853b          	subw	a0,a5,a0
  a8:	60a2                	ld	ra,8(sp)
  aa:	6402                	ld	s0,0(sp)
  ac:	0141                	addi	sp,sp,16
  ae:	8082                	ret

00000000000000b0 <strlen>:

uint
strlen(const char *s)
{
  b0:	1141                	addi	sp,sp,-16
  b2:	e406                	sd	ra,8(sp)
  b4:	e022                	sd	s0,0(sp)
  b6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b8:	00054783          	lbu	a5,0(a0)
  bc:	cf99                	beqz	a5,da <strlen+0x2a>
  be:	0505                	addi	a0,a0,1
  c0:	87aa                	mv	a5,a0
  c2:	86be                	mv	a3,a5
  c4:	0785                	addi	a5,a5,1
  c6:	fff7c703          	lbu	a4,-1(a5)
  ca:	ff65                	bnez	a4,c2 <strlen+0x12>
  cc:	40a6853b          	subw	a0,a3,a0
  d0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  d2:	60a2                	ld	ra,8(sp)
  d4:	6402                	ld	s0,0(sp)
  d6:	0141                	addi	sp,sp,16
  d8:	8082                	ret
  for(n = 0; s[n]; n++)
  da:	4501                	li	a0,0
  dc:	bfdd                	j	d2 <strlen+0x22>

00000000000000de <memset>:

void*
memset(void *dst, int c, uint n)
{
  de:	1141                	addi	sp,sp,-16
  e0:	e406                	sd	ra,8(sp)
  e2:	e022                	sd	s0,0(sp)
  e4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  e6:	ca19                	beqz	a2,fc <memset+0x1e>
  e8:	87aa                	mv	a5,a0
  ea:	1602                	slli	a2,a2,0x20
  ec:	9201                	srli	a2,a2,0x20
  ee:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  f6:	0785                	addi	a5,a5,1
  f8:	fee79de3          	bne	a5,a4,f2 <memset+0x14>
  }
  return dst;
}
  fc:	60a2                	ld	ra,8(sp)
  fe:	6402                	ld	s0,0(sp)
 100:	0141                	addi	sp,sp,16
 102:	8082                	ret

0000000000000104 <strchr>:

char*
strchr(const char *s, char c)
{
 104:	1141                	addi	sp,sp,-16
 106:	e406                	sd	ra,8(sp)
 108:	e022                	sd	s0,0(sp)
 10a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 10c:	00054783          	lbu	a5,0(a0)
 110:	cf81                	beqz	a5,128 <strchr+0x24>
    if(*s == c)
 112:	00f58763          	beq	a1,a5,120 <strchr+0x1c>
  for(; *s; s++)
 116:	0505                	addi	a0,a0,1
 118:	00054783          	lbu	a5,0(a0)
 11c:	fbfd                	bnez	a5,112 <strchr+0xe>
      return (char*)s;
  return 0;
 11e:	4501                	li	a0,0
}
 120:	60a2                	ld	ra,8(sp)
 122:	6402                	ld	s0,0(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret
  return 0;
 128:	4501                	li	a0,0
 12a:	bfdd                	j	120 <strchr+0x1c>

000000000000012c <gets>:

char*
gets(char *buf, int max)
{
 12c:	7159                	addi	sp,sp,-112
 12e:	f486                	sd	ra,104(sp)
 130:	f0a2                	sd	s0,96(sp)
 132:	eca6                	sd	s1,88(sp)
 134:	e8ca                	sd	s2,80(sp)
 136:	e4ce                	sd	s3,72(sp)
 138:	e0d2                	sd	s4,64(sp)
 13a:	fc56                	sd	s5,56(sp)
 13c:	f85a                	sd	s6,48(sp)
 13e:	f45e                	sd	s7,40(sp)
 140:	f062                	sd	s8,32(sp)
 142:	ec66                	sd	s9,24(sp)
 144:	e86a                	sd	s10,16(sp)
 146:	1880                	addi	s0,sp,112
 148:	8caa                	mv	s9,a0
 14a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14c:	892a                	mv	s2,a0
 14e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 150:	f9f40b13          	addi	s6,s0,-97
 154:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 156:	4ba9                	li	s7,10
 158:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 15a:	8d26                	mv	s10,s1
 15c:	0014899b          	addiw	s3,s1,1
 160:	84ce                	mv	s1,s3
 162:	0349d563          	bge	s3,s4,18c <gets+0x60>
    cc = read(0, &c, 1);
 166:	8656                	mv	a2,s5
 168:	85da                	mv	a1,s6
 16a:	4501                	li	a0,0
 16c:	198000ef          	jal	304 <read>
    if(cc < 1)
 170:	00a05e63          	blez	a0,18c <gets+0x60>
    buf[i++] = c;
 174:	f9f44783          	lbu	a5,-97(s0)
 178:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 17c:	01778763          	beq	a5,s7,18a <gets+0x5e>
 180:	0905                	addi	s2,s2,1
 182:	fd879ce3          	bne	a5,s8,15a <gets+0x2e>
    buf[i++] = c;
 186:	8d4e                	mv	s10,s3
 188:	a011                	j	18c <gets+0x60>
 18a:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 18c:	9d66                	add	s10,s10,s9
 18e:	000d0023          	sb	zero,0(s10)
  return buf;
}
 192:	8566                	mv	a0,s9
 194:	70a6                	ld	ra,104(sp)
 196:	7406                	ld	s0,96(sp)
 198:	64e6                	ld	s1,88(sp)
 19a:	6946                	ld	s2,80(sp)
 19c:	69a6                	ld	s3,72(sp)
 19e:	6a06                	ld	s4,64(sp)
 1a0:	7ae2                	ld	s5,56(sp)
 1a2:	7b42                	ld	s6,48(sp)
 1a4:	7ba2                	ld	s7,40(sp)
 1a6:	7c02                	ld	s8,32(sp)
 1a8:	6ce2                	ld	s9,24(sp)
 1aa:	6d42                	ld	s10,16(sp)
 1ac:	6165                	addi	sp,sp,112
 1ae:	8082                	ret

00000000000001b0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b0:	1101                	addi	sp,sp,-32
 1b2:	ec06                	sd	ra,24(sp)
 1b4:	e822                	sd	s0,16(sp)
 1b6:	e04a                	sd	s2,0(sp)
 1b8:	1000                	addi	s0,sp,32
 1ba:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1bc:	4581                	li	a1,0
 1be:	16e000ef          	jal	32c <open>
  if(fd < 0)
 1c2:	02054263          	bltz	a0,1e6 <stat+0x36>
 1c6:	e426                	sd	s1,8(sp)
 1c8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ca:	85ca                	mv	a1,s2
 1cc:	178000ef          	jal	344 <fstat>
 1d0:	892a                	mv	s2,a0
  close(fd);
 1d2:	8526                	mv	a0,s1
 1d4:	140000ef          	jal	314 <close>
  return r;
 1d8:	64a2                	ld	s1,8(sp)
}
 1da:	854a                	mv	a0,s2
 1dc:	60e2                	ld	ra,24(sp)
 1de:	6442                	ld	s0,16(sp)
 1e0:	6902                	ld	s2,0(sp)
 1e2:	6105                	addi	sp,sp,32
 1e4:	8082                	ret
    return -1;
 1e6:	597d                	li	s2,-1
 1e8:	bfcd                	j	1da <stat+0x2a>

00000000000001ea <atoi>:

int
atoi(const char *s)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e406                	sd	ra,8(sp)
 1ee:	e022                	sd	s0,0(sp)
 1f0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f2:	00054683          	lbu	a3,0(a0)
 1f6:	fd06879b          	addiw	a5,a3,-48
 1fa:	0ff7f793          	zext.b	a5,a5
 1fe:	4625                	li	a2,9
 200:	02f66963          	bltu	a2,a5,232 <atoi+0x48>
 204:	872a                	mv	a4,a0
  n = 0;
 206:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 208:	0705                	addi	a4,a4,1
 20a:	0025179b          	slliw	a5,a0,0x2
 20e:	9fa9                	addw	a5,a5,a0
 210:	0017979b          	slliw	a5,a5,0x1
 214:	9fb5                	addw	a5,a5,a3
 216:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 21a:	00074683          	lbu	a3,0(a4)
 21e:	fd06879b          	addiw	a5,a3,-48
 222:	0ff7f793          	zext.b	a5,a5
 226:	fef671e3          	bgeu	a2,a5,208 <atoi+0x1e>
  return n;
}
 22a:	60a2                	ld	ra,8(sp)
 22c:	6402                	ld	s0,0(sp)
 22e:	0141                	addi	sp,sp,16
 230:	8082                	ret
  n = 0;
 232:	4501                	li	a0,0
 234:	bfdd                	j	22a <atoi+0x40>

0000000000000236 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 236:	1141                	addi	sp,sp,-16
 238:	e406                	sd	ra,8(sp)
 23a:	e022                	sd	s0,0(sp)
 23c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 23e:	02b57563          	bgeu	a0,a1,268 <memmove+0x32>
    while(n-- > 0)
 242:	00c05f63          	blez	a2,260 <memmove+0x2a>
 246:	1602                	slli	a2,a2,0x20
 248:	9201                	srli	a2,a2,0x20
 24a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 24e:	872a                	mv	a4,a0
      *dst++ = *src++;
 250:	0585                	addi	a1,a1,1
 252:	0705                	addi	a4,a4,1
 254:	fff5c683          	lbu	a3,-1(a1)
 258:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 25c:	fee79ae3          	bne	a5,a4,250 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 260:	60a2                	ld	ra,8(sp)
 262:	6402                	ld	s0,0(sp)
 264:	0141                	addi	sp,sp,16
 266:	8082                	ret
    dst += n;
 268:	00c50733          	add	a4,a0,a2
    src += n;
 26c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 26e:	fec059e3          	blez	a2,260 <memmove+0x2a>
 272:	fff6079b          	addiw	a5,a2,-1
 276:	1782                	slli	a5,a5,0x20
 278:	9381                	srli	a5,a5,0x20
 27a:	fff7c793          	not	a5,a5
 27e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 280:	15fd                	addi	a1,a1,-1
 282:	177d                	addi	a4,a4,-1
 284:	0005c683          	lbu	a3,0(a1)
 288:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 28c:	fef71ae3          	bne	a4,a5,280 <memmove+0x4a>
 290:	bfc1                	j	260 <memmove+0x2a>

0000000000000292 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 292:	1141                	addi	sp,sp,-16
 294:	e406                	sd	ra,8(sp)
 296:	e022                	sd	s0,0(sp)
 298:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 29a:	ca0d                	beqz	a2,2cc <memcmp+0x3a>
 29c:	fff6069b          	addiw	a3,a2,-1
 2a0:	1682                	slli	a3,a3,0x20
 2a2:	9281                	srli	a3,a3,0x20
 2a4:	0685                	addi	a3,a3,1
 2a6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a8:	00054783          	lbu	a5,0(a0)
 2ac:	0005c703          	lbu	a4,0(a1)
 2b0:	00e79863          	bne	a5,a4,2c0 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2b4:	0505                	addi	a0,a0,1
    p2++;
 2b6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b8:	fed518e3          	bne	a0,a3,2a8 <memcmp+0x16>
  }
  return 0;
 2bc:	4501                	li	a0,0
 2be:	a019                	j	2c4 <memcmp+0x32>
      return *p1 - *p2;
 2c0:	40e7853b          	subw	a0,a5,a4
}
 2c4:	60a2                	ld	ra,8(sp)
 2c6:	6402                	ld	s0,0(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret
  return 0;
 2cc:	4501                	li	a0,0
 2ce:	bfdd                	j	2c4 <memcmp+0x32>

00000000000002d0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e406                	sd	ra,8(sp)
 2d4:	e022                	sd	s0,0(sp)
 2d6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2d8:	f5fff0ef          	jal	236 <memmove>
}
 2dc:	60a2                	ld	ra,8(sp)
 2de:	6402                	ld	s0,0(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret

00000000000002e4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2e4:	4885                	li	a7,1
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ec:	4889                	li	a7,2
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2f4:	488d                	li	a7,3
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2fc:	4891                	li	a7,4
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <read>:
.global read
read:
 li a7, SYS_read
 304:	4895                	li	a7,5
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <write>:
.global write
write:
 li a7, SYS_write
 30c:	48c1                	li	a7,16
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <close>:
.global close
close:
 li a7, SYS_close
 314:	48d5                	li	a7,21
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <kill>:
.global kill
kill:
 li a7, SYS_kill
 31c:	4899                	li	a7,6
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <exec>:
.global exec
exec:
 li a7, SYS_exec
 324:	489d                	li	a7,7
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <open>:
.global open
open:
 li a7, SYS_open
 32c:	48bd                	li	a7,15
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 334:	48c5                	li	a7,17
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 33c:	48c9                	li	a7,18
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 344:	48a1                	li	a7,8
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <link>:
.global link
link:
 li a7, SYS_link
 34c:	48cd                	li	a7,19
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 354:	48d1                	li	a7,20
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 35c:	48a5                	li	a7,9
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <dup>:
.global dup
dup:
 li a7, SYS_dup
 364:	48a9                	li	a7,10
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 36c:	48ad                	li	a7,11
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 374:	48b1                	li	a7,12
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 37c:	48b5                	li	a7,13
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 384:	48b9                	li	a7,14
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 38c:	1101                	addi	sp,sp,-32
 38e:	ec06                	sd	ra,24(sp)
 390:	e822                	sd	s0,16(sp)
 392:	1000                	addi	s0,sp,32
 394:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 398:	4605                	li	a2,1
 39a:	fef40593          	addi	a1,s0,-17
 39e:	f6fff0ef          	jal	30c <write>
}
 3a2:	60e2                	ld	ra,24(sp)
 3a4:	6442                	ld	s0,16(sp)
 3a6:	6105                	addi	sp,sp,32
 3a8:	8082                	ret

00000000000003aa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3aa:	7139                	addi	sp,sp,-64
 3ac:	fc06                	sd	ra,56(sp)
 3ae:	f822                	sd	s0,48(sp)
 3b0:	f426                	sd	s1,40(sp)
 3b2:	f04a                	sd	s2,32(sp)
 3b4:	ec4e                	sd	s3,24(sp)
 3b6:	0080                	addi	s0,sp,64
 3b8:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ba:	c299                	beqz	a3,3c0 <printint+0x16>
 3bc:	0605ce63          	bltz	a1,438 <printint+0x8e>
  neg = 0;
 3c0:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3c2:	fc040313          	addi	t1,s0,-64
  neg = 0;
 3c6:	869a                	mv	a3,t1
  i = 0;
 3c8:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 3ca:	00000817          	auipc	a6,0x0
 3ce:	52e80813          	addi	a6,a6,1326 # 8f8 <digits>
 3d2:	88be                	mv	a7,a5
 3d4:	0017851b          	addiw	a0,a5,1
 3d8:	87aa                	mv	a5,a0
 3da:	02c5f73b          	remuw	a4,a1,a2
 3de:	1702                	slli	a4,a4,0x20
 3e0:	9301                	srli	a4,a4,0x20
 3e2:	9742                	add	a4,a4,a6
 3e4:	00074703          	lbu	a4,0(a4)
 3e8:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 3ec:	872e                	mv	a4,a1
 3ee:	02c5d5bb          	divuw	a1,a1,a2
 3f2:	0685                	addi	a3,a3,1
 3f4:	fcc77fe3          	bgeu	a4,a2,3d2 <printint+0x28>
  if(neg)
 3f8:	000e0c63          	beqz	t3,410 <printint+0x66>
    buf[i++] = '-';
 3fc:	fd050793          	addi	a5,a0,-48
 400:	00878533          	add	a0,a5,s0
 404:	02d00793          	li	a5,45
 408:	fef50823          	sb	a5,-16(a0)
 40c:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 410:	fff7899b          	addiw	s3,a5,-1
 414:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 418:	fff4c583          	lbu	a1,-1(s1)
 41c:	854a                	mv	a0,s2
 41e:	f6fff0ef          	jal	38c <putc>
  while(--i >= 0)
 422:	39fd                	addiw	s3,s3,-1
 424:	14fd                	addi	s1,s1,-1
 426:	fe09d9e3          	bgez	s3,418 <printint+0x6e>
}
 42a:	70e2                	ld	ra,56(sp)
 42c:	7442                	ld	s0,48(sp)
 42e:	74a2                	ld	s1,40(sp)
 430:	7902                	ld	s2,32(sp)
 432:	69e2                	ld	s3,24(sp)
 434:	6121                	addi	sp,sp,64
 436:	8082                	ret
    x = -xx;
 438:	40b005bb          	negw	a1,a1
    neg = 1;
 43c:	4e05                	li	t3,1
    x = -xx;
 43e:	b751                	j	3c2 <printint+0x18>

0000000000000440 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 440:	711d                	addi	sp,sp,-96
 442:	ec86                	sd	ra,88(sp)
 444:	e8a2                	sd	s0,80(sp)
 446:	e4a6                	sd	s1,72(sp)
 448:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 44a:	0005c483          	lbu	s1,0(a1)
 44e:	28048463          	beqz	s1,6d6 <vprintf+0x296>
 452:	e0ca                	sd	s2,64(sp)
 454:	fc4e                	sd	s3,56(sp)
 456:	f852                	sd	s4,48(sp)
 458:	f456                	sd	s5,40(sp)
 45a:	f05a                	sd	s6,32(sp)
 45c:	ec5e                	sd	s7,24(sp)
 45e:	e862                	sd	s8,16(sp)
 460:	e466                	sd	s9,8(sp)
 462:	8b2a                	mv	s6,a0
 464:	8a2e                	mv	s4,a1
 466:	8bb2                	mv	s7,a2
  state = 0;
 468:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 46a:	4901                	li	s2,0
 46c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 46e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 472:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 476:	06c00c93          	li	s9,108
 47a:	a00d                	j	49c <vprintf+0x5c>
        putc(fd, c0);
 47c:	85a6                	mv	a1,s1
 47e:	855a                	mv	a0,s6
 480:	f0dff0ef          	jal	38c <putc>
 484:	a019                	j	48a <vprintf+0x4a>
    } else if(state == '%'){
 486:	03598363          	beq	s3,s5,4ac <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 48a:	0019079b          	addiw	a5,s2,1
 48e:	893e                	mv	s2,a5
 490:	873e                	mv	a4,a5
 492:	97d2                	add	a5,a5,s4
 494:	0007c483          	lbu	s1,0(a5)
 498:	22048763          	beqz	s1,6c6 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 49c:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4a0:	fe0993e3          	bnez	s3,486 <vprintf+0x46>
      if(c0 == '%'){
 4a4:	fd579ce3          	bne	a5,s5,47c <vprintf+0x3c>
        state = '%';
 4a8:	89be                	mv	s3,a5
 4aa:	b7c5                	j	48a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4ac:	00ea06b3          	add	a3,s4,a4
 4b0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4b4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4b6:	c681                	beqz	a3,4be <vprintf+0x7e>
 4b8:	9752                	add	a4,a4,s4
 4ba:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4be:	05878263          	beq	a5,s8,502 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 4c2:	05978c63          	beq	a5,s9,51a <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4c6:	07500713          	li	a4,117
 4ca:	0ee78663          	beq	a5,a4,5b6 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4ce:	07800713          	li	a4,120
 4d2:	12e78863          	beq	a5,a4,602 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4d6:	07000713          	li	a4,112
 4da:	14e78d63          	beq	a5,a4,634 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4de:	07300713          	li	a4,115
 4e2:	18e78c63          	beq	a5,a4,67a <vprintf+0x23a>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == 'c'){
 4e6:	06300713          	li	a4,99
 4ea:	1ce78163          	beq	a5,a4,6ac <vprintf+0x26c>
        putc(fd, va_arg(ap, int));
      } else if(c0 == '%'){
 4ee:	02500713          	li	a4,37
 4f2:	04e79463          	bne	a5,a4,53a <vprintf+0xfa>
        putc(fd, '%');
 4f6:	85ba                	mv	a1,a4
 4f8:	855a                	mv	a0,s6
 4fa:	e93ff0ef          	jal	38c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4fe:	4981                	li	s3,0
 500:	b769                	j	48a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 502:	008b8493          	addi	s1,s7,8
 506:	4685                	li	a3,1
 508:	4629                	li	a2,10
 50a:	000ba583          	lw	a1,0(s7)
 50e:	855a                	mv	a0,s6
 510:	e9bff0ef          	jal	3aa <printint>
 514:	8ba6                	mv	s7,s1
      state = 0;
 516:	4981                	li	s3,0
 518:	bf8d                	j	48a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 51a:	06400793          	li	a5,100
 51e:	02f68963          	beq	a3,a5,550 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 522:	06c00793          	li	a5,108
 526:	04f68263          	beq	a3,a5,56a <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 52a:	07500793          	li	a5,117
 52e:	0af68063          	beq	a3,a5,5ce <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 532:	07800793          	li	a5,120
 536:	0ef68263          	beq	a3,a5,61a <vprintf+0x1da>
        putc(fd, '%');
 53a:	02500593          	li	a1,37
 53e:	855a                	mv	a0,s6
 540:	e4dff0ef          	jal	38c <putc>
        putc(fd, c0);
 544:	85a6                	mv	a1,s1
 546:	855a                	mv	a0,s6
 548:	e45ff0ef          	jal	38c <putc>
      state = 0;
 54c:	4981                	li	s3,0
 54e:	bf35                	j	48a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 550:	008b8493          	addi	s1,s7,8
 554:	4685                	li	a3,1
 556:	4629                	li	a2,10
 558:	000ba583          	lw	a1,0(s7)
 55c:	855a                	mv	a0,s6
 55e:	e4dff0ef          	jal	3aa <printint>
        i += 1;
 562:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 564:	8ba6                	mv	s7,s1
      state = 0;
 566:	4981                	li	s3,0
        i += 1;
 568:	b70d                	j	48a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 56a:	06400793          	li	a5,100
 56e:	02f60763          	beq	a2,a5,59c <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 572:	07500793          	li	a5,117
 576:	06f60963          	beq	a2,a5,5e8 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 57a:	07800793          	li	a5,120
 57e:	faf61ee3          	bne	a2,a5,53a <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 582:	008b8493          	addi	s1,s7,8
 586:	4681                	li	a3,0
 588:	4641                	li	a2,16
 58a:	000ba583          	lw	a1,0(s7)
 58e:	855a                	mv	a0,s6
 590:	e1bff0ef          	jal	3aa <printint>
        i += 2;
 594:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 596:	8ba6                	mv	s7,s1
      state = 0;
 598:	4981                	li	s3,0
        i += 2;
 59a:	bdc5                	j	48a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 59c:	008b8493          	addi	s1,s7,8
 5a0:	4685                	li	a3,1
 5a2:	4629                	li	a2,10
 5a4:	000ba583          	lw	a1,0(s7)
 5a8:	855a                	mv	a0,s6
 5aa:	e01ff0ef          	jal	3aa <printint>
        i += 2;
 5ae:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b0:	8ba6                	mv	s7,s1
      state = 0;
 5b2:	4981                	li	s3,0
        i += 2;
 5b4:	bdd9                	j	48a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5b6:	008b8493          	addi	s1,s7,8
 5ba:	4681                	li	a3,0
 5bc:	4629                	li	a2,10
 5be:	000ba583          	lw	a1,0(s7)
 5c2:	855a                	mv	a0,s6
 5c4:	de7ff0ef          	jal	3aa <printint>
 5c8:	8ba6                	mv	s7,s1
      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	bd7d                	j	48a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ce:	008b8493          	addi	s1,s7,8
 5d2:	4681                	li	a3,0
 5d4:	4629                	li	a2,10
 5d6:	000ba583          	lw	a1,0(s7)
 5da:	855a                	mv	a0,s6
 5dc:	dcfff0ef          	jal	3aa <printint>
        i += 1;
 5e0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e2:	8ba6                	mv	s7,s1
      state = 0;
 5e4:	4981                	li	s3,0
        i += 1;
 5e6:	b555                	j	48a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e8:	008b8493          	addi	s1,s7,8
 5ec:	4681                	li	a3,0
 5ee:	4629                	li	a2,10
 5f0:	000ba583          	lw	a1,0(s7)
 5f4:	855a                	mv	a0,s6
 5f6:	db5ff0ef          	jal	3aa <printint>
        i += 2;
 5fa:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fc:	8ba6                	mv	s7,s1
      state = 0;
 5fe:	4981                	li	s3,0
        i += 2;
 600:	b569                	j	48a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 602:	008b8493          	addi	s1,s7,8
 606:	4681                	li	a3,0
 608:	4641                	li	a2,16
 60a:	000ba583          	lw	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	d9bff0ef          	jal	3aa <printint>
 614:	8ba6                	mv	s7,s1
      state = 0;
 616:	4981                	li	s3,0
 618:	bd8d                	j	48a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 61a:	008b8493          	addi	s1,s7,8
 61e:	4681                	li	a3,0
 620:	4641                	li	a2,16
 622:	000ba583          	lw	a1,0(s7)
 626:	855a                	mv	a0,s6
 628:	d83ff0ef          	jal	3aa <printint>
        i += 1;
 62c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 62e:	8ba6                	mv	s7,s1
      state = 0;
 630:	4981                	li	s3,0
        i += 1;
 632:	bda1                	j	48a <vprintf+0x4a>
 634:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 636:	008b8d13          	addi	s10,s7,8
 63a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 63e:	03000593          	li	a1,48
 642:	855a                	mv	a0,s6
 644:	d49ff0ef          	jal	38c <putc>
  putc(fd, 'x');
 648:	07800593          	li	a1,120
 64c:	855a                	mv	a0,s6
 64e:	d3fff0ef          	jal	38c <putc>
 652:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 654:	00000b97          	auipc	s7,0x0
 658:	2a4b8b93          	addi	s7,s7,676 # 8f8 <digits>
 65c:	03c9d793          	srli	a5,s3,0x3c
 660:	97de                	add	a5,a5,s7
 662:	0007c583          	lbu	a1,0(a5)
 666:	855a                	mv	a0,s6
 668:	d25ff0ef          	jal	38c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 66c:	0992                	slli	s3,s3,0x4
 66e:	34fd                	addiw	s1,s1,-1
 670:	f4f5                	bnez	s1,65c <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 672:	8bea                	mv	s7,s10
      state = 0;
 674:	4981                	li	s3,0
 676:	6d02                	ld	s10,0(sp)
 678:	bd09                	j	48a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 67a:	008b8993          	addi	s3,s7,8
 67e:	000bb483          	ld	s1,0(s7)
 682:	cc91                	beqz	s1,69e <vprintf+0x25e>
        for(; *s; s++)
 684:	0004c583          	lbu	a1,0(s1)
 688:	cd85                	beqz	a1,6c0 <vprintf+0x280>
          putc(fd, *s);
 68a:	855a                	mv	a0,s6
 68c:	d01ff0ef          	jal	38c <putc>
        for(; *s; s++)
 690:	0485                	addi	s1,s1,1
 692:	0004c583          	lbu	a1,0(s1)
 696:	f9f5                	bnez	a1,68a <vprintf+0x24a>
        if((s = va_arg(ap, char*)) == 0)
 698:	8bce                	mv	s7,s3
      state = 0;
 69a:	4981                	li	s3,0
 69c:	b3fd                	j	48a <vprintf+0x4a>
          s = "(null)";
 69e:	00000497          	auipc	s1,0x0
 6a2:	25248493          	addi	s1,s1,594 # 8f0 <malloc+0x12e>
        for(; *s; s++)
 6a6:	02800593          	li	a1,40
 6aa:	b7c5                	j	68a <vprintf+0x24a>
        putc(fd, va_arg(ap, int));
 6ac:	008b8493          	addi	s1,s7,8
 6b0:	000bc583          	lbu	a1,0(s7)
 6b4:	855a                	mv	a0,s6
 6b6:	cd7ff0ef          	jal	38c <putc>
 6ba:	8ba6                	mv	s7,s1
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	b3f1                	j	48a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6c0:	8bce                	mv	s7,s3
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	b3d9                	j	48a <vprintf+0x4a>
 6c6:	6906                	ld	s2,64(sp)
 6c8:	79e2                	ld	s3,56(sp)
 6ca:	7a42                	ld	s4,48(sp)
 6cc:	7aa2                	ld	s5,40(sp)
 6ce:	7b02                	ld	s6,32(sp)
 6d0:	6be2                	ld	s7,24(sp)
 6d2:	6c42                	ld	s8,16(sp)
 6d4:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6d6:	60e6                	ld	ra,88(sp)
 6d8:	6446                	ld	s0,80(sp)
 6da:	64a6                	ld	s1,72(sp)
 6dc:	6125                	addi	sp,sp,96
 6de:	8082                	ret

00000000000006e0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6e0:	715d                	addi	sp,sp,-80
 6e2:	ec06                	sd	ra,24(sp)
 6e4:	e822                	sd	s0,16(sp)
 6e6:	1000                	addi	s0,sp,32
 6e8:	e010                	sd	a2,0(s0)
 6ea:	e414                	sd	a3,8(s0)
 6ec:	e818                	sd	a4,16(s0)
 6ee:	ec1c                	sd	a5,24(s0)
 6f0:	03043023          	sd	a6,32(s0)
 6f4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6f8:	8622                	mv	a2,s0
 6fa:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6fe:	d43ff0ef          	jal	440 <vprintf>
  va_end(ap);
}
 702:	60e2                	ld	ra,24(sp)
 704:	6442                	ld	s0,16(sp)
 706:	6161                	addi	sp,sp,80
 708:	8082                	ret

000000000000070a <printf>:

void
printf(const char *fmt, ...)
{
 70a:	711d                	addi	sp,sp,-96
 70c:	ec06                	sd	ra,24(sp)
 70e:	e822                	sd	s0,16(sp)
 710:	1000                	addi	s0,sp,32
 712:	e40c                	sd	a1,8(s0)
 714:	e810                	sd	a2,16(s0)
 716:	ec14                	sd	a3,24(s0)
 718:	f018                	sd	a4,32(s0)
 71a:	f41c                	sd	a5,40(s0)
 71c:	03043823          	sd	a6,48(s0)
 720:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 724:	00840613          	addi	a2,s0,8
 728:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 72c:	85aa                	mv	a1,a0
 72e:	4505                	li	a0,1
 730:	d11ff0ef          	jal	440 <vprintf>
  va_end(ap);
}
 734:	60e2                	ld	ra,24(sp)
 736:	6442                	ld	s0,16(sp)
 738:	6125                	addi	sp,sp,96
 73a:	8082                	ret

000000000000073c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 73c:	1141                	addi	sp,sp,-16
 73e:	e406                	sd	ra,8(sp)
 740:	e022                	sd	s0,0(sp)
 742:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 744:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 748:	00001797          	auipc	a5,0x1
 74c:	8b87b783          	ld	a5,-1864(a5) # 1000 <freep>
 750:	a02d                	j	77a <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 752:	4618                	lw	a4,8(a2)
 754:	9f2d                	addw	a4,a4,a1
 756:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 75a:	6398                	ld	a4,0(a5)
 75c:	6310                	ld	a2,0(a4)
 75e:	a83d                	j	79c <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 760:	ff852703          	lw	a4,-8(a0)
 764:	9f31                	addw	a4,a4,a2
 766:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 768:	ff053683          	ld	a3,-16(a0)
 76c:	a091                	j	7b0 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76e:	6398                	ld	a4,0(a5)
 770:	00e7e463          	bltu	a5,a4,778 <free+0x3c>
 774:	00e6ea63          	bltu	a3,a4,788 <free+0x4c>
{
 778:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77a:	fed7fae3          	bgeu	a5,a3,76e <free+0x32>
 77e:	6398                	ld	a4,0(a5)
 780:	00e6e463          	bltu	a3,a4,788 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 784:	fee7eae3          	bltu	a5,a4,778 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 788:	ff852583          	lw	a1,-8(a0)
 78c:	6390                	ld	a2,0(a5)
 78e:	02059813          	slli	a6,a1,0x20
 792:	01c85713          	srli	a4,a6,0x1c
 796:	9736                	add	a4,a4,a3
 798:	fae60de3          	beq	a2,a4,752 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 79c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7a0:	4790                	lw	a2,8(a5)
 7a2:	02061593          	slli	a1,a2,0x20
 7a6:	01c5d713          	srli	a4,a1,0x1c
 7aa:	973e                	add	a4,a4,a5
 7ac:	fae68ae3          	beq	a3,a4,760 <free+0x24>
    p->s.ptr = bp->s.ptr;
 7b0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7b2:	00001717          	auipc	a4,0x1
 7b6:	84f73723          	sd	a5,-1970(a4) # 1000 <freep>
}
 7ba:	60a2                	ld	ra,8(sp)
 7bc:	6402                	ld	s0,0(sp)
 7be:	0141                	addi	sp,sp,16
 7c0:	8082                	ret

00000000000007c2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7c2:	7139                	addi	sp,sp,-64
 7c4:	fc06                	sd	ra,56(sp)
 7c6:	f822                	sd	s0,48(sp)
 7c8:	f04a                	sd	s2,32(sp)
 7ca:	ec4e                	sd	s3,24(sp)
 7cc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ce:	02051993          	slli	s3,a0,0x20
 7d2:	0209d993          	srli	s3,s3,0x20
 7d6:	09bd                	addi	s3,s3,15
 7d8:	0049d993          	srli	s3,s3,0x4
 7dc:	2985                	addiw	s3,s3,1
 7de:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7e0:	00001517          	auipc	a0,0x1
 7e4:	82053503          	ld	a0,-2016(a0) # 1000 <freep>
 7e8:	c905                	beqz	a0,818 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ea:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ec:	4798                	lw	a4,8(a5)
 7ee:	09377663          	bgeu	a4,s3,87a <malloc+0xb8>
 7f2:	f426                	sd	s1,40(sp)
 7f4:	e852                	sd	s4,16(sp)
 7f6:	e456                	sd	s5,8(sp)
 7f8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7fa:	8a4e                	mv	s4,s3
 7fc:	6705                	lui	a4,0x1
 7fe:	00e9f363          	bgeu	s3,a4,804 <malloc+0x42>
 802:	6a05                	lui	s4,0x1
 804:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 808:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 80c:	00000497          	auipc	s1,0x0
 810:	7f448493          	addi	s1,s1,2036 # 1000 <freep>
  if(p == (char*)-1)
 814:	5afd                	li	s5,-1
 816:	a83d                	j	854 <malloc+0x92>
 818:	f426                	sd	s1,40(sp)
 81a:	e852                	sd	s4,16(sp)
 81c:	e456                	sd	s5,8(sp)
 81e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 820:	00000797          	auipc	a5,0x0
 824:	7f078793          	addi	a5,a5,2032 # 1010 <base>
 828:	00000717          	auipc	a4,0x0
 82c:	7cf73c23          	sd	a5,2008(a4) # 1000 <freep>
 830:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 832:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 836:	b7d1                	j	7fa <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 838:	6398                	ld	a4,0(a5)
 83a:	e118                	sd	a4,0(a0)
 83c:	a899                	j	892 <malloc+0xd0>
  hp->s.size = nu;
 83e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 842:	0541                	addi	a0,a0,16
 844:	ef9ff0ef          	jal	73c <free>
  return freep;
 848:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 84a:	c125                	beqz	a0,8aa <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 84e:	4798                	lw	a4,8(a5)
 850:	03277163          	bgeu	a4,s2,872 <malloc+0xb0>
    if(p == freep)
 854:	6098                	ld	a4,0(s1)
 856:	853e                	mv	a0,a5
 858:	fef71ae3          	bne	a4,a5,84c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 85c:	8552                	mv	a0,s4
 85e:	b17ff0ef          	jal	374 <sbrk>
  if(p == (char*)-1)
 862:	fd551ee3          	bne	a0,s5,83e <malloc+0x7c>
        return 0;
 866:	4501                	li	a0,0
 868:	74a2                	ld	s1,40(sp)
 86a:	6a42                	ld	s4,16(sp)
 86c:	6aa2                	ld	s5,8(sp)
 86e:	6b02                	ld	s6,0(sp)
 870:	a03d                	j	89e <malloc+0xdc>
 872:	74a2                	ld	s1,40(sp)
 874:	6a42                	ld	s4,16(sp)
 876:	6aa2                	ld	s5,8(sp)
 878:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 87a:	fae90fe3          	beq	s2,a4,838 <malloc+0x76>
        p->s.size -= nunits;
 87e:	4137073b          	subw	a4,a4,s3
 882:	c798                	sw	a4,8(a5)
        p += p->s.size;
 884:	02071693          	slli	a3,a4,0x20
 888:	01c6d713          	srli	a4,a3,0x1c
 88c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 88e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 892:	00000717          	auipc	a4,0x0
 896:	76a73723          	sd	a0,1902(a4) # 1000 <freep>
      return (void*)(p + 1);
 89a:	01078513          	addi	a0,a5,16
  }
}
 89e:	70e2                	ld	ra,56(sp)
 8a0:	7442                	ld	s0,48(sp)
 8a2:	7902                	ld	s2,32(sp)
 8a4:	69e2                	ld	s3,24(sp)
 8a6:	6121                	addi	sp,sp,64
 8a8:	8082                	ret
 8aa:	74a2                	ld	s1,40(sp)
 8ac:	6a42                	ld	s4,16(sp)
 8ae:	6aa2                	ld	s5,8(sp)
 8b0:	6b02                	ld	s6,0(sp)
 8b2:	b7f5                	j	89e <malloc+0xdc>
